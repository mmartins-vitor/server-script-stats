The goal of this project is to write a script to analyse server perfomance status. 

## Requirements 

You are required to write a script 'server-stats.sh' that can analyse basic server performance stats. You should be able to run the script on any Linux server and it should give you the following stats:

    - Total CPU usage
    - Total memory usage (Free vs Used including percentage)
    - Total disk usage (Free vs Used including percentage)
    - Top 5 processes by CPU usage
    - Top 5 processes by memory usage

## como executar

docker run -it -v "$(pwd):/app" -w /app ubuntu bash

## CPU 

top -bn1
    - top: comando que mostra informações de uso da CPU, memoria e processos em tempo real
    - -b: modo  batch (para saída de textom sem interface interativa)
    - -n1: execute apenas 1 vez (em vez de ficar rodando em loop)
grep "Cpu(s)"
    - Filtra a linha que contém o resumo do uso da CPU
awk '{print $8}'
    - Pega o campo n# 8 da linha que representa o valor id, ou seja, tempo em que a CPU não está fazendo nada
cut -d',' -f1
    - Remove possiveis virgulas e deixa numero limpo para calculo
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)
    - Como CPU_IDLE representa quanto a CPU está parada, o calculo 100 - idle nos da o uso real.
    - bc é a calculadora de precisão, usada pois o resultado é em decimal