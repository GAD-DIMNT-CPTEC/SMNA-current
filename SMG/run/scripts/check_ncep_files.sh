#!/bin/bash

# Usage: ./check_ncep_files.sh /path/to/ncep/files HOUR
# Example: ./check_ncep_files.sh /oper/dados/dboper/raw/arch/mod/ncep/gdas/2026/06/12 06

ncep_filepath="$1"
hour="$2"

if [ -z "$ncep_filepath" ] || [ -z "$hour" ]; then
    echo "❌ Missing arguments: directory path and hour (00,06,12,18)"
    exit 1
fi

required_files=("1bamua" "atms" "gpsro" "satwnd" "prepbufr")

max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    missing_files=()
    for f in "${required_files[@]}"; do
        if ! ls "${ncep_filepath}/gdas.t${hour}z.${f}"* >/dev/null 2>&1; then
            missing_files+=("$f")
        fi
    done

    if [ ${#missing_files[@]} -eq 0 ]; then
        echo "✅ All required observation files found for hour ${hour} in ${ncep_filepath}"
        exit 0
    else
        line=""
        last_index=$((${#required_files[@]}-1))
        for i in "${!required_files[@]}"; do
            f="${required_files[$i]}"
            if printf '%s\n' "${missing_files[@]}" | grep -q "^${f}$"; then
                line+=$(printf "%-7s" "$f")
            else
                line+=$(printf "%-7s" "")
            fi
            if [ $i -lt $last_index ]; then
                line+=" "
            fi
        done
        line=$(echo "$line" | sed 's/[[:space:]]*$//')
        echo "⚠ Missing files [${line}] for hour ${hour}. Attempt $attempt/$max_attempts. Waiting 10 minutes..."
        sleep 600
        attempt=$((attempt+1))
    fi
done

echo "❌ Required files not found after $max_attempts attempts for hour ${hour} in ${ncep_filepath}"
exit 1
