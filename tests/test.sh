#!/bin/bash

unit_test() {
    local flags=(-I inc/ -m32 -g -no-pie)
    local files=(temp.c src/utility.c src/telemetry.c ../src/telemetry.s ../src/utility.s)
    local main="#include \"test.h\" \n #include <string.h> \n \n #include <stdlib.h> \n #include <stdio.h> \n int main() {     :call_func;     return 0; } void custom_assert_fail(const char *__assertion, const char *counter) {     const char *msg = \"Fallito: \";     const size_t length = strlen(__assertion);     const char *expr = strcpy((char *)malloc(length), __assertion);     char *string = malloc(length + strlen(msg));     puts(strcat(strcat(string, msg), expr)); }" 
    
    name=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    function="test_$name(0)"
    echo -e "${main/\:call_func/$function}" > temp.c

    gcc "${flags[@]}" "${files[@]}" -o bin/test    
    rm -f temp.c
}

test_all() {
    make clean
    make
    ./bin/test input.txt out.txt
}

if [[ "$1" == "all" || -z "$1" ]]; then 
    test_all
    exit 0
fi

unit_test $1