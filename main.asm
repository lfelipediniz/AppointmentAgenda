#this script is a simple agenda for appointments make in MIPS assembly

# data segment
.data

   #constants
      #strings
      MAX_EVENTS: .word 100
      MAX_LENGTH_EVENT_NAME: .word 50
      MIN_HOUR: .float 0.0
      MAX_HOUR: .float 23.59
      INVALID_DAY: .word 39
      INVALID_DAY_MASTER: .word 45
      

      COMMON_SHOUR: .float 8.0
      COMMON_EHOUR: .float 18.0


   #variables
      #action inserted by the user
      action: .word 0
      # counter of events
      eventCounter: .word 1

      #event number for remove and edit
      eventNumber: .word 0
      

      #auxiliary inputs
      aux_eventStartTime: .float 0.0
      aux_eventEndTime: .float 0.0

      #flags
      flag_removeSort: .word 0

   # events name array with MAX_LENGTH_EVENT_NAME * MAX_EVENTS bytes
   eventsName: .space 5000

   # events day array  with  4 * MAX_EVENTS bytes
   eventsDay: .space 400

   # events start time hours array with 4 * MAX_EVENTS bytes
   eventsStartTime: .space 400

   # events end time minutes array with 4 * MAX_EVENTS bytes
   eventsEndTime: .space 400

   # strings returned to the user
      actions: .asciiz "Available actions:\n[1] insert\n[2] print\n[3] remove\n[4] edit\n[0] quit\n"
      invalidAction: .asciiz "Invalid Action!\n"
      errorInput: .asciiz "\nUnable to insert :(\n"
      welcome: .asciiz "Welcome to AppointmentAgenda!\n"
      notImplemented: .asciiz "Not implemented yet!\n"

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
      print_eventNumber: .asciiz "Event number: "

      # remove function outputs
      remove_eventNumber: .asciiz "What is the event number to be removed?\n"

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

   # eventCounter starts in 1, so we need to multiply it by 4 to get the correct position in the array
      lw $t0, eventCounter
      mul $t0, $t0, 4

   # printing the event day question
      li $v0, 4
      la $a0, insert_eventDay
      syscall

   # reading the event day as integer
      li $v0, 5
      syscall
      move $s0, $v0

   # printing the event start question
      li $v0, 4
      la $a0, insert_eventStartTime
      syscall

   # reading the event start time as float
      li $v0, 6
      syscall
      s.s $f0, aux_eventStartTime

   # verify if is a valid hour

      # if the hour is less than 0, we need to print the errorInput message
      l.s $f12, MIN_HOUR
      c.lt.s $f0, $f12   # Compare if $f0 less than $f12
      bc1t errorInsert   # if true, print error message

      # if the hour is greater than 23.59, we need to print the errorInput message
      l.s $f12, MAX_HOUR
      c.lt.s $f12, $f0   # Compare if $f12 less than $f0
      bc1t errorInsert   # if true, print error message

   # print event end time
      li $v0, 4
      la $a0, insert_eventEndTime
      syscall

   # reading the event end time as float
      li $v0, 6
      syscall
      s.s $f0, aux_eventEndTime

   # verify if is a valid hour

      # if the hour is less than 0, we need to print the errorInput message
      l.s $f12, MIN_HOUR
      c.lt.s $f0, $f12   # Compare if $f0 less than $f12
      bc1t errorInsert   # if true, print error message

      # if the hour is greater than 23.59, we need to print the errorInput message
      l.s $f12, MAX_HOUR
      c.lt.s $f12, $f0   # Compare if $f12 less than $f0
      bc1t errorInsert   # if true, print error message
      
      # if the hour is less than the start time, we need to print the errorInput message
      l.s $f12, aux_eventStartTime
      c.lt.s $f0, $f12   # Compare if $f0 less than $f12
      bc1t errorInsert   # if true, print error message

      j compareDay
      
      day_insert:
      exit_sortArray:

   # if flag_removeSort is equal to 1, goto jumpIncrement
      lw $t3, flag_removeSort
      beq $t3, 1, jumpIncrement

   # increase at one the eventCounter
      lw $t0, eventCounter
      addi $t0, $t0, 1
      sw $t0, eventCounter

      j loop_action

   jumpIncrement:
      #decrease 1 in eventCounter
      lw $t1, eventCounter
      subi $t1, $t1, 1
      sw $t1, eventCounter

      j loop_action


compareDay:

   # set flag_removeSort to 0
   li $t3, 0
   sw $t3, flag_removeSort

   # using auxCounter set to value 1
   li $t1, 1
   lw $t2, eventCounter

   # compare if the day inserted already exists withing the eventsDay array
   loop_compareDay:

      # if auxCounter is equal to eventCounter, we have compared all days, the value inserted is the biggest
      bge $t1, $t2, exit_compareDay

      # if the day inserted is equal to any day in the array, we need to print the errorInput message
      mul $t3, $t1, 4 #MAX_LENGTH_DAY
      lw $t4, eventsDay($t3)
      l.s $f14, eventsStartTime($t3)
      l.s $f16, eventsEndTime($t3)
      beq $t4, $s0, compareHour

      exit_compareHour:

      # if the day inserted is less than any day in the array, we need to insert it in actual position
      blt $s0, $t4, sortArray

      
      # Increment auxCounter
      addi $t1, $t1, 1
   j loop_compareDay


