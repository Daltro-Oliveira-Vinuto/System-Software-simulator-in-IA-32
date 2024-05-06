// Nome: Daltro Oliveira Vinuto

#include <stdio.h>
#include <string.h>

// funcao a ser chamada em assembly x86
extern int simulador(char *);

// funcao usada para testes apenas
void testa_nome(char *nome) {

   printf("%s\n\n", nome);
   printf("%c\n\n", nome[0]);
   printf("%p\n\n", &nome[0]);

}

// funcao principal
int main(int argc, char **argv) {
   if (argc != 2) {
      printf("Numero de parametros invalido!\n\n");
   } else if (argc == 2) {
      const int tamanho_nome_arquivo_objeto = 101;
      int tamanho_arquivo_saida;

      char nome_arquivo_objeto[tamanho_nome_arquivo_objeto];

      strcpy(nome_arquivo_objeto, argv[1]);

      //printf("%s", nome_arquivo_objeto);
      //testa_nome(&nome_arquivo_objeto[0]);
      //printf("tamanho de nome_arquivo_objeto: %d\n", sizeof(nome_arquivo_objeto));
      //printf("sizeof %d\n\n", sizeof(&nome_arquivo_objeto[0]));

      // chama funcao em assembly =====================
      tamanho_arquivo_saida = simulador(&nome_arquivo_objeto[0]);

      printf("Tamanho em bytes do arquivo de saida: %d\n\n", tamanho_arquivo_saida);

   }


}