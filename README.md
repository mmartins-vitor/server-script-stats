The goal of this project is to write a script to analyse server perfomance status. 

## Requirements 

You are required to write a script 'server-stats.sh' that can analyse basic server performance stats. You should be able to run the script on any Linux server and it should give you the following stats:

    - Total CPU usage
    - Total memory usage (Free vs Used including percentage)
    - Total disk usage (Free vs Used including percentage)
    - Top 5 processes by CPU usage
    - Top 5 processes by memory usage

## como executar

### no terminal 

```bash
docker run -it -v "$(pwd):/app" -w /app ubuntu bash
```

### executando com make

```bash
make setup
```
## Explicação do Script

O script `server-stats.sh` é dividido em seções para analisar diferentes aspectos do servidor.

### CPU

O uso de CPU é calculado subtraindo o tempo ocioso (`idle`) de 100%.

```bash
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d',' -f1)
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)
```

- `top -bn1`: Executa o comando `top` em modo "batch" (`-b`) por uma única iteração (`-n1`) para obter um snapshot do estado do sistema.
- `grep "Cpu(s)"`: Filtra a saída do `top` para obter apenas a linha que contém as estatísticas da CPU.
- `awk '{print $8}'`: Extrai a oitava coluna da linha da CPU, que corresponde ao percentual de tempo ocioso (`idle`).
- `cut -d',' -f1`: Remove a vírgula do valor para garantir que seja um número puro.
- `echo "100 - $CPU_IDLE" | bc`: Usa a calculadora `bc` para subtrair o valor ocioso de 100, resultando no percentual de uso atual da CPU.

### Memória

As estatísticas de memória são extraídas do comando `free`.

```bash
MEM_TOTAL=$(free -m | awk '/Mem:/{print $2}')
MEM_USADO=$(free -m | awk '/Mem:/{print $3}')
MEM_LIVRE=$(free -m | awk '/Mem:/{print $4}')
MEM_PERCENT=$(echo "scale=2; $MEM_USADO/$MEM_TOTAL*100" | bc)
```

- `free -m`: Exibe o uso de memória RAM no sistema, com valores em Megabytes (`-m`).
- `awk '/Mem:/{print $2}'`: Na linha que começa com `Mem:`, extrai a segunda coluna (memória total). O mesmo padrão é usado para a coluna 3 (usada) e 4 (livre).
- `echo "scale=2; $MEM_USADO/$MEM_TOTAL*100" | bc`: Calcula o percentual de memória usada.
    - `scale=2`: Define que o resultado terá duas casas decimais.
    - `bc`: Executa o cálculo de ponto flutuante.

### Disco

O uso do disco para o diretório raiz (`/`) é obtido com o comando `df`.

```bash
DISCO=$(df -h / | tail -1)
DISCO_TOTAL=$(echo $DISCO | awk '{print $2}')
DISCO_USADO=$(echo $DISCO | awk '{print $3}')
DISCO_LIVRE=$(echo $DISCO | awk '{print $4}')
DISCO_PERC=$(echo $DISCO | awk '{print $5}')
```

- `df -h /`: Mostra o uso de espaço em disco para o sistema de arquivos raiz (`/`) em formato legível por humanos (`-h`).
- `tail -1`: Pega apenas a última linha da saída, que contém os dados que queremos.
- `echo $DISCO | awk '{print $2}'`: Extrai a segunda coluna da linha de dados, que corresponde ao tamanho total do disco. O mesmo padrão é usado para as colunas 3 (usado), 4 (livre) e 5 (percentual de uso).

### Top 5 Processos (CPU e Memória)

Para listar os processos que mais consomem recursos, usamos o comando `ps`.

```bash
# Por uso de CPU
ps -eo %cpu,pid,user,args --sort=-%cpu | head -n 6

# Por uso de Memória
ps -eo %mem,pid,user,args --sort=-%mem | head -n 6
```

- `ps -eo ...`: O comando `ps` lista os processos. A flag `-e` mostra todos os processos e `-o` permite formatar a saída.
    - `%cpu,%mem,pid,user,args`: Define as colunas a serem exibidas: percentual de CPU, percentual de memória, ID do processo, usuário e o comando completo.
- `--sort=-%cpu` ou `--sort=-%mem`: Ordena a saída em ordem decrescente (o `-` indica decrescente) pelo uso de CPU ou memória.
- `head -n 6`: Exibe as 6 primeiras linhas da saída (1 linha de cabeçalho + 5 processos).
