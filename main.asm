
#this script is a simple agenda for appointments make in MIPS assembly

# data segment
.data
    #action inserted by the user
    action: .word 0

   # counter of events
   eventCounter: .word 1

   # auxiliar counter
   auxCounter: .word 0

   # events name array with 1500 bytes
   eventsName: .space 1500

   # events day array with 120 bytes, 30 days * 4 bytes
   eventsDay: .space 120  

    # strings returned to the user
    actions: .asciiz "Available actions:\n[1] insert\n[2] print\n[3] remove\n[4] edit\n[0] quit\n"
    invalidAction: .asciiz "Invalid Action!\n"
    errorInput: .asciiz "Unable to insert :(\n"
    welcome: .asciiz "Welcome to AppointmentAgenda!\n"

   # line break
   lineBreak: .asciiz "\n"

   # insert function outputs
   insert_eventName: .asciiz "What is the event name?\n"
   insert_eventDay: .asciiz "What day does this event occur?\n"
   insert_eventStartTime: .asciiz "What time does this event start?\n"
   insert_eventEndTime: .asciiz "What time does this event end?\n"

   # print function outputs
   print_eventName: .asciiz "Event name: "
   print_eventDay: .asciiz "Event day: "

.text
.globl main

# welcome message
li $v0, 4
la $a0, welcome
syscall

j loop_action

# this function inserts a new event
insert:

   # printing the event name question
      li $v0, 4
      la $a0, insert_eventName
      syscall

   # eventCounter starts in 1, so we need to multiply it by 50 to get the correct position in the array
      lw $t0, eventCounter
      mul $t0, $t0, 50

   # reading the event name

      li $v0, 8
      la $a0, eventsName
      add $a0, $a0, $t0
      li $a1, 50
      syscall


   # eventCounter starts in 1, so we need to multiply it by 4 to get the correct position in the array
      lw $t0, eventCounter
      mul $t0, $t0, 4

   # printing the event day question
      li $v0, 4
      la $a0, insert_eventDay
      syscall

   # reading the event day
         li $v0, 8
         la $a0, eventsDay
         add $a0, $a0, $t0
         li $a1, 4
         syscall

   # incresse at one the eventCounter
      lw $t0, eventCounter
      addi $t0, $t0, 1
      sw $t0, eventCounter

   j loop_action

# function of print all events
print:
    # using auxCounter set to value 0
    li $t0, 1
    sw $t0, auxCounter

    # loop to print all informations about events
    loop_print:

      # if auxCounter is equal to eventCounter, we have printed all events
      lw $t0, auxCounter
      lw $t1, eventCounter
      bge $t0, $t1, exit_print

      #print text of event name
      li $v0, 4
      la $a0, print_eventName
      syscall

      # print event name
      li $v0, 4
      la $a0, eventsName
      mul $t0, $t0, 50
      add $a0, $a0, $t0
      syscall

      # reset auxCounter to 1
      lw $t0, auxCounter 

      # print text of event day
      li $v0, 4
      la $a0, print_eventDay
      syscall

      # print event day
      li $v0, 4
      la $a0, eventsDay
      mul $t0, $t0, 4
      add $a0, $a0, $t0
      syscall
         
      # increment auxCounter
      lw $t0, auxCounter
      addi $t0, $t0, 1
      sw $t0, auxCounter

      # print line break
      li $v0, 4
      la $a0, lineBreak
      syscall

      
      j loop_print

    exit_print:
        j loop_action

# função para remover um evento
remove:
    j loop_action

# função para editar um evento que já existe
edit:
    j loop_action

main:
    # loop que pergunta as acoes desejadas, até que o usuário queira sair
    loop_action:
        # impressão da pergunta
        li $v0, 4
        la $a0, actions
        syscall

        # leitura do número inteiro que representa a ação
        li $v0, 5
        syscall

        # armazenando o valor lido em action
        sw $v0, action

        # verificando se action é igual a 0 (quit)
        lw $t0, action
        beq $t0, $zero, quit

        # se a ação for 1, 2, 3 ou 4, chama a função correspondente
        beq $t0, 1, insert
        beq $t0, 2, print
        beq $t0, 3, remove
        beq $t0, 4, edit

        # caso a ação não seja válida
        li $v0, 4
        la $a0, invalidAction
        syscall

        # chamamos o loop aqui caso o usuário digite uma ação ilegal
        j loop_action

quit:
    # encerrando o programa
    li $v0, 10
    syscall
