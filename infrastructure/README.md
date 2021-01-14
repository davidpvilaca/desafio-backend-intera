# Intera Infrastructure

Projeto de infraestrutura do desafio backend Intera.

## Introdução

Toda a parte da infraestrutura foi utilizado AWS com a filosofia de IaC (infrastructure as code) com o [Terraform](https://terraform.io). Afim de reduzir a complexidade não foram utilizados módulos ou organizações mais isoladas do terraform, porém houve preocupação como escopo de cada parte.

## Configurando

### AWS

Assumindo que já tenha uma conta AWS e chaves de autenticação com permissões apropriadas para criação dessa infra, siga os passos:

1. Instale o aws cli: https://aws.amazon.com/pt/cli/
2. Configure um profile aws chamado `intera_davidpvilaca` contendo as chaves de acesso. Caso não saiba configurar veja: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html

### Terraform CLI

Baixe e instale a versão 0.14.4 do terraform: https://www.terraform.io/downloads.html

Foi utilizado neste projeto o "remote backend" da própria cloud do terraform: [app.terraform.io](https://app.terraform.io), portanto crie uma conta lá e crie também um workspace com nome `davdpvilaca`.

Após criar a conta e o workspace no terraform.io, há uas possibilidades de autenticação:

1. Criar um API Token para autenticar o CLI do terraform: Settings > Tokens > Create an API Token. Copie seu token e configure no seu arquivo `.terraformrc`, veja como criar esse arquivo em: https://www.terraform.io/docs/commands/cli-config.html.
2. Utilizar o `terraform login` para autenticar (essa opção não pode ser feita se a primeira foi configurada)

Com a autenticação funcionando basta iniciar o terraform na pasta:

1. Com o terminal, entre na pasta `infrastructure/terraform`
2. Execute: `terraform init`

Se tudo foi configurado corretamente, o terraform irá baixar o provider aws e iniciará corretamente o remote state na cloud.
## Como fazer o deploy?

Como consequência da decisão de não utilizar separações em módulos no terraform, há uma dificuldade na primeira vez em que se vai aplicar, portanto tenha em mãos os arquivos zip das lambdas (production ready). Para obter os arquivos lambda basta executar com terminal na pasta raíz do repositório o arquivo `get-lambdas.sh`. Será criado uma pasta chamado `lambdas` contendo o conteúdo que irá pro S3.

Obs: Esse arquivo `get-lambdas.sh` foi criado apenas para agilizar o processo de pegar os arquivos lambdas, mas pode ser feito manualmente indo em cada pasta das lambdas e executando `npm run build:lamba`.

1. Primeiramente deverá ser aplicado apenas a parte do S3 para criar os buckets no qual o código das lambdas ficarão: `terraform apply -target=aws_s3_bucket.intera_lambda_repository`.
2. Os arquivos de código fonte de produção de cada lambda deverá ser adicionado no bucket: `talents/latest.zip`, `openings/latest.zip` e `match/latest.zip`. Eles estão na pasta `lambdas` gerados anteriormente.
3. Após isso deverá funcionar o apply normalmente sem problemas: `terraform apply`.

Caso já tenha aplicado a primeira vez, basta apenas o `terraform apply`.
