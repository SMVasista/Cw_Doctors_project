#! /bin/bash


function process() {
	
	echo -e "\e[34m"

	if [ $1 == "loc" ];then

		python ./.GDD.py $2 loc > .parseddata
	else
		if [ $1 == "wlink" ]; then
			
			python ./.GDD.py $2 web > .parseddata
		else
			echo "please select option 'loc' offline files parsing; 'wlink' for weblinks"

		fi

	fi

	echo "Processing File..."
	grep -v "{" .parseddata |  grep -v "}" | grep -vi "Google" | grep -v "=" | grep -v ";" | grep -vi "appointment" | grep -vi "Terms and Conditions" | grep -vi "you are here" | grep -vi "About us" | grep -vi "sitemap" | grep -vi "advertisement" | grep -v "Contact Us" | grep -vi "Search" | grep -iv "gender" | grep -v "Visitor Guide" | grep -iv "gift" | grep -iv "payment" | grep -iv "profile" | grep -iv "sign in" | grep -vi "news" | grep -vi "history" | grep -v "Careers" | grep -vi "events" | grep -vi "blog" | sed "s|  | |g" | sed "s|\.|\\n|g"  > .tmp.txt
	sed -i "s|Find\ a\ Doctor||g" .tmp.txt
	sed -i "s|Referring\ Physicians||g" .tmp.txt
	sed -i "s|Privacy\ Policy||g" .tmp.txt

}

function parserawfile() {

	grep -iv "select a" $1 | grep -iv "gender" > .tmp.txt
}

function name_identifiers() {
	
	name=$(grep "MD" .tmp.txt)
	name2=$(grep "MBBS" .tmp.txt)
	name3=$(grep "FACS" .tmp.txt)
	name4=$(grep "FACC" .tmp.txt)
	
	printf "$name\n$name2\n$name3\n$name4\n" | tr -d '\t' | uniq -u
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

	printf "$data\n$data1\n$data2\n$data3\n$data4\n$data5\n" | tr -d '\t' | uniq -u
		
}

function titles_identifiers() {

	if [ `echo $now_name | wc -w` -gt 0 ];then
		if [ `grep -i "associate professor" .tmp.txt | wc -w` -gt 0 ];then
			echo "Associate Professor"
		else
			if [ `grep -i "professor" .tmp.txt | wc -w` -gt 0 ];then
				echo "Professor"
			else
				if [ `grep -i "chief" .tmp.txt | wc -w` -gt 0 ];then
					echo "chief"
				else
					if [ `grep -i "department" .tmp.txt | grep -i "head" | wc -w` -gt 0 ];then
						echo "Head of Department"
					else
						echo "Ambiguous | Doctor/Physician"
					fi
				fi
			fi
		fi			
			
			
	else
		echo "Doctor"
	fi

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
	
	printf "$data\n$data1\n$data2\n$data3\n$data4\n" | tr -d "\t" | uniq -u
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

	id1="member of"
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

	id2="affiliati"
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

	
	
	printf "$data\n$data2\n" | tr -d '\t' | uniq -u

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
	
		printf "$data\n" | tr -d '\t' | uniq -u

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
	
		printf "$data2\n" | tr -d '\t' | uniq -u

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
	
		printf "$data3\n" | tr -d '\t' | uniq -u

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
		printf "$data\n$data2\n$data3\n" | tr -d '\t' | uniq -u

	fi
}

function list_publications_pubmed_standalone() {


		author=$(zenity --entry --text="Enter Doctor's Name First_Last format" --title="DoctorScrape")
		m_author="$(echo $author | sed "s|\_|\+|g")"
		wget -O .tmp_pmidlist.txt -q "https://www.ncbi.nlm.nih.gov/pubmed/?term=$m_author[Author - Full]&retmax=1000"
		python .GDD.py .tmp_pmidlist.txt loc > .tmp_text.txt
		sed -i "s|Similar articles|\\n\\n\\n\\n|g" .tmp_text.txt
		grep -i "PMID" .tmp_text.txt
		rm .tmp_pmidlist.txt .tmp_text.txt


}

