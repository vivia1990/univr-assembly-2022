.data
string: .string "00000000000"
str_len: .long . - string
car: .byte 0 

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
    movl 8(%ebp), %esi
    movl 12(%ebp), %edi

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
    movl 8(%ebp), %esi

    xorl %ecx, %ecx
    xorl %ebx, %ebx
    xorl %eax, %eax  
    movl $10, %edi

stn_ripeti:
    movb (%ecx,%esi,1), %bl
    cmp $0, %bl   
    je stn_fine
    subb $48, %bl 
    mull %edi     
    addl %ebx, %eax
    inc %ecx
    jmp stn_ripeti

stn_fine:
    popl %ebx    
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

##
# char* intToString(unsigned long numeric);
# converte un numero unsigned long in stringa
##
.text
.global intToString
.type intToString, @function
intToString:
    pushl %ebp
    movl %esp, %ebp
    pushl %esi
    pushl %edi
    pushl %ebx
    pushl %ecx
    pushl %edx
    movl 8(%ebp), %eax
    mov $0, %ecx
    leal string, %edi
    addl str_len, %edi

is_continua_a_dividere:
    cmp $10, %eax
    jge is_dividi
    pushl %eax
    inc %ecx
    mov %ecx, %ebx
    pushl %ecx
    leal string, %ecx
    addl str_len, %ecx
    subl %ebx, %ecx
    movl %ecx, %esi
    popl %ecx
    jmp is_salva

is_dividi:
    movl $0, %edx
    movl $10, %ebx
    divl %ebx
    pushl %edx
    inc %ecx
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
 