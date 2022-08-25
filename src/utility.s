.data
its_string:
    .string "00000000000"
its_string_size:
    .long (. - its_string) - 1
car:
    .byte 0 # la variabile car è dichiarata di tipo byte

.globl string

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
# long strToNum(char* number)
# converte una stringa di caratteri in numero
##
.globl strToNum
.type strToNum, @function
strToNum: 
    pushl %ebp
    movl %esp, %ebp
    pushl %edi 
    pushl %esi 
    pushl %ecx    
    pushl %ebx
    pushl %edx    
    movl 8(%ebp), %esi

    xorl %ecx, %ecx   # azzero il contatore
    xorl %ebx, %ebx  # azzero il registro EBX
    xorl %eax, %eax  
    movl $10, %edi

stn_ripeti:
    movb (%ecx,%esi,1), %bl
    cmpb $0, %bl     # vedo se e' stato letto il carattere '\n'
    je stn_fine
    subb $48, %bl   # converte il codice ASCII della cifra nel numero corrisp.
    mull %edi       # EBX = EBX * 10
    addl %ebx, %eax
    inc %ecx
    jmp stn_ripeti

stn_fine:
    popl %edx
    popl %ebx      # ripristino i registri utilizzati    
    popl %ecx    
    popl %esi
    popl %edi
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
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    movl %esp, %ebp

    movl 24(%ebp), %eax
    subl $4, %esp
    movl $10, -4(%ebp)
    leal its_string, %esi
    addl its_string_size, %esi

its_loop:
    xorl %edx, %edx
    divl -4(%ebp)
    movl %edx, %ebx
    addl $48, %ebx
    decl %esi
    movb %bl, (%esi)
    cmpl $0, %eax
    jne its_loop

its_end:
    movl %esi, %eax
    movl %ebp, %esp
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp

    ret
 