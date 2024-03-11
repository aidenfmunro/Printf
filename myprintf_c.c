extern int myPrintfC (char* format, ...);

int main (void)
{
    myPrintfC ("binary number: %b, %o, %x", 11, 11, 11);

    return 0;
}