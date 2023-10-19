.data
    # input action (numero)
    action: .word 0

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


# função para inserir um evento
insert:

    # impressão da pergunta
    li $v0, 4
    la $a0, insert_eventName
    syscall

    

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
