# calcula potencia
.text
.globl main
main: #Rotina para carregar os valores de entrada
    la $a0, base # carrega o valor da base
    li $v0, 4 # Codigo para print_str
    syscall # chama o sistema para executar a operacao
    
    li $v0, 5 # Codigo para read_int
    syscall
    move $t0, $v0 # move o valor inserido para $t0
    
    la $a0, exp # carrega o valor do expoente
    li $v0, 4 # Codigo para print_str
    syscall
    li $v0, 5 # Codigo para read_int
    syscall
    move $a1, $v0 # carrega exp em $a1    
    move $a0, $t0 # carrega base em $a0
    
    blt $a1, $zero, expMenor # condicional: verifica se o expoente é menor que 0, se for executa expMenor
    j recursividade # executa a recursao
    syscall
    
    recursividade: # subrotina que divide entrada de dados, calculo e encerramento
    jal produto # inicia o calculo da potencia recursiva
    jal termina # invoca a subrotina de encerramento
    syscall
    
    produto:
    addi $sp, $sp, -4 # soma -4 ao stack pointer, alocando 4 bytes na pilha
    sw $ra, 0($sp) # copia o valor do ponteiro da pilha para a memoria (operação push $ra)
    bne $a1, $zero, igualZero # condicional: executa a subrotina se $al for diferente de zero
    syscall 
    addi $v0, $zero, 1 # atribui 1 a $v0
    addi $sp, $sp, 4 # soma 4 ao stack pointer
    jr $ra #recomendacao de Salloum para subrotinas: procedimento return
      
    expMenor: # subrotina chamada quando exp e menor que 0
    la $a0, menor # exibe a mensagem que exp e menor que 0 
    li $v0, 4 # codigo para print_str
    syscall
    li $v0, 10 # finaliza a execução (codigo para exit)
    syscall
 
    igualZero: # subrotina caso base da recursao (seguindo Salloum)
    bne $a1, 1, maiorQueUm # condicional: verifica se $al e maior que 1
    addi $sp, $sp, 4  # se for, soma 4 ao stack pointer
    add $v0, $zero, $a0 # atribui $a0 a $v0
    jr $ra #retorna
    
    maiorQueUm:
    move $t1, $a1 # move $al pra $tl
    andi $t0, $t1, 1 # verifica se o exp e par ou impar
    bne $t0, $zero, expImpar # chamado quando exp e impar
    srl $a1, $a1,1 # se e par divide o exp
    jal produto  # chama produto, executando recursao
    mul $v0, $v0, $v0 # eleva o valor retornado de produto ao quadrado 
    lw $ra, 0($sp) # carrega valor da memória $sp+0 em $ra
    addi $sp, $sp, 4 # soma 4 ao stack pointer (operacao pop $ra)
    jr $ra #return
    
    expImpar:    
    addi $a1, $a1, -1 # subtrai 1 para fazer a multiplicacao exp*produto-1
    jal produto	# invoca a subrotina produto
    lw $ra, 0($sp) # carrega valor da memória $sp+0 para o registrador $ra 
    addi $sp, $sp, 4 # soma 4 a $sp (operacao pop $ra)
    mul $v0, $v0, $a0 # multiplica o parametro e $v0
    jr $ra #return para a subrotina maiorQueUm
   
    termina: # subrotina para finalizar a execucao do programa
    move $s0, $v0 # recupera o valor de $v0 em $s0
    la $a0, resultado # carrega a string em resultado
    li $v0, 4 # codigo para print_str imprime "resultado"
    syscall
    move $a0, $s0 # finalmente, move o valor que estava inicialmente em $v0 para $a0
    li $v0, 1 # imprime o resultado (codigo para print_int)
    syscall
    li $v0, 10 # finaliza a execução (codigo para exit)
    syscall
	
.data
base: .asciiz "Informe a base: "
exp: .asciiz "Informe o expoente: "
menor: .asciiz "Erro de entrada: expoente menor que zero."
resultado: .asciiz "Resultado: "
