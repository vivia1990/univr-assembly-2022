.file "telemetry.s"
.bss
.comm row_fields, 12 # array long
.comm pilot_stats, 16 # array long
.data
    row_fields_size: .long 3
    pilot_stats_size: .long 4 # maxRpm, tempMax, speedMax, SpeedSum

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
    pilots_size: .long (. - pilots_array) / 4

    strLow: .string "LOW"
    strHigh: .string "HIGH"
    strMed: .string "MEDIUM"

.globl pilot_stats_size
.globl row_fields_size
.globl pilots_size

.text
.globl telemetry
.type telemetry, @function
telemetry:
    pushl %ebp
    pushl %ebx
    pushl %edx
    pushl %ecx
    movl %esp, %ebp
    movl 20(%ebp), %edi # char *input
    movl 24(%ebp), %esi # char *output
    
    cmpb $0, (%edi) # if (*input == '\n' || (*input == '\0'))
    je tlm_fail

    cmpb $10, (%edi)
    je tlm_fail

    subl $4, %esp # alloco parametro getPilotId
    xorl %ecx, %ecx # countChar

tlm_pilot_loop:
    movb (%edi), %al
    cmpb $10, %al
    je tlm_end_pilot_loop
    movb %al, (%esi, %ecx, 1)
    incl %ecx
    incl %edi
    jmp tlm_pilot_loop

tlm_end_pilot_loop:
    movb $0, (%esi, %ecx, 1)
    incl %edi

    movl %esi, (%esp)
    call getPilotId
    movl %ebp, %esp

    cmpl $0, %eax
    jl tlm_fail

    xorl %ecx, %ecx # countChar = 0
    subl $12, %esp # alloco (ebp) countLine(-4), rowPointer(-16)[-8],  pilotId(-32)[-12]
    movl $0, -4(%ebp)
    movl %esi, -8(%ebp)
    movl %eax, -12(%ebp)

tlm_main_loop:    
    cmpb $0, (%edi)
    je tlm_end_loop
    xorl %edx, %edx # countComma

tlm_flag_loop:
    xorl %ecx, %ecx # countChar

tlm_row_loop:
    movb (%edi), %bl
    cmpb $10, %bl # comma
    je tlm_special_char
    cmpb $0, %bl # newLine
    je tlm_special_char
    cmpb $44, %bl # endChar
    je tlm_special_char

    jmp tlm_char

tlm_special_char:
    movb $0, (%esi, %ecx, 1)
    incl %edx # countComma
    cmpl $2, %edx # if countComma == 2
    jne tlm_special_char_2
    pushl %esi
    call strToNum
    addl $4, %esp
    cmpl -12(%ebp), %eax # pilotId == currentId
    je tlm_special_char_1
    pushl %edi
    call charLen
    addl $4, %esp
    addl %eax, %edi
    movl -8(%ebp), %esi # rowPointer
    cmpb $0, (%edi)
    je tlm_end_loop
    movl %edi, %eax
    incl %eax
    cmpb $0, (%eax)
    je tlm_end_loop
    cmpb $10, (%edi)
    jne tlm_reset_comma
    movl %edi, %eax
    incl %eax
    cmpb $10, (%eax)
    je tlm_end_loop # se è uguale anche quello prima lo è, salto

tlm_reset_comma:
    xorl %edx, %edx

tlm_special_char_1:
    incl %edi # input++
    jmp tlm_flag_loop # goto loop

tlm_special_char_2:
    pushl %edx
    pushl %esi
    call setPilotStats
    addl $8, %esp
    cmpl $1, %edx # if countComma == 1
    jne tlm_special_char_3
    movb %bl, (%esi, %ecx, 1)
    addl %ecx, %esi
    incl %esi

tlm_special_char_3:
    xorl %ecx, %ecx # countChar = 0
    incl %edi # input++
    cmpb $44, %bl # if (!comma)
    je tlm_row_loop
    pushl %esi
    call writeArray
    addl $4, %esp
    addl %eax, %esi
    movb $10, (%esi)
    incl %esi
    cmpb $10, %bl # if (newLine && *input != '\n')
    jne tlm_special_char_4 # goto end_loop
    cmpb $10, (%edi)
    je tlm_special_char_4
    jmp tlm_main_loop_1

tlm_special_char_4:
    addl $1, -4(%ebp) # countline
    jmp tlm_end_loop

tlm_char:
    movb %bl, (%esi, %ecx, 1)
    incl %edi # input++
    incl %ecx # countChar++
    jmp tlm_row_loop

tlm_main_loop_1:
    movl %esi, -8(%ebp) # rowPointer
    addl $1, -4(%ebp) # countline
    jmp tlm_main_loop

tlm_end_loop:
    cmpl $0, -4(%ebp)
    je tlm_fail
    movl $1, %eax
    jmp tlm_return

tlm_fail:
    movl 24(%ebp), %edi
    pushl %edi
    movl %edi, 4(%esp)
    leal invalid_pilot_str, %ebx
    pushl %ebx
    call stringCopy
    addl %eax, %esi    
    movb $0, (%esi)
    xorl %eax, %eax

tlm_return:
    movl %ebp, %esp    
    popl %ecx
    popl %edx
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
    je gpi_end_loop_found
        
    incl %ecx
    jmp gpi_loop 

gpi_end_loop:
    movl $-1, %eax # non trovato
    jmp gpi_return

