#!/usr/bin/bash

# alors j'ai un fichier ici : /QRISdata/Q7250/SraRunTable.txt
# celui ci contient des noms de data à télécharger sur NCBI , et donc leurs identifiants. 
# voici l'en tete : Run,analyte_type,Assay Type,AvgSpotLen,Bases,BioProject,BioSample,biospecimen_repository,biospecimen_repository_sample_id,body_site,Bytes,Center Name,Consent_Code,Consent,DATASTORE filetype,DATASTORE provider,DATASTORE region,Experiment,gap_accession,gap_parent_phs,histological_type,Instrument,Is_Tumor,Library Name,LibraryLayout,LibrarySelection,LibrarySource,Organism,Platform,ReleaseDate,create_date,version,Sample Name,SRA Study,study_design,study_name,submitted_subject_id,sex,AssemblyName,sequencing_date (run),run (run),CompleteGenomics_sample_ID (run),alignment_software (exp),Library_Construction_batch (exp),Assembly (run),read_group_platform_unit (run),lsid (exp),lsid (run),project (exp),project (run),run_barcode (run),run_name (run),sample_barcode (exp),sample_barcode (run),target_set (exp),work_request (exp),work_request (run),molecular_indexing_scheme (run),Runs (run),Sequencing_Dates (run),BI_GSSR_sample_ID (exp),BI_GSSR_sample_ID (run),BI_GSSR_sample_LSID (exp),BI_GSSR_sample_LSID (run),BI_project_name (exp),BI_project_name (run),BI_run_barcode (run),BI_run_name (run),BI_target_set (exp),BI_work_request_ID (exp),BI_work_request_ID (run),FLAG (exp),secondary_accessions (run),secondary_accessions (exp),Illumina_HiSeq_1000 (run),instrument_model (run),dangling_references (run),missing_file (run),TRUNCATED_DATA (exp)
# voici quelques lignes :
# SRR1784867,RNA,RNA-Seq,150,10766823750,PRJNA89521,SAMN02724509,NCI_TARGET,TARGET-50-PAJNCJ-01A-01R,Primary Solid Tumor,6804472697,BCCAGSC,1,DS-PEDCR,"fastq,run.zq,sra","gs,ncbi,s3","gs.us-east1,ncbi.dbgap,s3.us-east-1",SRX535093,phs000471,phs000218,Kidney Tumors,Illumina HiSeq 2000,Yes,A33656,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2015-02-02T00:00:00Z,2015-02-02T20:08:00Z,1,TARGET-50-PAJNCJ-01A-01R,SRP012006,Tumor vs. Matched-Normal,"TARGET: Kidney\, Wilms Tumor (WT)",TARGET-50-PAJNCJ,female,,"2013-11-19T22:49:17Z,2013-11-19T22:49:17Z","137868,137868",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
# SRR1784868,RNA,RNA-Seq,150,9274252950,PRJNA89521,SAMN02724710,NCI_TARGET,TARGET-50-PAKRVH-01A-01R,Primary Solid Tumor,5911505670,BCCAGSC,1,DS-PEDCR,"fastq,run.zq,sra","gs,ncbi,s3","gs.us-east1,ncbi.dbgap,s3.us-east-1",SRX535041,phs000471,phs000218,Kidney Tumors,Illumina HiSeq 2000,Yes,A33644,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2015-02-02T00:00:00Z,2015-02-02T20:00:00Z,1,TARGET-50-PAKRVH-01A-01R,SRP012006,Tumor vs. Matched-Normal,"TARGET: Kidney\, Wilms Tumor (WT)",TARGET-50-PAKRVH,male,,"2013-11-19T22:49:32Z,2013-11-19T22:49:32Z","137872,137872",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
# SRR1784869,RNA,RNA-Seq,150,11888927700,PRJNA89521,SAMN02724490,NCI_TARGET,TARGET-50-PAJMKJ-01A-01R,Primary Solid Tumor,7356935594,BCCAGSC,1,DS-PEDCR,"fastq,run.zq,sra","gs,ncbi,s3","gs.us-east1,ncbi.dbgap,s3.us-east-1",SRX535079,phs000471,phs000218,Kidney Tumors,Illumina HiSeq 2000,Yes,A33653,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2015-02-02T00:00:00Z,2015-02-02T21:06:00Z,1,TARGET-50-PAJMKJ-01A-01R,SRP012006,Tumor vs. Matched-Normal,"TARGET: Kidney\, Wilms Tumor (WT)",TARGET-50-PAJMKJ,female,,"2013-11-19T20:59:48Z,2013-11-19T20:59:48Z","137845,137845",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
# SRR1329251,RNA,RNA-Seq,150,14328358800,PRJNA89521,SAMN02724519,NCI_TARGET,TARGET-50-CAAAAQ-01A-01R,Primary Solid Tumor,5377726381,BCCAGSC,1,DS-PEDCR,"bam,run.zq,sra","gs,ncbi,s3","gs.us-east1,ncbi.dbgap,s3.us-east-1",SRX567384,phs000471,phs000218,Kidney Tumors,Illumina HiSeq 2000,Yes,A33635,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2014-06-11T00:00:00Z,2014-06-03T20:26:00Z,1,TARGET-50-CAAAAQ-01A-01R,SRP012006,Tumor vs. Matched-Normal,"TARGET: Kidney\, Wilms Tumor (WT)",TARGET-50-CAAAAQ,female,GCA_000001405.13,"2013-11-19T19:16:43Z,2013-12-17T21:46:44Z","137828,138416",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
# comme tu peux le voir il y a des bam et des fastq
# ce que je veux faire dans ce script c'est récuperer les SRR id des fastq et les mettre dans un fichier texte, et les bam les mettre dans un autre

# Chemin du fichier d'entrée
input_file="/QRISdata/Q7250/SraRunTable.txt"

# Chemins des fichiers de sortie
fastq_output_file="/scratch/user/uqsdemon/SRRIDS/fastq_ids.txt"
bam_output_file="/scratch/user/uqsdemon/SRRIDS/bam_ids.txt"

# Extraire les identifiants SRR pour les fastq et les sauvegarder dans fastq_ids.txt
awk -F, '/fastq/ {print $1}' "$input_file" > "$fastq_output_file"

# Extraire les identifiants SRR pour les bam et les sauvegarder dans bam_ids.txt
awk -F, '/bam/ {print $1}' "$input_file" > "$bam_output_file"

