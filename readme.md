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
.
├── Dockerfile
├── docker-compose.yml
├── knexfile.js
├── db.js
├── index.js
├── migrations/
├── prometheus.yml
└── README.md
```

## ✅ Verificações

- Certifique-se de que a porta 3000 (API), 4000 (Grafana) e 9090 (Prometheus) estão liberadas no SG da EC2
- Banco SQLite deve estar mapeado via volume no Compose
- Secrets corretos no repositório GitHub (EC2_HOST, EC2_SSH_KEY)

## 🧪 Testes
Utilizar comandos `curl` como:

```bash
curl -X POST http://<host>:3000/api/comment/new   -H "Content-Type: application/json"   -d '{"email":"test@example.com","comment":"Olá mundo","content_id":1}'
```

---