#include "../usr/include/common.h"

typedef struct node {

    int key;
    struct node *next;
} node_t;

int main() {

    node_t *list;

    iniciaAlocador();

    list = alocaMem(sizeof(node_t));
    list->key = 10;
    list->next = alocaMem(sizeof(node_t));
    list->next->key = 20;

    imprimeMapaMem();

    liberaMem(list->next);
    liberaMem(list);

    finalizaAlocador();
    return 0;
}