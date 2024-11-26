
# Hands-On de DevOps: Integração de Git e Docker

## Objetivo
Este repositório demonstra como integrar **Git** e **Docker** com um laboratório prático. Você aprenderá a:
- Usar Git para controle de versão.
- Automatizar tarefas do Docker com um **Makefile**.
- Instalar o Docker (caso não esteja instalado), configurar o **Portainer** para gerenciamento de containers e executar um container **Nginx**.

## Pré-requisitos
- Entendimento básico de Git e Docker.
- Um ambiente Linux ou macOS. (Usuários de Windows podem usar WSL2.)

---

## Passos a Seguir

### 1. Clone o Repositório
```bash
git clone <url_do_repositorio>
cd devops-lab
```

---

### 2. Visão Geral do Makefile
O **Makefile** automatiza:
1. Verificar se o Docker está instalado e instalá-lo, se necessário.
2. Configurar o **Portainer** para gerenciamento de containers.
3. Executar um container **Nginx** para teste.

---

### 3. Comandos

#### Executar Todas as Tarefas
```bash
make
```

Isso irá:
1. Verificar e instalar o Docker, se necessário.
2. Configurar o Portainer em `http://localhost:9000`.
3. Configurar o Nginx em `http://localhost:8080`.

---

#### Executar Tarefas Individuais
- **Verificar Instalação do Docker**:
    ```bash
    make check-docker
    ```

- **Instalar e Executar o Portainer**:
    ```bash
    make install-portainer
    ```

- **Executar o Nginx**:
    ```bash
    make run-nginx
    ```

---

### 4. Modificar e Comitar
- Modifique o Makefile (ex.: altere a porta do Nginx para `8081`).
- Faça o commit das alterações:
    ```bash
    git add Makefile
    git commit -m "Alterada a porta do Nginx para 8081"
    git push
    ```

---

### 5. Verificar Resultados
- **Portainer**: Acesse a interface em [http://localhost:9000](http://localhost:9000).
- **Nginx**: Acesse [http://localhost:8080](http://localhost:8080) (ou a nova porta, se modificada).

---

## Conteúdo do Makefile
```makefile
# Variáveis
DOCKER=$(shell which docker)

# Regras
all: check-docker install-portainer run-nginx

check-docker:
	@if [ -z "$(DOCKER)" ]; then \
		echo "Docker não encontrado. Instalando..."; \
		curl -fsSL https://get.docker.com | sh; \
		sudo usermod -aG docker $$USER; \
		echo "Docker instalado com sucesso!"; \
	else \
		echo "Docker já está instalado!"; \
	fi

install-portainer:
	@if [ -z "$(shell docker ps | grep portainer)" ]; then \
		echo "Iniciando Portainer..."; \
		docker volume create portainer_data; \
		docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v portainer_data:/data portainer/portainer-ce; \
		echo "Portainer iniciado em http://localhost:9000"; \
	else \
		echo "Portainer já está em execução!"; \
	fi

run-nginx:
	@if [ -z "$(shell docker ps | grep nginx)" ]; then \
		echo "Iniciando Nginx..."; \
		docker run -d -p 8080:80 --name=nginx nginx; \
		echo "Nginx iniciado em http://localhost:8080"; \
	else \
		echo "Nginx já está em execução!"; \
	fi
```

---

## Próximos Passos
- Explore mais configurações do Docker.
- Melhore o Makefile para incluir outros containers ou serviços.
- Use o Git para colaborar e versionar sua infraestrutura como código.

---

## Licença
Este projeto está licenciado sob a Licença MIT.
