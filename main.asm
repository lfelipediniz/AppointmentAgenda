.data
prompt:     .asciiz "Welcome to AppointmentAgenda\n"
menu:       .asciiz "Select an option for your appointments\n1. Insert\n2. Remove\n3. Edit\n4. List\n0. Exit\n"
input_prompt: .asciiz "Enter your choice: "

.text
.globl main

main:
    # exibe mensagem de boas-vindas
    li $v0, 4            # código de impressão de string
    la $a0, prompt       # endereço da mensagem de boas vindas
    syscall

menu_loop:
    # exibe o menu
    li $v0, 4            # código de impressão da string
    la $a0, menu         # endereço do menu
    syscall

    # solicita a escolha do usuário
    li $v0, 4            # código de impressão da string
    la $a0, input_prompt # endereço da mensagem de entrada
    syscall

    # le a escolha do usuário
    li $v0, 5            # código da leitura do inteiro
    syscall
    move $t0, $v0        # armazena a escolha em $t0

    # precisa implementar uma lógica para cada opção do menu aqui

    # verifica a escolha do usuário e sai se for 0
    beq $t0, $zero, exit

    # caso o contrario ele volta pro início do menu
    j menu_loop

exit:
    # finaliza o programa
    li $v0, 10  # código do serviço de saída
    syscall
