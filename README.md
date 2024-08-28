# SRR_database_extraction
extraction of SRR database for training deep learning algorithm

structure :

folder : SRRIDS : contains the two files bam_ids.txt and fastq_ids.txt which are the id extracted from the SRR table, we are using theses id to activate the command of extraction for each ids. 

convert.sh for the moment not used, but you could use the skeleton of this code if you need to transform files into bam or fastq.
 
fastqfetch.sh : the main script; it will take the files online and download them under two reads in the workspace given under fastq format. 

filedone.txt : contain ever ids that have been alrdy dowloaded.

names.sh : RUN IT BEFORE ANY fastqfetch.sh usage. this script will write in filedone.txt and this file will be used to avoid to download two times the sames files. 

ngc file : the key for downloading srr, needs to be in the folder

sorting.sh : file to extract the ids from the SRR table intial.

srabatch.sh : file to activate fastqfetch.sh, it will run until 7 days passed and will download all the files it could during the time allowed. 
might be good to run plural of them, but make sure its not downloading the sames files in the same time . maybe split the ids files. 

suppr.py : suppress empty folders in the workspace, if needed 