
EOL equ 00
BUFFER_LEN equ 256

global myPrintfC

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

            mov al, [rbp + 16 + 8 * rbx]

            stosb

            jmp .mainLoop

;-----End of case 'c'-----------------------------------------------------------

;-----Start of case 's'---------------------------------------------------------

.symbolS:

            push rsi                ; save rsi
            inc rbx

            mov rsi, [rbp + 16 + 8 * rbx]

.sLoop:
            movsb

            cmp BYTE [rsi], EOL     ; compare with end symbol

            jne .sLoop      

            pop rsi                 ; get rsi

            jmp .mainLoop

;-----End of case 's'-----------------------------------------------------------

;-----Start of case 'd'---------------------------------------------------------

.symbolD:

;-----End of case 'd'-----------------------------------------------------------

            mov cl, 0
            ; jmp

;-----Start of case 'b'---------------------------------------------------------

.symbolB:

            mov cl, 1
            jmp .printNum 

;-----End of case 'b'-----------------------------------------------------------

;-----Start of case 'o'---------------------------------------------------------

.symbolO:

            mov cl, 3
            jmp .printNum

;-----End of case 'o'-----------------------------------------------------------

;-----Start of case 'x'---------------------------------------------------------

.symbolX:

            mov cl, 4
            jmp .printNum 

;-----End of case 'x'-----------------------------------------------------------

.printNum:

            inc rbx 
            mov rdx, [rbp + 16 + 8 * rbx]       ; value

            mov r8, 01b
            shl r8, cl
            dec r8

.isNegative:

            test rdx, rdx           ; check for signed
            jns .bLoop           

            mov al, 0x2D            ; '-' symbol
            stosb                   

            neg rdx                 ; make unsigned

.bLoop:

            mov rax, r8
            and rax, rdx

            shr rdx, cl

            mov al, [hexTable + rax]  
            stosb

            cmp rdx, 0

            jne .bLoop

            jmp .mainLoop

.differentSymbol:

            mov byte [rdi], '%'
            inc rdi

            jmp .mainLoop

.symbolPercent:

            stosb

            jmp .mainLoop

.end:

            mov al, 0xa             ; '\n' or else it will output '%'
            mov [rdi], al

            sub rdi, buffer - 1     ; '\n' is added
            mov rdx, rdi

            mov rax, 0x01           ; syscall write ()
            mov rdi, 1
            mov rsi, buffer
            syscall

            xor rax, rax            ; rdi - return value 0
            ret

; TODO: check for overflow, flushbuf