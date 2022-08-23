#include "test.h"
#include <stdio.h>
#include <stdlib.h>

int test_stringcompare(unsigned counter)
{
    custom_assert(stringCompare("Pierre Gasly", "Pierre Gasly") == 0, counter++);
    custom_assert(stringCompare("Pierre Gasly", "mic") < 0, counter++);
    custom_assert(stringCompare("mic", "mic") == 0, counter++);
    custom_assert(stringCompare("2022", "2023") < 0, counter++);
    custom_assert(stringCompare("202", "2023") < 0, counter++);

    return 1;
}

int test_charlen(unsigned counter)
{
    custom_assert(charLen("\n") == 0, counter++);
    custom_assert(charLen("sela") == 4, counter++);
    custom_assert(charLen("pi") == 2, counter++);
    custom_assert(charLen("selas") == 5, counter++);
    custom_assert(charLen("") == 0, counter++);

    return 1;
}

int test_strtonum(unsigned counter)
{
    custom_assert(strToNum("0") == 0, counter++);
    custom_assert(strToNum("3245") == 3245, counter++);
    custom_assert(strToNum("1") == 1, counter++);
    custom_assert(strToNum("22151251") == 22151251, counter++);

    return 1;
}

int test_stringcopy(unsigned counter)
{
    char* str_dest = (char*)malloc(1024);
    custom_assert(stringCopy("deca", str_dest) == 4, counter++);
    custom_assert(stringCopy("SELA", str_dest) == 4, counter++);
    custom_assert(stringCopy("", str_dest) == 0, counter++);
    custom_assert(stringCopy("\n", str_dest) == 0, counter++);
    custom_assert(stringCopy("gallina", str_dest) == 7, counter++);

    return 1;
}
