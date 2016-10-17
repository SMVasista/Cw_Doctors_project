#! /bin/bash

function dt () {
	date +'%b_%d_%Y_%H_%M_%S'
}

function DocScr() {

	zenity --info --text="Welcome to DocScr Beta. Please press OK and enter details to proceed" --title="DocScr Beta"
	usname=$(zenity --entry --text="Please enter your username for logging" title="DocScr Beta")

	mkdir Doctors_Data_Results
	mkdir Literature_Data_Results

	echo "Created Results Folder Doctors_Data_Results Literature_Data_Results in `pwd`"
	echo "User " $usname >> /APF/Sumanth/DocScr/DocScrlog/.log
	echo "Created Results Folder Doctors_Data_Results Literature_Data_Results in `pwd`at time `dt`" >> /APF/Sumanth/DocScr/DocScrlog/.log

	selecttask=$(zenity --list --column="Select your task" "RUN-SINGLE-QUERIES" "RUN-BATCHMODE" "PUB-SCRAPE" "COMMANDS-HELP" --title="DocScr Beta")

	if [ $selecttask == "RUN-SINGLE-QUERIES" ];then
		echo "$usname selected $selecttask at time `dt`" >> /APF/Sumanth/DocScr/DocScrlog/.log
		cp /APF/Sumanth/DocScr/.modules.sh .
		cp /APF/Sumanth/DocScr/.GDD.py .
		cp /APF/Sumanth/DocScr/lqlist .
		source .modules.sh
		echo "DocScr Initialized Please start process from File or Wlink"
	
	else
		if [ $selecttask == "RUN-BATCHMODE" ]; then
		echo "$usname selected $selecttask at time `dt`" >> /APF/Sumanth/DocScr/DocScrlog/.log
		cp /APF/Sumanth/DocScr/.modules.sh .
		cp /APF/Sumanth/DocScr/.GDD.py .
		cp /APF/Sumanth/DocScr/lqlist .
		source .modules.sh
		echo "DocScr Beta Initialized"

		batch_directory=$(zenity --entry --text="Please enter the batch raw files location" title="DocScr Beta")
		find $batch_directory | grep -vw "$batch_directory"$ > workinglist
		echo "$usname entered $batch_directory at time `dt` for processing $selecttask" >> /APF/Sumanth/DocScr/DocScrlog/.log

		while IFS='' read -r line || [[ -n "$line" ]]; do
			process loc "$line"
			name=$(name_identifiers | tr -d '\t' | sed '/ ^$/d' | sed '/^$/d')
			title=$(titles_identifiers | tr -d '\t' | sed '/ ^$/d' | sed '/^$/d')
			qualification=$(qualification_identifiers | tr -d '\t' | sed '/ ^$/d' | sed '/^$/d')
			specialt=$(specialization_identifiers | tr -d '\t' | sed '/ ^$/d' | sed '/^$/d')
			certif=$(certification_identifiers | tr -d '\t' | sed '/ ^$/d' | sed '/^$/d')
			affiliation=$(affiliation_identifiers | tr -d '\t' | sed '/ ^$/d' | sed '/^$/d')
			relevence=$(cwrelevence | tr -d '\t' | sed '/ ^$/d' | sed '/^$/d')
			phone=$(access_details phone | tr -d '\t' | sed '/ ^$/d' | sed '/^$/d')
			fax=$(access_details fax | tr -d '\t' | sed '/ ^$/d' | sed '/^$/d')
			address=$(onsite_access c | tr -d '\t' | sed '/ ^$/d' | sed '/^$/d')
			address_alternate=$(onsite_access r | tr -d '\t' |sed '/ ^$/d' | sed '/^$/d')
			
			filename=$(echo "$line" | sed "s|$batch_directory||g")

			printf "NAME(s)_IDENTIFIED\t\"$name\"" > Doctors_Data_Results/$filename.csv
			printf "\n" >> Doctors_Data_Results/$filename.csv
			printf "ACADEMIC/PROFESSIONAL TITLES\t\"$title\""  >> Doctors_Data_Results/$filename.csv
			printf "\n" >> Doctors_Data_Results/$filename.csv
			printf "ACADEMIC QUALIFICATIONS\t\"$qualification\"" >> Doctors_Data_Results/$filename.csv
			printf "\n" >> Doctors_Data_Results/$filename.csv
			printf "SPECIALISATION & RESEARCH INTERESTS\t\"$specialt\"" >> Doctors_Data_Results/$filename.csv
			printf "\n" >> Doctors_Data_Results/$filename.csv
			printf "BOARD CERIFICATIONS\t\"$certif\"" >> Doctors_Data_Results/$filename.csv
			printf "\n" >> Doctors_Data_Results/$filename.csv
			printf "RELEVENCE TO CWO\t\"$relevence\"" >> Doctors_Data_Results/$filename.csv
			printf "\n" >> Doctors_Data_Results/$filename.csv
			printf "CONTACT_DETAILS PHONE\t\"$phone\"" >> Doctors_Data_Results/$filename.csv
			printf "\n" >> Doctors_Data_Results/$filename.csv
			printf "CONTACT_DETAILS FAX\t\"$fax\"" >> Doctors_Data_Results/$filename.csv
			printf "\n" >> Doctors_Data_Results/$filename.csv
			printf "CONTACT_DETAILS ADDRESS\t\"$address\"" >> Doctors_Data_Results/$filename.csv
			printf "\"$address_alternate\"\n" >> Doctors_Data_Results/$filename.csv
			printf "_____________________END_OF_FILE__________________________\n\n\n" >> Doctors_Data_Results/$filename.csv

			echo "Finished processing file : $line"
			echo "Finished processing file : $line at time `dt`" >> /APF/Sumanth/DocScr/DocScrlog/.log
			
		done < workinglist

		ls $batch_directory | sed "s|\-|\_|g" | sed "s|_md$||g" > Doctors_Data_Results/Doctors_List_batch_`dt`
		zenity --text-info --filename="Doctors_Data_Results/Doctors_List_batch_`dt`" --title="Doctors List Scraped in Batch"
		zenity --info --text="Process Completed. Data stored in Report" --title="DocScr Beta"
		else
			if [ $selecttask == "PUB-SCRAPE" ]; then
				echo "Pub-Scrape function selected"
				cp /APF/Sumanth/DocScr/.modules.sh .
				cp /APF/Sumanth/DocScr/.GDD.py .
				cp /APF/Sumanth/DocScr/lqlist .
				cp /APF/Sumanth/DocScr/nqlist .
				source .modules.sh
				doc_list=$(zenity --entry --text="Please enter the list of query-names" title="DocScr Beta")
				while IFS='' read -r line || [[ -n "$line" ]]; do
					query=$(echo "$line" | sed "s|\_|\+|g")
					pubmedresults=$(list_publications_pubmed $query)
					ashresults=$(list_publications_ash $query)
					nocresults=$(list_publications_noc $query)
					biomedresults=$(list_publications_biomed $query)
					ctresults=$(list_publications_ct $query)

					printf "RESULTS FETCHED FOR\t\"$line\"" > Literature_Data_Results/$line.csv
					printf "\n\n" >> Literature_Data_Results/$line.csv
					printf "PUBMED-NIM TOP RESULTS\t\"$pubmedresults\"" >> Literature_Data_Results/$line.csv
					printf "\n" >> Literature_Data_Results/$line.csv
					printf "ASH PUBLICATIONS\t\"$ashresults\"" >> Literature_Data_Results/$line.csv
					printf "\n" >> Literature_Data_Results/$line.csv
					printf "JOURNAL OF NEUROONCOLOGY\t\"$nocresults\"" >> Literature_Data_Results/$line.csv
					printf "\n" >> Literature_Data_Results/$line.csv
					printf "BIOMEDCENTRAL BREAST CANCER RESEARCH\t\"$biomedresults\"" >> Literature_Data_Results/$line.csv
					printf "\n" >> Literature_Data_Results/$line.csv
					printf "TOP CLINICAL TRIAL LISTED UNDER US Gov\t\"$ctresults\"" >> Literature_Data_Results/$line.csv
					printf "\n\n" >> Literature_Data_Results/$line.csv

					score=$(index_doctor Literature_Data_Results/$line.csv lqlist nqlist)
					printf "RELEVENCE INDEX\t\"$score\"" >> Literature_Data_Results/$line.csv
					printf "_____________________END_OF_FILE__________________________\n\n\n" >> Literature_Data_Results/$filename.csv

					echo "Finished processing query : $line"
					echo "Finished processing query : $line at time `dt`" >> /APF/Sumanth/DocScr/DocScrlog/.log
				done < $doc_list
				zenity --info --text="Process Completed. Data stored in Report" --title="DocScr Beta"
			else
				if [ $selecttask == "COMMANDS-HELP" ]; then
					echo "$usname selected COMMAND-HELP module from DocScr at time `dt`" >> /APF/Sumanth/DocScr/DocScrlog/.log
					zenity --text-info --filename="/APF/Sumanth/DocScr/commands.txt" --title="DocScr Beta"
					rm -rf Doctors_Data_Results/ Literature_Data_Results/
					echo "Closing current job invocation. Please enter DocScr to reinitiate"

				else
					echo "Improper selection"
				fi
			fi
		fi

	fi

}

