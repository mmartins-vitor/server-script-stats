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