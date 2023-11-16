#this script is a simple agenda for appointments make in MIPS assembly

# data segment
.data

   #constants
      #strings
      MAX_EVENTS: .word 100
      MAX_LENGTH_EVENT_NAME: .word 50
      MIN_HOUR: .float 0.0
      MAX_HOUR: .float 23.59
      MAX_MINUTES: .float 0.59

   #flags
      editer_flag: .word 0


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
      aux_eventString: .space 50
      aux_eventName: .space 50


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
      invalidAction: .asciiz "\nInvalid Action!\n"
      errorInput: .asciiz "\nUnable to insert :(\n"
      welcome: .asciiz "Welcome to AppointmentAgenda!\n"
      notImplemented: .asciiz "Not implemented yet!\n"
      errorWrongInput: .asciiz "\nWrong input!\n"

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
      remove_noEventToRemove: .asciiz "There is no event to remove!\n"

      # edit function outputs
      edit_eventNumber: .asciiz "What is the event number to be edited?\n"
      edit_eventName: .asciiz "What is the new event name?\n"
      edit_eventDay: .asciiz "What is the new event day?\n"
      edit_eventStartTime: .asciiz "What is the new event start time?\n"
      edit_eventEndTime: .asciiz "What is the new event end time?\n"
      edit_noEventToEdit: .asciiz "There is no event to edit!\n"
      edit_keepThis: .asciiz "\nKeep this value?\n[0] Yes\n[1] No\n"
      edit_whatsNew: .asciiz "\nWhat is the new value?\n"
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
      la $a0, aux_eventName
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

   # if $v0 is smaller than 1 or bigger than 31 we need to print the errorInput message
      blt $v0, 1, errorInsert
      bgt $v0, 31, errorInsert

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

      # for minutes greater than 59, we need to print the errorInput message

      # storage aux_eventStartTime in $f12
      l.s $f12, aux_eventStartTime

      # Convert the floating-point value in f12 to an integer
      cvt.w.s $f22, $f12   # Convert single-precision floating point to 32-bit integer in f0
      # Store the integer part in an integer register
      mfc1 $t6, $f22        # Move the integer value from f0 to $t0


      # Move the integer value from $t6 to a floating-point register $f12
      mtc1 $t6, $f16     # Move the integer value in $t6 to floating-point register $f12

      # Convert the integer value in $f12 to a floating-point value
      cvt.s.w $f16, $f16  # Convert 32-bit integer in $f12 to single-precision float in $f12

      # Subtract the value in f16 from f12 and store the result in f12
      sub.s $f12, $f12, $f16  

      # storage MAX_MINUTES in $f19
      l.s $f19, MAX_MINUTES

      # compare if the minutes is greater than 59
      c.lt.s $f19, $f12  
      bc1t errorInsert   

   # print event end time
      li $v0, 4
      la $a0, insert_eventEndTime
      syscall

   # reading the event end time as float
      li $v0, 6
      syscall
      s.s $f0, aux_eventEndTime
      l.s $f15, aux_eventStartTime
      c.lt.s $f0, $f15   # if f0 < f15
      bc1t errorInsert        

      c.eq.s $f0, $f15   # if f0 == f15
      bc1t errorInsert 

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

      # for minutes greater than 59, we need to print the errorInput message

      # storage aux_eventStartTime in $f12
      l.s $f12, aux_eventEndTime

      # Convert the floating-point value in f12 to an integer
      cvt.w.s $f22, $f12   # Convert single-precision floating point to 32-bit integer in f0
      # Store the integer part in an integer register
      mfc1 $t6, $f22        # Move the integer value from f0 to $t0


      # Move the integer value from $t6 to a floating-point register $f12
      mtc1 $t6, $f16     # Move the integer value in $t6 to floating-point register $f12

      # Convert the integer value in $f12 to a floating-point value
      cvt.s.w $f16, $f16  # Convert 32-bit integer in $f12 to single-precision float in $f12

      # Subtract the value in f16 from f12 and store the result in f12
      sub.s $f12, $f12, $f16  

      # storage MAX_MINUTES in $f19
      l.s $f19, MAX_MINUTES

      # compare if the minutes is greater than 59
      c.lt.s $f19, $f12  
      bc1t errorInsert 

      j compareDay
      
      day_insert:
      exit_sortArray:
        
   # increase at one the eventCounter
      lw $t0, eventCounter
      addi $t0, $t0, 1
      sw $t0, eventCounter

      j loop_action
 
