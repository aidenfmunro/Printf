# Printf Clone

Printf (C) function implemented in x86 NASM Assembly for Linux

## Functionality

Support of theese format specifiers:
```
    %d: Signed decimal integers
    %s: String
    %c: Single character
    %b: Signed binary integers
    %o: Signed octal integers
    %x: Signed hex integers

```

## Example

```
int main (void)
{
    myPrintfC ("I'm, %d %s old", 21, "years");

    return 0;
}

```
## Dependencies

```
sudo apt install nasm
```

## Usage

**Your own file:**

Compile into an object file:

``` 
nasm -f elf64 test.s -o test.o
```

Link with gcc:

```
gcc test1.o ... test2.o -o main
```

**Build this project:**

```
make
```


