# 🗂️ Comments API com Monitoramento

API para gerenciamento de comentários em matérias, desenvolvida em Node.js com SQLite, contendo infraestrutura automatizada com Terraform, CI/CD via GitHub Actions e monitoramento com Prometheus + Grafana.

## 🔧 Tecnologias Utilizadas

- Node.js (Express, Knex)
- SQLite
- Docker e Docker Compose
- AWS EC2 (via Terraform)
- GitHub Actions (CI/CD)
- Prometheus + Grafana
- UptimeRobot (opcional)
- Terraform CLI

## 📦 Funcionalidades da API

- `POST /api/comment/new`: Cria um novo comentário
- `GET /api/comment/list/:content_id`: Lista comentários por matéria
- `GET /api/comment/list`: Lista todos os comentários

## 🚀 Passo a Passo Realizado

### 1. Criação da API
- Estrutura em Node.js com Knex e SQLite
- Criação de migrações e rotas

### 2. Docker
- Criação de `Dockerfile` e `docker-compose.yml`
- Volume persistente para o banco SQLite
- Serviços adicionais: Prometheus e Grafana

### 3. Terraform
- Provisionamento de uma EC2 Amazon Linux 2023
- Instalação automatizada do Docker via `user_data`

### 4. CI/CD com GitHub Actions
- Envio de código com `scp-action`
- Deploy com `ssh-action`
- Execução de:
  ```bash
  docker-compose down
  docker-compose up -d --build
  docker-compose exec -T api npx knex migrate:latest
  ```

### 5. Monitoramento
- Prometheus configurado para coletar métricas
- Grafana na porta `4000`, conectado ao Prometheus
- UptimeRobot (opcional) para ping externo da API

## 📁 Estrutura Esperada

```bash
<<<<<<< HEAD
=======
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
>>>>>>> 894704578abce4295fb861e79de988b18607359e
.
├── Dockerfile
├── docker-compose.yml
├── knexfile.js
├── db.js
├── index.js
├── migrations/
├── prometheus.yml
└── README.md
<<<<<<< HEAD
```
=======


☁️ Infraestrutura na AWS com Terraform

Provisione a instância EC2 com Terraform (exemplo básico):
>>>>>>> 894704578abce4295fb861e79de988b18607359e

## ✅ Verificações

- Certifique-se de que a porta 3000 (API), 4000 (Grafana) e 9090 (Prometheus) estão liberadas no SG da EC2
- Banco SQLite deve estar mapeado via volume no Compose
- Secrets corretos no repositório GitHub (EC2_HOST, EC2_SSH_KEY)

## 🧪 Testes
Utilizar comandos `curl` como:

<<<<<<< HEAD
```bash
curl -X POST http://<host>:3000/api/comment/new   -H "Content-Type: application/json"   -d '{"email":"test@example.com","comment":"Olá mundo","content_id":1}'
```

---
=======
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

