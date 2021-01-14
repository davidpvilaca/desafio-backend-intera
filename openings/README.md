<h1 align="center">
  Openings Service
</h1>

<h4 align="center">
  Serviço de cadastro de Openings
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

[![](https://mermaid.ink/img/eyJjb2RlIjoic2VxdWVuY2VEaWFncmFtXG4gICAgQXBwU3luYy0-Pk9wZW5pbmdzX1NlcnZlcjogQ3JlYXRlIE9wZW5pbmdzXG4gICAgXG4gICAgYWN0aXZhdGUgT3BlbmluZ3NfU2VydmVyXG4gICAgT3BlbmluZ3NfU2VydmVyLT4-T3BlbmluZ3M6IEVucXVldWVcbiAgICBPcGVuaW5ncy0-Pk9wZW5pbmdzX1NlcnZlcjogQWNrXG4gICAgT3BlbmluZ3NfU2VydmVyLT4-QXBwU3luYzogQWNrXG4gICAgZGVhY3RpdmF0ZSBPcGVuaW5nc19TZXJ2ZXJcbiAgICBcbiAgICBhY3RpdmF0ZSBPcGVuaW5nc19Xb3JrZXJcbiAgICBPcGVuaW5nc19Xb3JrZXItPj5PcGVuaW5nczogR0VUIFF1ZXVlIE1lc3NhZ2VcbiAgICBPcGVuaW5nc19Xb3JrZXItPj5PcGVuaW5nc19EQjogQ3JlYXRlXG4gICAgT3BlbmluZ3NfREItPj5PcGVuaW5nc19Xb3JrZXI6IEFja1xuICAgIE9wZW5pbmdzX1dvcmtlci0-PlNRU19NYXRjaDogRW5xdWV1ZVxuICAgIFNRU19NYXRjaC0-Pk9wZW5pbmdzX1dvcmtlcjogQWNrXG4gICAgZGVhY3RpdmF0ZSBPcGVuaW5nc19Xb3JrZXIiLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoic2VxdWVuY2VEaWFncmFtXG4gICAgQXBwU3luYy0-Pk9wZW5pbmdzX1NlcnZlcjogQ3JlYXRlIE9wZW5pbmdzXG4gICAgXG4gICAgYWN0aXZhdGUgT3BlbmluZ3NfU2VydmVyXG4gICAgT3BlbmluZ3NfU2VydmVyLT4-T3BlbmluZ3M6IEVucXVldWVcbiAgICBPcGVuaW5ncy0-Pk9wZW5pbmdzX1NlcnZlcjogQWNrXG4gICAgT3BlbmluZ3NfU2VydmVyLT4-QXBwU3luYzogQWNrXG4gICAgZGVhY3RpdmF0ZSBPcGVuaW5nc19TZXJ2ZXJcbiAgICBcbiAgICBhY3RpdmF0ZSBPcGVuaW5nc19Xb3JrZXJcbiAgICBPcGVuaW5nc19Xb3JrZXItPj5PcGVuaW5nczogR0VUIFF1ZXVlIE1lc3NhZ2VcbiAgICBPcGVuaW5nc19Xb3JrZXItPj5PcGVuaW5nc19EQjogQ3JlYXRlXG4gICAgT3BlbmluZ3NfREItPj5PcGVuaW5nc19Xb3JrZXI6IEFja1xuICAgIE9wZW5pbmdzX1dvcmtlci0-PlNRU19NYXRjaDogRW5xdWV1ZVxuICAgIFNRU19NYXRjaC0-Pk9wZW5pbmdzX1dvcmtlcjogQWNrXG4gICAgZGVhY3RpdmF0ZSBPcGVuaW5nc19Xb3JrZXIiLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ)

A entrada de dados se inicia no AWS AppSync e até os dados serem enfileirados na fila dos Openings, a conexão da requisição é mantida. Após enfileirar com sucesso a conexão com a entrada de dados é encerrada e toda comunicação passa se dar através de triggers e eventos. Tanto a entrada do dado no banco de dados quanto o cálculo do Match que será feito na sequência.
