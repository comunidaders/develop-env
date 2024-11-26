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