compareDay:

   # using auxCounter set to value 1
   li $t1, 1
   lw $t2, eventCounter

   # compare if the day inserted already exists withing the eventsDay array
   loop_compareDay:

      # if auxCounter is equal to eventCounter, we have compared all days, the value inserted is the biggest
      bge $t1, $t2, exit_compareDay

      mul $t3, $t1, 50 #MAX_LENGTH_EVENT_NAME

      # aux_eventName into eventsName array
      la $t4, aux_eventString
      la $t5, eventsName($t3)

      # loop to copy the aux_eventName into eventsName
      loop_insertNameinAux:
         lb $t7, 0($t5)
         sb $t7, 0($t4)
         addi $t4, $t4, 1
         addi $t5, $t5, 1
         bne $t7, $zero, loop_insertNameinAux
         j  exit_insertNameinAux

       exit_insertNameinAux:


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
  mul $t5, $t1, 4 #MAX_LENGTH_HOUR

  # store the start time and end time of the event inserted confliction and atual event
  l.s $f13, aux_eventStartTime
  l.s $f14, aux_eventEndTime
  l.s $f15, eventsStartTime($t5)
  l.s $f16, eventsEndTime($t5)

    # verify if the event inserted confliction with the atual event
    c.lt.s $f14, $f15   # if f14 < f15
    bc1t sortArray        

    c.eq.s $f14, $f15   # if f14 == f15
    bc1t sortArray          

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
   # store aux_eventName into eventsName array

   mul $t3, $t1, 50 #MAX_LENGTH_EVENT_NAME
   # aux_eventName into eventsName array
   la $t6, aux_eventName
   la $t7, eventsName($t3)
   # loop to copy the aux_eventName into eventsName
   loop_insertAuxName:
      lb $t3, 0($t6)
      sb $t3, 0($t7)
      addi $t6, $t6, 1
      addi $t7, $t7, 1
      bne $t3, $zero, loop_insertAuxName
      j exit_insertAuxName

   exit_insertAuxName:


   mul $t3, $t1, 4 #MAX_LENGTH_DAY
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

   # event name in the array sorted
   mul $t3, $t1, 50 #MAX_LENGTH_EVENT_NAME
   
   # copy from eventsName($t3) to aux_eventName
   la $t6, eventsName($t3)
   la $t7, aux_eventName

   loop_nameSort:
      lb $t8, 0($t6)
      sb $t8, 0($t7)
      addi $t6, $t6, 1
      addi $t7, $t7, 1
      bne $t8, $zero, loop_nameSort
      j exit_nameSort
   exit_nameSort:

   # store aux_eventString into eventsName($t3) array
   la $t6, aux_eventString
   la $t7, eventsName($t3)

   loop_nameSort2:
      lb $t8, 0($t6)
      sb $t8, 0($t7)
      addi $t6, $t6, 1
      addi $t7, $t7, 1
      bne $t8, $zero, loop_nameSort2
      j exit_nameSort2
   exit_nameSort2:

   # move aux_eventName to aux_eventString
   la $t6, aux_eventName
   la $t7, aux_eventString

   loop_nameSort3:
      lb $t8, 0($t6)
      sb $t8, 0($t7)
      addi $t6, $t6, 1
      addi $t7, $t7, 1
      bne $t8, $zero, loop_nameSort3
      j exit_nameSort3
   exit_nameSort3:

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

   insertAuxEvent:
   # set t0 apropiate position in the array
   lw $t0, eventCounter
   mul $t0, $t0, 50 #MAX_LENGTH_EVENT_NAME

   # aux_eventName into eventsName array
   la $t1, aux_eventName
   la $t2, eventsName($t0)



   # loop to copy the aux_eventName into eventsName
   loop_insertName:
      lb $t3, 0($t1)
      sb $t3, 0($t2)
      addi $t1, $t1, 1
      addi $t2, $t2, 1
      bne $t3, $zero, loop_insertName
      j exit_insertName

   exit_insertName:

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
   # if eventCounter is equal to 1, we have no events to remove
   lw $t0, eventCounter
   beq $t0, 1, errorNoEventToRemove


    # print the event number question
      li $v0, 4
      la $a0, remove_eventNumber
      syscall

   # store the event number in the eventNumber variable
      li $v0, 5
      syscall
      sw $v0, eventNumber

   # if $v0 is smaller than 2 or bigger than eventCounter we need to print the errorInput message
      blt $v0, 1, errorWrongInputf
      sub $t0, $t0, 1
      bgt $v0, $t0, errorWrongInputf


   edit_remover:
   # eventNumber is number of the event to be removed
      lw $t0, eventNumber
      lw $t1, eventCounter
      addi $t0, $t0, 1
      bge $t0, $t1, exit_remover
      
      mul $t2, $t0, 50 #MAX_LENGTH_EVENT_NAME
      sub $t5, $t2, 50 #MAX_LENGTH_DAY
      la $t4, eventsName($t2)
      la $t6, eventsName($t5)

      loop_nameRemover:
         lb $t7, 0($t4)
         sb $t7, 0($t6)
         addi $t4, $t4, 1
         addi $t6, $t6, 1
         bne $t7, $zero, loop_nameRemover
         j exit_nameRemover

      exit_nameRemover:


      mul $t2, $t0, 4 #MAX_LENGTH_DAY
      sub $t5, $t2, 4 #MAX_LENGTH_DAY
      
      lw $t4, eventsDay($t2)
      sw $t4, eventsDay($t5)

      l.s $f12, eventsStartTime($t2)
      s.s $f12, eventsStartTime($t5)

      l.s $f13, eventsEndTime($t2)
      s.s $f13, eventsEndTime($t5)


   exit_remover:
   # decrease eventCounter
   lw $t1, eventCounter
   subi $t1, $t1, 1
   sw $t1, eventCounter

   lw $t0, editer_flag
   beq $t0, $zero loop_action
   j edit_insert


