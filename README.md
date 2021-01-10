# Desafio Backend INTERA

Repostório com a solução implementada do desafio de backend da Intera.

## Estruturação

A solução completa, desde da a infra com terraform até o código das lambdas, está neste repositório. Escolhi trabalhar com monorepo simplesmente por ser mais fácil acompanhar alterações em cada serviço e infra sem ficar me perdendo entre vários repositórios desnecessariamente.

## Arquitetura

A minha proposta está baseada fortemente em microserviços, porém foi propositalmente simplificado para um melhor resultado dado o tempo x qualidade.

### Diagrama geral

![diagrama](.github/images/general-diagram.png)

Temos inicialmente 2 microserviços e 1 serviço de Match:

- [Talents](talents) - responsável pelo banco de talentos
  - server: servidor http REST ou GRaphQL simples para CRUD com comunicação de escrita via fila SQS.
  - worker: ouve mensagem de escrita via fila SQS, valida e escreve no banco de talentos.
- [Openings](openings) - responsável pelo banco de vagas e requisitos
  - server: servidor http REST ou GRaphQL simples para CRUD com comunicação de escrita via fila SQS.
  - worker: ouve mensagem de escrita via fila SQS, valida e escreve no banco de vagas.
- [Match](match) - responsável pelo match entre talentos e vagas disponíveis
  - Worker: verifica alterações no banco, informados pelo talents e openings e faz o match.

Cada serviço possui um arquivo `README.md` com mais informações e instruções.

## Tecnologias utilizadas

- NodeJS (^v14.15.4)
- Terraform (v0.14.4)
- AWS Lambda
- AWS DynamoDB
- AWS SQS

## Build e deploy

Cada serviço tem seu próprio projeto Node isolado e cada um possui os scripts:

- Build: `npm run build`
- Verificação de conformidade com linter: `npm run lint`
- Executar testes: `npm test`

### Terraform

Para iniciar o terraform acesse a pasta "infrastructure/terraform" e execute no terminal: `terraform init`, após rodar com sucesso basta publicar com `terraform apply`, não se esqueça de sempre fazer uma revisão com `terraform plan`.

Cada serviço, após o build, gera uma pasta `dist` que possui de fato o código que irá para produção.

## Autor

David Vilaça - [davidpvilaca](https://github.com/davidpvilaca)