function list_publications_pubmed() {


		wget -O .tmp_pmidlist.txt -q "https://www.ncbi.nlm.nih.gov/pubmed/?term=$1[Author%20-%20Full]&retmax=1000"
		python .GDD.py .tmp_pmidlist.txt loc > .tmp_text.txt
		sed -i "s|Similar articles|\\n\\n\\n\\n|g" .tmp_text.txt
		grep -i "PMID" .tmp_text.txt


}

function list_publications_ct_standalone() {


		author=$(zenity --entry --text="Enter Doctor's Name First_Last format" --title="DoctorScrape")
		m_author="$(echo $author | sed "s|\_|\+|g")"
		touch .tmp_pmidlist.txt
		touch .report.txt	
		for iter in {1..2}
		do
			wget -O .tmp_pmidlist_$iter.txt -q "https://clinicaltrials.gov/ct2/results?term=$m_author&pg=$iter"
			cat .tmp_pmidlist_$iter.txt >> .tmp_pmidlist.txt
			rm .tmp_pmidlist_$iter.txt
		done
		python .GDD.py .tmp_pmidlist.txt loc > .tmp_text.txt
		awk /"Recruiting"/ RS="\n\n\n\n" ORS="\n\n\n\n" .tmp_text.txt >> .report.txt 
		awk /"Completed"/ RS="\n\n\n\n" ORS="\n\n\n\n" .tmp_text.txt >> .report.txt
		cat .report.txt | tr -s '\n'
		rm .tmp_pmidlist.txt .tmp_text.txt .report.txt


}

function list_publications_ct() {

		touch .tmp_pmidlist.txt
		touch .report.txt	
		for iter in {1..2}
		do
			wget -O .tmp_pmidlist_$iter.txt -q "https://clinicaltrials.gov/ct2/results?term=$1&pg=$iter"
			cat .tmp_pmidlist_$iter.txt >> .tmp_pmidlist.txt
			rm .tmp_pmidlist_$iter.txt
		done
		python .GDD.py .tmp_pmidlist.txt loc > .tmp_text.txt
		awk /"Recruiting"/ RS="\n\n\n\n" ORS="\n\n\n\n" .tmp_text.txt >> .report.txt 
		awk /"Completed"/ RS="\n\n\n\n" ORS="\n\n\n\n" .tmp_text.txt >> .report.txt
		cat .report.txt | tr -s '\n'
		rm .tmp_pmidlist.txt .report.txt

}

function list_publications_ctpharma() {

		touch .tmp_pmidlist.txt
		touch .report.txt	
		for iter in {1..6}
		do
			wget -O .tmp_pmidlist_$iter.txt -q "https://clinicaltrials.gov/ct2/results?term=&recr=&type=&rslt=&age_v=&gndr=&cond=&intr=&titles=&outc=&spons=$1&lead=&id=&state1=&cntry1=&state2=&cntry2=&state3=&cntry3=&locn=&rcv_s=&rcv_e=&lup_s=&lup_e=&pg=$iter"
			cat .tmp_pmidlist_$iter.txt >> .tmp_pmidlist.txt
			rm .tmp_pmidlist_$iter.txt
		done
		python .GDD.py .tmp_pmidlist.txt loc > .tmp_text.txt
		awk /"Recruiting"/ RS="\n\n\n\n" ORS="\n\n\n\n" .tmp_text.txt >> .report.txt 
		awk /"Completed"/ RS="\n\n\n\n" ORS="\n\n\n\n" .tmp_text.txt >> .report.txt
		cat .report.txt | tr -s '\n'
		rm .tmp_pmidlist.txt .report.txt

}


