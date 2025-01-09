#!/bin/bash

# Carrega as variáveis do arquivo .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "[bucket] Erro: Arquivo .env não encontrado."
    exit 1
fi

# Função para criar e verificar bucket
create_and_verify_bucket() {
    local bucket_name=$1
    local bucket_type=$2
    
    if aws s3 ls "s3://$bucket_name" 2>/dev/null; then
      echo "$bucket_type Bucket is already created."
    else
      echo "$bucket_type Bucket does not exist. Let's create it..."

      
      aws s3api create-bucket --bucket "$bucket_name" --region "$AWS_REGION"
      echo "$bucket_type Bucket created."
    fi
}

echo "Setting up buckets..."

# Cria e verifica o bucket principal
create_and_verify_bucket "$AWS_BUCKET_NAME" "backend"

echo "Setting up buckets - DONE."