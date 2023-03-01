#!/bin/grep

# This script only needs one input, which is the path to the database file you want to build
# Just add it after the script like this $user: clean_reference_databases.sh path/to/reference.fasta

# Check for installed software
for f in ~/Software/*; do
	export PATH=$PATH:$f
done

for f in ~/Software/*/bin/; do
	export PATH=$PATH:$f
done


# This script needs dustmasker, this routine will check for it
command -v dustmasker >/dev/null 2>&1 || { echo >&2 "Dustmasker of the NCIB-blast+ package is not installed";
	echo "Please install it manually, or add you local instalation to your PATH"
	exit 1;
}
# This script needs malt, this routine will check for it
command -v malt-build >/dev/null 2>&1 || { echo >&2 "malt-build of the Malt software suite is not installed";
	echo "Please install it manually, or add you local instalation to your PATH"
	exit 1;
}

# Store the current path into a variable
CURRENT_DIR="$(pwd)"

# Get the command line arguments containing the reference database file in fasta
REF_DB_FILE=$(readlink -e ${@})

# Check if the file exists, 
if [ -f ${REF_DB_FILE} ]; then
	REF_DB_FILE=${REF_FOLDER##*/}
	REF_DB_FILE_NAME=${REF_FOLDER%.fasta}
	REF_FOLDER=${REF_DB_FILE%${REF_DB_FILE}}
	
	mkdir -p ${CURRENT_DIR}/${REF_DB_FILE_NAME}_Malt_DB
	
	#First softmark low complexity areas with Dustmasker
	dustmasker -in ${REF_DB_FILE} -out ${REF_DB_FILE_NAME}_Softmasked.fasta -outfmt fasta &> ${CURRENT_DIR}/Soft_Masked/${REF_DB_FILE_NAME}_dustmasker_STDout.txt
	wait
	# replace lower case letters with N's. This is recommended by Arthur Kocher, but i'm not sure if this is does what he thinks it does. 
	# N's are wildcards, so replace a specific lower case letter with a wildcard, means everything could map to it. 
	sed '/^[^>]/ s/[a-z]/N/g' ${CURRENT_DIR}/Soft_Masked/${REF_DB_FILE_NAME}_Softmasked.fasta > ${CURRENT_DIR}/Hard_Masked/${REF_DB_FILE_NAME}_Hardmasked.fasta
	wait
	malt-build
	J-Xmx1800G \
	-i ${REF_DB_FILE} \
	-s DNA \
	-a2taxonomy ~/Software/malt/acc2tax_distro/nucl_acc2tax-Jan2021.map.gz \
	-d malt_index \
	-t 1
else
	echo "The specified file does not appear to exist, please check the added path"
	exit 1;
fi
echo "Preparing the reference database"