gpi_end_loop_found:
    movl %ecx, %eax    

gpi_return:
    addl $12, %esp
    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp

    ret
.size	getPilotId, .-getPilotId

.text
##
# int setPilotStats(char *output, unsigned field)
# setta le statistiche relative al pilota
##
.globl setPilotStats
.type setPilotStats, @function
setPilotStats:
    pushl %ebp    
    pushl %ebx
    pushl %ecx
    movl %esp, %ebp
    movl 16(%ebp), %eax # output
    movl 20(%ebp), %ebx # field
    subl $16, %esp
    movl %eax, (%esp)

    cmpl $3, %ebx
    jl spss_end
    
    call strToNum
    movl %eax, (%esp)        

    cmpl $3, %ebx
    jne spss_1
    movl $2, 12(%esp)
    movl $250, 8(%esp)
    movl $100, 4(%esp)
    movl $3, %eax # pilot_stats[3]
    movl (%esp), %ecx
    addl pilot_stats(, %eax, 4), %ecx
    movl %ecx, pilot_stats(, %eax, 4)
    call setPilotStat
    jmp spss_end

spss_1:
    cmpl $4, %ebx
    jne spss_2
    movl $0, 12(%esp)
    movl $10000, 8(%esp)
    movl $5000, 4(%esp)
    call setPilotStat
    jmp spss_end

spss_2:
    cmpl $5, %ebx
    jne spss_end
    movl $1, 12(%esp)
    movl $110, 8(%esp)
    movl $90, 4(%esp)    
    call setPilotStat    

spss_end:
    addl $16, %esp
    popl %ecx    
    popl %ebx
    popl %ebp

    ret
.size	setPilotStats, .-setPilotStats

.text
##
# void setPilotStat(long number, long lowVal, long highVal, long index)
# setta le statistiche relative al pilota con i vari confronti
##
.globl setPilotStat
.type setPilotStat, @function
setPilotStat:
    pushl %ebp    
    pushl %ebx
    pushl %ecx
    movl %esp, %ebp    
    movl 16(%ebp), %eax # number
    movl 28(%ebp), %ecx # index
    
    cmpl %eax, pilot_stats(, %ecx, 4)
    jg sps_1
    movl %eax, pilot_stats(, %ecx, 4)
    
sps_1:
    cmpl %eax, 20(%ebp) # lowVal
    jl sps_2
    leal strLow, %ebx
    movl %ebx, row_fields(, %ecx, 4)
    jmp sps_end

sps_2:
    cmpl %eax, 24(%ebp) # highVal
    jge sps_3
    leal strHigh, %ebx
    movl %ebx, row_fields(, %ecx, 4)
    jmp sps_end

sps_3:
    leal strMed, %ebx
    movl %ebx, row_fields(, %ecx, 4)

sps_end:
    popl %ecx
    popl %ebx
    popl %ebp

    ret
.size	setPilotStat, .-setPilotStat

.text
##
# Scrive i valori array row_fields e ritorna il numero di caratteri scritti
# long writeArray(char *output)
##
.globl writeArray
.type writeArray, @function
writeArray:
    pushl %ebp    
    pushl %ebx
    pushl %ecx
    pushl %edx
    movl %esp, %ebp    
    movl 20(%ebp), %ebx # parametro output
    subl $8, %esp # alloco per parametri
    xorl %ecx, %ecx
    movl row_fields_size, %edx

wa_loop:
    cmpl %edx, %ecx
    je wa_end_loop
    movl row_fields(,%ecx, 4), %eax
    movl %eax, (%esp)
    movl %ebx, -4(%ebp)
    call stringCopy
    addl %eax, %ebx
    movb $44, (%ebx)
    incl %ebx
    incl %ecx
    jmp wa_loop

wa_end_loop:
    addl $8, %esp
    decl %ebx
    movb $0, (%ebx)
    movl %ebx, %eax
    movl 20(%ebp), %ebx
    subl %ebx, %eax
    
    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp

    ret
.text
##
# Scrive i valori array pilot_stats nell'ultima riga
# void setTotalsRow(char* output, unsigned long countLine)
##
.globl setTotalsRow
.type setTotalsRow, @function
setTotalsRow:
    pushl %ebp
    pushl %ecx
    pushl %edx
    pushl %edi
    movl %esp, %ebp

    xorl %ecx, %ecx
    movl 20(%ebp), %edi
    movl 24(%ebp), %edx
    movl pilot_stats_size, %eax
    decl %eax
    subl $4, %esp
    movl %eax, -4(%ebp)

str_loop:
    cmpl %ecx, -4(%ebp)
    je str_end    
    pushl pilot_stats(, %ecx, 4)
    call intToString
    pushl %edi
    pushl %eax
    call stringCopy
    addl %eax, %edi
    movb $44, (%edi)
    incl %edi
    incl %ecx    
    jmp str_loop

str_end:
    movl %edx, %ecx
    movl $3, %eax
    movl pilot_stats(, %eax, 4), %eax
    xorl %edx, %edx
    divl %ecx
    pushl %edi
    pushl %eax
    call intToString
    pushl %edi
    pushl %eax
    call stringCopy
    addl %eax, %edi
    movb $10, (%edi)
    inc %edi
    movb $0, (%edi)

    movl %ebp, %esp
    popl %edi
    popl %edx
    popl %ecx
    popl %ebp

    ret
