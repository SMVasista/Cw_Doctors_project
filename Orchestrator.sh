#! /bin/bash

function parsetextfile() {

	grep -v "{" $1 |  grep -v "}" | grep -vi "Google" | grep -v "=" | grep -v ";" | grep -vi "appointment" > .tmp.txt
	sed -i "s|\.|\\n|g" .tmp.txt
}

function parserawfile() {

	grep -iv "select a" $1 | grep -iv "gender" > .tmp.txt
}

function name_identifiers() {
	
	name=$(grep "MD" .tmp.txt)
	name2=$(grep "MBBS" .tmp.txt)
	name3=$(grep "FACS" .tmp.txt)
	name4=$(grep "Mr" .tmp.txt)
	name5=$(grep "Ms" .tmp.txt)
	name6=$(grep "Mrs" .tmp.txt)
	
	printf "$name\n$name2\n$name3\n$name4\n$name5\n$name" | tr -d '\t' | uniq -u
}

function specialization_identifiers() {

	id1="specialt"
	wcn_o=$(grep -i -A1 "$id1" .tmp.txt | wc -w )
	for iter in {1..20}
	do
		data=$(grep -i -A"$iter" "$id1" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id1" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id1" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	id2="interests"
	wcn_o=$(grep -i -A1 "$id2" .tmp.txt | wc -w )
	for iter in {1..20}
	do
		data1=$(grep -i -A"$iter" "$id2" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id2" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id2" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	id3="specialization"
	wcn_o=$(grep -i -A1 "$id3" .tmp.txt | wc -w )
	for iter in {1..20}
	do
		data2=$(grep -i -A"$iter" "$id3" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id3" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id3" .tmp.txt | wc -w)
		if [[ $wcn -eq $wcn_p && $wcn -gt $wcn_o ]]; then
			break
		else
			continue
		fi
	done

	id4="conditions"
	wcn_o=$(grep -i -A1 "$id4" .tmp.txt | wc -w )
	for iter in {2..20}
	do
		data3=$(grep -i -A"$iter" "$id4" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id4" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id4" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	id5="research interest"
	wcn_o=$(grep -i -A1 "$id5" .tmp.txt | wc -w )
	for iter in {2..20}
	do
		data4=$(grep -i -A"$iter" "$id5" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id5" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id5" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	id6="expertise"
	wcn_o=$(grep -i -A1 "$id6" .tmp.txt | wc -w )
	for iter in {1..20}
	do
		data5=$(grep -i -A"$iter" "$id6" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id6" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id6" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	printf "$data\n$data1\n$data2\n$data3\n$data4\n$data5" | tr -d '\t' | uniq -u
		
}

function titles_identifiers() {

	id1="title"
	for iter in {1..2}
	do
		data=$(grep -i -A"$iter" "$id1" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id1" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id1" .tmp.txt | wc -w)
		if [ $wcn -eq $wcn_p ]; then
			break
		else
			continue
		fi
	done

	id2="professor"
	for iter in {1..2}
	do
		data1=$(grep -i -A"$iter" "$id2" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id2" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id2" .tmp.txt | wc -w)
		if [ $wcn -eq $wcn_p ]; then
			break
		else
			continue
		fi
	done
	echo $data $data1 | tr -d "\t" | uniq -u

}

function qualification_identifiers() {

	id1="internship"
	wcn_o=$(grep -i -A1 "$id1" .tmp.txt | wc -w )
	for iter in {1..20}
	do
		data=$(grep -i -A"$iter" "$id1" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id1" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id1" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	id2="medical degree"
	wcn_o=$(grep -i -A1 "$id2" .tmp.txt | wc -w )
	for iter in {1..20}
	do
		data1=$(grep -i -A"$iter" "$id2" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id2" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id2" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	id3="residenc"
	wcn_o=$(grep -i -A1 "$id3" .tmp.txt | wc -w )
	for iter in {1..20}
	do
		data2=$(grep -i -A"$iter" "$id3" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id3" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id3" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	id4="fellowship"
	wcn_o=$(grep -i -A1 "$id4" .tmp.txt | wc -w )
	for iter in {1..20}
	do
		data3=$(grep -i -A"$iter" "$id4" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id4" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id4" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done
	
	printf "$data $data1 $data2 $data3 $data4" | tr -d "\t" | uniq -u
}

function certification_identifiers() {

	id1="certification"
	wcn_o=$(grep -i -A1 "$id1" .tmp.txt | wc -w )
	for iter in {1..20}
	do
		data2=$(grep -i -A"$iter" "$id1" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id1" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id1" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done
	
	printf "$data2" | tr -d '\t' | uniq -u

}

function affiliation_identifiers() {

	id1="honorary member"
	wcn_o=$(grep -i -A1 "$id2" .tmp.txt | wc -w )
	for iter in {1..20}
	do
		data=$(grep -i -A"$iter" "$id1" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id1" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id1" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	id2="affiliat"
	wcn_o=$(grep -i -A1 "$id2" .tmp.txt | wc -w )
	for iter in {1..20}
	do
		data2=$(grep -i -A"$iter" "$id2" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id2" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id2" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	
	
	printf "$data\n$data2" | tr -d '\t' | uniq -u

}

function access_details() {

	if [ $1 == "phone" ];then
		id1="phone"
		wcn_o=$(grep -i -A1 "$id1" .tmp.txt | wc -w )
		for iter in {1..20}
		do
			data=$(grep -i -A"$iter" "$id1" .tmp.txt)
			wcn=$(grep -i -A"$iter" "$id1" .tmp.txt | wc -w)
			wcn_p=$(grep -i -A"$(($iter-1))" "$id1" .tmp.txt | wc -w)
			if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
				break
			else
				continue
			fi
		done
	
		printf "$data" | tr -d '\t' | uniq -u

		id2="call"
		wcn_o=$(grep -i -A1 "$id2" .tmp.txt | wc -w )
		for iter in {1..6}
		do
			data2=$(grep -i -A"$iter" "$id2" .tmp.txt)
			wcn=$(grep -i -A"$iter" "$id2" .tmp.txt | wc -w)
			wcn_p=$(grep -i -A"$(($iter-1))" "$id2" .tmp.txt | wc -w)
			if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
				break
			else
				continue
			fi
		done
	
		printf "$data2" | tr -d '\t' | uniq -u

		id3="clinic line"
		wcn_o=$(grep -i -A1 "$id3" .tmp.txt | wc -w )
		for iter in {1..6}
		do
			data3=$(grep -i -A"$iter" "$id3" .tmp.txt)
			wcn=$(grep -i -A"$iter" "$id3" .tmp.txt | wc -w)
			wcn_p=$(grep -i -A"$(($iter-1))" "$id3" .tmp.txt | wc -w)
			if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
				break
			else
				continue
			fi
		done
	
		printf "$data3" | tr -d '\t' | uniq -u

	else
		if [ $1 == "fax" ];then
			id1="fax"
			wcn_o=$(grep -i -A1 "$id1" .tmp.txt | wc -w )
			for iter in {1..6}
			do
				data=$(grep -i -A"$iter" "$id1" .tmp.txt)
				wcn=$(grep -i -A"$iter" "$id1" .tmp.txt | wc -w)
				wcn_p=$(grep -i -A"$(($iter-1))" "$id1" .tmp.txt | wc -w)
				if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
					break
				else
					continue
				fi
			done
	
			printf "$data" | tr -d '\t' | uniq -u
		else
			if [ $1 == "virtual" ];then
				id1="website"
				wcn_o=$(grep -i -A1 "$id1" .tmp.txt | wc -w )
				for iter in {1..6}
				do
					data=$(grep -i -A"$iter" "$id1" .tmp.txt)
					wcn=$(grep -i -A"$iter" "$id1" .tmp.txt | wc -w)
					wcn_p=$(grep -i -A"$(($iter-1))" "$id1" .tmp.txt | wc -w)
					if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
						break
					else

						continue
					fi
				done
		
				printf "$data" | tr -d '\t' | uniq -u
				
				id2="mail"
				wcn_o=$(grep -i -A1 "$id2" .tmp.txt | wc -w )
				for iter in {1..6}
				do
					data=$(grep -i -A"$iter" "$id2" .tmp.txt)
					wcn=$(grep -i -A"$iter" "$id2" .tmp.txt | wc -w)
					wcn_p=$(grep -i -A"$(($iter-1))" "$id2" .tmp.txt | wc -w)
					if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
						break
					else
						continue
					fi
				done
				
				printf "$data" | tr -d '\t' | uniq -u				

			else

				echo "Invalid option selected : Choose [phone] [fax] [virtual] [onsite] only"		
			fi
		fi
	fi

}

function onsite_access() {
	id1="address"
	wcn_o=$(grep -i -A1 "$id1" .tmp.txt | wc -w )
	for iter in {1..6}
	do
		data=$(grep -i -A"$iter" "$id1" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id1" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id1" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done
	id2="location"
	wcn_o=$(grep -i -A1 "$id2" .tmp.txt | wc -w )
	for iter in {1..6}
	do
		data2=$(grep -i -A"$iter" "$id2" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id2" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id2" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done
	id3="patients at"
	wcn_o=$(grep -i -A1 "$id3" .tmp.txt | wc -w )
	for iter in {1..6}
	do
		data3=$(grep -i -A"$iter" "$id3" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id3" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id3" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	if [ $1 == "c" ];then
		crumb1="street"
		wcn_o=$(grep -i -C1 "$crumb1" .tmp.txt | wc -w )
		crumb1data=$(grep -i -C10 "$crumb1" .tmp.txt)

		crumb2="driving"
		wcn_o=$(grep -i -C1 "$crumb2" .tmp.txt | wc -w )
		crumb2data=$(grep -i -C10 "$crumb2" .tmp.txt)
		
		printf "$crumb1data\n$crumb2data" | tr -d '\t' | uniq -u
	else
		printf "$data\n$data2\n$data3" | tr -d '\t' | uniq -u

	fi
}

function list_publications_doctorspage() {

	id1="publication"
	wcn_o=$(grep -i -A1 "$id1" .tmp.txt | wc -w )
	for iter in {1..40}
	do
		data=$(grep -i -A"$iter" "$id1" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id1" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id1" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	id2="RSS Feed"
	wcn_o=$(grep -i -A1 "$id1" .tmp.txt | wc -w )
	for iter in {1..40}
	do
		data2=$(grep -i -A"$iter" "$id2" .tmp.txt)
		wcn=$(grep -i -A"$iter" "$id2" .tmp.txt | wc -w)
		wcn_p=$(grep -i -A"$(($iter-1))" "$id2" .tmp.txt | wc -w)
		if [[ "$wcn" -eq "$wcn_p" && "$wcn" -gt "$wcn_o" ]]; then
			break
		else
			continue
		fi
	done

	printf "$data\n$data2" | tr -d '\t' | uniq -u
}

function list_publications_pubmed() {

#	if [ $1 == "iv" ];then

		author=$(zenity --entry --text="Enter Doctor's Name First_Last format" --title="DoctorScrape")
		m_author="$(echo $author | sed "s|\_|\+|g")"
		wget -O .tmp_pmidlist.txt "https://www.ncbi.nlm.nih.gov/pubmed/?term=$m_author[Author]"
		python /home/sumanth/PYTHON/cw_doctors_project/GetDoctorsData.py .tmp_pmidlist.txt loc > .tmp_text.txt
		sed -i "s|Similar articles|\n\n|g" .tmp_text.txt
		grep -i "PMID" .tmp_text.txt
		rm .tmp_pmidlist.txt .tmp_text.txt

}
		
