# 🗂️ Comments API com Monitoramento

API para gerenciamento de comentários em matérias, desenvolvida em Node.js com SQLite, contendo infraestrutura automatizada com Terraform, CI/CD via GitHub Actions e monitoramento com Prometheus + Grafana.

---

## 📦 Tecnologias Utilizadas

- Node.js + Express
- SQLite + Knex.js
- Docker + Docker Compose
- Terraform (AWS EC2)
- GitHub Actions (CI/CD)
- Prometheus + Grafana (monitoramento)
- UptimeRobot (monitoramento externo)

---

## 🔧 Funcionalidades da API

- Criar comentário: `POST /api/comment/new`
- Listar comentários por `content_id`: `GET /api/comment/list/:content_id`
- Listar todos os comentários: `GET /api/comment/list`

---

## 🛠️ Como rodar localmente

```bash
# Clonar o projeto
git clone https://github.com/seu-usuario/comments-api.git
cd comments-api

# Instalar dependências
npm install

# Rodar migrations
npx knex migrate:latest

# Iniciar o servidor
node index.js


🐳 Como rodar com Docker

bash
Copiar
Editar
# Build e subida dos containers
docker-compose up -d --build

# Rodar as migrations dentro do container
docker-compose exec -T api npx knex migrate:latest


📁 Estrutura do Projeto

kotlin
Copiar
Editar
.
├── Dockerfile
├── docker-compose.yml
├── knexfile.js
├── index.js
├── db.js
├── migrations/
├── routes/
│   └── comments.js
├── data/
│   └── comments.db
├── prometheus.yml
└── README.md


☁️ Infraestrutura na AWS com Terraform

Provisione a instância EC2 com Terraform (exemplo básico):

hcl
Copiar
Editar
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "node_api" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2023
  instance_type = "t2.micro"
  key_name      = "sua-chave"

  tags = {
    Name = "NodeAPI"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker git -y",
      "sudo service docker start",
      "sudo usermod -aG docker ec2-user"
    ]
  }
}


🚀 Deploy Automatizado (GitHub Actions)

deploy.yml
yaml
Copiar
Editar
name: Deploy to EC2

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout código
      uses: actions/checkout@v3

    - name: Copiar código via SSH para EC2
      uses: appleboy/scp-action@v0.1.6
      with:
        host: ${{ secrets.EC2_HOST }}
        username: ec2-user
        key: ${{ secrets.EC2_SSH_KEY }}
        source: "."
        target: "/home/ec2-user/app"

    - name: Rodar containers remotamente com Docker Compose
      uses: appleboy/ssh-action@v0.1.10
      with:
        host: ${{ secrets.EC2_HOST }}
        username: ec2-user
        key: ${{ secrets.EC2_SSH_KEY }}
        script: |
          cd /home/ec2-user/app
          mkdir -p data
          chmod 777 data
          sudo docker-compose down || true
          sudo docker-compose up -d --build

    - name: Rodar migrações
      uses: appleboy/ssh-action@v0.1.10
      with:
        host: ${{ secrets.EC2_HOST }}
        username: ec2-user
        key: ${{ secrets.EC2_SSH_KEY }}
        script: |
          cd /home/ec2-user/app
          sudo docker-compose exec -T api npx knex migrate:latest


📊 Monitoramento com Prometheus + Grafana

Prometheus
Porta: 9090

Configuração: prometheus.yml

Endpoint da API para scrape: http://api:3000/metrics

Grafana
Porta: 4000

Login padrão: admin/admin

Configurar data source Prometheus: http://prometheus:9090

Exemplo de Métrica Customizada (Node.js + Prometheus):
js
Copiar
Editar
const client = require('prom-client');
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics();
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});


🌐 Monitoramento Externo com UptimeRobot

Criar monitor HTTP

Inserir URL pública da instância EC2

Receber alertas por e-mail, SMS ou Telegram


✅ Checklist de Deploy

 API funcional localmente

 Banco SQLite persistido em volume

 Container rodando via Docker Compose

 CI/CD configurado com GitHub Actions

 EC2 provisionada com Terraform

 Prometheus + Grafana configurados

 Monitor externo com UptimeRobot


📮 Contato

Diego Torres
