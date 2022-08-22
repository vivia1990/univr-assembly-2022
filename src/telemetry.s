.file "telemetry.s"
.bss
.comm row_fields, 12 # array long
.data
pilot_0_str:  .string "Pierre Gasly"
pilot_1_str:  .string "Charles Leclerc"
pilot_2_str:  .string "Max Verstappen"
pilot_3_str:  .string "Lando Norris"
pilot_4_str:  .string "Sebastian Vettel"
pilot_5_str:  .string "Daniel Ricciardo"
pilot_6_str:  .string "Lance Stroll"
pilot_7_str:  .string "Carlos Sainz"
pilot_8_str:  .string "Antonio Giovinazzi"
pilot_9_str:  .string "Kevin Magnussen"
pilot_10_str: .string "Alexander Albon"
pilot_11_str: .string "Nicholas Latifi"
pilot_12_str: .string "Lewis Hamilton"
pilot_13_str: .string "Romain Grosjean"
pilot_14_str: .string "George Russell"
pilot_15_str: .string "Sergio Perez"
pilot_16_str: .string "Daniil Kvyat"
pilot_17_str: .string "Kimi Raikkonen"
pilot_18_str: .string "Esteban Ocon"
pilot_19_str: .string "Valtteri Bottas"
invalid_pilot_str: .string "Invalid\n"
# array statico piloti
pilots_array: .long	pilot_0_str, pilot_1_str ,pilot_2_str, pilot_3_str, pilot_4_str, pilot_5_str, pilot_6_str, pilot_7_str, pilot_8_str, pilot_9_str, pilot_10_str, pilot_11_str, pilot_12_str, pilot_13_str, pilot_14_str, pilot_15_str, pilot_16_str, pilot_17_str, pilot_18_str, pilot_19_str

    pilots_size: .long (pilot_0_str - pilots_array) / 4
    row_fields_size: .long 3
 
.text
.globl telemetry
.type telemetry, @function
telemetry:
    pushl %ebp
    pushl %ebx
    movl %esp, %ebp
    movl 12(%ebp), %edi # char *input
    movl 16(%ebp), %esi # char *output
    
    cmpb $0, (%edi) # if (*input == '\n' || (*input == '\0'))
    je tlm_fail

    cmpb $10, (%edi)
    je tlm_fail

    subl $4, %esp # alloco parametro getPilotId
    xorl %ecx, %ecx

tlm_loop_1:
    movb (%edi), %al
    cmpb $10, %al
    je tlm_end_loop_1
    movb %al, (%esi, %ecx, 1)
    incl %ecx
    incl %edi
    jmp tlm_loop_1

tlm_end_loop_1:
    incl %ecx
    movb $0, (%esi, %ecx, 1)
    incl %edi

    movl %esi, (%esp)
    call getPilotId
    movl %ebp, %esp

    cmpl $0, %eax
    jl tlm_fail

    xorl %ecx, %ecx # countChar = 0
    subl $28, %esp # alloco (ebp) countLine(-4), output(-8), rowPointer(-16)
    # alloco (ebp) newLine(-20), endChar(-24), comma(-28)
    movl %esi, -8(%ebp) 
tlm_main_loop:    
    cmpb $0, (%edi)
    xorl %edx, %edx # countComma

tlm_flag_loop:
    xorl %ecx, %ecx # countChar

tlm_row_loop:
    movb (%edi), %bl
    # newLine
    cmpb $10, %bl
    sete %al
    movzbl %al, %eax
    movl %eax, -20(%ebp)
    # endChar
    cmpb $0, %bl 
    sete %al
    movzbl %al, %eax
    movl %eax, -24(%ebp)
    # comma
    cmpb $44, %bl
    sete %al
    movzbl %al, %eax
    movl %eax, -28(%ebp) 

    cmpl $1, %eax # comma
    je tlm_special_char
    cmpl $1, -20(%ebp) # newLine
    je tlm_special_char
    cmpl $1, -24(%ebp) # endChar
    je tlm_special_char

    jmp tlm_char

tlm_special_char:
    movb $0, (%esi, %ecx, 1)
    incl %edx
    cmpl $2, %edx # if countComma == 2
    jne tlm_special_char_2
    jmp tlm_special_char_1
    # if skiprow
    pushl %edi
    call charLen
    addl $4, %esp
    addl %eax, %edi
    movl -16(%ebp), %esi
    cmpl $0, (%edi)
    je tlm_end_loop
    movl %edi, %eax
    incl %eax
    cmpl $0, (%eax)
    je tlm_end_loop
    cmpl $10, (%edi)
    jne tlm_reset_comma
    movl %edi, %eax
    incl %eax
    cmpl $10, (%eax)
    je tlm_end_loop # se è uguale anche quello prima lo è, salto

tlm_reset_comma:
    xorl %edx, %edx

tlm_special_char_1:
    incl %edi # input++
    jmp tlm_flag_loop # goto loop

tlm_special_char_2:
    # set pilot stats
    cmpl $1, %edx # if countComma == 1
    jne tlm_special_char_3
    movb %bl, (%esi, %ecx, 1)
    addl %ecx, %esi
    incl %esi

tlm_special_char_3:
    xorl %ecx, %ecx # countChar = 0
    incl %edi # input++
    cmpl $0, -28(%ebp) # if (!comma)
    jne tlm_row_loop

tlm_char:
    movb %bl, (%esi, %ecx, 1)
    incl %edi # input++
    incl %ecx
    jmp tlm_row_loop

tlm_main_loop_1:
    movl %esi, -16(%ebp)
    addl $1, -4(%ebp)
    jmp tlm_main_loop

tlm_end_loop:
# fine

tlm_fail:
    movb $0, (%esi)
    movl $1, %eax

tlm_return:
    popl %ebx
    popl %ebp

    ret
.size	telemetry, .-telemetry

.text
##
# int getPilotId(char *pilotName);
# restituisce id del pilota dall'array dei piloti
##
.globl getPilotId
.type getPilotId, @function
getPilotId:
    pushl %ebp    
    pushl %ebx
    pushl %ecx    
    pushl %edx
    movl %esp, %ebp

    xorl %ecx, %ecx
    subl $12, %esp # alloco anche contatore
    movl 20(%ebp), %edx # parametro pilotname
    movl %edx, -8(%ebp)
    movl pilots_size, %edx
    decl %edx

gpi_loop:
    cmpl %edx, %ecx
    jg gpi_end_loop # while < pilots_size

    movl pilots_array(, %ecx, 4), %ebx
    movl %ebx, (%esp) # parametro char
    call stringCompare
    
    cmpl $0, %eax # if
    je gpi_end_loop
        
    incl %ecx
    jmp gpi_loop 

gpi_end_loop:
    addl $12, %esp # riporto stack pointer in posizione
    popl %edx
    movl %ecx, %eax # return value
    popl %ecx
    popl %ebx
    popl %ebp

    ret
.size	getPilotId, .-getPilotId