compareHour:
  mul $t5, $t2, 4 #MAX_LENGTH_HOUR

  # store the start time and end time of the event inserted confliction and atual event
  l.s $f13, eventsStartTime($t3)
  l.s $f14, eventsEndTime($t3)
  l.s $f15, eventsStartTime($t5)
  l.s $f16, eventsEndTime($t5)

    # verify if the event inserted confliction with the atual event
    c.lt.s $f14, $f15   # if f14 < f15
    bc1t exit_compareHour        

    c.eq.s $f14, $f15   # if f14 == f15
    bc1t exit_compareHour          

    c.lt.s $f16, $f13   # if f16 < f13
    bc1t exit_compareHour          

    c.eq.s $f16, $f13   # if f16 == f13
    bc1t exit_compareHour           

    c.eq.s $f14, $f15   # if f14 == f15
    bc1t errorInsert         

    c.eq.s $f16, $f13   # if f16 == f13
    bc1t errorInsert         

    j errorInsert  # after all comparisons, we need to print the errorInput message


sortArray:

   # store day inserted in the array
   sw $s0, eventsDay($t3)


   # store start time inserted in the array
   l.s $f12, aux_eventStartTime
   s.s $f12, eventsStartTime($t3)

   # store end time inserted in the array
   l.s $f13, aux_eventEndTime
   s.s $f13, eventsEndTime($t3)
   
   loop_sortArray:

   # $t1=auxCounter, $t2=eventCounter, $t3=position in the array, $t4=day in the array
   beq $t1, $t2, exit_sortArray # if auxCounter is equal to eventCounter, the array is sorted
   addi $t1, $t1, 1 # Increment auxCounter($t1)
   mul $t3, $t1, 4 # position in the array, auxCounter * 4

   # event day in the array sorted
   lw $t5, eventsDay($t3) # day in the array
   sw $t4, eventsDay($t3) # store day in the array in $t4
   move $t4, $t5 # move day in the array to $t4

   # event start time in the array sorted
   l.s $f15, eventsStartTime($t3) # start time in the array
   s.s $f14, eventsStartTime($t3) # store start time in the array in $f12
   mov.s $f14, $f15 # move start time in the array to $f12

   # event end time in the array sorted
   l.s $f17, eventsEndTime($t3) # end time in the array
   s.s $f16, eventsEndTime($t3) # store end time in the array in $f12
   mov.s $f16, $f17 # move end time in the array to $f12


   j loop_sortArray


exit_compareDay:
   # day greater than any event, so we can insert it in the end of the array

   # event day in the array sorted
   sw $s0, eventsDay($t0) 

   # event start time in the array sorted
   l.s $f12, aux_eventStartTime
   s.s $f12, eventsStartTime($t0)

   # event end time in the array sorted
   l.s $f13, aux_eventEndTime
   s.s $f13, eventsEndTime($t0)

   j day_insert
   
errorInsert:
   li $v0, 4
   la $a0, errorInput
   syscall
      
   # print line break
   li $v0, 4
   la $a0, lineBreak
   syscall
      
   j loop_action


# function of print all events
print:
    # using auxCounter set to 1
    li $t0, 1
    lw $t1, eventCounter

    # loop to print all information about events
    loop_print:

      # if auxCounter is equal to eventCounter, we have printed all events
      bge $t0, $t1, exit_print

      # Print text of event number
      li $v0, 4
      la $a0, print_eventNumber
      syscall

      # print t0
      li $v0, 1
      move $a0, $t0
      syscall

      # Print line break
      li $v0, 4
      la $a0, lineBreak
      syscall

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


      # Print text of event day
      li $v0, 4
      la $a0, print_eventDay
      syscall

      # We need to multiply the counter by 4 to get the correct position in the array
      mul $t2, $t0, 4 #MAX_LENGTH_DAY

      # Print event day
      li $v0, 1
      lw $a0, eventsDay($t2)
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
      li $v0, 2
      l.s $f12, eventsStartTime($t2)
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
      li $v0, 2
      l.s $f12, eventsEndTime($t2)
      syscall

      # Print line break
      li $v0, 4
      la $a0, lineBreak
      syscall

      # Increment auxCounter
      addi $t0, $t0, 1

      # Print line break
      li $v0, 4
      la $a0, lineBreak
      syscall

      j loop_print 

    exit_print:
        j loop_action



# function to remove an event
remove:
    # print the event number question
      li $v0, 4
      la $a0, remove_eventNumber
      syscall

   # store the event number in the eventNumber variable
      li $v0, 5
      syscall
      sw $v0, eventNumber

   # adapt eventNumber to integer
   lw $t0, eventNumber
   mul $t0, $t0, 4 #DAY_LENGTH

   # storage INVALID in the event day
   lw $t1, INVALID_DAY_MASTER
   sw $t1, eventsDay($t0)

   # storage 1 in t1
   li $t1, 1 # auxCounter

   # storage eventCounter in t2
   lw $t2, eventCounter

   # set flag_removeSort to 1
   li $t3, 1
   sw $t3, flag_removeSort

   j loop_sortArray

# function to edit an event
edit:
    li $v0, 4
    la $a0, notImplemented
    syscall
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