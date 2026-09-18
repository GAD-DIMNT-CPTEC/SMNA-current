#!/bin/bash

# Usage: ./check_ctl_files.sh /path/to/pos_ctlfiles
# Example: ./check_ctl_files.sh /p/projetos/ioper/SMNA_v3.0.0.t12717/SMG/datainout/bam/pos/dataout/TQ0299L064/2026091800

DATAOUT="$1"

if [ -z "$DATAOUT" ]; then
    echo "Uso: $0 <diretorio DATAOUT>"
    exit 1
fi

# === Checagem e correção dos arquivos ctl vazios ou corrompidos ===
empty_files=$(find "${DATAOUT}" -name "*.fct.*.ctl" -size 0)
corrupted_files=$(grep -L '^dset' "${DATAOUT}"/*.fct.*.ctl 2>/dev/null)
problem_files=$(echo -e "${empty_files}\n${corrupted_files}" | sort -u)

if [ -n "$problem_files" ]; then
    echo "=== Processando arquivos ctl vazios ou corrompidos ==="

    # Encontrar um arquivo ctl completo para usar de base
    okfile=$(grep -l '^dset' "${DATAOUT}"/*.fct.*.ctl 2>/dev/null | head -n 1)

    if [ -z "$okfile" ]; then
        echo "❌ Nenhum arquivo ctl íntegro encontrado em ${DATAOUT}"
        echo "Sugestão: copie manualmente um arquivo válido de outro ciclo para servir de base."
        exit 1
    fi


    for notok in $problem_files; do
        echo "Atualizando arquivo: ${notok}"

        # Copiar conteúdo do arquivo OK para o Not OK
        cp "${okfile}" "${notok}"

        # Extrair padrão do nome (parte numérica completa)
        filename=$(basename "${notok}")
        pattern=$(echo "${filename}" | sed -E 's/.*GPOSCPT([0-9]+)P.*/\1/')

        # Substituir mantendo prefixo e sufixo nas linhas que especificam data e hora dos arquivos .grb e .idx
        sed -i -E "s/^(dset \^GPOSCPT)[0-9]+P(\.fct.*\.grb)/\1${pattern}P\2/" "${notok}"
        sed -i -E "s/^(index \^GPOSCPT)[0-9]+P(\.fct.*\.idx)/\1${pattern}P\2/" "${notok}"

        # Substituir apenas a parte da data/hora em tdef por fctdate no formato adequado
        fctdate=$(echo "$filename" | sed -E 's/.*([0-9]{10})P.*/\1/')
        formatted=$(LC_TIME=C date -d "${fctdate:0:8} ${fctdate:8:2}" +"%HZ%d%^b%Y")
        sed -i -E "s/(tdef[[:space:]]+.*)[0-9]{2}Z[0-9]{2}[A-Z]{3}[0-9]{4}(.*)/\1${formatted}\2/" "${notok}"

    done
else
    echo "Nenhum arquivo ctl vazio ou corrompido encontrado em ${DATAOUT}"
fi
