# **Tech Challenge RD 2025**

Este repositório contém um **desafio de carrinho de compras (e-commerce)** desenvolvido em **Ruby on Rails**. Ele abrange funcionalidades essenciais como adicionar, remover e atualizar produtos no carrinho, gerenciar carrinhos abandonados e executar testes automatizados. O ambiente pode ser facilmente gerenciado via **Docker Compose** e um **Makefile** simplificado.

Além disso, o desenvolvimento deste projeto foi gerenciado com o auxílio do **Plane**, um gerenciador de tarefas eficiente e intuitivo. Você pode visualizar as tarefas relacionadas ao projeto acessando o link abaixo:

🔗 **[Board de Tarefas](https://sites.plane.so/issues/4b56811a0473405f883b3eb2eed3ba8b/?board=kanban&peekId=23fb0694-55a2-45df-b84d-4056f6dd4cbb)**

---

## **1. Funcionalidades**
- **Gerenciamento de Carrinho**:
  - Criar um carrinho e adicionar produtos (ou atualizar quantidades).
  - Listar os produtos no carrinho.
  - Remover produtos do carrinho.

- **Controle de Carrinhos Abandonados**:
  - Carrinhos inativos por mais de **3 horas** são marcados como abandonados.
  - Carrinhos abandonados são automaticamente excluídos após **7 dias**.

- **Infraestrutura**:
  - Banco de Dados: **PostgreSQL**.
  - Jobs em segundo plano: **Sidekiq + Redis**.
  - Configuração via **Docker Compose** (Rails, Sidekiq, PostgreSQL, Redis).
  - Testes automatizados com **RSpec**.

---

## **2. Como Executar**

### **Via Docker Compose (Recomendado)**

1. Clone o repositório:
   ```sh
   git clone https://github.com/seu-usuario/tech-challenge-rd-2025.git
   cd tech-challenge-rd-2025
   ```

2. Construa e inicie os contêineres:
   ```sh
   make build
   make start
   ```

3. Acesse a aplicação em: [http://localhost:3000](http://localhost:3000).

4. Para verificar logs:
   ```sh
   make logs
   ```

### **Execução Manual (Sem Docker)**

Caso prefira rodar a aplicação localmente:

1. Instale:
   - Ruby 3.3.1 (ou a versão especificada em `.ruby-version`).
   - PostgreSQL 16 e Redis 7.
   - Dependências adicionais (ex: libvips para processamento de imagens).

2. Instale as gems:
   ```sh
   bundle install
   ```

3. Configure o banco de dados:
   ```sh
   bin/setup
   ```

4. Inicie a aplicação e o Sidekiq:
   ```sh
   bundle exec rails server
   bundle exec sidekiq
   ```

## **3. Executando os Testes**

### **Dentro do Docker (recomendado)**
   ```sh
   make test
   ```
Esse comando inicia o serviço de testes, executa o RSpec e finaliza o contêiner automaticamente.

### **Manual (sem Docker)**
   ```sh
   bundle exec rspec
   ```

## **4. Comandos Úteis no Makefile**

Este projeto inclui um Makefile para facilitar operações do dia a dia:

- `make start`    # Inicia os serviços (web, Sidekiq, PostgreSQL, Redis)
- `make stop`     # Para e remove todos os contêineres
- `make shell`    # Abre um shell dentro do contêiner web
- `make console`  # Abre o console do Rails no contêiner web
- `make test`     # Executa os testes automatizados
- `make logs`     # Exibe logs de todos os serviços
- `make clean`    # Remove contêineres, imagens e volumes órfãos

Para visualizar todos os comandos disponíveis:
   ```sh
   make help
   ```

## **5. Descrição do Desafio**

[📄 Leia a descrição completa do desafio](docs/challenge.md)
