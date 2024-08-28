#!/usr/bin/bash
help(){
    echo "this script is going to download the SRA files from a sra list provided after sorting the id from a sra table"
    echo "and place them inside of a new folder"
    echo "no argument is needed"
    echo
    echo " this script is functioning if the table file has a header"
    echo " if not, just change the done by the one behind a #"
    exit 1
}
# Add sratoolkit to PATH
export PATH="/scratch/user/uqsdemon/ApplicationGNN/gnnenvo/bin/sratoolkit.3.1.1-ubuntu64/bin:$PATH"

# Charger les modules nécessaires (if still required)
module load sra-tools
module load samtools

# Chemin du fichier contenant les identifiants SRR
fastq_ids_file="/scratch/user/uqsdemon/rnewbashscriptvf/SRRIDS/fastq_ids.txt"
# Liste des identifiants à exclure
exclude_ids_file="/scratch/user/uqsdemon/rnewbashscriptvf/filedone.txt"
outputpath="/QRISdata/Q7361/SRRIDS/fastqfilesncbi"
keypath="/scratch/user/uqsdemon/rnewbashscriptvf/prj_33410_D38764.ngc"

# Vérifiez que sra-tools est chargé correctement
if ! command -v fasterq-dump &> /dev/null; then
  echo "fasterq-dump could not be found. Please check your sratoolkit installation and PATH."
  help
fi

if [ ! -f "$fastq_ids_file" ]; then
    echo "Error: the file with sra ids does not exist."
    help
fi

if [ ! -f "$keypath" ]; then
    echo "Erreur : le fichier NGC n'existe pas au chemin spécifié."
    help
fi

# Charger les identifiants à exclure dans un tableau
mapfile -t exclude_ids < "$exclude_ids_file"

temp_path="/QRISdata/Q7361/temp"

# Assurez-vous que le répertoire temporaire existe
mkdir -p "$temp_path"

# Lire chaque ligne du fichier fastq_ids.txt
while read -r srr_id; do
  # Vérifier si l'identifiant est dans la liste des exclusions
  if printf '%s\n' "${exclude_ids[@]}" | grep -qx "$srr_id"; then
    echo "Skipping excluded ID: $srr_id"
    continue
  fi
  echo "Téléchargement et conversion de $srr_id en format fastq depuis NCBI..."
  # Télécharger et convertir le fichier SRA en fichiers fastq
  mkdir -p "$outputpath/$srr_id"
  fasterq-dump --ngc "$keypath" --split-files "$srr_id" -O "$outputpath/$srr_id" --temp "$temp_path"
done < "$fastq_ids_file"

echo "download over"