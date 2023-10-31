#this script is a simple agenda for appointments make in MIPS assembly

# data segment
.data

   #constants
      #strings
      MAX_EVENTS: .word 100
      MAX_LENGTH_EVENT_NAME: .word 50
      MAX_LENGTH_DAY: .word 3
      MAX_LENGTH_HOUR: .word 6

   #variables
      #action inserted by the user
      action: .word 0
      # counter of events
      eventCounter: .word 1
      # auxiliar counter
      auxCounter: .word 0

   # events name array with MAX_LENGTH_EVENT_NAME * MAX_EVENTS bytes
   eventsName: .space 5000

   # events day array  with  MAX_LENGTH_DAY * MAX_EVENTS bytes
   eventsDay: .space 300

   # events start time hours array with MAX_LENGTH_HOUR * MAX_EVENTS bytes
   eventsStartTime: .space 600

   # events end time minutes array with MAX_LENGTH_HOUR * MAX_EVENTS bytes
   eventsEndTime: .space 600

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
      insert_eventStartTime: .asciiz "What is the event start time? Format: HH.MM\n"
      insert_eventEndTime: .asciiz "What is the event end time? Format: HH.MM?\n"


      # print function outputs
      print_eventName: .asciiz "Event name: "
      print_eventDay: .asciiz "Event day: "
      print_eventStartTime: .asciiz "Event start time: "
      print_eventEndTime: .asciiz "Event end time: "

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

   # eventCounter starts in 1, so we need to multiply it by MAX_LENGTH_EVENT_NAME to get the correct position in the array
      lw $t0, eventCounter
      mul $t0, $t0, 50 #MAX_LENGTH_EVENT_NAME

   # reading the event name
      li $v0, 8
      la $a0, eventsName
      add $a0, $a0, $t0
      li $a1, 50 #MAX_LENGTH_EVENT_NAME
      syscall

   # eventCounter starts in 1, so we need to multiply it by MAX_LENGTH_DAY to get the correct position in the array
      lw $t0, eventCounter
      mul $t0, $t0, 3 #MAX_LENGTH_DAY

   # printing the event day question
      li $v0, 4
      la $a0, insert_eventDay
      syscall

   # reading the event day as string
      li $v0, 8
      la $a0, eventsDay
      add $a0, $a0, $t0
      li $a1, 3 #MAX_LENGTH_DAY
      syscall

   # print line break
      li $v0, 4
      la $a0, lineBreak
      syscall

   # eventCounter starts in 1, so we need to multiply it by MAX_LENGTH_HOUR to get the correct position in the array
      lw $t0, eventCounter
      mul $t0, $t0, 6 #MAX_LENGTH_HOUR


   # printing the event start question
      li $v0, 4
      la $a0, insert_eventStartTime
      syscall

   # reading the event start time as string
      li $v0, 8
      la $a0, eventsStartTime
      add $a0, $a0, $t0
      li $a1, 6 #MAX_LENGTH_HOUR
      syscall

   # eventCounter starts in 1, so we need to multiply it by MAX_LENGTH_HOUR to get the correct position in the array
      lw $t0, eventCounter
      mul $t0, $t0, 6 #MAX_LENGTH_HOUR

   # print line break
      li $v0, 4
      la $a0, lineBreak
      syscall

   # print event end time
      li $v0, 4
      la $a0, insert_eventEndTime
      syscall

   # reading the event end time as string
      li $v0, 8
      la $a0, eventsEndTime
      add $a0, $a0, $t0
      li $a1, 6 #MAX_LENGTH_HOUR
      syscall

   # print line break
      li $v0, 4
      la $a0, lineBreak
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

    # loop to print all information about events
    loop_print:

      # if auxCounter is equal to eventCounter, we have printed all events
      lw $t0, auxCounter
      lw $t1, eventCounter
      bge $t0, $t1, exit_print

      # Print text of event name
      li $v0, 4
      la $a0, print_eventName
      syscall

      # Print event name
      li $v0, 4
      la $a0, eventsName
      mul $t2, $t0, 50 #MAX_LENGTH_EVENT_NAME
      add $a0, $a0, $t2
      syscall

      # Reset auxCounter to 1
      lw $t0, auxCounter 

      # Print text of event day
      li $v0, 4
      la $a0, print_eventDay
      syscall

      # Print event day
      li $v0, 4
      la $a0, eventsDay
      mul $t2, $t0, 3 #MAX_LENGTH_DAY
      add $a0, $a0, $t2
      syscall

      # Print line break
      li $v0, 4
      la $a0, lineBreak
      syscall

      # Print text of event start time
      li $v0, 4
      la $a0, print_eventStartTime
      syscall

      # Print event start time
      li $v0, 4
      la $a0, eventsStartTime
      mul $t2, $t0, 6 #MAX_LENGTH_HOUR
      add $a0, $a0, $t2
      syscall

      # Print line break
      li $v0, 4
      la $a0, lineBreak
      syscall

      # Print text of event end time
      li $v0, 4
      la $a0, print_eventEndTime
      syscall

      # Print event end time
      li $v0, 4
      la $a0, eventsEndTime
      mul $t2, $t0, 6 #MAX_LENGTH_HOUR
      add $a0, $a0, $t2
      syscall

      # Print line break
      li $v0, 4
      la $a0, lineBreak
      syscall

      # Increment auxCounter
      lw $t0, auxCounter
      addi $t0, $t0, 1
      sw $t0, auxCounter

      # Print line break
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