function list_pharam_research() {
				echo "Collecting Pharma's Interests"
				cp /APF/Sumanth/DocScr/.modules.sh .
				cp /APF/Sumanth/DocScr/.GDD.py .
				cp /APF/Sumanth/DocScr/lqlist .
				cp /APF/Sumanth/DocScr/nqlist .
				source .modules.sh
				pharma_list=$(zenity --entry --text="Please enter the list of pharma-query-names" title="DocScr Beta")
				while IFS='' read -r line || [[ -n "$line" ]]; do
					query=$(echo "$line" | sed "s|\_|\+|g")
					ctresults=$(list_publications_ctpharma $query)

					printf "RESULTS FETCHED FOR\t\"$line\"" > $line.csv
					printf "\"$ctresults\"" >> $line.csv
					printf "\n\n" >> $line.csv
					printf "_____________________END_OF_FILE__________________________\n\n\n" >> $line.csv

					echo "Finished processing query : $line"
					echo "Finished processing query : $line at time `dt`" >> /APF/Sumanth/DocScr/DocScrlog/.log
				done < $pharma_list

function DSAnalytix() {

	zenity --info --text="Welcome to DSAnalytix Beta. Please press OK and enter details to proceed" --title="DSAnalytix Beta"
	usname=$(zenity --entry --text="Please enter your username for logging" title="DSAnalytix Beta")
	mkdir Analytix_Data_Results
	echo "$usname Created Results Folder Analytix_Data_Results in `pwd`at time `dt`" >> /APF/Sumanth/DocScr/DocScrlog/.log
	data_resv=$(zenity --entry --text="Please enter parsed data location for DSAnalytix" title="DSAnalytix Beta")
	echo "$usname set data reservoir for analytics as $data_resv at time `dt`" >> /APF/Sumanth/DocScr/DocScrlog/.log
	


}



}

function iwantout() {
	mv Doctors_Data_Results Doctors_Data_Results_"$usname"_`dt` && cp -r Doctors_Data_Results_"$usname"_`dt` /APF/Sumanth/DocScr/backup_profiles/

	mv Literature_Data_Results Literature_Data_Results_"$usname"_`dt` && cp -r Literature_Data_Results_"$usname"_`dt` /APF/Sumanth/DocScr/backup_literature/

	echo "Copied backup of your projects"

	echo "Clearing pwd area"
	rm -rf *
	echo "Now exiting in 3 sec..."
	sleep 3
	exit
}
		
