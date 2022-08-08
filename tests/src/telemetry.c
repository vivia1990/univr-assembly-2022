#include "test.h"

int test_getpilotid(unsigned counter) {
    custom_assert(getPilotId("Sebastian Vettel") == 1, counter);
    return 1;
}

