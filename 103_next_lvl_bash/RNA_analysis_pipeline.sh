# Put reference genome in ~/scratch/Reference_genome
# Now go to the folder that contains the datasets and start this script (make sure each dataset is in it's own folder, these foldernames will be used to name the trimmed read files
CURRENT_FOLDER = $(pwd)



# Install bowtie if not already there
command -v bowtie2 >/dev/null 2>&1 || { echo >&2 "I require bowtie but it's not installed. Please install first."; exit 1;}

# Install TrimGalore if not already there
command -v trim-galore-local >/dev/null 2>&1 || { echo >&2 "I require trim_galore but it's not installed. installing now.";
	mkdir -p ~/Software;
	wget https://github.com/FelixKrueger/TrimGalore/archive/0.4.5.zip -P ~/Software -q -o /dev/null &;
	wait $!;
	unzip ~/Software/0.4.5.zip -qq &;
	wait $!;
	rm *.zip;
	cd ~/Software/Trim*;
	mv trim-galore trim-galore-local
	export PATH=$PATH:$(pwd);
}

cd ~/Reference_genome/
condor_run -a request_cpus=16 "bowtie2-build *.fa* assembly_db -q --threads 16"


# Run TrimGalore for each dataset paralel
mkdir -p ~/scratch/Trimmed_reads
for f in "${CURRENT_FOLDER}*/";
do
    FOLDER_NAME=$(basename "$f")
#   echo $FOLDER_NAME
    FILE_1="${CURRENT_FOLDER}${FOLDER_NAME}/${FOLDER_NAME%/}_1.fastq.gz"
    FILE_2="${CURRENT_FOLDER}${FOLDER_NAME}/${FOLDER_NAME%/}_2.fastq.gz"
#   echo ${FOLDER_NAME}${FILE_1}
    OUTPUT_DIR="~/scratch/trimmed_reads/${FOLDER_NAME}"
#   echo $OUTPUT_DIR
    mkdir -p $OUTPUT_DIR
    condor_run -a request_cpus=16 "trim_galore_local --fastqc --illumina -q 30 --dont_gzip --max_n 1 --retain_unpaired -o $OUTPUT_DIR --suppress_warn --paired $FILE_1 $FILE_2" &
done

wait
# Throw into R
# Do Something XD

# Align read to reference genome using bowtie 
	bowtie-build all_A5/${FOLDER_NAME%/}_2nd_itt_final.final.scaffolds.fasta &
	wait $!
	condor_run -a request_cpus=16 "bowtie assembly_db -q -1 $FILE_1 -2 $FILE_2 -X 600 --fr -y -t -p 16 -S --sam-RG TAG:PAIR | samtools view -bS - > output.bam" &
	wait $!;
	condor_run -a request_cpus=16 "samtools sort output.bam output.sorted.bam" &

# samtools index aln.sorted.bam 