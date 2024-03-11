extern int myPrintfC (char* format, ...);

int main (void)
{
    myPrintfC ("Hello!, %c s", 'x');

    return 0;
}