#!/bin/bash

echo "Atualizando pacotes..."
apt update

echo "Instalando dependências..."
apt install -y procps coreutils psmisc bc

echo "Dando permissão de execução ao server-stats.sh..."
chmod +x /app/server-stats.sh

echo "Executando o script..."
/app/server-stats.sh
