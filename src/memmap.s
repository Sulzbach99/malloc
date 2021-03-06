# 5.4 implemente uma funcao que imprime um mapa da memoria da regiao da heap em todos os algoritmos propostos aqui.
# Cada byte da parte gerencial do no deve ser impresso com o caractere "#". O caractere usado para a impressao dos bytes
# do bloco de cada no depende se o bloco estiver livre ou ocupado. Se estiver livre, imprime o caractere -". Se estiver
# ocupado, imprime o caractere "+".
.section .text
imprimeParte:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        $0, %rax                # Inicializa contador em 0
    pushq       %rax                    # Aloca variavel local (contador)
  for:
    movq        -8(%rbp), %rax          # Obtem contador
    movq        %rsi, %rbx              # Obtem segundo parametro
    cmpq        %rax, %rbx              # Compara segundo parametro com contador
    jle         done_for                # Se ja foram feitas as impressoes requisitadas, desvia para o final do for
    pushq       %rdi                    # Caller save do primeiro parametro
    pushq       %rsi                    # Caller save do segundo parametro
    call        putchar                 # Chama funcao para imprimir caractere do primeiro parametro
    popq        %rsi                    # Restaura segundo parametro
    popq        %rdi                    # Restaura primeiro parametro
    movq        -8(%rbp), %rax          # Obtem contador
    addq        $1, %rax                # Incrementa contador
    movq        %rax, -8(%rbp)          # Atualiza contador
    jmp         for                     # Desvia para o inicio do for
  done_for:
    addq        $8, %rsp                # Desempilha variavel local
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
.globl imprMapa
imprMapa:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    call        brkGet                  # Obtem ponteiro para final da heap
    pushq       %rax                    # Empilha variavel local apontando para final da heap
    movq        topoInicialHeap, %rbx   # Obtem ponteiro para inicio da heap
    pushq       %rbx                    # Empilha variavel local apontando para inicio da heap
    pushq       %rax                    # Empilha variavel local apontando para final da heap
  loop:
    movq        -16(%rbp), %rax         # Obtem ponteiro para informacao gerencial
    movq        -8(%rbp), %rbx          # Obtem ponteiro para final da heap
    cmpq        %rax, %rbx              # Compara final da heap com informacao gerencial atual
    jle         done_loop               # Se todos os blocos foram percorridos, desvia para o final do loop
    movq        $35, %rdi               # Estabelece primeiro parametro ('#')
    movq        $16, %rsi               # Estabelece segundo parametro (16 - numero de bytes de informacao gerencial)
    call        imprimeParte            # Chama funcao para imprimir bytes da informacao gerencial
    movq        -16(%rbp), %rax         # Obtem ponteiro para informacao gerencial
    movq        %rax, %rsi              # Obtem ponteiro para informacao gerencial
    movq        8(%rsi), %rsi           # Obtem tamanho do bloco (segundo parametro)
    movq        (%rax), %rax            # Obtem informacao gerencial
    movq        $0, %rbx                # Obtem valor que indica bloco livre
    cmpq        %rax, %rbx              # Verifica se informacao gerencial indica bloco livre
    je          else                    # Se sim, desvia para else
    movq        $43, %rdi               # Estabelece primeiro parametro ('+' - bloco ocupado)
    jmp         done_if                 # Desvia para final do if
  else:
    movq        $45, %rdi               # Estabelece primeiro parametro ('-' - bloco livre)
  done_if:
    call        imprimeParte            # Chama funcao para imprimir bytes do bloco
    movq        -16(%rbp), %rax         # Obtem ponteiro para informacao gerencial
    movq        8(%rax), %rbx           # Obtem tamanho do bloco
    addq        $16, %rbx               # Obtem tamanho do bloco + informacao gerencial
    addq        %rax, %rbx              # Obtem ponteiro para proxima informacao gerencial
    movq        %rbx, -16(%rbp)         # Atualiza variavel local
    jmp         loop                    # Desvia para inicio do loop
  done_loop:
    movq        $10, %rdi               # Estabelece parametro ('\n' - newline)
    call        putchar                 # Imprime newline '\n'
    popq        %rdi                    # Desempilha variavel local com topo da heap usa como parametro
    call        brkUpdate               # Restaura topo da heap (problema com o putchar)
    addq        $16, %rsp               # Desempilha variaveis locais
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
