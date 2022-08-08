#include "test.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int (*test_array[])(unsigned counter) = {    
    &test_getpilotid
};

int main(int argc, char const *argv[]) {
    size_t size = sizeof test_array / sizeof(test_array[0]);
    for (size_t i = 0; i < size; i++) {
        printf("Test numero %d\n", i + 1);
        test_array[i](i);
    }

    return EXIT_SUCCESS;
}

void custom_assert_fail(const char *__assertion, const char *counter) {
    const char *msg = "Fallito: ";
    const size_t length = strlen(__assertion);
    const char *expr = strcpy((char *)malloc(length), __assertion);

    char *string = malloc(length + strlen(msg));

    puts(strcat(strcat(string, msg), expr));
}
