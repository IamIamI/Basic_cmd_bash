#$ -S /bin/bash
#$ -N prepare_reads
#$ -cwd 
#$ -j y 
#$ -o /mnt/scratch/lesley_sitter/qsub_malt_STDout.txt
#$ -q archgen.q #queue
#$ -pe smp 4
#$ -l h_vmem=16G
#$ -V # load personal profile

export PATH=/mnt/archgen/users/lesley_sitter/Software/TrimGalore-0.6.6/:$PATH

count=$((SGE_TASK_ID-1))

files=(
	"/mnt/scratch/lesley_sitter/xaa"
	"/mnt/scratch/lesley_sitter/xab"
	"/mnt/scratch/lesley_sitter/xac"
	"/mnt/scratch/lesley_sitter/xad"
	"/mnt/scratch/lesley_sitter/xae"
	"/mnt/scratch/lesley_sitter/xaf"
	"/mnt/scratch/lesley_sitter/xag"
	"/mnt/scratch/lesley_sitter/xah"
	"/mnt/scratch/lesley_sitter/xai"
	"/mnt/scratch/lesley_sitter/xaj"
	"/mnt/scratch/lesley_sitter/xak"
	"/mnt/scratch/lesley_sitter/xal"
	"/mnt/scratch/lesley_sitter/xam"
	"/mnt/scratch/lesley_sitter/xan"
	"/mnt/scratch/lesley_sitter/xao"
	"/mnt/scratch/lesley_sitter/xap"
	"/mnt/scratch/lesley_sitter/xaq"
	"/mnt/scratch/lesley_sitter/xar"
	"/mnt/scratch/lesley_sitter/xas"
	"/mnt/scratch/lesley_sitter/xat"
	"/mnt/scratch/lesley_sitter/xau"
	"/mnt/scratch/lesley_sitter/xav"
	"/mnt/scratch/lesley_sitter/xaw"
	"/mnt/scratch/lesley_sitter/xax"
	"/mnt/scratch/lesley_sitter/xay"
	"/mnt/scratch/lesley_sitter/xaz"
	"/mnt/scratch/lesley_sitter/xba"
	"/mnt/scratch/lesley_sitter/xbb"
	"/mnt/scratch/lesley_sitter/xbc"
	"/mnt/scratch/lesley_sitter/xbd"
	"/mnt/scratch/lesley_sitter/xbd"
	"/mnt/scratch/lesley_sitter/xbe"
	"/mnt/scratch/lesley_sitter/xbf"
	"/mnt/scratch/lesley_sitter/xbg"
	"/mnt/scratch/lesley_sitter/xbh"
)

while read -r sample_line ; do 
	sample_name="$(cut -d ',' -f1 <<<${sample_line})" 
	sample_fastas="$(cut -d ',' -f2 <<<${sample_line})" 
	sample_fasta_dir=$(dirname "$(cut -d ' ' -f1 <<<${sample_fastas})")
#	IFS=' ' read -ra fasta_array <<< "$(cut -d ',' -f2 <<<${sample_line})"
	zcat "${sample_fasta_dir}"/*.fastq.gz | gzip -9 - > /mnt/scratch/lesley_sitter/Processed_reads/${sample_name}.fastq.gz
	wait
#	mv /mnt/scratch/lesley_sitter/Processed_reads/${sample_name}.fastq /mnt/scratch/lesley_sitter/Processed_reads/${sample_name}.fastq.gz
	trim_galore -q 30 --illumina --length 30 --no_report_file \
	--max_n 2 --j 4 -o /mnt/scratch/lesley_sitter/Processed_reads_step2/${sample_name}_adpttrim.fastq.gz \
	/mnt/scratch/lesley_sitter/Processed_reads/${sample_name}.fastq.gz
	wait
	rm /mnt/scratch/lesley_sitter/Processed_reads/${sample_name}.fastq.gz
done < ${files[$count]}
#if [ ${#fasta_array[@]} > 1 ]; then
