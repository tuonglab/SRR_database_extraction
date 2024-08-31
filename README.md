# SRR_database_extraction

Extraction of SRR database for training deep learning algorithm

## Structure

### Folder: SRRIDS
Contains the two files `bam_ids.txt` and `fastq_ids.txt` which are the IDs extracted from the SRR table. We are using these IDs to activate the command of extraction for each ID.

### convert.sh
For the moment not used, but you could use the skeleton of this code if you need to transform files into BAM or FASTQ.

### fastqfetch.sh
The main script; it will take the files online and download them under two reads in the workspace given under FASTQ format.

### filedone.txt
Contains every ID that has already been downloaded.

### names.sh
**RUN IT BEFORE ANY `fastqfetch.sh` USAGE.** This script will write in `filedone.txt` and this file will be used to avoid downloading the same files twice.

### ngc file
The key for downloading SRR, needs to be in the folder.

### sorting.sh
File to extract the IDs from the initial SRR table.

### srabatch.sh
File to activate `fastqfetch.sh`. It will run until 7 days have passed and will download all the files it can during the allowed time. It might be good to run multiple instances, but make sure it's not downloading the same files at the same time. Maybe split the IDs files.

### suppr.py
Suppress empty folders in the workspace, if needed.
