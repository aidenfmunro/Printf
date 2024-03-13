extern int myPrintfC (char* format, ...);

int main (void)
{

    // int res = myPrintfC ("%o\n%d %s %x %d%%%c%b\n%d %s %x %d%%%c%b\n", -1, -1, "love", 380123, 100, 33, 123,
    //                                                                        -1, "love", 380123, 100, 33, 123);

    char* string = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

    int res = myPrintfC ("%s %d\n %b %% %d %x", string, 100, -100, 100, -100);
    return res;
}