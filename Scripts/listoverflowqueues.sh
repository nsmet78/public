#!/bin/bash
#
###################################################################
#
#                         List Overflow Queues
#
# This script checks whether there are queues with too many jobs waiting
#
###################################################################
#
# Author  : Nicolas SMET (MAPPING SUITE SAS)
# Creation date : 30/01/2019
# Update date : 19/05/2020
#
# Prerequisites : map_daemon must be alive
#
# Environment variables : MAPPING_PATH   (with the full path of mapping.conf file)
#
# Use option --help to show usage 
#
# This script is not under maintenance and can be customized as needed.
#
###################################################################

version="1.1"

#############
# Fonctions #
#############

function process_queue
{
  if [ "$nbjob" -gt "$nb_job_max" ]
  then
    # A overflow queue was found
    nb_queue_found=`expr $nb_queue_found + 1`
    result_list="${result_list}${queue_name}\t${nbjob}\n"
  fi
}


###################################
###################################
## MAIN MAIN MAIN MAIN MAIN MAIN ##
###################################
###################################


set -e

IFS="
"

declare PATH_BIN=/apps/mapping/bin
declare -i nb_job_max=100
declare outfile=""
declare show_header="yes"
declare queue_name_to_check=""
declare hide_list="no"
declare result_list=""
declare -i nb_queue_found=0


###############################
# Check if MAPPING_PATH is set
###############################

if [ ! -n "$MAPPING_PATH" ]
then
  echo "Please export MAPPING_PATH environment variable before to execute this script"
  echo "MAPPING_PATH must contain the mapping.conf fullpath"
  exit 1 
fi

###########
# Get args
###########

PARSED_OPTIONS=$(getopt -o l:b:o:Nq:h --long "help,version,limit:,mappingbin:,outfile:,skip-column-names,queue-name:,hide-list" -- "$@")
if [ $? -ne 0 ]
then
   exit 2
fi

eval set -- "$PARSED_OPTIONS"

while true
do
   case "$1" in
     --help)
       echo ""
       echo "This script checks whether there are queues with too many jobs waiting (overflow queues)."
       echo ""
       echo "Usage: $0 [OPTION]"
       echo ""
       echo "-l, --limit=NB_JOBS             Max limit of ready jobs in each queues (default: 100)"
       echo "-b, --mapping-binaries=PATH     Mapping binaries full path (default: /apps/mapping/bin)"
       echo "-o, --outfile=FILE              Use this option to create a file with the list of overflow queues"
       echo "                                  instead of displaying it on standard ouput."
       echo "-N, --skip-column-names         Remove the column header" 
       echo "-q, --queue-name=QUEUE          Filter : name of the queue to check."
       echo "                                  With this filter, the response is not the number of overflow queues but"
       echo "                                  If the the queue is not overflow : return 0."
       echo "                                  If the queue is overflow : return the number of ready jobs in this queue."
       echo "-h, --hide-list                 Hide the list of overflow queues to return only the number"
       echo "                                  of overflow queues found."
       echo "    --help                      This help"
       echo "    --version                   Version of this script"
       echo ""
       echo "Result:"
       echo "    The first line of the stdout always contains the number of overflow queues found."
       echo "    If the value is 0, it means that everything is fine."
       echo ""
       echo "    The queue list is available either on the continuation of the standard output,"
       echo "    or in a file specified via the --outfile option."
       echo "    Each line contains the name of the queue and the number of jobs,"
       echo "    presented in 2 columns, separated by a tabulation."
       echo "    The column headers can be removed with option -N"
       echo ""
       echo "This script can ben called by a script in crontab for all queues,"
       echo "or by a Mapping Spooler event trigger with a specific queue name."
       echo ""
       echo ""
       echo "Usage examples:"
       echo ""
       echo "      # export MAPPING_PATH=/apps/maping/conf/mapping.conf"
       echo ""
       echo "      # listoverflowqueues.sh -l 20 -b /apps/mapping/bin"
       echo "      # listoverflowqueues.sh --limit=20 --queue-name myprinter"
       echo "      # listoverflowqueues.sh -l 20 -o myfile -N" 
       echo ""
       echo ""
       echo "Response example without any option:"
       echo "This response means that there are 2 overflow queues with more than 100 ready jobs"
       echo ""
       echo "2"
       echo "Queues	Ready jobs"
       echo "------	----------"
       echo "queue1	123"
       echo "HP_PCL	154"
       echo ""
       exit 0
       ;;
     --version)
       echo Version: $version
       exit 0
       ;;
     -l|--limit)
       shift
       if [ -n "$1" ]
       then
         nb_job_max=$1
       fi
       ;;
     -b|--mapping-binaries)
       shift
       if [ -n "$1" ]
       then
         PATH_BIN="$1"
       fi
       ;;
     -o|--outfile)
       shift
       if [ -n "$1" ]
       then
         outfile="$1"
       fi
       ;;
     -N|--skip-column-names)
       show_header="no"
       ;;
     -q|--queue-name)
       shift
       queue_name_to_check=$1
       ;;
     -h|--hide-list)
       hide_list="yes"
       ;;
     --)
       shift
       break;;
  esac
  shift
done


###########################
# Response header creation
###########################

if [ "$show_header" = "yes" ]
then
  result_list="${result_list}Queues\tReady jobs\n"
  result_list="${result_list}------\t----------\n"
fi


#############################
# Search for overflow queues
#############################

nbjob=0
start=0

for LINE in `${PATH_BIN}/map_splf -lpstatq -qname:$queue_name_to_check | cut -c1-50`
do
  value=`echo $LINE | cut -d$'\t' -f2`
  # Queue or device
  if [ $value = "entry" ] || [ $value = "queue" ]
  then
    if [ "$queue_name" != "" ]
    then
       # It is not the first "queue" or "entry" line found
       # so process the previous one
       process_queue
    fi
    queue_name=`echo $LINE | cut -d$'\t' -f3`
    nbjob=0
  fi

  # Count Ready job
  if [ $value = "ready" ]
  then
    nbjob=`expr $nbjob + 1`
  fi
done

# Process the last queue if at least one overflow queue was found
if [ "$queue_name" != "" ]
then
   process_queue
fi

##########################################################
# Write the number of overflow queues found to the stdout
##########################################################

if [ "$queue_name_to_check" = "" ]
then
  echo $nb_queue_found
else
  if [ "$nbjob" -gt "$nb_job_max" ]
  then
     echo $nbjob
  else
     echo 0
  fi
fi


###########################################################
# Write list of overflow queues (to stdout or into a file)
###########################################################

if [ $nb_queue_found -gt 0 ]
then
  if [ "$outfile" = "" ]
  then
    if [ ! $hide_list = "yes" ]
    then
      echo -e "${result_list}\c"
    fi
  else
    echo -e "${result_list}\c" > $outfile
  fi
fi


