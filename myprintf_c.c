extern int myPrintfC (char* format, ...);

int main (void)
{

    int res = myPrintfC ("%o\n%d %s %x %d%%%c%b\n%d %s %x %d%%%c%b\n", -1, -1, "love", 3802, 100, 33, 123,
                                                                           -1, "love", 3802, 100, 33, 123);

    return res;
}