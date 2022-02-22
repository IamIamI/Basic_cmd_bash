#!/bin/bash

#$ -S /bin/bash #defines bash as the shell for execution
#$ -N MaltBuild #Name of the command that will be listed in the queue
#$ -cwd #change to current directory
#$ -e /home/lesley_sitter/archgen/Poop_Milk/Virus_DB/maltrun_qsub_run.err
#$ -o /home/lesley_sitter/archgen/Poop_Milk/Virus_DB/maltrun_qsub_run.out
#$ -q archgen.q #queue
#$ -l h_vmem=200G #request 4Gb of memory
#$ -pe smp 16 #needs 36 cores
#$ -V # load personal profile

module load jdk-15.0.2

echo "Malt start:" > /home/lesley_sitter/archgen/Poop_Milk/Virus_DB/malt_start_finish.txt
date +%x_%H:%M:%S >> /home/lesley_sitter/archgen/Poop_Milk/Virus_DB/malt_start_finish.txt

/mnt/archgen/projects1/users/herbig/sitter/Software/Malt/malt-run \
-J-XX:ParallelGCThreads=1 \
-J-Xmx150G \
-d /home/lesley_sitter/archgen/Poop_Milk/Virus_DB/malt_index \
-o /home/lesley_sitter/archgen/Poop_Milk/Virus_DB/Malt_output \
-id 95 \
-v false \
-t 16 \
-m BlastN \
-at SemiGlobal \
-mq 25 \
-mrf 100000 \
-i /mnt/archgen/projects1/users/herbig/sitter/poop_milk/squirrel/BTY001.A0101_leehom.fastq.fq.gz_filtered.fastq \
/mnt/archgen/projects1/users/herbig/sitter/poop_milk/squirrel/BTY001.B0101_leehom.fastq.fq.gz_filtered.fastq \
--memoryMode load &> /home/lesley_sitter/archgen/Poop_Milk/Virus_DB/malt-run_STDout.txt

echo "Malt finish:" >> /home/lesley_sitter/archgen/Poop_Milk/Virus_DB/malt_start_finish.txt
date +%x_%H:%M:%S >> /home/lesley_sitter/archgen/Poop_Milk/Virus_DB/malt_start_finish.txt
exit 0
