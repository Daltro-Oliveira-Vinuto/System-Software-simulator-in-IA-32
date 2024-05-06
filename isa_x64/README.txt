nome: Kyara Esteves de Sousa Mat: 825298

O projeto foi implementado e testado no sistema operacional 
Ubuntu linux. O programa nao funcionara no windows pois as
chamadas de sistemas sao diferentes do linux.

Para compilar e linkar digite a seguinte linha de comando na mesma pasta contendo os arquivos: 

make all 

O que ira gerar um executavel chamado trabalho2.exe, portanto para 
executa-lo basta digitar: ./trabalho2.exe nome_arquivo_objeto

Onde 'nome_arquivo_objeto' é o nome do arquivo objeto que corresponde ao arquivo de saida do trabalho1

Obs.: O nome do arquivo objeto nao pode ultrapassar 100 caracteres;

Obs.: O arquivo objeto fornecido para o simulador deve necessariamente ter uma extensao.

Obs.: O arquivo objeto deve conter no maximo 2000 instrucoes.

Obs.: O simulador nao suporta numeros negativos. Apenas positivos.Portanto o jmpn nao funciona corretamente

Obs.: Estou considerando que cada line feed no arquivo de saida do disassembler tambem ocupa um byte, assim por exemplo ADD é sempre escrito ADD\n portanto ocupando 4 bytes.


