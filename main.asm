.data
prompt:       .asciiz "Welcome to AppointmentAgenda\n"
menu:         .asciiz "Select an option for your appointments\n1. Insert\n2. Remove\n3. Edit\n4. List\n0. Exit\n"
input_prompt: .asciiz "Enter your choice: "
event_prompt: .asciiz "Enter the name of the event: "
day_prompt:   .asciiz "Enter the day of the event: "
start_prompt: .asciiz "Enter the starting time of the event (e.g., 13.30): "
end_prompt:   .asciiz "Enter the ending time of the event (e.g., 14.30): "

#  Definindo a estrutura do nó do evento e alinhado corretamente (64 bytes)
.align        3
event_node:   .space 64

# Estrutura do evento
event_list:   .word 0 # Início da lista de eventos
event_count:  .word 0 # Contador de eventos

.text
.globl        main

main:
    #  Exibe mensagem de boas-vindas
    li $v0, 4            # Código de impressão de string
    la $a0, prompt       # Endereço da mensagem de boas vindas
    syscall

menu_loop:
    #  Exibe o menu
    li $v0, 4            # Código de impressão da string
    la $a0, menu         # Endereço do menu
    syscall

    #  Solicita a escolha do usuário
    li $v0, 4            # Código de impressão da string
    la $a0, input_prompt # Endereço da mensagem de entrada
    syscall

    #    Lê a escolha do usuário
    li   $v0, 5            # Código da leitura do inteiro
    syscall
    move $t0, $v0        # Armazena a escolha em $t0

    # Verifica a escolha do usuário
    beq $t0, $zero, exit   # Sair
    beq $t0, 1, insert_event # Inserir um evento
    # Implemente outras opções aqui

    # Caso contrário, volta para o início do menu
    j menu_loop

insert_event:
    #  Solicita o nome do evento
    li $v0, 4              # Código de impressão de string
    la $a0, event_prompt   # Endereço da mensagem do evento
    syscall

    #  Lê o nome do evento
    li $v0, 8              # Código de leitura da string
    la $a0, event_node     # Endereço do buffer para armazenar o evento
    li $a1, 64             # Tamanho máximo do evento
    syscall

    #  Solicita o dia do evento
    li $v0, 4              # Código de impressão de string
    la $a0, day_prompt     # Endereço da mensagem do dia
    syscall

    #    Lê o dia do evento
    li   $v0, 5              # Código da leitura do inteiro
    syscall
    move $t1, $v0          # Armazena o dia em $t1

    #  Solicita o horário de início do evento
    li $v0, 4              # Código de impressão de string
    la $a0, start_prompt   # Endereço da mensagem do horário de início
    syscall

    #     Lê o horário de início do evento
    li    $v0, 6              # Código da leitura do número de ponto flutuante
    syscall
    mov.s $f0, $f0         # Move o valor de ponto flutuante para $f0

    #  Solicita o horário de término do evento
    li $v0, 4              # Código de impressão de string
    la $a0, end_prompt     # Endereço da mensagem do horário de término
    syscall

    #     Lê o horário de término do evento
    li    $v0, 6              # Código da leitura do número de ponto flutuante
    syscall
    mov.s $f1, $f0         # Move o valor de ponto flutuante para $f1

    #   Chama a função para adicionar o evento à lista
    jal add_event_to_list

    # Volta ao menu
    j menu_loop

add_event_to_list:
    #    Verifica se a lista de eventos está vazia
    lw   $t2, event_list
    beqz $t2, create_new_event_list

    #    Se não estiver vazia, encontra o último evento na lista
    move $t3,                  $t2
    lw   $t2,                  ($t2)   # Próximo evento na lista
    loop_find_last_event:
        beqz $t2, add_to_existing_event_list
        move $t3, $t2
        lw   $t2, ($t2)  # Próximo evento na lista
        j    loop_find_last_event

    # Cria um novo evento na lista
    create_new_event_list:
        la $t2,   event_node  # Endereço do novo evento
        sw $zero, ($t2)     # Inicializa o campo "prox" com zero
        sw $t2,   event_list  # Define o novo evento como início da lista
        addi $t0, $t0, 1   # Incrementa o contador de eventos
        sw $t0,   event_count

    # Adiciona os dados do evento no novo nó
    add_to_existing_event_list:
        sw    $t1, 4($t2)  # Armazena o dia do evento no nó
        mov.s $f2, $f0  # Copia o horário de início para $f2
        mov.s $f3, $f1  # Copia o horário de término para $f3
        swc1  $f2, 8($t2)  # Armazena o horário de início no nó
        swc1  $f3, 12($t2) # Armazena o horário de término no nó
        move  $t3, $t2     # Atualiza o último nó na lista

    jr $ra  # Retorna

exit:
    #  Finaliza o programa
    li $v0, 10  # Código do serviço de saída
    syscall
