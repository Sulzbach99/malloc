.section .text
.globl brkGet
brkGet:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        $12, %rax               # ID do servico brk
    movq        $0, %rdi                # Parametro da chamada (de modo a retornar a altura atual da brk)
    syscall                             # Chamada ao sistema
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
.globl brkUpdate
brkUpdate:
    pushq       %rbp                    # Empilha endereco-base do registro de ativacao antigo
    movq        %rsp, %rbp              # Atualiza ponteiro para endereco-base do registro de ativacao atual
    movq        $12, %rax               # ID do servico brk
    syscall                             # Chamada ao sistema
    popq        %rbp                    # Desmonta registro de ativacao atual e restaura ponteiro para o antigo
    ret                                 # Retorna
