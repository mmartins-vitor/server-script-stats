#! /bin/bash
echo "--- STATS DO SERVIDOR ---"
echo ""

# CPU
echo ">>> USO DE CPU:"
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d',' -f1)
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc )
echo "Uso total da CPU: $CPU_USAGE %"
echo ""

# MEM
echo ">>> USO DE MEMÓRIA:"
MEM_TOTAL=$(free -m | awk '/Mem:/{print $2}')
MEM_USADO=$(free -m | awk '/Mem:/{print $3}')
MEM_LIVRE=$(free -m | awk '/Mem:/{print $4}')
MEM_PERCENT=$(echo "scale=2; $MEM_USADO/$MEM_TOTAL*100" | bc)
echo "Memoria total: ${MEM_TOTAL} MB"
echo "Memoria usada: ${MEM_USADO} MB"
echo "Memoria livre: ${MEM_LIVRE} MB"
echo "Uso da memoria: $MEM_PERCENT %"
echo ""

# DISCO
echo ">>> USO DE DISCO:"
DISCO=$(df -h / | tail -1)
DISCO_TOTAL=$(echo $DISCO | awk '{print $2}')
DISCO_USADO=$(echo $DISCO | awk '{print $3}')
DISCO_LIVRE=$(echo $DISCO | awk '{print $4}')
DISCO_PERC=$(echo $DISCO | awk '{print $5}')
echo "Disco total: $DISCO_TOTAL"
echo "Disco usado: $DISCO_USADO"
echo "Disco livre: $DISCO_LIVRE"
echo "Uso percentual: $DISCO_PERC"
echo ""

# TOP 5 PROCESSOS CPU
echo ">>> TOP 5 PROCESSOS POR USO DE CPU:"
ps -eo %cpu,pid,user,args --sort=-%cpu | head -n 6
echo ""

# TOP 5 PROCESSOS MEM
echo ">>> TOP 5 PROCESSOS POR USO DE MEMÓRIA:"
ps -eo %mem,pid,user,args --sort=-%mem | head -n 6
echo ""
