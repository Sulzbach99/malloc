# 5.1 implemente o algoritmo proposto na seção 5.1.2 em assembly
.section    .data
    .quad       topoInicialHeap 0
.section    .text
iniciaAlocador:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        $12, %rax               # ID do servico brk
    movq        $0, %rdi                # Parametro da chamada (de modo a retornar a altura atual da brk)
    syscall                             # Chamada ao sistema
    movq        %rax, $topoInicialHeap  # Armazena altura da brk em topoInicialHeap
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
finalizaAlocador:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        $12, %rax               # ID do servico brk
    movq        $topoInicialHeap, %rdi  # Parametro da chamada (de modo a atualizar a altura da brk)
    syscall                             # Chamada ao sistema
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
liberaMem:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        $0, -16(%rdi)           # Indica que o bloco esta livre
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
alocaMem: