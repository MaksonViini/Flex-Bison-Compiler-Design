# Compilador para a Linguagem Mini

Este repositório contém um compilador completo para a linguagem Mini, desenvolvido como trabalho prático na disciplina de Compiladores.

## Sobre a Linguagem Mini

A linguagem Mini é uma linguagem simples com as seguintes características:

- As palavras-chave são reservadas.
- Variáveis devem ser declaradas antes do uso.
- A semântica dos comandos e expressões segue a tradição do Pascal.
- Entrada e saída são limitadas ao teclado e à tela do computador.
- Comentários de uma linha começam com `%`.

## Uso do Compilador

### Instalação

Para utilizar o compilador, certifique-se de ter as dependências instaladas:

- Bison (Yacc)
- Flex (Lex)
- GCC (GNU Compiler Collection)

### Comandos Disponíveis no Makefile

#### Comandos Básicos

- `make one`: Compila o compilador Mini e executa o código de exemplo `tests/mini_lang.mini`, redirecionando a saída para `tests/resultado_mini.txt`.

#### Comandos de Teste

- `make all`: Compila e executa todos os arquivos de teste encontrados em `tests/`, gerando resultados correspondentes.

- `make lex`: Realiza a compilação do analisador léxico e executa o código de teste `tests/teste1.mini`, redirecionando a saída para `tests/resultado.txt`.

#### Limpeza

- `make clean`: Remove os arquivos gerados pela compilação, limpando o ambiente.

### Observações

Certifique-se de seguir as diretrizes específicas da linguagem Mini ao escrever o código fonte.
