#!/bin/bash

#execute command:
#/home/ams/ht1/c/c.sh /home/ams/ht1/c/sync /home/ams/ht1/c/stored/sync

log_file=c_log
path_sync=$1
path_destination=$2
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
declare -A sync_folder_Arr
declare -A delete_Arr
declare files_to_copy_Arr
declare files_to_delete_Arr

log(){
	#$1 - operation (ex: copying/deleting)
	#$2 - filename
	cd $SCRIPTPATH
	date=$(date '+%Y-%m-%d %H:%M:%S')
	echo -e "$date\t$1\t\t$2\t$3" >>  $log_file
	return 0
}

stored_dir_exists(){
	### Check if directory does exists and creates it if negative ###
	if [ ! -d "$1" ] 
	then
		echo "Directory $1 DOES NOT exists. Creating new derictory" >> $log_file
		mkdir "$1"
	fi
	return 0
}

compare_directions(){
	### Creates 2 arrays - files to copy and files to delete ###
	cd $path_sync
	declare source_files_Arr=(*)
	cd $SCRIPTPATH
	echo -e "$(date '+%Y-%m-%d %H:%M:%S')\tSource files:\t\t ${source_files_Arr[@]}" >> $log_file
	
	cd $path_destination
	destination_files_Arr=(*)
	cd $SCRIPTPATH
	echo -e "$(date '+%Y-%m-%d %H:%M:%S')\tDestination files:\t ${destination_files_Arr[@]}" >> $log_file
	
	if [[ ${destination_files_Arr[@]} =~ "*" ]] 
	then
		# destination folder is empty, we need just to copy files #
		for i in "${source_files_Arr[@]}"
		do
			log "copying" $i
			cp $path_sync/$i $path_destination
		done
		return 0
	fi
	
	for i in "${source_files_Arr[@]}"
	do
		if [[ ! "${destination_files_Arr[*]}" =~ $i ]]
		# if destination folder doesn't have source folder file ==> copy it #
		then
			log "copying" $i
			cp $path_sync/$i $path_destination
		fi
	done

	for n in "${destination_files_Arr[@]}"
	do
		echo $n
		if [[ ! "${source_files_Arr[*]}" =~ $n ]]
		# if there is a file in destination folder that is absent in source folder, then delete it #
		then
			log "deleting" $n
			rm $path_destination/$n
		fi
	done
	
	return 0
}

#------------------------main--------------------------
echo -e "\nParam 1 - path to the syncing directory:\t$path_sync\nParam 2 - path to stored files\t\t\t$path_destination" >> $log_file
stored_dir_exists $path_destination
compare_directions

echo "Script c.sh ended its work, look for changes in c_log file"
#rsync -avvu --delete "$path_sync" "$path_destination" >> $log_file
#works, but only in one way (doesn't delete in destination folder)

