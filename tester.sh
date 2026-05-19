#!/usr/bin/env bash

set -euo pipefail

if [ ${#} -ge 1 ]; then
	BINARIES=("$1")
else
	BINARIES=(
		corewar-panda-1
		corewar-panda-2
		corewar-panda-3
		corewar-icarus-1
		corewar-icarus-2
		corewar-apollon-1
		corewar-apollon-2
		corewar-migi-1
		corewar-migi-2
		corewar-migi-3
		corewar-snake-1
		corewar-snake-2
		corewar-snake-3
		corewar-snake-4
		corewar-snake-5
		corewar-snake-6
		corewar-expension-1
		corewar-expension-2
		corewar-expension-3
		corewar-mandom-1
		corewar-mandom-2
	)
fi

../champions/asm ../champions/*.s

COR_FILES=()
for f in *.cor; do
	[ -f "$f" ] || continue
	COR_FILES+=("$f")
done

if [ ${#COR_FILES[@]} -eq 0 ]; then
	echo "Aucun fichier .cor trouvé dans le répertoire courant."
	exit 1
fi

for bin in "${BINARIES[@]}"; do
	if [ ! -x "./$bin" ]; then
		if [ -f "./$bin" ]; then
			echo "Le fichier './$bin' existe mais n'est pas exécutable, tentative chmod +x..."
			chmod +x "./$bin" 2>/dev/null || {
				echo "Impossible de rendre './$bin' exécutable. Ignoré."
				continue
			}
		else
			echo "Binaire './$bin' introuvable — ignoré." >&2
			continue
		fi
	fi

	printf "== $bin ==\n"
	for cor in "${COR_FILES[@]}"; do
		printf "$cor ==> "
		if output=$(./"$bin" "$cor" 2>&1); then
			printf '%s' "$output" | tail -n 2
		else
			printf '%s' "$output" | tail -n 2
		fi
	done
	echo
done
