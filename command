#!/bin/bash

RED='\033[1;31m'
BLUE='\033[1;34m'
PURP='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

files=("elaborato.md" "vincoli.md" "variabili.md" "tabella.md" "flusso.md" "tlm-funzioni.md")
build_relazione() 
{
    cd relazione
    pandoc header.yaml -H preamble.tex --pdf-engine=xelatex  "${files[@]}" -o ../Relazione.pdf
}


declare -A options
options[relazione]=build_relazione

name_command=$1
flag=0
for key in "${!options[@]}"; do
    if [[ $key == $name_command ]]; then
        flag=1
        break;
    fi
done

if [[ $flag == 0 ]]; then
    echo -e "${RED} Comando non valido! Vedi documentazione${NC}"
    exit 1
fi

${options[$name_command]}