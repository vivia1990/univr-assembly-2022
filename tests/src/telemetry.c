#include "test.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SPEED 250
#define MIN_SPEED 100
#define MAX_TMP 110
#define MIN_TMP 90
#define MAX_RPM 10000
#define MIN_RPM 5000

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
    custom_assert(getPilotId("burundi") < 0, counter);
    custom_assert(getPilotId("Valtteri Bottass") < 0, counter);
    custom_assert(getPilotId("romain Grosjean") < 0, counter);
    return 1;
}

int test_telemetry(unsigned counter)
{
    char* output = malloc(1024);
    char* string = malloc(1024);
    strcpy(string, "Charles Leclerc\n0.01023,1,92,3505,90\n0.01023,1,3452,3452,3452\n");
    telemetry(string, output);
    custom_assert(pilot_stats[0] == 3505, counter++); // maxRpm
    custom_assert(pilot_stats[1] == 3452, counter++); // maxTmp
    custom_assert(pilot_stats[2] == 3452, counter++); // maxSpped
    custom_assert(pilot_stats[3] == 92 + 3452, counter++); // sumSpeed
    memset(output, 0, 1024);
    memset(row_fields, 0, sizeof(long) * row_fields_size);
    memset(pilot_stats, 0, sizeof(long) * pilot_stats_size);

    strcpy(string, "Charles Leclerc\n0.01023,1,92,3505,90\n0.01023,1,3452,3452,3452\n\n\n\n");
    telemetry(string, output);
    custom_assert(pilot_stats[0] == 3505, counter++); // maxRpm
    custom_assert(pilot_stats[1] == 3452, counter++); // maxTmp
    custom_assert(pilot_stats[2] == 3452, counter++); // maxSpped
    custom_assert(pilot_stats[3] == 92 + 3452, counter++); // sumSpeed
    memset(output, 0, 1024);
    memset(row_fields, 0, sizeof(long) * row_fields_size);
    memset(pilot_stats, 0, sizeof(long) * pilot_stats_size);

    strcpy(string, "Charles Leclerc\n0.01023,12,92,3505,90\n0.01023,1,3452,3452,3452\n\n\n\n");
    telemetry(string, output);
    memset(output, 0, 1024);
    memset(row_fields, 0, sizeof(long) * row_fields_size);
    memset(pilot_stats, 0, sizeof(long) * pilot_stats_size);

    strcpy(string, "Charles Leclerc\n0.01023,12,92,3505,90\n0.01023,1,3452,3452,3452\n0.01023,1,3452,3452,3452\n\n\n\n");
    telemetry(string, output);
    memset(output, 0, 1024);
    memset(row_fields, 0, sizeof(long) * row_fields_size);
    memset(pilot_stats, 0, sizeof(long) * pilot_stats_size);

    strcpy(string, "Charles Leclerc\n0.01023,12,92,3505,90\n0.01023,1,3452,3452,3452\n0.01023,0,3452,3452,3452\n\n\n\n");
    telemetry(string, output);
    memset(output, 0, 1024);
    memset(row_fields, 0, sizeof(long) * row_fields_size);
    memset(pilot_stats, 0, sizeof(long) * pilot_stats_size);

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

    memset(row_fields, 0, sizeof(long) * row_fields_size);
    memset(pilot_stats, 0, sizeof(long) * pilot_stats_size);

    setPilotStats("0", 3); // velocità
    custom_assert(strcmp((char*)row_fields[2], "LOW") == 0, counter++);
    custom_assert(pilot_stats[3] == 0, counter++);
    custom_assert(pilot_stats[2] == 0, counter++);

    setPilotStats("77777", 4); // rpm
    custom_assert(strcmp((char*)row_fields[0], "HIGH") == 0, counter++);
    custom_assert(pilot_stats[0] == 77777, counter++);

    setPilotStats("105", 5); // temp
    custom_assert(strcmp((char*)row_fields[1], "MEDIUM") == 0, counter++);
    custom_assert(pilot_stats[1] == 105, counter++);

    setPilotStats("10", 3); // velocità
    custom_assert(strcmp((char*)row_fields[2], "LOW") == 0, counter++);
    custom_assert(pilot_stats[3] == 10, counter++);
    custom_assert(pilot_stats[2] == 10, counter++);

    setPilotStats("77776", 4); // rpm
    custom_assert(strcmp((char*)row_fields[0], "HIGH") == 0, counter++);
    custom_assert(pilot_stats[0] == 77777, counter++);

    setPilotStats("104", 5); // temp
    custom_assert(strcmp((char*)row_fields[1], "MEDIUM") == 0, counter++);
    custom_assert(pilot_stats[1] == 105, counter++);

    setPilotStats("150", 3); // velocità
    custom_assert(strcmp((char*)row_fields[2], "MEDIUM") == 0, counter++);
    custom_assert(pilot_stats[3] == 10 + 150, counter++);
    custom_assert(pilot_stats[2] == 150, counter++);

    memset(row_fields, 0, sizeof(long) * row_fields_size);
    memset(pilot_stats, 0, sizeof(long) * pilot_stats_size);

    return 1;
}

int test_setpilotstat(unsigned counter)
{
    setPilotStat(3452, MIN_RPM, MAX_RPM, 0); // rpm
    setPilotStat(3452, MIN_TMP, MAX_TMP, 1); // temp
    setPilotStat(3452, MIN_SPEED, MAX_SPEED, 2); // velocità
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
    char* output = malloc(1024);
    const char* low = "LOW";
    const char* high = "HIGH";
    const char* medium = "MEDIUM";

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

    memset(row_fields, 0, sizeof(long) * row_fields_size);
    memset(pilot_stats, 0, sizeof(long) * pilot_stats_size);

    free(output);
    return 1;
}
