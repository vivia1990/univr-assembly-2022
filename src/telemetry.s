.file "telemetry.s"
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
 
.text
.globl telemetry
.type telemetry, @function
telemetry:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx

    leal pilot_0_str, %ebx
    pushl %ebx
    call getPilotId
    movl %eax, %ecx
    ret
.size	telemetry, .-telemetry

.text
.globl getPilotId
.type getPilotId, @function
getPilotId:
    pushl %ebp    
    pushl %ebx
    pushl %ecx    
    pushl %edx
    movl %esp, %ebp

    xorl %ecx, %ecx
    subl $8, %esp
    movl 20(%ebp), %edx # parametro pilotname
    movl %edx, -4(%ebp) # 

gpi_loop:
    cmpl $19, %ecx
    jg gpi_end_loop # while < pilots_size

    movl pilots_array(%ecx), %ebx
    movl %ebx, (%esp) # parametro char
    movl $0, %eax # call stringCompare return in %eax
    
    cmpl $0, %eax # if
    je gpi_end_loop
        
    incl %ecx
    jmp gpi_loop 

gpi_end_loop:
    addl $8, %esp
    popl %edx
    movl %ecx, %eax # return value
    popl %ecx
    popl %ebx
    popl %ebp
    ret

.size	getPilotId, .-getPilotId
