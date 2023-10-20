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

   # events day array  with 120 bytes, 30 days * 4 bytes
   eventsDay: .space 120  

   # events start time hours array with 120 bytes, 30 'hours' * 4 bytes
   eventsStartTimeHours: .space 120

   # events start time minutes array with 120 bytes, 30 'minutes' * 4 bytes
   eventsStartTimeMinutes: .space 120

   # events end time hours array with 120 bytes, 30 'hours' * 4 bytes
   eventsEndTimeHours: .space 120

   # events end time minutes array with 120 bytes, 30 'minutes' * 4 bytes
   eventsEndTimeMinutes: .space 120

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
   insert_eventStartTimeHours: .asciiz "What is the event start time (hours) |Format 24h|?\n"
   insert_eventStartTimeMinutes: .asciiz "What is the event start time (minutes)?\n"

   # print function outputs
   print_eventName: .asciiz "Event name: "
   print_eventDay: .asciiz "Event day: "
   print_eventStartTime: .asciiz "Event start time:\n"
   print_eventStartTimeHours: .asciiz "Hour: "
   print_eventStartTimeMinutes: .asciiz "Minute: "
   print_eventEndTime: .asciiz "Event end time:\n"

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

   #printing the event start time hours question
      li $v0, 4
      la $a0, insert_eventStartTimeHours
      syscall

   # reading the event start time hours
      li $v0, 8
      la $a0, eventsStartTimeHours
      add $a0, $a0, $t0
      li $a1, 4
      syscall

   #printing the event start time minutes question
      li $v0, 4
      la $a0, insert_eventStartTimeMinutes
      syscall

   # reading the event start time minutes
      li $v0, 8
      la $a0, eventsStartTimeMinutes
      add $a0, $a0, $t0
      li $a1, 4
      syscall

   #printing the event end time hours question
      li $v0, 4
      la $a0, insert_eventStartTimeHours
      syscall

   # reading the event end time hours
      li $v0, 8
      la $a0, eventsEndTimeHours
      add $a0, $a0, $t0
      li $a1, 4
      syscall

   #printing the event end time minutes question
      li $v0, 4
      la $a0, insert_eventStartTimeMinutes
      syscall

   # reading the event end time minutes
      li $v0, 8
      la $a0, eventsEndTimeMinutes
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

      # reset auxCounter to 1
      lw $t0, auxCounter

      # print text of event start time
      li $v0, 4
      la $a0, print_eventStartTime
      syscall

      # print text of event start time hours
      li $v0, 4
      la $a0, print_eventStartTimeHours
      syscall

      # print event start time hours
      li $v0, 4
      la $a0, eventsStartTimeHours
      mul $t0, $t0, 4
      add $a0, $a0, $t0
      syscall

      # reset auxCounter to 1
      lw $t0, auxCounter

      # print text of event start time minutes
      li $v0, 4
      la $a0, print_eventStartTimeMinutes
      syscall

      # print event start time minutes
      li $v0, 4
      la $a0, eventsStartTimeMinutes
      mul $t0, $t0, 4
      add $a0, $a0, $t0
      syscall

      # reset auxCounter to 1
      lw $t0, auxCounter

      # print text of event end time
      li $v0, 4
      la $a0, print_eventEndTime
      syscall

      # print text of event end time hours
      li $v0, 4
      la $a0, print_eventStartTimeHours
      syscall

      # print event end time hours
      li $v0, 4
      la $a0, eventsEndTimeHours
      mul $t0, $t0, 4
      add $a0, $a0, $t0
      syscall

      # reset auxCounter to 1
      lw $t0, auxCounter

      # print text of event end time minutes
      li $v0, 4
      la $a0, print_eventStartTimeMinutes
      syscall

      # print event end time minutes
      li $v0, 4
      la $a0, eventsEndTimeMinutes
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

# function to remove an event
remove:
    j loop_action

# function to edit an event
edit:
    j loop_action

main:
    # loop quest the action to the user
    loop_action:
        # print the available actions
        li $v0, 4
        la $a0, actions
        syscall

        # read the int number of the action
        li $v0, 5
        syscall

        # storaging the action in the action variable
        sw $v0, action

        # verify if the action is 0, if yes, quit the program
        lw $t0, action
        beq $t0, $zero, quit

        # call the function according to the action
        beq $t0, 1, insert
        beq $t0, 2, print
        beq $t0, 3, remove
        beq $t0, 4, edit

        # case the action is invalid, print the invalidAction message
        li $v0, 4
        la $a0, invalidAction
        syscall

        # for ilegal actions, we need to call the loop_action again
        j loop_action

quit:
    # exit the program
    li $v0, 10
    syscall
