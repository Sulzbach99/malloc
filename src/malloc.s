# 5.1 implemente o algoritmo proposto na seção 5.1.2 em assembly
.section    .data
    .equ    FIT_ALGORITHM, bestFit
    .globl topoInicialHeap
    topoInicialHeap:  .quad 0
    inicioNextFit:    .quad 0
    .globl isRunning
    isRunning:        .quad 0
.section    .text
###################################################################################################################
# void iniciaAlocador() Executa syscall brk para obter o endereco do topo corrente da heap e o armazena em uma
# variavel global, topoInicialHeap.
###################################################################################################################
.globl iniciaAlocador
iniciaAlocador:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        $_IO_2_1_stdout_, %rdi  # Configura primeiro parametro (stdout)
    movq        $0, %rsi                # Configura segundo parametro (NULL)
    call        setbuf                  # Chama setbuf para configurar a escrita para stdout como "unbuffered"
    call        brkGet                  # Obtem ponteiro para final da heap
    movq        %rax, topoInicialHeap   # Armazena altura da brk em topoInicialHeap
    movq        %rax, inicioNextFit     # Armazena altura da brk em inicioNextFit (usado apenas no "next fit")
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
###################################################################################################################
# void finalizaAlocador() Executa syscall brk para restaurar o valor original da heap contido em topoInicialHeap.
###################################################################################################################
.globl finalizaAlocador
finalizaAlocador:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        topoInicialHeap, %rdi   # Estabelece parametro (topoInicialHeap)
    call        brkUpdate               # Restaura topo inicial da heap
    movq        $_IO_2_1_stdout_, %rdi  # Configura primeiro parametro (stdout)
    call        setlinebuf              # Chama setlinebuf para configurar a escrita para stdout como "line buffered"
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
###################################################################################################################
# int liberaMem(void* bloco) indica que o bloco esta livre. (int?????????????????????????????????????????????????)
###################################################################################################################
.globl meuLiberaMem
meuLiberaMem:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        $0, -16(%rdi)           # Indica que o bloco esta livre
    movq        topoInicialHeap, %rax   # Obtem topoInicialHeap
    pushq       %rax                    # Aloca variavel local que aponta para a primeira informacao gerencial
    pushq       %rax                    # Aloca variavel local que aponta para a primeira informacao gerencial
  while:
    call        brkGet                  # Obtem ponteiro para final da heap
    movq        -16(%rbp), %rbx         # Obtem ponteiro 2
    cmpq        %rax, %rbx              # Compara ponteiro 2 com final da heap
    jge         done_while              # Se toda a heap foi percorrida, sai do laco
    movq        -8(%rbp), %rax          # Obtem ponteiro 1
    movq        -16(%rbp), %rbx         # Obtem ponteiro 2
    cmpq        %rax, %rbx              # Compara ponteiro 2 com ponteiro 1
    je          done_if_libera          # Se sao iguais, sai do if
    movq        -8(%rbp), %rax          # Obtem ponteiro 1
    movq        (%rax), %rax            # Obtem informacao gerencial 1
    movq        $0, %rbx                # Obtem 0 (que indica bloco livre)
    cmpq        %rax, %rbx              # Verifica se bloco 1 esta livre
    jne         done_if_libera          # Se o bloco 1 esta ocupado, sai do if
    movq        -16(%rbp), %rax         # Obtem ponteiro 2
    movq        (%rax), %rax            # Obtem informacao gerencial 2
    movq        $0, %rbx                # Obtem 0 (que indica bloco livre)
    cmpq        %rax, %rbx              # Verifica se bloco 2 esta livre
    jne         done_if_libera          # Se o bloco 2 esta ocupado, sai do if
    movq        -8(%rbp), %rax          # Obtem ponteiro 1
    movq        8(%rax), %rax           # Obtem tamanho 1
    movq        -16(%rbp), %rbx         # Obtem ponteiro 2
    movq        8(%rbx), %rbx           # Obtem tamanho 2
    addq        $16, %rbx               # Soma ao tamanho das informacoes gerenciais
    addq        %rax, %rbx              # Soma os tamanhos, obtendo o tamanho do bloco fundido
    movq        -8(%rbp), %rax          # Obtem ponteiro 1
    movq        %rbx, 8(%rax)           # Atualiza tamanho 1
    movq        -8(%rbp), %rax          # Obtem ponteiro 1
    movq        %rax, -16(%rbp)         # Ponteiro 2 = ponteiro 1
  done_if_libera:
    movq        -16(%rbp), %rax         # Obtem ponteiro 2
    movq        %rax, -8(%rbp)          # Ponteiro 1 = ponteiro 2
    movq        -16(%rbp), %rax         # Obtem ponteiro 2
    movq        8(%rax), %rbx           # Obtem tamanho 2
    addq        $16, %rax               # Soma ao tamanho das informacoes gerenciais
    addq        %rbx, %rax              # Soma o tamanho com o ponteiro 2, apontando para a proxima informacao gerencial
    movq        %rax, -16(%rbp)         # Atualiza ponteiro 2
    jmp         while                   # Continua no laco
  done_while:
    addq        $16, %rsp               # Desempilha variaveis locais
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
###################################################################################################################
firstFit:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        topoInicialHeap, %rax   # Obtem topoInicialHeap
    pushq       %rax                    # Aloca variavel local que aponta para a primeira informacao gerencial
  loop_first_fit:
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        %rsi, %rbx              # Obtem ponteiro para fim da heap
    cmpq        %rax, %rbx              # Compara fim da heap com ponteiro para informacao gerencial atual
    jle         first_fit_not_fit       # Se nao ha blocos liberados utilizaveis, sai do laco com status "not fit"
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        (%rax), %rax            # Obtem informacao gerencial do bloco atual
    movq        $0, %rbx                # Obtem 0 (que indica "livre")
    cmpq        %rax, %rbx              # Compara 0 com informacao gerencial do bloco atual
    jne         do_loop_first_fit       # Se o bloco nao esta livre, continua no laco
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        8(%rax), %rax           # Obtem tamanho do bloco atual
    movq        %rdi, %rbx              # Obtem parametro num_bytes
    cmpq        %rax, %rbx              # Compara num_bytes com tamanho do bloco atual
    jle         first_fit_fit           # Se o bloco atual e grande o suficiente, sai do laco com status "fit"
  do_loop_first_fit:
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        8(%rax), %rbx           # Obtem tamanho do bloco atual
    addq        $16, %rax               # Obtem ponteiro para inicio do bloco atual
    addq        %rbx, %rax              # Obtem ponteiro para a proxima informacao gerencial
    movq        %rax, -8(%rbp)          # Atualiza variavel com ponteiro para proxima informacao gerencial
    jmp         loop_first_fit          # Continua no laco
  first_fit_not_fit:
    movq        $0, %rax                # Retorna 0 (nao ha blocos livres utilizaveis)
    jmp         done_first_fit          # Desvia para final da funcao
  first_fit_fit:
    movq        -8(%rbp), %rax          # Retorna ponteiro para informacao gerencial do bloco atual
  done_first_fit:
    addq        $8, %rsp                # Desempilha variaveis locais
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
###################################################################################################################
bestFit:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        topoInicialHeap, %rax   # Obtem topoInicialHeap
    pushq       %rax                    # Aloca variavel local que aponta para a primeira informacao gerencial
    pushq       $0                      # Aloca variavel local auxiliar
  loop_best_fit:
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        %rsi, %rbx              # Obtem ponteiro para fim da heap
    cmpq        %rax, %rbx              # Compara fim da heap com ponteiro para informacao gerencial atual
    jg          done_if_best_fit_1      # Se a heap ainda não foi inteiramente percorrida, continua no laco
    movq        -16(%rbp), %rax         # Obtem ponteiro para informacao gerencial do bloco "best fit"
    movq        $0, %rbx                # Obtem 0 (que indica que nao ha blocos disponiveis)
    cmpq        %rax, %rbx              # Verifica se foi selecionado um "best fit"
    je          best_fit_not_fit        # Se nao ha blocos liberados utilizaveis, sai do laco com status "not_fit"
    jne         best_fit_fit            # Se ha um bloco "best fit", sai do laco com status "fit"
  done_if_best_fit_1:
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        (%rax), %rax            # Obtem informacao gerencial do bloco atual
    movq        $0, %rbx                # Obtem 0 (que indica "livre")
    cmpq        %rax, %rbx              # Compara 0 com informacao gerencial do bloco atual
    jne         do_loop_best_fit        # Se o bloco nao esta livre, continua no laco
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        8(%rax), %rax           # Obtem tamanho do bloco atual
    movq        %rdi, %rbx              # Obtem parametro num_bytes
    cmpq        %rax, %rbx              # Compara num_bytes com tamanho do bloco atual
    jg          do_loop_best_fit        # Se o bloco atual nao e grande o suficiente, continua no laco
    movq        -16(%rbp), %rax         # Obtem ponteiro para informacao gerencial do bloco "best fit"
    movq        $0, %rbx                # Obtem 0 (que indica que nao ha blocos disponiveis para alocacao ate entao)
    cmpq        %rax, %rbx              # Verifica se ja foi selecionado um bloco "fit"
    jne          done_if_best_fit_2     # Se sim, vai para o fim do if
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        %rax, -16(%rbp)         # Atualiza ponteiro para "best fit"
  done_if_best_fit_2:
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        8(%rax), %rax           # Obtem tamanho do bloco atual
    movq        -16(%rbp), %rbx         # Obtem informacao gerencial do bloco "best fit"
    movq        8(%rbx), %rbx           # Obtem tamanho do bloco "best fit"
    cmpq        %rax, %rbx              # Compara tamanhos
    jle         do_loop_best_fit        # Se o "best fit" ainda é "best fit", desvia para o laco
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        %rax, -16(%rbp)         # Atualiza ponteiro para "best fit"
  do_loop_best_fit:
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        8(%rax), %rbx           # Obtem tamanho do bloco atual
    addq        $16, %rax               # Obtem ponteiro para inicio do bloco atual
    addq        %rbx, %rax              # Obtem ponteiro para a proxima informacao gerencial
    movq        %rax, -8(%rbp)          # Atualiza variavel com ponteiro para proxima informacao gerencial
    jmp         loop_best_fit           # Continua no laco
  best_fit_not_fit:
    movq        $0, %rax                # Retorna 0 (nao ha blocos livres utilizaveis)
    jmp         done_best_fit           # Desvia para final da funcao
  best_fit_fit:
    movq        -16(%rbp), %rax         # Retorna ponteiro para informacao gerencial do bloco "best fit"
  done_best_fit:
    addq        $16, %rsp               # Desempilha variaveis locais
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
###################################################################################################################
nextFit:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        inicioNextFit, %rax     # Obtem inicioNextFit
    pushq       %rax                    # Aloca variavel local que aponta para a primeira informacao gerencial
  loop_next_fit:
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        (%rax), %rax            # Obtem informacao gerencial do bloco atual
    movq        $0, %rbx                # Obtem 0 (que indica "livre")
    cmpq        %rax, %rbx              # Compara 0 com informacao gerencial do bloco atual
    jne         do_loop_next_fit        # Se o bloco nao esta livre, continua no laco
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        8(%rax), %rax           # Obtem tamanho do bloco atual
    movq        %rdi, %rbx              # Obtem parametro num_bytes
    cmpq        %rax, %rbx              # Compara num_bytes com tamanho do bloco atual
    jle         next_fit_fit            # Se o bloco atual e grande o suficiente, sai do laco com status "fit"
  do_loop_next_fit:
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        8(%rax), %rbx           # Obtem tamanho do bloco atual
    addq        $16, %rax               # Obtem ponteiro para inicio do bloco atual
    addq        %rbx, %rax              # Obtem ponteiro para a proxima informacao gerencial
    movq        %rax, -8(%rbp)          # Atualiza variavel com ponteiro para proxima informacao gerencial
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        %rsi, %rbx              # Obtem ponteiro para fim da heap
    cmpq        %rax, %rbx              # Compara fim da heap com ponteiro para informacao gerencial atual
    jg          done_if_next_fit        # Se o fim da heap foi atingido, comeca do inicio
    movq        topoInicialHeap, %rax   # Obtem topoInicialHeap
    movq        %rax, -8(%rbp)          # Atualiza informacao gerencial atual para a primeira informacao gerencial
  done_if_next_fit:
    movq        -8(%rbp), %rax          # Obtem ponteiro para informacao gerencial do bloco atual
    movq        inicioNextFit, %rbx     # Obtem inicioNextFit
    cmpq        %rax, %rbx              # Compara inicioNextFit com informacao gerencial atual
    je          next_fit_not_fit        # Se toda a heap foi percorrida, sai do laco com status "not fit"
    jmp         loop_next_fit           # Continua no laco
  next_fit_not_fit:
    movq        $0, %rax                # Retorna 0 (nao ha blocos livres utilizaveis)
    jmp         done_next_fit           # Desvia para final da funcao
  next_fit_fit:
    movq        -8(%rbp), %rax          # Retorna ponteiro para informacao gerencial do bloco atual
  done_next_fit:
    movq        -8(%rbp), %rbx          # Obtem informacao gerencial atual
    movq        %rbx, inicioNextFit     # Atualiza inicioNextFit
    addq        $8, %rsp                # Desempilha variaveis locais
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
###################################################################################################################
# void* alocaMem(int num_bytes)
### 1. Procura um bloco livre com tamanho maior ou igual a num_bytes.
### 2. Se encontrar, indica que o bloco esta ocupado e retorna o endereco inicial do bloco;
### 3. Se nao encontrar, abre espaco para um novo bloco usando a syscall brk, indica que o bloco esta ocupado e
### retorna o endereco inicial do bloco.
###################################################################################################################
.globl meuAlocaMem
meuAlocaMem:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        $0, %rax                # Obtem 0 (que indica !isRunning)
    movq        isRunning, %rbx         # Obtem isRunning
    cmpq        %rax, %rbx              # Verifica o valor de isRunning (se o alocador ja foi iniciado)
    jne         start                   # Se o alocador foi iniciado, desvia para o comeco, efetivamente
    pushq       %rdi                    # Caller save do parametro num_bytes
    call        iniciaAlocador          # Se não, inicia o alocador
    popq        %rdi                    # Restaura parametro num_bytes
    movq        $1, isRunning           # Indica que o alocador foi iniciado
  start:
    pushq       %rdi                    # Caller save do parametro num_bytes
    call        brkGet                  # Obtem ponteiro para final da heap
    popq        %rdi                    # Restaura parametro num_bytes
    pushq       %rax                    # Aloca variavel local que aponta para o fim da heap
    movq        -8(%rbp), %rsi          # Estabelece ponteiro para fim da heap como segundo parametro
    pushq       %rdi                    # Caller save do parametro num_bytes
    call        FIT_ALGORITHM           # Chama funcao para encontrar bloco livre
    popq        %rdi                    # Restaura parametro num_bytes
    pushq       %rax                    # Aloca variavel local com ponteiro para bloco a ser alocado
    movq        -16(%rbp), %rax         # Obtem ponteiro para informacao gerencial do bloco a ser alocado
    movq        $0, %rbx                # Obtem 0 (que indica que nao ha blocos livres utilizaveis)
    cmpq        %rax, %rbx              # Verifica se ha um bloco livre utilizavel
    jne         fit                     # Se sim, desvia para fit
    movq        %rdi, %rax              # Obtem parametro num_bytes
    movq        -8(%rbp), %rbx          # Obtem ponteiro para topo atual da heap
    addq        $16, %rbx               # Obtem ponteiro para inicio do bloco a ser alocado
    addq        %rax, %rbx              # Obtem ponteiro para final do bloco a ser alocado
    pushq       %rdi                    # Caller save do parametro num_bytes
    movq        %rbx, %rdi              # Parametro da chamada (de modo a atualizar a altura da brk)
    call        brkUpdate               # Atualiza topo da heap
    popq        %rdi                    # Restaura parametro num_bytes
    movq        -8(%rbp), %rax          # Obtem ponteiro para fim da heap
    movq        %rax, -16(%rbp)         # Atualiza ponteiro para informacao gerencial do bloco a ser alocado
    jmp         done                    # Desvia para o final da funcao
  fit:
    movq        -16(%rbp), %rax         # Obtem ponteiro para informacao gerencial
    movq        8(%rax), %rax           # Obtem tamanho do bloco
    movq        %rdi, %rbx              # Obtem parametro num_bytes
    cmpq        %rax, %rbx              # Compara num_bytes com tamanho do bloco
    je          done                    # Se o bloco tem o tamanho certo, desvia para o fim da funcao
    movq        -16(%rbp), %rax         # Obtem ponteiro para informacao gerencial
    movq        %rdi, %rbx              # Obtem parametro num_bytes
    movq        8(%rax), %rax           # Obtem tamanho do bloco
    subq        %rbx, %rax              # Subtrai tamanho a ser alocado
    movq        $16, %rbx               # Obtem 16 (espaco a ser ocupado pelas informacoes gerenciais)
    cmpq        %rax, %rbx              # Verifica se o bloco restante e grande o suficiente
    jl          proceed                 # Se sim, continua a configuracao do bloco restante
    movq        -16(%rbp), %rax         # Obtem ponteiro para informacao gerencial
    movq        8(%rax), %rax           # Obtem tamanho do bloco
    movq        %rax, %rdi              # Assume que o tamanho do bloco a ser alocado e o mesmo do bloco antes vazio
    jmp         done                    # Desvia para o fim da funcao
  proceed:
    movq        -16(%rbp), %rax         # Obtem ponteiro para informacao gerencial
    movq        %rdi, %rbx              # Obtem parametro num_bytes
    movq        8(%rax), %rsi           # Obtem tamanho do bloco
    subq        %rbx, %rsi              # Subtrai tamanho a ser alocado
    subq        $16, %rsi               # Subtrai espaco ocupado pelas informacoes gerenciais
    addq        $16, %rax               # Obtem ponteiro para início do bloco a ser alocado
    addq        %rbx, %rax              # Obtem ponteiro para final do bloco a ser alocado e inicio do bloco livre restante
    movq        $0, (%rax)              # Indica que o bloco restante esta livre
    movq        %rsi, 8(%rax)           # Estabelece tamanho do bloco restante
  done:
    movq        -16(%rbp), %rax         # Obtem ponteiro para informacao gerencial alocada
    movq        $1, (%rax)              # Indica que o bloco alocado esta ocupado
    addq        $8, %rax                # Obtem ponteiro para tamanho do bloco alocado
    movq        %rdi, (%rax)            # Estabelece tamanho do bloco alocado (num_bytes)
    addq        $8, %rax                # Obtem ponteiro para bloco alocado
    addq        $16, %rsp               # Desempilha variaveis locais
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
###################################################################################################################
