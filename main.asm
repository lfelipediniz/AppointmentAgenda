.data
prompt:       .asciiz "Welcome to AppointmentAgenda\n"
menu:         .asciiz "Select an option for your appointments\n1. Insert\n2. Remove\n3. Edit\n4. List\n0. Exit\n"
input_prompt: .asciiz "Enter your choice: "
event_prompt: .asciiz "Enter the name of the event: "
events:       .space 1000 # Espaço para armazenar os eventos

.text
.globl        main

main:
    #  exibe mensagem de boas-vindas
    li $v0, 4            # código de impressão de string
    la $a0, prompt       # endereço da mensagem de boas vindas
    syscall

menu_loop:
    #  exibe o menu
    li $v0, 4            # código de impressão da string
    la $a0, menu         # endereço do menu
    syscall

    #  solicita a escolha do usuário
    li $v0, 4            # código de impressão da string
    la $a0, input_prompt # endereço da mensagem de entrada
    syscall

    #    le a escolha do usuário
    li   $v0, 5            # código da leitura do inteiro
    syscall
    move $t0, $v0        # armazena a escolha em $t0

    # veridica a escolha do usuário
    beq $t0, $zero, exit  # Sair
    beq $t0, 1, insert_event  # Inserir um evento
	
    # implementem as outras opções aqui

    # Caso contrário, volta para o início do menu
    j menu_loop

insert_event:
    #  solicita o nome do evento
    li $v0, 4              # codigo de impressao da string
    la $a0, event_prompt   # endereco da mensagem do evento
    syscall

    #  le o nome do evento
    li $v0, 8              # codigo de leitura da string
    la $a0, events         # edereco do buffer pra armazenar o evento
    li $a1, 1000           # tamanho maximo do evento
    syscall

    # Volta ao menu
    j menu_loop

exit:
    #  finaliza o programa
    li $v0, 10  # código do serviço de saída
    syscall
