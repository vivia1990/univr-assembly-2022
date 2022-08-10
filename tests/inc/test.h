#include <assert.h>

#define custom_assert(expr, counter) \
    ((expr)                          \
         ? __ASSERT_VOID_CAST(0)     \
         : custom_assert_fail(#expr, #counter))

void custom_assert_fail(const char *__assertion, const char *counter);

extern int test_stringcompare(unsigned counter);
extern int stringCompare(char *string1, char *string2);

extern int test_getpilotid(unsigned counter);
extern int getPilotId(char *pilotName);

extern int test_telemetry(unsigned counter);
extern int telemetry(char *input, char *output);