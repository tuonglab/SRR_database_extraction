#!/bin/bash

# Chemin du répertoire source
source_dir="/QRISdata/Q7361/SRRIDS/fastqfilesncbi"

# Chemin du fichier de destination
output_file="/scratch/user/uqsdemon/rnewbashscriptvf/filedone.txt"

# Vérifier si le fichier de destination existe déjà et le supprimer
if [ -f "$output_file" ]; then
    rm "$output_file"
fi

# Créer un nouveau fichier de destination vide
touch "$output_file"

# Parcourir tous les dossiers dans le répertoire source et écrire leurs noms dans le fichier de destination
for dir in "$source_dir"/*; do
    if [ -d "$dir" ]; then
        echo "$(basename "$dir")" >> "$output_file"
    fi
done

echo "Les noms des dossiers ont été écrits dans $output_file"