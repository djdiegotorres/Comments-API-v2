# Comments-API - Implementação de Prometheus e Grafana com Terraform e Docker Compose

Este documento descreve as alterações realizadas nos arquivos Terraform para incluir a implantação da API, Prometheus e Grafana em uma **única máquina virtual EC2** usando Docker e Docker Compose.

## Alterações Realizadas

Foram feitas as seguintes modificações nos arquivos Terraform e novos arquivos foram criados:

### `docker-compose.yml` (Novo Arquivo)

Este arquivo define os serviços Docker para a API, Prometheus e Grafana:

*   **api:** Constrói a imagem Docker a partir do `Dockerfile` existente no projeto e expõe a porta 3000. Monta o volume para `comments.db`.
*   **prometheus:** Utiliza a imagem `prom/prometheus:latest`, expõe a porta 9090 e monta o arquivo de configuração `prometheus.yml`.
*   **grafana:** Utiliza a imagem `grafana/grafana:latest`, expõe a porta 4000 (mapeada para a porta 3000 do container Grafana) e utiliza um volume para persistência de dados.

### `prometheus.yml` (Novo Arquivo)

Este arquivo de configuração para o Prometheus define os `job_name` para a API e o próprio Prometheus, permitindo que o Prometheus colete métricas desses serviços.

### `terraform/main.tf`

1.  **Recurso `aws_instance` único:** O recurso `aws_instance` foi modificado para provisionar apenas uma máquina virtual EC2 (`single_server`).
2.  **`user_data` atualizado:** O script `user_data` desta instância foi atualizado para:
    *   Instalar Docker e Git.
    *   Instalar o Docker Compose.
    *   Clonar o repositório `Comments-API` para a instância.
    *   Navegar até o diretório do repositório e executar `docker-compose up -d` para iniciar todos os serviços definidos no `docker-compose.yml`.
3.  **Regras de Security Group:** As regras de entrada (ingress) no `aws_security_group.allow_http_ssh` foram mantidas para permitir o tráfego nas portas 22 (SSH), 3000 (API), 9090 (Prometheus) e 4000 (Grafana).

### `terraform/outputs.tf`

1.  **Saída de IP Público Único:** A saída foi modificada para expor apenas o IP público da única instância EC2 (`single_instance_ip`).

## Como Aplicar as Alterações

Para aplicar essas alterações e implantar a API, Prometheus e Grafana em uma única instância EC2 usando Terraform e Docker Compose, siga os passos abaixo:

1.  **Certifique-se de que os novos arquivos estão no diretório raiz do projeto:**
    *   `docker-compose.yml`
    *   `prometheus.yml`

2.  **Navegue até o diretório Terraform:**
    ```bash
    cd Comments-API/terraform
    ```

3.  **Inicialize o Terraform:**
    Este comando baixa os provedores necessários e inicializa o diretório de trabalho do Terraform.
    ```bash
    terraform init
    ```

4.  **Planeje as alterações:**
    Este comando mostra um plano de execução, detalhando o que o Terraform fará (quais recursos serão criados, modificados ou destruídos).
    ```bash
    terraform plan
    ```

5.  **Aplique as alterações:**
    Este comando executa o plano e provisiona os recursos na AWS. Você será solicitado a confirmar a aplicação.
    ```bash
    terraform apply
    ```

Após a aplicação bem-sucedida, o IP público da instância será exibido na saída do comando `terraform apply` (ou você pode obtê-lo executando `terraform output`).

## Acesso às Ferramentas

Assumindo que `<IP_PUBLICO_INSTANCIA>` é o IP público da sua única instância EC2:

*   **API:** Acesse `http://<IP_PUBLICO_INSTANCIA>:3000` no seu navegador.
*   **Prometheus:** Acesse `http://<IP_PUBLICO_INSTANCIA>:9090` no seu navegador.
*   **Grafana:** Acesse `http://<IP_PUBLICO_INSTANCIA>:4000` no seu navegador. As credenciais padrão do Grafana são `admin`/`admin` (você será solicitado a alterá-las no primeiro login).

**Nota:** Certifique-se de que sua chave SSH (`key_name` no `variables.tf`) esteja configurada corretamente em sua conta AWS e que você tenha as permissões necessárias para criar recursos EC2 e Security Groups.