errorNoEventToRemove:
   li $v0, 4
   la $a0, remove_noEventToRemove
   syscall

   j loop_action

# function to edit an event
edit:
    # if eventCounter is 1, we need to print the errorEdit message
      lw $t0, eventCounter
      beq $t0, 1, errorNoEvent

    # print the event number question
      li $v0, 4
      la $a0, edit_eventNumber
      syscall

   # store the event number in the eventNumber variable
      li $v0, 5
      syscall
      sw $v0, eventNumber

   # if $v0 is smaller than 1 or bigger than eventCounter we need to print the errorInput message
      blt $v0, 1, errorWrongInputf
      sub $t0, $t0, 1
      bgt $v0, $t0, errorWrongInputf

      # set editer_flag to 1
      lw $t0, editer_flag
      addi $t0, $t0, 1
      sw $t0, editer_flag

   # storage the evventday in s0
      lw $t0, eventNumber
      mul $t0, $t0, 4 #MAX_LENGTH_DAY

      lw $s0, eventsDay($t0)

   # storage the event start time in aux_eventStartTime
      l.s $f12, eventsStartTime($t0)
      s.s $f12, aux_eventStartTime

   # storage the event end time in aux_eventEndTime
      l.s $f12, eventsEndTime($t0)
      s.s $f12, aux_eventEndTime

   # storage the event name in aux_eventName
      mul $t0, $t0, 50 #MAX_LENGTH_EVENT_NAME
      la $t1, eventsName($t0)
      la $t2, aux_eventName

      loop_nameEdit:
         lb $t3, 0($t1)
         sb $t3, 0($t2)
         addi $t1, $t1, 1
         addi $t2, $t2, 1
         bne $t3, $zero, loop_nameEdit
         j exit_nameEdit

      exit_nameEdit:

   # jumps to remove function with editer_flag set to 1
   j edit_remover

   edit_insert:

   # printing the event name question
      li $v0, 4
      la $a0, edit_eventName
      syscall

   # eventCounter starts in 1, so we need to multiply it by MAX_LENGTH_EVENT_NAME to get the correct position in the array
      lw $t0, eventCounter
      mul $t0, $t0, 50 #MAX_LENGTH_EVENT_NAME

   # print keep event question
      li $v0, 4
      la $a0, edit_keepThis
      syscall

   # reading the option
    li $v0, 5               
    syscall                
    move $t3, $v0  

   # if $t3 is equal zero, jump to edit_jumpName
      beq $t3, $zero, edit_jumpName

   # print what's new question
      li $v0, 4
      la $a0, edit_whatsNew
      syscall

   # reading the event name
      li $v0, 8
      la $a0, aux_eventName
      li $a1, 50 #MAX_LENGTH_EVENT_NAME
      syscall

   edit_jumpName:

   # eventCounter starts in 1, so we need to multiply it by 4 to get the correct position in the array
      lw $t0, eventCounter
      mul $t0, $t0, 4

   # printing the event day question
      li $v0, 4
      la $a0, insert_eventDay
      syscall

   # print keep event question
      li $v0, 4
      la $a0, edit_keepThis
      syscall

   # reading the option
    li $v0, 5               
    syscall                
    move $t3, $v0  

   # if $t3 is equal zero, jump to edit_jumpDay
      beq $t3, $zero, edit_jumpDay

   # print what's new question
      li $v0, 4
      la $a0, edit_whatsNew
      syscall

   # reading the event day as integer
      li $v0, 5
      syscall
      move $s0, $v0

   # if $v0 is smaller than 1 or bigger than 31 we need to print the errorInput message
      blt $v0, 1, errorInsert
      bgt $v0, 31, errorInsert

   edit_jumpDay:
   
   # printing the event start question
      li $v0, 4
      la $a0, insert_eventStartTime
      syscall

   # print keep event question
      li $v0, 4
      la $a0, edit_keepThis
      syscall
   
   # reading the option
    li $v0, 5               
    syscall                
    move $t3, $v0           

   # if $t3 is equal zero, jump to edit_jumpStartTime
      beq $t3, $zero, edit_jumpStartTime

   # print what's new question
      li $v0, 4
      la $a0, edit_whatsNew
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

      # for minutes greater than 59, we need to print the errorInput message

      # storage aux_eventStartTime in $f12
      l.s $f12, aux_eventStartTime

      # Convert the floating-point value in f12 to an integer
      cvt.w.s $f22, $f12   # Convert single-precision floating point to 32-bit integer in f0
      # Store the integer part in an integer register
      mfc1 $t6, $f22        # Move the integer value from f0 to $t0


      # Move the integer value from $t6 to a floating-point register $f12
      mtc1 $t6, $f16     # Move the integer value in $t6 to floating-point register $f12

      # Convert the integer value in $f12 to a floating-point value
      cvt.s.w $f16, $f16  # Convert 32-bit integer in $f12 to single-precision float in $f12

      # Subtract the value in f16 from f12 and store the result in f12
      sub.s $f12, $f12, $f16  

      # storage MAX_MINUTES in $f19
      l.s $f19, MAX_MINUTES

      # compare if the minutes is greater than 59
      c.lt.s $f19, $f12  
      bc1t errorInsert

   edit_jumpStartTime:  

   # print event end time
      li $v0, 4
      la $a0, insert_eventEndTime
      syscall

   # print keep event qkeep
      li $v0, 4
      la $a0, edit_keepThis
      syscall

   # reading the option
    li $v0, 5               
    syscall                
    move $t3, $v0  


   # if $t3 is equal zero, jump to edit_jumpEndTime
      beq $t3, $zero, edit_jumpEndTime

   # reading the event end time as float
      li $v0, 6
      syscall
      s.s $f0, aux_eventEndTime
      l.s $f15, aux_eventStartTime
      c.lt.s $f0, $f15   # if f0 < f15
      bc1t errorInsert        

      c.eq.s $f0, $f15   # if f0 == f15
      bc1t errorInsert 

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

      # for minutes greater than 59, we need to print the errorInput message

      # storage aux_eventStartTime in $f12
      l.s $f12, aux_eventEndTime

      # Convert the floating-point value in f12 to an integer
      cvt.w.s $f22, $f12   # Convert single-precision floating point to 32-bit integer in f0
      # Store the integer part in an integer register
      mfc1 $t6, $f22        # Move the integer value from f0 to $t0


      # Move the integer value from $t6 to a floating-point register $f12
      mtc1 $t6, $f16     # Move the integer value in $t6 to floating-point register $f12

      # Convert the integer value in $f12 to a floating-point value
      cvt.s.w $f16, $f16  # Convert 32-bit integer in $f12 to single-precision float in $f12

      # Subtract the value in f16 from f12 and store the result in f12
      sub.s $f12, $f12, $f16  

      # storage MAX_MINUTES in $f19
      l.s $f19, MAX_MINUTES

      # compare if the minutes is greater than 59
      c.lt.s $f19, $f12  
      bc1t errorInsert

      edit_jumpEndTime:

      j compareDay

errorNoEvent:
   li $v0, 4
   la $a0, edit_noEventToEdit
   syscall

   j loop_action

errorWrongInputf:
   li $v0, 4
   la $a0, errorWrongInput
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
