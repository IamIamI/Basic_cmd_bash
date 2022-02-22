#$ -S /bin/bash #defines bash as the shell for execution
#$ -N PlayScript #Name of the command that will be listed in the queue
#$ -cwd #change to current directory
#$ -j Y
#$ -q archgen.q #queue
#$ -l h_vmem=8G #request 4Gb of memory
#$ -pe smp 1 #needs 36 cores
#$ -V # load personal profile
#$ -o /mnt/scratch/basic_linux/105_qsubmissions/your_username/STDout.txt
