<h1 align="center">
  Talents Service
</h1>

<h4 align="center">
  Serviço de cadastro de Talents
</h4>

<p align="center">
  <a href="#Tecnologias">Tecnologias</a>&nbsp;&nbsp;|&nbsp;
  <a href="#Projeto">Projeto</a>&nbsp;&nbsp;|&nbsp;
  <a href="#detalhes"> Detalhes</a>&nbsp;&nbsp;|&nbsp;
</p>

<br>

## **Tecnologias**

Este serviço foi desenvolvido com a linguagem JavaScript (NodeJS).

## Build

Há dois scripts de build: `npm run build` que gera a pasta dist com o código fonte de produção e o `npm run build:lambda` que além de gerar todo código fonte de produção também cria um arquivo zip com eles, chamado `latest.zip`.

## **Projeto**

Basicamente o projeto possui duas funções dentro do mesmo escopo, são elas:

- Server: Obter entrada de dados, através do AWS AppSync, e colocar em uma fila de processamento
- Worker: Ser informado através de eventos sobre itens a serem processados e cadastrá-los no banco de dados (DynamoDB)

* Após uma ação do worker ele também é responsável por colocar o objeto em uma fila de processamento para ser feito o match.

## **Detalhes**

[![](https://mermaid.ink/img/eyJjb2RlIjoic2VxdWVuY2VEaWFncmFtXG4gICAgQXBwU3luYy0-PlRhbGVudHNfU2VydmVyOiBDcmVhdGUgVGFsZW50c1xuICAgIFxuICAgIGFjdGl2YXRlIFRhbGVudHNfU2VydmVyXG4gICAgVGFsZW50c19TZXJ2ZXItPj5TUVNfVGFsZW50czogRW5xdWV1ZVxuICAgIFNRU19UYWxlbnRzLT4-VGFsZW50c19TZXJ2ZXI6IEFja1xuICAgIFRhbGVudHNfU2VydmVyLT4-QXBwU3luYzogQWNrXG4gICAgZGVhY3RpdmF0ZSBUYWxlbnRzX1NlcnZlclxuICAgIFxuICAgIGFjdGl2YXRlIFRhbGVudHNfV29ya2VyXG4gICAgVGFsZW50c19Xb3JrZXItPj5TUVNfVGFsZW50czogR0VUIFF1ZXVlIE1lc3NhZ2VcbiAgICBUYWxlbnRzX1dvcmtlci0-PlRhbGVudHNfREI6IENyZWF0ZVxuICAgIFRhbGVudHNfREItPj5UYWxlbnRzX1dvcmtlcjogQWNrXG4gICAgVGFsZW50c19Xb3JrZXItPj5TUVNfTWF0Y2g6IEVucXVldWVcbiAgICBTUVNfTWF0Y2gtPj5UYWxlbnRzX1dvcmtlcjogQWNrXG4gICAgZGVhY3RpdmF0ZSBUYWxlbnRzX1dvcmtlciIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoic2VxdWVuY2VEaWFncmFtXG4gICAgQXBwU3luYy0-PlRhbGVudHNfU2VydmVyOiBDcmVhdGUgVGFsZW50c1xuICAgIFxuICAgIGFjdGl2YXRlIFRhbGVudHNfU2VydmVyXG4gICAgVGFsZW50c19TZXJ2ZXItPj5TUVNfVGFsZW50czogRW5xdWV1ZVxuICAgIFNRU19UYWxlbnRzLT4-VGFsZW50c19TZXJ2ZXI6IEFja1xuICAgIFRhbGVudHNfU2VydmVyLT4-QXBwU3luYzogQWNrXG4gICAgZGVhY3RpdmF0ZSBUYWxlbnRzX1NlcnZlclxuICAgIFxuICAgIGFjdGl2YXRlIFRhbGVudHNfV29ya2VyXG4gICAgVGFsZW50c19Xb3JrZXItPj5TUVNfVGFsZW50czogR0VUIFF1ZXVlIE1lc3NhZ2VcbiAgICBUYWxlbnRzX1dvcmtlci0-PlRhbGVudHNfREI6IENyZWF0ZVxuICAgIFRhbGVudHNfREItPj5UYWxlbnRzX1dvcmtlcjogQWNrXG4gICAgVGFsZW50c19Xb3JrZXItPj5TUVNfTWF0Y2g6IEVucXVldWVcbiAgICBTUVNfTWF0Y2gtPj5UYWxlbnRzX1dvcmtlcjogQWNrXG4gICAgZGVhY3RpdmF0ZSBUYWxlbnRzX1dvcmtlciIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)


A entrada de dados se inicia no AWS AppSync e até os dados serem enfileirados na fila dos Talents, a conexão da requisição é mantida. Após enfileirar com sucesso a conexão com a entrada de dados é encerrada e toda comunicação passa se dar através de triggers e eventos. Tanto a entrada do dado no banco de dados quanto o cálculo do Match que será feito na sequência.
