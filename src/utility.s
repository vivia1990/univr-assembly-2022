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
# int stringCompare(char *string1, char *string2);
# Compara due stringhe, return vedere strcmp (C)
##
.globl charLen
.type charLen, @function
charLen:
    pushl %ebp
    movl %esp, %ebp # ebp
    pushl %ebx
    movl 8(%ebp), %eax
    movl 8(%ebp), %ebx

# Iterate Routine
_iterate:
    cmpl $0, (%eax) # Compare EAX first Byte with 0, if equal then set zero flag else pass
    je _length  # If Zero flag is set, then follow _lenth routine else pass
    cmpl $10, (%eax) # Compare EAX first Byte with 0, if equal then set zero flag else pass
    je _length  # If Zero flag is set, then follow _lenth routine else pass
    inc %eax  # increase EAX += 1
    jmp _iterate # Repeat

# Length 
_length:
    subl %ebx, %eax # EAX = EBX - EAX [Difference Between memory Address of Starting and Ending Point ]
    movl %edx, %ecx
    ret
