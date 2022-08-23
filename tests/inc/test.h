#include <assert.h>

#define BOLD "\x1B[1m"
#define RED "\x1B[1;31m"
#define GRN "\x1B[1;32m"
#define YEL "\x1B[1;33m"
#define BLU "\x1B[1;34m"
#define MAG "\x1B[1;35m"
#define CYN "\x1B[1;36m"
#define WHT "\x1B[1;37m"
#define NC "\x1B[0m"

#define custom_assert(expr, counter) \
    ((expr)                          \
            ? __ASSERT_VOID_CAST(0)  \
            : custom_assert_fail(#expr, #counter))

typedef struct unit_test {
    char const* name;
    int (*test)(unsigned counter);
} unit_test;

enum error_codes {
    assert_fail = -1
};

struct _errordesc {
    int code;
    char* message;
};

void custom_assert_fail(const char* __assertion, const char* counter);

// maxRpm, tempMax, speedMax, SpeedSum
extern unsigned long pilot_stats[4];

// rpm, temp, speed
extern unsigned long row_fields[3];

extern long row_fields_size;
extern long pilot_stats_size;

int test_stringcompare(unsigned counter);
extern int stringCompare(char* string1, char* string2);

int test_getpilotid(unsigned counter);
extern int getPilotId(char* pilotName);

int test_telemetry(unsigned counter);
extern int telemetry(char* input, char* output);

extern int test_charlen(unsigned counter);
extern int charLen(char* string);

extern int test_strtonum(unsigned counter);
extern unsigned long strToNum(char*string);

extern int test_writearray(unsigned counter);
extern long writeArray(char* output);

extern int test_stringcopy(unsigned counter);
extern int stringCopy(char* string_src, char* string_dst);

int test_setpilotstats(unsigned counter);
extern void setPilotStats(char* output, unsigned field);

int test_setpilotstat(unsigned counter);
extern void setPilotStat(long number, long lowVal, long highVal, long index);

extern int test_inttostring(unsigned counter);
extern char* intToString(int num);