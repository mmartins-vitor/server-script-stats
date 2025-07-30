# Makefile

# Nome da imagem que vamos usar
IMAGE=ubuntu

# Diretório atual
SCRIPT_DIR=$(shell pwd)

# Alvo para rodar o script via setup-server.sh
setup:
	docker run -it \
		-v "$(SCRIPT_DIR):/app" \
		-w /app \
		$(IMAGE) \
		bash setup-server.sh
