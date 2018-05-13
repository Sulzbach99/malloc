#include <stdio.h>

void iniciaAlocador();
/* Executa syscall brk para obter o endereco do topo corrente da heap e o armazena em uma variavel global, topoInicialHeap. */

void finalizaAlocador();
/* Executa syscall brk para restaurar o valor original da heap contido em topoInicialHeap. */

int liberaMem(void* bloco);
/* Indica que o bloco esta livre. (int?????????????????????????????????????????????????) */

void* alocaMem(int num_bytes);
/* 1. Procura um bloco livre com tamanho maior ou igual a num_bytes.
** 2. Se encontrar, indica que o bloco esta ocupado e retorna o endereco inicial do bloco;
** 3. Se nao encontrar, abre espaco para um novo bloco usando a syscall brk, indica que o bloco esta ocupado e
** retorna o endereco inicial do bloco. */

void imprimeMapaMem();