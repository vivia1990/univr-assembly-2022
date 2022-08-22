.data
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
    