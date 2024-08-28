#!/usr/bin/bash

# load modules 
module load sra-tools
module load samtools

help(){
    echo "Usage: use this script to convert SRA files to fastq or bam"
    echo 
    echo "Options :"
    echo " -b : convert to bam file. "
    echo " -q : convert to fastq file. "
    echo " -h : show this help message and exit"
    echo 
    echo " dont forget to change the output directory inside the script"
    echo "if not the output will be ./"
    exit 1
}

# change your own path here
destination="./"

conversion_type=""

while getopts "bq:h" op; do
    case $op in
        q)
            conversion_type="fastq"
            ;;
        b)
            conversion_type="bam"
            ;;
        h)
            help
            ;;
        \?)
            echo "wrong operator: -$OPTARG" >&2
            help
            ;;
    esac
done

if [ -z "$conversion_type" ]; then
    echo " you need to specify a conversion option: -q or -b"
    help
fi

find . -name "*.sra" -exec mv {} $destination \;

for sra_file in $destination*.sra; do
    echo "running $sra_file..."

    base_name=$(basename "$sra_file" .sra)

    case $conversion_type in
        fastq) 
            echo "conversion of $sra_file in fastq...."
            fastq-dump.3 --ngc a.ngc "$sra_file"
            ;;
        bam)
            echo "conversion of $sra_file in bam....."
            sam_dump.3 --ngc a.ngc $sra_file | samtools view -bS - > "${base_name}.bam"
            ;;
    esac

done 

echo "treatment's over"