function index_doctor() {

	relev_score=0
	n_relev_score=0

	while IFS='' read -r line || [[ -n "$line" ]]; do
		score=$(grep -iwc "$line" $1)
		relev_score=$(($score + $relev_score))
	done < $2

	while IFS='' read -r line || [[ -n "$line" ]]; do
		n_score=$(grep -iwc "$line" $1)
		n_relev_score=$(($n_score + $n_relev_score))
	done < $3


	index=$(($relev_score - $n_relev_score))
	echo "Relevence Index : $index"
	
	

}

#Other Journals Parsing

function list_publications_ash() {

	input=$(echo "$1" | sed "s|\_|\%2B|g")
	wget -O .tmp_pmidlist.txt -q "http://www.bloodjournal.org/search/author1%3A$input%20numresults%3A100%20sort%3Apublication-date%20direction%3Adescending%20format_result%3Acondensed"
	python .GDD.py .tmp_pmidlist.txt loc > .tmp_text.txt
	cat .tmp_text.txt | sed "s|^Blood$|Article_published_in_Blood|g" | awk /"Article_published_in_Blood"/ RS="\n\n" ORS="\n\n"


}

function list_publications_noc() {


	wget -O .tmp_pmidlist.txt -q "http://neuro-oncology.oxfordjournals.org/search?submit=yes&submit=Search&pubdate_year=&volume=&firstpage=&doi=&author1=$1&author2=&title=&andorexacttitle=and&titleabstract=&andorexacttitleabs=and&fulltext=&andorexactfulltext=and&journalcode=neuonc|nop&fmonth=&fyear=&tmonth=&tyear=&flag=&format=standard&hits=125&sortspec=date&submit=yes"
	python .GDD.py .tmp_pmidlist.txt loc > .tmp_text.txt
	searchterm=$(echo "$1" | sed "s|\+| |g")
	cat .tmp_text.txt | awk /"$searchterm"/ RS="\n\n" ORS="\n\n"

}

function list_publications_biomed() {


	wget -O .tmp_pmidlist.txt -q "https://breast-cancer-research.biomedcentral.com/articles?query=$1&volume=&searchType=&tab=keyword"
	python .GDD.py .tmp_pmidlist.txt loc > .tmp_text.txt
	cat .tmp_text.txt | awk /"Research article"/ RS="\n\n\n\n" ORS="\n\n\n\n" | tr -s '\n'

}


function cwrelevence() {

	if [ `grep -ci "oncology" .tmp.txt` -gt 0 ];then
		echo "Yes"
	else
		echo "No"
	fi 
}
		

function clearexit() {

	rm .parseddata
	rm .tmp.txt
	echo " Files location Cleared for exit"
	echo -e "\e[0m"

}


function get_relevence () {

location=$(zenity --entry --text="Enter Location of .csv files" --title="DoctorScrape")
cd $location
ls > .list
touch "$1".txt
while IFS='' read -r line || [[ -n "$line" ]]; do

	exists=$(cat $line | grep -c "$1")
	if [ $exists -gt 0 ];then
		echo "$line" >> "$1".txt
	else
		continue
	fi
done < .list

}

function setqparam() {
	echo $1 > $2.txt
	sed -i "s|\,|\\n|g" $2.txt
}

function create1dmatrix () {

ls $1 > .baselist

while IFS='' read -r line || [[ -n "$line" ]]; do
	name=$(echo "$line" | sed "s|\.csv||g")
	python .analytix.py 2d $1/$line $2 .baselist .baselist >> $name.csv

done < .baselist
rm .baselist
}

function create2dmatrix () {

ls $1 > .baselist

while IFS='' read -r line || [[ -n "$line" ]]; do
	name=$(echo "$line" | sed "s|\.csv||g")
	python .analytix.py 2d $1/$line $2 $3 .baselist >> $name.csv

done < .baselist
rm .baselist
}	

function create3dmatrix () {

ls $1 > .baselist

while IFS='' read -r line || [[ -n "$line" ]]; do
	name=$(echo "$line" | sed "s|\.csv||g")
	python .analytix.py 3d $1/$line $2 $3 $4 >> $name.csv

done < .baselist
rm .baselist
}
