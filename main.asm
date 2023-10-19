.data
    # input action (numero)
    action: .word 0

    # contador de eventos
    eventCounter: .word 0

    # arrays

    names:
        .space 2500 # 50 posições de strings com 50 caracteres

    days:
        .align 2
        .space 200

    startTimes:
        .align 3
        .space 200

    endTimes:
        .align 3
        .space 200

    # retornos pro usuario
    actions: .asciiz "Available actions:\n[1] insert\n[2] print\n[3] remove\n[4] edit\n[0] quit\n"
    invalidAction: .asciiz "Invalid Action!\n"
    errorInput: .asciiz "Unable to insert :(\n"
    welcome: .asciiz "Welcome to AppointmentAgenda!\n"

    insert_eventName: .asciiz "What is a event name?\n"

.text
.globl main

# impressão das boas-vindas
li $v0, 4
la $a0, welcome
syscall

j loop_action

# inicializa o registrador $t0 com 0
li $t0, 0

insert:
    # carrega o valor de eventCounter
    lw $t1, eventCounter

    # verifica se eventCounter é igual a 0
    beqz $t1, insertFirst

    li $t2, 50      # tamanho de cada entrada no array names
    mul $t2, $t2, $t1   # calculando a posição de inserção (50 * eventCounter)
    add $t3, $t2, $t4   # soma com o endereço base do names

    # le do nome do evento do usuário
    li $v0, 4
    la $a0, insert_eventName
    syscall
    li $v0, 8
    la $a0, names  # endereço base do names
    add $a0, $a0, $t2  # faz o deslocamento
    li $a1, 50  # tanhanho maximo do nome do evento
    syscall

    # incrementa eventCounter em 1
    addi $t1, $t1, 1
    sw $t1, eventCounter

    j loop_action

#caso seja a primera vez que está fazendo a inserção de um evento
insertFirst:
    # leitura do nome do evento do usuário
    li $v0, 4
    la $a0, insert_eventName
    syscall
    li $v0, 8
    la $a0, names # endereço base do names
    li $a1, 50  # tanhanho maximo do nome do evento
    syscall

    # incrementa eventCounter em 1
    addi $t1, $t1, 1
    sw $t1, eventCounter

    j loop_action



# função para imprimir todos os eventos
print:
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

        # caso a acao nao seja valida
        li $v0, 4
        la $a0, invalidAction
        syscall

        # chamamos o loop aqui caso o usuario digite uma acao ilegal
        j loop_action

quit:
    # encerrando o programa
    li $v0, 10
    syscall
