.data
string:
    .string "00000000000"
str_len:
    .long . - string
car:
    .byte 0 # la variabile car è dichiarata di tipo byte
.text
##
# int stringCompare(char *string1, char *string2);
# Compara due stringhe, return vedere strcmp (C)
##
.globl stringCompare
.type stringCompare, @function
stringCompare:
    pushl %ebp
    movl %esp, %ebp # ebp
    pushl %edi
    pushl %esi
    pushl %ebx
    pushl %ecx
    movl 8(%ebp), %esi # string1
    movl 12(%ebp), %edi # string2

    xorl %ecx, %ecx
    xorl %ebx, %ebx
    xorl %eax, %eax

sc_loop:
    movb (%esi, %ecx, 1), %al
    cmpb $0, %al
    je sc_end_loop

    movb (%edi, %ecx, 1), %bl
    subl %ebx, %eax
    jnz sc_end_cmp

    incl %ecx
    jmp sc_loop

sc_end_loop:
    movb (%edi, %ecx, 1), %bl
    subl %ebx, %eax
    jz sc_end_cmp    

sc_end_cmp:
    popl %ecx
    popl %ebx
    popl %esi
    popl %edi
    popl %ebp

    ret

.text
##
# int charLen(char *string);
# Restituisce la lunghezza della stringa
##
.globl charLen
.type charLen, @function
charLen:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    movl 8(%ebp), %eax
    movl %eax, %ebx

cl_iterate:
    cmpb $0, (%eax) 
    je cl_length  
    cmpb $10, (%eax) 
    je cl_length 
    inc %eax  
    jmp cl_iterate 

cl_length:
    subl %ebx, %eax 
    movl %edx, %ecx
    popl %ebx
    popl %ebp
    ret

.text 
##
# int stringCopy(char *input, char *output);
# Copia una stringa da indirizzo di partenza a una destinazione e restituisce la lunghezza della stringa
##
.globl stringCopy
.type stringCopy, @function
stringCopy:
    pushl %ebp
    movl %esp, %ebp
    pushl %esi
    pushl %edi
    pushl %edx
    xorl %eax, %eax
    movl 8(%ebp), %esi
    movl 12(%ebp), %edi

sc_iterate:
    cmpb $0, (%esi)
    je sc_end
    cmpb $10, (%esi) 
    je sc_end
    movl (%esi), %edx
    movl %edx, (%edi)
    inc %eax
    inc %esi
    inc %edi
    jmp sc_iterate

sc_end:
    popl %edx
    popl %edi
    popl %esi
    popl %ebp
    ret

.text
.global intToString # rende visibile il simbolo itoa al linker
.type intToString, @function # dichiarazione della funzione itoa
intToString:
    pushl %ebp
    movl %esp, %ebp
    pushl %esi
    pushl %edi
    pushl %ebx
    pushl %ecx
    pushl %edx
    movl 8(%ebp), %eax
    mov $0, %ecx # carica il numero 0 in ecx
    leal string, %edi
    addl str_len, %edi
is_continua_a_dividere:
    cmp $10, %eax # confronta 10 con il contenuto di eax
    jge is_dividi # salta all'etichetta dividi se eax è
    pushl %eax # salva nello stack il contenuto di eax
    inc %ecx # incrementa di 1 il valore di ecx per
    mov %ecx, %ebx # pone il valore di ecx in ebx
    pushl %ecx
    leal string, %ecx
    addl str_len, %ecx
    subl %ebx, %ecx
    movl %ecx, %esi
    popl %ecx
    jmp is_salva # salta all'etichetta stampa
is_dividi:
    movl $0, %edx # carica 0 in edx
    movl $10, %ebx # carica 10 in ebx
    divl %ebx # divide per ebx (10) il numero ottenuto
    pushl %edx # salva il resto nello stack
    inc %ecx # incrementa il contatore delle cifre da stampare
    jmp is_continua_a_dividere
is_salva:
    cmp $0, %ebx
    je is_fine
    popl %eax
    movb %al, car
    addb $48, car
    subl %ebx, %edi
    movl car, %eax 
    movl %eax, (%edi)
    addl %ebx, %edi
    dec %ebx
    jmp is_salva
is_fine:
    movl %esi, %eax
    popl %edx
    popl %ecx
    popl %ebx
    popl %edi
    popl %esi
    popl %ebp
 ret
 