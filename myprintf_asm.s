global myPrintfC

;-----Start of constants--------------------------------------------------------

EOL        equ 00
BUFFER_LEN equ 264

;-----End of constants----------------------------------------------------------

;----Start of overflowCheck macro-----------------------------------------------

%macro overflowCheck 0

        cmp rdi, buffer + BUFFER_LEN - 64 - 1
        jb %%noFlush

        call flushBuffer
%%noFlush:

%endmacro

;-----End of overflowCheck macro------------------------------------------------

section .bss

buffer      resb BUFFER_LEN

section .data

hexTable    db '0123456789ABCDEF'

section .text

;-------------------------------------------------------------------------------
;
; [Brief]: printf cover for C language.
;
; [Expects]: rdi - format string, 
;            args: rsi, rdx, rcx, r8, r9,
;            stack (cdecl).        
;
;-------------------------------------------------------------------------------

;-----start of myPrintfC label--------------------------------------------------

myPrintfC:    
            pop r10                 ; save return address

            push r9                 ; 
            push r8                 ;
            push rcx                ; arguments
            push rdx                ;
            push rsi                ;
            push rdi                ;

            push r10                ; put return address

            push rbp                ;
            mov rbp, rsp            ; stack frame prologue

            call myPrintf          

            pop rbp                 ; stack frame epilogue

            pop r10                 ; pop old address

            add rsp, 6 * 8          ; balance the stack

            push r10                ; push return address 

            ret

;-----end of myPrintfC label----------------------------------------------------

;-------------------------------------------------------------------------------
;
; [Brief]: printf realization
;
; [Expects]: rdi - format string, 
;            args: rsi, rdx, rcx, r8, r9,
;            stack (cdecl). 
;
; [Example]: 
;            | n'th argument  | <- rbp + 16 + 8n
;            |      ...       |
;            | 2nd argument   | <- rbp + 24
;            | 1nd argument   | <- rbp + 16
;            | return address | <- rbp + 8
;            | saved rbp      | <- rbp
;
; [Save]:    rsi, rdi, rbx, rbp 
;
;-------------------------------------------------------------------------------

;-----start of myPrintf label---------------------------------------------------
myPrintf:
            mov rsi, [rbp + 16]     ; format string 

            mov rdi, buffer         ; buffer 

            mov rbx, 0              ; argument counter

.mainLoop:
            xor rax, rax            ; clean rax

            lodsb

            cmp al, EOL

            je .end

            cmp al, '%'

            je .conversionSpecifier

            mov [rdi], al           ; copy char to buffer 
            inc rdi                 ; shift buffer address

            ; add check for buffer overflow!

            jmp .mainLoop           ; proceed to next char

.conversionSpecifier:

            xor rax, rax            ; clean rax

            lodsb                   ; load next symbol                   

            cmp al, '%'             ; case '%'
            je .symbolPercent

            cmp al, 'x'             ; sym > x
            ja .differentSymbol

            cmp al, 'b'             ; sym < b
            jb .differentSymbol     

            sub al, 'b'             ; get address number

            mov rax, [.formatSpecifiers + rax * 8]
            jmp rax                 ; jump

;-------------------------------------------------------------------------------
;
; Jump table for symbols: b, c, d, o, s, x.
;
;-------------------------------------------------------------------------------

;-----Start of jump table-------------------------------------------------------

.formatSpecifiers:

            dq .symbolB             ; case 'b'
            dq .symbolC             ; case 'c'
            dq .symbolD             ; case 'd'

            times ('n' - 'd') dq .differentSymbol           
                                                            
            dq .symbolO             ; case 'o'              
                                                             
            times ('r' - 'o') dq .differentSymbol           
                                                            
            dq .symbolS             ; case 's'              
                                                            
            times ('w' - 's') dq .differentSymbol           

            dq .symbolX             ; case 'x'

;-----End of jump table---------------------------------------------------------

;-----Start of case 'c'---------------------------------------------------------

.symbolC:
            inc rbx

            overflowCheck

            mov al, [rbp + 16 + 8 * rbx]

            stosb

            jmp .mainLoop

;-----End of case 'c'-----------------------------------------------------------

;-----Start of case 's'---------------------------------------------------------

.symbolS:

            inc rbx

            push rsi                ; save rsi

            mov rsi, [rbp + 16 + 8 * rbx]

            call copy2Buffer

            pop rsi                 ; get rsi

            jmp .mainLoop

;-----End of case 's'-----------------------------------------------------------

;-----Start of case 'd'---------------------------------------------------------

.symbolD:

;-----End of case 'd'-----------------------------------------------------------

            call printNumBase10
            jmp .mainLoop

;-----Start of case 'b'---------------------------------------------------------

.symbolB:

            mov cl, 1
            call printNumBase2n
            jmp .mainLoop 

;-----End of case 'b'-----------------------------------------------------------

;-----Start of case 'o'---------------------------------------------------------

.symbolO:

            mov cl, 3
            call printNumBase2n
            jmp .mainLoop

;-----End of case 'o'-----------------------------------------------------------

;-----Start of case 'x'---------------------------------------------------------

.symbolX:

            mov cl, 4
            call printNumBase2n
            jmp .mainLoop 

