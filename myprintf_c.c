#include <stdio.h>

extern int myPrintfC (char* format, ...);

void perfFuncPrintf(size_t sampleSize);

void perfFuncMyPrintf(size_t sampleSize);

void perfFuncPrintf(size_t sampleSize)
{
    const char* fmt = "%d%d%d%d%d\n";

    for (size_t i = 0; i < sampleSize; i++)
        printf(fmt, i, i, i, i, i);
}


void perfFuncMyPrintf(size_t sampleSize)
{
    const char* fmt = "%d%d%d%d%d\n";

    for (size_t i = 0; i < sampleSize; i++) // TODO: give pointer to function
        myPrintfC(fmt, i, i, i, i, i);
}


int main (void)
{

    // int res = myPrintfC ("%o\n%d %s %x %d%%%c%b\n%d %s %x %d%%%c%b\n", -1, -1, "love", 3802, 100, 33, 126,
    //                                                                       -1, "love", 3802, 100, 33, 126);

    // char* string = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    //                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

    size_t sampleSize = 100000;

    perfFuncMyPrintf(sampleSize);

    return 0;
}