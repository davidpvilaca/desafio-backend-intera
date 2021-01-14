# Intera Infrastructure

Projeto de infraestrutura do desafio backend Intera.

## Introdução

Toda a parte da infraestrutura foi utilizado AWS com a filosofia de IaC (infrastructure as code) com o [Terraform](https://terraform.io). Afim de reduzir a complexidade não foram utilizados módulos ou organizações mais isoladas do terraform, porém houve preocupação como escopo de cada parte.

## Como fazer o deploy?

Como consequência da decisão de não utilizar separações em módulos no terraform, há uma dificuldade na primeira vez em que se vai aplicar:

1. Primeiramente deverá ser aplicado apenas a parte do S3 para criar os buckets no qual o código das lambdas ficarão: `terraform apply -target=aws_s3_bucket.intera_lambda_repository`.
2. Os arquivos de código fonte de produção de cada lambda deverá ser adicionado no bucket: `talents/latest.zip`, `openings/latest.zip` e `match/latest.zip`.
3. Após isso deverá funcionar o apply normalmente sem problemas: `terraform apply`.

Caso já tenha aplicado a primeira vez, basta apenas o `terraform apply`.