;-----End of case 'x'-----------------------------------------------------------

.differentSymbol:

            mov byte [rdi], '%'
            inc rdi

            jmp .mainLoop

.symbolPercent:

            stosb

            jmp .mainLoop

.end:

            call flushBuffer

            xor rax, rax            ; rdi - return value 0
            ret

;-----End of myPrintf label-----------------------------------------------------

;-------------------------------------------------------------------------------
;
; [Brief]: Copies from src to dest
;
; [Expects]: rdi - dest
;            rsi - src
;
;           
;           
; [Destroy]: al
;
; [Save]:    rsi, rdi, rbx, rbp 
;
;-------------------------------------------------------------------------------

;-----Start of copy2Buffer label------------------------------------------------

copy2Buffer:

.copyByte:

            overflowCheck

            lodsb
            cmp al, EOL

            je .end

            stosb

            jmp .copyByte

.end:

            ret

;-----End of copy2Buffer label--------------------------------------------------

;-------------------------------------------------------------------------------
;
; [Brief]: Print number of base 2^n (n = 1, 3, 4)
;
; [Expects]: rdi - format string,
;            rbx - argument count
;             cl - base
;
; [Sets]:
;            r8  - bit mask
;            rdx - value 
;           
;           
; [Destroy]: rax, rdx, rcx
;
; [Save]:    rsi, rdi, rbx, rbp 
;
;-------------------------------------------------------------------------------

;-----Start of printNumBase2n label---------------------------------------------

printNumBase2n:

            inc rbx                 ; arument counter +1

            mov rdx, [rbp + 16 + 8 * rbx]

.isNegative:

            test edx, edx
            jns .continue
            
            overflowCheck

            mov al, '-'
            stosb

            neg edx

.continue:

            call countBytes
            
            add rdi, rax    

            mov byte [rdi], EOL
            dec rdi

            push rax

            mov r8, 01b
            shl r8, cl
            dec r8

.loop:

            overflowCheck

            mov rax, r8
            and rax, rdx

            shr edx, cl

            mov al, [hexTable + rax]  
            mov [rdi], al
            dec di

            test edx, edx

            jne .loop

            pop rax

            add rdi, rax

            inc rdi

            ret

;-----End of printNumBase2n label-----------------------------------------------

;-------------------------------------------------------------------------------
;
; [Brief]: Print number of base 10
;
; [Expects]: rdi - format string,
;            rbx - argument count
;
; [Sets]:
;            r8 - value
;            r9 - counts bytes need to print
;            r10 - quotient
;           
;           
; [Destroy]: rax, rdx
;
; [Save]:    rsi, rdi, rbx, rbp 
;
;-------------------------------------------------------------------------------

;-----Start of printNumBase10 label---------------------------------------------

printNumBase10:

            inc rbx

            mov r8, [rbp + 16 + 8 * rbx]

.isNegaitve:
            mov rdx, r8
            
            test edx, edx
            jns .continue

            mov al, '-'
            stosb

            neg edx
            mov r8, rdx
.continue:

            mov r10, 10 
            mov rax, r8
            xor r9, r9              ; for count bytes

.countBytes:

            xor rdx, rdx
            inc r9
            div r10

            test eax, eax

            jne .countBytes

            add rdi, r9

            mov rax, r8

.loop:
            overflowCheck

            xor rdx, rdx
            div r10

            add dl, '0'
            mov [rdi], dl
            dec rdi

            test eax, eax

            jne .loop

            add rdi, r9

            inc rdi

            ret

;-----End of printNumBase10 label-----------------------------------------------

;-------------------------------------------------------------------------------
;
; [Brief]: Count bytes need to print for a number of base 2^n (n = 1, 3, 4)
;
; [Expects]: rdx - value,
;            cl - base
;
; [Sets]:
;            r8 - value
;            r9 - counts bytes need to print
;            r10 - quotient
;           
;           
; [Destroy]: rax, rdx
;
; [Return];  ch - amount of bytes needed
;
; [Save]:    rsi, rdi, rbx, rbp 
;
;-------------------------------------------------------------------------------

;-----Start of countBytes label-------------------------------------------------

countBytes:

            xor rax, rax
            xor ch, ch
            mov rax, rdx

.loop:
            inc ch
            shr rax, cl

            test rax, rax
            jne .loop

            xor rax, rax

            mov al, ch

            ret

;-----End of countBytes label----------------------------------------------------

;-------------------------------------------------------------------------------
;
; [Brief]: Flushes the buffer
;
; [Expects]: rdi - address of last byte needed to be printed,
;            
;
; [Sets]:
;            rdi - back to the begining
;           
; [Destroy]: rax
;
; [Save]:    rsi, rdx
;
;-------------------------------------------------------------------------------

;-----Start of flushBuffer label------------------------------------------------

flushBuffer:
            push rsi
            push rdx

            sub rdi, buffer         
            mov rdx, rdi

            mov rax, 0x01           ; syscall write ()
            mov rdi, 1
            mov rsi, buffer
            syscall

            pop rdx
            pop rsi

            mov rdi, buffer         ; set buffer

            ret

;-----End of flushBuffer lable--------------------------------------------------
    
; TODO: check for overflow