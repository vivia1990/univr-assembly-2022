#include "test.h"
#include <stdlib.h>

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
    char *output = malloc(1024);
    char *string = "Charles Leclerc\n0.01023,0,0,3505,90\n0.01023,1,5,4305,89\n";

    telemetry(string, output);
    free(output);
    
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
