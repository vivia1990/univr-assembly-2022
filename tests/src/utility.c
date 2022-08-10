#include "test.h"
#include <stdio.h>

int test_stringcompare(unsigned counter) {
    custom_assert(stringCompare("Pierre Gasly", "Pierre Gasly") == 0, counter++);
    custom_assert(stringCompare("Pierre Gasly", "mic") < 0, counter++);
    custom_assert(stringCompare("mic", "mic") == 0, counter++);    
    custom_assert(stringCompare("2022", "2023") < 0, counter++);
    custom_assert(stringCompare("202", "2023") < 0, counter++);
    
    return 1;
}

int test_telemetry(unsigned counter) {    

    return 1;
}