# 5.1 implemente o algoritmo proposto na seção 5.1.2 em assembly
.section    .data
    .quad       topoInicialHeap 0
.section    .text
###################################################################################################################
###################################################################################################################
# void iniciaAlocador() Executa syscall brk para obter o endereco do topo corrente da heap e o armazena em uma
# variavel global, topoInicialHeap.
###################################################################################################################
###################################################################################################################
iniciaAlocador:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        $12, %rax               # ID do servico brk
    movq        $0, %rdi                # Parametro da chamada (de modo a retornar a altura atual da brk)
    syscall                             # Chamada ao sistema
    movq        %rax, $topoInicialHeap  # Armazena altura da brk em topoInicialHeap
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
###################################################################################################################
###################################################################################################################
# void finalizaAlocador() Executa syscall brk para restaurar o valor original da heap contido em topoInicialHeap.
###################################################################################################################
###################################################################################################################
finalizaAlocador:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        $12, %rax               # ID do servico brk
    movq        $topoInicialHeap, %rdi  # Parametro da chamada (de modo a atualizar a altura da brk)
    syscall                             # Chamada ao sistema
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
###################################################################################################################
###################################################################################################################
# int liberaMem(void* bloco) indica que o bloco esta livre.
###################################################################################################################
###################################################################################################################
liberaMem:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        $0, -16(%rdi)           # Indica que o bloco esta livre
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
###################################################################################################################
###################################################################################################################
# void* alocaMem(int num_bytes)
### 1. Procura um bloco livre com tamanho maior ou igual a num_bytes.
### 2. Se encontrar, indica que o bloco esta ocupado e retorna o endereco inicial do bloco;
### 3. Se nao encontrar, abre espaco para um novo bloco usando a syscall brk, indica que o bloco esta ocupado e
### retorna o endereco inicial do bloco.
###################################################################################################################
###################################################################################################################
alocaMem:
###################################################################################################################
###################################################################################################################
