#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "test.h"

struct _errordesc errordesc[] = {
    { assert_fail,
        "Assertion fail" }
};

unit_test test_array[] = {
    { .name = "GetPilotId",
        .test = &test_getpilotid },
    { .name = "StringCompare",
        .test = &test_stringcompare }
};

int main(int argc, char const* argv[])
{
    puts(MAG "Testing project...\n" NC);

    size_t size = sizeof test_array / sizeof(test_array[0]);
    for (size_t i = 0; i < size; i++) {
        printf(BOLD "Test %s\n" NC, test_array[i].name);
        errno = 0;
        test_array[i].test(i + 1);

        if (!errno) {
            puts(GRN "Passato!" NC);
        }
        putc('\n', stdout);
    }

    puts(MAG "End" NC);

    return EXIT_SUCCESS;
}

void custom_assert_fail(const char* __assertion, const char* counter)
{
    const char* msg = "Fallito: ";
    const size_t length = strlen(__assertion);
    const char* expr = strcpy((char*)malloc(length), __assertion);

    char* string = malloc(length + strlen(msg));
    if (!string) {
        printf("Memory error %s row: %d\n", __FUNCTION__, __LINE__);
        exit(1);
    }

    printf(RED "%s\n" NC, strcat(strcat(string, msg), expr));
    errno = assert_fail;

    free(string);
}
