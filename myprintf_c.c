extern int myPrintfC (char* format, ...);

int main (void)
{

    int res = myPrintfC ("%o\n%d %s %x %d%%%c%b\n%d %s %x %d%%%c%b\n", 1, 1, "love", 380123, 100, 33, 123,
                                                                          1, "love", 380123, 100, 33, 123);

    // int res = myPrintfC ("%b %o %x", 100, 100, 100);
    return res;
}