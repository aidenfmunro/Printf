#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern int myPrintfC(const char* fmt, ...);

void perfFuncPrintf(size_t sampleSize)
{
    const char* fmt = "%d%d%d%d%d\n";

    for (size_t i = 0; i < sampleSize; i++)
        printf(fmt, i, i, i, i, i);
}


void perfFuncMyPrintf(size_t sampleSize)
{
    const char* fmt = "%d%d%d%d%d\n";

    for (size_t i = 0; i < sampleSize; i++)
        myPrintfC(fmt, i, i, i, i, i);
}

int main()
{
    size_t sampleSize = 1000000;

    perfFuncPrintf(sampleSize);
    perfFuncMyPrintf(sampleSize);

    return 0;
}