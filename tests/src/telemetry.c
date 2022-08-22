#include "test.h"
#include <stdlib.h>
#include <string.h>

const char* const pilots[] = {
    "Pierre Gasly",
    "Charles Leclerc",
    "Max Verstappen",
    "Lando Norris",
    "Sebastian Vettel",
    "Daniel Ricciardo",
    "Lance Stroll",
    "Carlos Sainz",
    "Antonio Giovinazzi",
    "Kevin Magnussen",
    "Alexander Albon",
    "Nicholas Latifi",
    "Lewis Hamilton",
    "Romain Grosjean",
    "George Russell",
    "Sergio Perez",
    "Daniil Kvyat",
    "Kimi Raikkonen",
    "Esteban Ocon",
    "Valtteri Bottas"
};

int test_getpilotid(unsigned counter)
{
    custom_assert(getPilotId("Alexander Albon") == 10, counter);
    custom_assert(getPilotId("Max Verstappen") == 2, counter);
    custom_assert(getPilotId("Pierre Gasly") == 0, counter);
    custom_assert(getPilotId("Valtteri Bottas") == 19, counter);
    return 1;
}

int test_telemetry(unsigned counter)
{
    char* output = malloc(1024);
    char* string = "Charles Leclerc\n0.01023,0,0,3505,90\n0.01023,1,5,4305,89\n";

    telemetry(string, output);
    free(output);

    return 1;
}

int test_setpilotstats(unsigned counter)
{
    setPilotStats("3452", 3); // velocità
    custom_assert(strcmp((char*)row_fields[2], "HIGH") == 0, counter++);
    custom_assert(pilot_stats[3] == 3452, counter++);
    custom_assert(pilot_stats[2] == 3452, counter++);

    setPilotStats("3452", 4); // rpm
    custom_assert(strcmp((char*)row_fields[0], "LOW") == 0, counter++);
    custom_assert(pilot_stats[0] == 3452, counter++);

    setPilotStats("3452", 5); // temp
    custom_assert(strcmp((char*)row_fields[1], "HIGH") == 0, counter++);
    custom_assert(pilot_stats[1] == 3452, counter++);

    return 1;
}

int test_setpilotstat(unsigned counter)
{
    setPilotStat("3452", 5000, 10000, 0); // rpm
    setPilotStat("3452", 90, 110, 1); // temp
    setPilotStat("3452", 100, 250, 2); // velocità
    custom_assert(strcmp((char*)row_fields[0], "LOW") == 0, counter++);
    custom_assert(strcmp((char*)row_fields[1], "HIGH") == 0, counter++);
    custom_assert(strcmp((char*)row_fields[2], "HIGH") == 0, counter++);
    custom_assert(pilot_stats[0] == 3452, counter++);
    custom_assert(pilot_stats[1] == 3452, counter++);
    custom_assert(pilot_stats[2] == 3452, counter++);
    custom_assert(pilot_stats[3] == 0, counter++);

    memset(row_fields, 0, sizeof(long) * row_fields_size);
    memset(pilot_stats, 0, sizeof(long) * pilot_stats_size);

    return 1;
}

int test_writearray(unsigned counter)
{
    char *output = malloc(1024);
    const char *low = "LOW";
    const char *high = "HIGH";
    const char *medium = "MEDIUM";

    row_fields[0] = (long)low;
    row_fields[1] = (long)medium;
    row_fields[2] = (long)high;

    custom_assert(writeArray(output) == 15, counter++);
    custom_assert(stringCompare(output, "LOW,MEDIUM,HIGH") == 0, counter++);

    row_fields[0] = (long)medium;
    row_fields[1] = (long)high;
    row_fields[2] = (long)medium;
    custom_assert(writeArray(output) == 18, counter++);
    custom_assert(stringCompare(output, "MEDIUM,HIGH,MEDIUM") == 0, counter++);

    row_fields[0] = (long)high;
    row_fields[1] = (long)high;
    row_fields[2] = (long)high;
    custom_assert(writeArray(output) == 14, counter++);
    custom_assert(stringCompare(output, "HIGH,HIGH,HIGH") == 0, counter++);

    free(output);
    return 1;
}
