#!/bin/bash

file_to_parse=example_log.log
#file_to_parse=example_log1.log
declare counter=0
declare -A IP_ARR
declare -A counts_ip
declare -A unsw_Arr
declare -A time_Arr
declare -A bot_Arr

get_ip(){
	IP_Arr[$counter]=$1
	return 0
}

get_url(){
	URL_Arr[$counter]=$7
#	echo "Q-ty of param-s: $#"
#	echo -e "\tparam 14: ${14}\tparam 15: ${15}\tparam 16: ${16}\tparam 17: ${17}"
	return 0
}

get_html_unswer(){
	unsw_Arr[$counter]=$9
	return 0
}

get_request_time(){
#	time_Arr[$counter]=$4:1:-3
	time_Arr[$counter]=$(echo $4 | cut -c 2-18)
	return 0
}

get_bot(){
	bot_Arr[$counter]=${!#}
#	bot_Arr[$counter]=$(echo ${!#} | rev | cut -c 2 | rev)
	return 0
}

max_ip(){
	#unset array counts_ip
	for a in "${IP_Arr[@]}"
	do
	    ((counts_ip[$a]++))
	done
	for n in "${!counts_ip[@]}"
	do
	    if [ "${counts_ip[$n]}" -gt "${counts_ip[${max:=$n}]}" ]
	    then
	        max=$n
	    fi
	done
	echo -e "\tThe most friquent ip is: $max, it appeared ${counts_ip["$max"]} times"
	return 0
}

max_url(){
	unset array counts
        unset max
	declare -A counts
	for a in "${URL_Arr[@]}"
        do
            ((counts[$a]++))
        done
        for n in "${!counts[@]}"
        do
	    if [[ $n == *html* ]]
	    then 
                if [ "${counts[$n]}" -gt "${counts[${max:=$n}]}" ]
                then
                    max=$n
                fi
	    fi
        done
        echo -e "\tThe most friquently visited page is: $max,\n\t it appeared ${counts["$max"]} times"
	return 0
}

ip_requests(){
	unset array counts
	declare -A counts
	for a in "${IP_Arr[@]}"
	do
		((counts[$a]++))
	done
	for n in "${!counts[@]}"
	do
		echo -e "\tIP $n appears "${counts[$n]}" time(s)" | sort
	done
	return 0
}

non_existing_pages(){
	for i in ${!unsw_Arr[@]}
	do
#		echo -e "\tString $i "${IP_Arr[$i]}"\t "${unsw_Arr[$i]}""
		if [[ ${unsw_Arr[$i]} == "404" ]]
		then
			echo -e "\tString $i "${URL_Arr[$i]}"\t "${unsw_Arr[$i]}""
		fi
	done
	return 0
}

request_time(){
	unset max
	declare -A counts_time
#	for i in ${!time_Arr[@]}; do
#		echo "element $i is ${time_Arr[$i]}"
#	done


        for a in "${time_Arr[@]}"
        do
            ((counts_time[$a]++))
        done
        for n in "${!counts_time[@]}"
        do
            if [ "${counts_time[$n]}" -gt "${counts_time[${max:=$n}]}" ]
            then
                max=$n
            fi
        done
        echo -e "\tThe most used time is: $max, it has ${counts_time["$max"]} requests"

	return 0
}

show_bot(){
	declare -A counts_bot
	k=0
	for i in "${bot_Arr[@]}"
       	do
		((k++))
		if [[ $i =~ "bot" ]]
                then
	       		counts_bot["$i"]=$k
		fi
       	done

	for n in "${!counts_bot[@]}"
        do
		echo -e "\t$n \t has IP: ${IP_Arr[${counts_bot["$n"]}]}"
#		echo -e "\tBot: $i it appeared \t${counts_bot["$i"]}\t (times)"
#		echo -e "\tString $i "${IP_ARR[$i]}"\t "${bot_Arr[$i]}""
#            if [ "${counts_time[$n]}" -gt "${counts_time[${max:=$n}]}" ]
#            then
#                max=$n
#            fi
        done
	#test ===============
	#echo "--------------------------------------"
	#for i in "${!bot_Arr[@]}"
	#do		
	#	echo -e "\t${bot_Arr[$i]} \t ${IP_Arr[$i]}"
	#done
	#test ===============

#        for i in ${!bot_Arr[@]}
#        do
#                if [[ ${bot_Arr[$i]} =~ "bot" ]]
#                then
#                        echo -e "\tString $i "${IP_Arr[$i]}"\t "${bot_Arr[$i]}""
#                fi
#        done
        return 0
}



#---------------------------preparing----------------------------
readarray -t Arr < $file_to_parse

for i in ${!Arr[@]}; do
        counter=$i
        get_ip ${Arr[$counter]}
        get_url ${Arr[$counter]}
        get_html_unswer ${Arr[$counter]}
	get_request_time ${Arr[$counter]}
	get_bot ${Arr[$counter]}
done

#---------------------------task 1----------------------------
echo -e "B-task\n1.	From which ip were the most requests?"
max_ip

#---------------------------task 2----------------------------
echo -e "\n2.	What is the most requested page?"
max_url

#---------------------------task 3----------------------------
echo -e "\n3.	How many requests were there from each ip?"
ip_requests

#---------------------------task 4----------------------------
echo -e "\n4.	What non-existent pages were clients referred to?"
non_existing_pages

#---------------------------task 5----------------------------
echo -e "\n5.\tWhat time did site get the most requests?"
request_time

#---------------------------task 6----------------------------
echo -e "\n6.	What search bots have accessed the site? (UA + IP)"
show_bot


#for i in ${!URL_Arr[@]}; do
#       echo "element $i is ${URL_Arr[$i]}"
#done

#
