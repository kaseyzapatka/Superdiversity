/* Superdiveristy Project: Phase 1: Tree Diagram 
 * =======================================================
  
 * File: 2020.08.23 non-immigrants.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Tree Diagram for Phase 1 of Superdiveristy Project
 * Data: 
 
	- non-immigrant admissions (Tables 25 to 32)
		- table 28; however, 2004 and older data are not consistenly the same table 

	
 * Date Last Updated: 2020.08.23 */ 
 

* Load data: 2018: Non-immigrants 
* ===================================
import excel "$rawdir/Non-immigrants/fy2018_table28d.xlsx", clear

	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 196/215
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2018
				
	   }
	
		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia6"
		
		replace country = "China, People's Republic" if country == "China, People's Republic7,8"
		
		replace country = "Denmark" if country == "Denmark9"
		
		replace country = "France" if country == "France10"
		
		replace country = "Morocco" if country == "Morocco11"
		
		replace country = "Netherlands" if country == "Netherlands12"
		
		replace country = "New Zealand13" if country == "New Zealand13"
		
		replace country = "United Kingdom" if country == "United Kingdom14"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
		
		replace country = "East Timor" if country == "Timor-Leste"
		
		replace country = "Serbia and Montenegro" if country == "Serbia and Montenegro (former)"
	
		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2018.dta", replace
	 
	clear all 
	 
* Load data: 2017: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2017_table28d.xlsx", clear


	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
	
	   }
	   
	* drop the last rows that are notes
	drop in 196/215
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2017
				
	   }

		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia6"
		
		replace country = "China, People's Republic" if country == "China, People's Republic7,8"
		
		replace country = "Denmark" if country == "Denmark9"
		
		replace country = "France" if country == "France10"
		
		replace country = "Morocco" if country == "Morocco11"
		
		replace country = "Netherlands" if country == "Netherlands12"
		
		replace country = "New Zealand13" if country == "New Zealand13"
		
		replace country = "United Kingdom" if country == "United Kingdom14"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
		
		replace country = "East Timor" if country == "Timor-Leste"
		
		replace country = "Serbia and Montenegro" if country == "Serbia and Montenegro (former)"
		
		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2017.dta", replace
	 
	clear all 

* Load data: 2016: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2016_table28d.xls", clear


	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 196/216
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2016
				
	   }
	   
	  * file edits 
		* ------------
		replace country = "Australia" if country == "Australia6"
		
		replace country = "China, People's Republic" if country == "China, People's Republic7,8"
		
		replace country = "Denmark" if country == "Denmark9"
		
		replace country = "France" if country == "France10"
		
		replace country = "Morocco" if country == "Morocco11"
		
		replace country = "Netherlands" if country == "Netherlands12"
		
		replace country = "New Zealand13" if country == "New Zealand13"
		
		replace country = "United Kingdom" if country == "United Kingdom14"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
		
		replace country = "East Timor" if country == "Timor-Leste"
		
		replace country = "Serbia and Montenegro" if country == "Serbia and Montenegro (former)"

		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2016.dta", replace
	 
	clear all 
	
	
* Load data: 2015: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2015_table28d.xls", clear


	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 196/220
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2015
				
	   }
		
		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia6"
		
		replace country = "China, People's Republic" if country == "China7,8"
		
		replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville)9"
		
		replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa)10"
		
		replace country = "Denmark" if country == "Denmark11"
		
		replace country = "France" if country == "France12"
		
		replace country = "Korea, North" if country == "Korea, North13"
		
		replace country = "Korea, South" if country == "Korea, South14"
		
		replace country = "Morocco" if country == "Morocco15"
		
		replace country = "Netherlands" if country == "Netherlands16"
		
		replace country = "New Zealand13" if country == "New Zealand17"
		
		replace country = "United Kingdom" if country == "United Kingdom18"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
		
		replace country = "Serbia and Montenegro" if country == "Serbia and Montenegro (former)"

		
		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2015.dta", replace
	 
	clear all 
	
* Load data: 2014: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2014_table28d.xls", clear


	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 196/221
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2014
				
	   }

		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia6"
		
		replace country = "Canada" if country == "Canada7"
		
		replace country = "China, People's Republic" if country == "China8,9"
		
		replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville)10"
		
		replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa)11"
		
		replace country = "Denmark" if country == "Denmark12"
		
		replace country = "France" if country == "France13"
		
		replace country = "Korea, North" if country == "Korea, North14"
		
		replace country = "Korea, South" if country == "Korea, South15"
		
		replace country = "Morocco" if country == "Morocco16"
		
		replace country = "Netherlands" if country == "Netherlands17"
		
		replace country = "New Zealand13" if country == "New Zealand18"
		
		replace country = "United Kingdom" if country == "United Kingdom19"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"

		
		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2014.dta", replace
	 
	clear all 
	
* Load data: 2013: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2013_table28d.xls", clear

	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"

				
	   }
	   
	* drop the last rows that are notes
	drop in 194/258
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2013
				
	   }

		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia6"
		
		replace country = "Canada" if country == "Canada 7"
		
		replace country = "China, People's Republic" if country == "China 8,9"
		
		replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville) 10"
		
		replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa) 11"
		
		replace country = "Denmark" if country == "Denmark 12"
		
		replace country = "France" if country == "France 13"
		
		replace country = "Korea, North" if country == "Korea, North 14"
		
		replace country = "Korea, South" if country == "Korea, South 15"
		
		replace country = "Morocco" if country == "Morocco 16"
		
		replace country = "Netherlands" if country == "Netherlands 17"
		
		replace country = "New Zealand13" if country == "New Zealand 18"
		
		replace country = "United Kingdom" if country == "United Kingdom 19"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"

		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2013.dta", replace
	 
	clear all 

* Load data: 2012: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2012_table28d.xls", clear


	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 193/226
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2012
				
	   }

		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia6"
		
		replace country = "China, People's Republic" if country == "China 7,8"
		
		replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville) 9"
		
		replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa) 10"
		
		replace country = "Denmark" if country == "Denmark 11"
		
		replace country = "France" if country == "France 12"
		
		replace country = "Korea, North" if country == "Korea, North 13"
		
		replace country = "Korea, South" if country == "Korea, South 14"
		
		replace country = "Morocco" if country == "Morocco 15"
		
		replace country = "Netherlands" if country == "Netherlands 16"
		
		replace country = "New Zealand13" if country == "New Zealand 17"
		
		replace country = "United Kingdom" if country == "United Kingdom 18"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"

		
		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2012.dta", replace
	 
	clear all
	
* Load data: 2011: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2011_table28d.xls", clear

	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 193/256
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2011
				
	   }

		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia 7"
		
		replace country = "China, People's Republic" if country == "China 8,9"
		
		replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville) 10"
		
		replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa) 11"
		
		replace country = "Denmark" if country == "Denmark 12"
		
		replace country = "France" if country == "France 13"
		
		replace country = "Korea, North" if country == "Korea, North 14"
		
		replace country = "Korea, South" if country == "Korea, South 15"
		
		replace country = "Morocco" if country == "Morocco 16"
		
		replace country = "Netherlands" if country == "Netherlands 17"
		
		replace country = "New Zealand13" if country == "New Zealand 18"
		
		replace country = "United Kingdom" if country == "United Kingdom 19"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		
		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2011.dta", replace
		 
	clear all

* Load data: 2010: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2010_table28d.xls", clear

	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 193/219
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2010
				
	   }

		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia 7"
		
		replace country = "China, People's Republic" if country == "China 8,9"
		
		replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville)10"
		
		replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa) 11"
		
		replace country = "Denmark" if country == "Denmark 12"
		
		replace country = "France" if country == "France 13"
		
		replace country = "Korea, North" if country == "Korea, North 14"
		
		replace country = "Korea, South" if country == "Korea, South 15"
		
		replace country = "Morocco" if country == "Morocco 16"
		
		replace country = "Netherlands" if country == "Netherlands 17"
		
		replace country = "New Zealand13" if country == "New Zealand 18"
		
		replace country = "United Kingdom" if country == "United Kingdom 19"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		
		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2010.dta", replace
	
	clear all

* Load data: 2009: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2009_table28d.xls", clear


	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 193/219
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2009
				
	   }
		
		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia 6"
		
		replace country = "China, People's Republic" if country == "China 7"
		
		replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville) 8"
		
		replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa) 9"
		
		replace country = "Denmark" if country == "Denmark 10"
		
		replace country = "France" if country == "France 11"
		
		replace country = "Korea, North" if country == "Korea, North 12"
		
		replace country = "Korea, South" if country == "Korea, South 13"
		
		replace country = "Morocco" if country == "Morocco 14"
		
		replace country = "Netherlands" if country == "Netherlands 15"
		
		replace country = "New Zealand13" if country == "New Zealand 16"
		
		replace country = "United Kingdom" if country == "United Kingdom 17"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"

		
		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2009.dta", replace
		 
	clear all
		 
* Load data: 2008: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2008_table28d.xls", clear


	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 194/220
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2008
				
	   }

		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia 6"
		
		replace country = "China, People's Republic" if country == "China 7"
		
		replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville) 8"
		
		replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa) 9"
		
		replace country = "Denmark" if country == "Denmark 10"
		
		replace country = "France" if country == "France 11"
		
		replace country = "Korea, North" if country == "Korea, North 12"
		
		replace country = "Korea, South" if country == "Korea, South 13"
		
		replace country = "Morocco" if country == "Morocco 14"
		
		replace country = "Netherlands" if country == "Netherlands 15"
		
		replace country = "New Zealand13" if country == "New Zealand 16"
		
		replace country = "United Kingdom" if country == "United Kingdom 17"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"

		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2008.dta", replace
	 
	clear all
	
* Load data: 2007: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2007_table28d.xls", clear

	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
	
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
		
	   }
	   
	* drop the last rows that are notes
	drop in 194/219
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2007
				
	   }

		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia 6"
		
		replace country = "China, People's Republic" if country == "China 7"
		
		replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville) 8"
		
		replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa) 9"
		
		replace country = "Denmark" if country == "Denmark 10"
		
		replace country = "France" if country == "France 11"
		
		replace country = "Korea, North" if country == "Korea, North 12"
		
		replace country = "Korea, South" if country == "Korea, South 13"
		
		replace country = "Morocco" if country == "Morocco 14"
		
		replace country = "Netherlands" if country == "Netherlands 15"
		
		replace country = "New Zealand13" if country == "New Zealand 16"
		
		replace country = "United Kingdom" if country == "United Kingdom 17"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"

		
		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2007.dta", replace
	 
	clear all
	 
* Load data: 2006: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2006_table29d.xls", clear

	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 195/220
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2006
				
	   }
	
	
		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia 6"
		
		replace country = "China, People's Republic" if country == "China 7"
		
		replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville) 8"
		
		replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa) 9"
		
		replace country = "Denmark" if country == "Denmark 10"
		
		replace country = "France" if country == "France 11"
		
		replace country = "Korea, North" if country == "Korea, North 12"
		
		replace country = "Korea, South" if country == "Korea, South 13"
		
		replace country = "Morocco" if country == "Morocco 14"
		
		replace country = "Netherlands" if country == "Netherlands 15"
		
		replace country = "New Zealand13" if country == "New Zealand 16"
		
		replace country = "United Kingdom" if country == "United Kingdom 17"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"

		
		compress 
	
	* save file 
	save "$savedir/Non-immigrants/nonimmigrants2006.dta", replace
	 
	clear all
	 
* Load data: 2005: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2005_table29d.xls", clear

	* drop the first 16 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/16
  
		* rename each row 
		rename A country
		rename B total
		rename C tour_bus_visa
		rename D tour_bus_other
		rename E students
		rename F tempworker
		rename G diplomats
		rename H otherclasses
		rename I unknown
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 195/228
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-unknown {
		
		rename `v' `v'2005
				
	}

		* file edits 
		* ------------
		replace country = "Australia" if country == "Australia 6"
		
		replace country = "China, People's Republic" if country == "China 7"
		
		replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville) 8"
		
		replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa) 9"
		
		replace country = "Denmark" if country == "Denmark 10"
		
		replace country = "France" if country == "France 11"
		
		replace country = "Korea, North" if country == "Korea, North 12"
		
		replace country = "Korea, South" if country == "Korea, South 13"
		
		replace country = "Morocco" if country == "Morocco 14"
		
		replace country = "Netherlands" if country == "Netherlands 15"
		
		replace country = "New Zealand13" if country == "New Zealand 16"
		
		replace country = "United Kingdom" if country == "United Kingdom 17"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		
		
			compress 
	
	* save file 
		save "$savedir/Non-immigrants/nonimmigrants2005.dta", replace
	 
		clear all
		
		
	
* Load data: 2004: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2004_NIMSupTable1D.xls", clear


	* transpose datset 
	* ----------------------------------------------------------
	drop in 1/3
	
	drop B		
	
		* transpose dataset 
		sxpose, clear  
	
	drop in 2
	drop _var60-_var67
	
		* rename variables using "fast stata code.xlsx", sheetname (non-immigrants)
		* ----------------------------------------------------------
		rename _var1 country
		rename _var2 total
		rename _var3 A_1
		rename _var4 A_2
		rename _var5 A_3
		rename _var6 B_1
		rename _var7 B_2
		rename _var8 C_1
		rename _var9 C_2
		rename _var10 C_3
		rename _var11 E_1
		rename _var12 E_2
		rename _var13 F_1
		rename _var14 F_2
		rename _var15 G_1
		rename _var16 G_2
		rename _var17 G_3
		rename _var18 G_4
		rename _var19 G_5
		rename _var20 GB
		rename _var21 GT
		rename _var22 H_1B
		rename _var23 H_1B1
		rename _var24 H_1C
		rename _var25 H_2A
		rename _var26 H_2B
		rename _var27 H_3
		rename _var28 H_4
		rename _var29 I_1
		rename _var30 J_1
		rename _var31 J_2
		rename _var32 K_1
		rename _var33 K_2
		rename _var34 K_3
		rename _var35 K_4
		rename _var36 L_1
		rename _var37 L_2
		rename _var38 M_1
		rename _var39 M_2
		rename _var40 N_1_7
		rename _var41 O_1
		rename _var42 O_2
		rename _var43 O_3
		rename _var44 P_1
		rename _var45 P_2
		rename _var46 P_3
		rename _var47 P_4
		rename _var48 Q_1
		rename _var49 R_1
		rename _var50 R_2
		rename _var51 TD
		rename _var52 TN
		rename _var53 V_1
		rename _var54 V_2
		rename _var55 V_3
		rename _var56 WB
		rename _var57 WT
		rename _var58 Other
		rename _var59 Unknown
		
			drop in 1
			
	
	* run loop to filter out missing (-) and suppressed (D)
	* ------------------------------------------------------
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
		replace `v' = "0" if `v' == "X"
				
	   }
	   
	   destring, replace 
  	
	
	* collapse variables to match other data
	* ------------------------------------------------------
	
	
		* collpase GB, GT, WB, and WT into "tour_bus_visa" 
		gen tour_bus_visa =  GB + GT + WB + WT
		
			br tour_bus_visa GB GT WB WT	
			
			drop  GB GT WB WT	
			
		* collpase B-1 and B-2 into "tour_bus_other" 
		gen tour_bus_other = B_1 + B_2
		
			br  tour_bus_other B_1 B_2
			
			drop  B_1 B_2
			
		* collapse F-1 to F-3, J-1, J-2, and M-1 to M-3 admissions into "students" 
		gen students = F_1 + F_2 + J_1 + J_2 + M_1 + M_2
			
			br students F_1 F_2 J_1 J_2 M_1 M_2
			
			drop F_1 F_2 J_1 J_2 M_1 M_2
			
		* collapse E-1 to E-3, H-1B, H-1B1, H-1C, H-2A, H-2B, H-2R, H-3, H-4, I-1, L-1, 
		*		   L-2, O-1 to O-3, P-1 to P-4, Q-1, R-1, R-2, TD and TN admissions into "tempworker"
		gen tempworker = E_1 + E_2 + H_1B + H_1B1 + H_1C + H_2A + H_2B + H_3 + H_4 + I_1 + L_1 + ///
						 L_2 + O_1 + O_2 + O_3 + P_1 + P_2 + P_3 + P_4 + Q_1 + R_1 + R_2 + TD + TN 
						 
			br tempworker E_1 E_2 H_1B H_1B1 H_1C H_2A H_2B H_3 H_4 I_1 L_1 L_2 O_1 O_2 O_3 P_1 P_2 P_3 P_4 ///
				 Q_1 R_1 R_2 TD TN
				 
			drop E_1 E_2 H_1B H_1B1 H_1C H_2A H_2B H_3 H_4 I_1 L_1 L_2 O_1 O_2 O_3 P_1 P_2 P_3 P_4 ///
				 Q_1 R_1 R_2 TD TN
				 
		* collapse A-1 to A-3, G-1 to G-5, and N-1 to N-7 admissions into "diplomats"
		gen diplomats = A_1 + A_2 + A_3 + G_1 + G_2 + G_3 + G_4 + G_5 + N_1_7
		
			br diplomats A_1 A_2 A_3 G_1 G_2 G_3 G_4 G_5 N_1_7
			
			drop A_1 A_2 A_3 G_1 G_2 G_3 G_4 G_5 N_1_7
			
		* collpase C_1, C_2, C_3, K_1, K_2, K_3, K_4, V_1, V_2, and V_3 into "otherclasses"
		gen otherclasses = C_1 + C_2 + C_3 + K_1 + K_2 + K_3 + K_4 + V_1 + V_2 + V_3 + Other
		
			br otherclasses C_1 C_2 C_3 K_1 K_2 K_3 K_4 V_1 V_2 V_3 Other
			
			drop C_1 C_2 C_3 K_1 K_2 K_3 K_4 V_1 V_2 V_3 Other
		
		
			* check that all vars add too total variable
			* -----------------------------------------------------
			gen chk = Unknown + tour_bus_visa + tour_bus_other + students + tempworker + diplomats + otherclasses
								
				gen diff = total - chk
				
					fre diff 
				
				drop diff chk 
	
	* clean dataset
	* ------------------------------------------------------	

	* rename variables to match earlier data
	rename Unknown unknown
			
		* run loop to filter out missing (-) and suppressed (D)
		* -----------------------------------------------------
		foreach v of varlist total-otherclasses {
			
			replace `v' = . if `v' == 0
					
		   }
		 
		  
		* run loop to rename each variable with year suffix
		* -----------------------------------------------------
		foreach v of varlist total-otherclasses {
			
			rename `v' `v'2004
					
		 }
		   
			* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
			* -----------------------------------------------------
			drop if country == "Asia"
			drop if country == "Africa"
			drop if country == "Europe"
			drop if country == "North America"
			drop if country == "Oceania"
			drop if country == "Central America"
			drop if country == "South America"
			drop if country == "Caribbean"
			
		* sort by country to order dataset like others
		* -----------------------------------------------------
		sort country
		
			* file edits 
			* ------------
			replace country = "All other countries" if country == "All other countries 1"
			
			replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
			
			replace country = "Czech Republic" if country == "Czechia"
			
			replace country = "Cape Verde" if country == "Cabo Verde"
			
			replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
			
			replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
			
			replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville) 1"
			
			replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa) 2"
			
			replace country = "Korea, North" if country == "Korea, North 3"
			
			replace country = "Korea, South" if country == "Korea, South 4"
			
			replace country = "Korea" if country == "Korea 3"
			
			replace country = "United States" if country == "United States 5"
			
			replace country = "China, People's Republic" if country == "China"
			
			replace country = "All other countries" if country == "Other"
			
			replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
			
			replace country = "Czech Republic" if country == "Czechia"
			
			replace country = "Cape Verde" if country == "Cabo Verde"
			
			replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
			
			replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
			
			replace country = "British Virgin Islands" if country == "Virgin Islands, British"
			
			replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
			
			replace country = "East Timor" if country == "Timor-Leste"
			
			replace country = "Cote d'Ivoire" if country == "Cote dIvoire"
			
			replace country = "New Zealand13" if country == "New Zealand"
			
	
	   
		compress 
		
		order total, last
	
	* save file
	save "$savedir/Non-immigrants/nonimmigrants2004.dta", replace

		clear all
		
		
		
* Load data: 2003: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2003_NIMSupTable1D.xls", clear

	* transpose datset 
	* ----------------------------------------------------------
	drop in 1/3
	
	drop B		
	
		* transpose dataset 
		sxpose, clear  
	
	drop in 2
	drop _var60-_var67
	
		* rename variables using "fast stata code.xlsx", sheetname (non-immigrants)
		* ----------------------------------------------------------
		rename _var1 country
		rename _var2 total
		rename _var3 A_1
		rename _var4 A_2
		rename _var5 A_3
		rename _var6 B_1
		rename _var7 B_2
		rename _var8 C_1
		rename _var9 C_2
		rename _var10 C_3
		rename _var11 E_1
		rename _var12 E_2
		rename _var13 F_1
		rename _var14 F_2
		rename _var15 G_1
		rename _var16 G_2
		rename _var17 G_3
		rename _var18 G_4
		rename _var19 G_5
		rename _var20 GB
		rename _var21 GT
		rename _var22 H_1B
		rename _var23 H_1B1
		rename _var24 H_1C
		rename _var25 H_2A
		rename _var26 H_2B
		rename _var27 H_3
		rename _var28 H_4
		rename _var29 I_1
		rename _var30 J_1
		rename _var31 J_2
		rename _var32 K_1
		rename _var33 K_2
		rename _var34 K_3
		rename _var35 K_4
		rename _var36 L_1
		rename _var37 L_2
		rename _var38 M_1
		rename _var39 M_2
		rename _var40 N_1_7
		rename _var41 O_1
		rename _var42 O_2
		rename _var43 O_3
		rename _var44 P_1
		rename _var45 P_2
		rename _var46 P_3
		rename _var47 P_4
		rename _var48 Q_1
		rename _var49 R_1
		rename _var50 R_2
		rename _var51 TD
		rename _var52 TN
		rename _var53 V_1
		rename _var54 V_2
		rename _var55 V_3
		rename _var56 WB
		rename _var57 WT
		rename _var58 Other
		rename _var59 Unknown
		
			drop in 1
			
	
	* run loop to filter out missing (-) and suppressed (D)
	* ------------------------------------------------------
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
		replace `v' = "0" if `v' == "X"
				
	   }
	   
	   destring, replace 
  	
	
	* collapse variables to match other data
	* ------------------------------------------------------
	
		* collpase GB, GT, WB, and WT into "tour_bus_visa" 
		gen tour_bus_visa =  GB + GT + WB + WT
		
			br tour_bus_visa GB GT WB WT	
			
			drop  GB GT WB WT	
			
		* collpase B-1 and B-2 into "tour_bus_other" 
		gen tour_bus_other = B_1 + B_2
		
			br  tour_bus_other B_1 B_2
			
			drop  B_1 B_2
			
		* collapse F-1 to F-3, J-1, J-2, and M-1 to M-3 admissions into "students" 
		gen students = F_1 + F_2 + J_1 + J_2 + M_1 + M_2
			
			br students F_1 F_2 J_1 J_2 M_1 M_2
			
			drop F_1 F_2 J_1 J_2 M_1 M_2
			
		* collapse E-1 to E-3, H-1B, H-1B1, H-1C, H-2A, H-2B, H-2R, H-3, H-4, I-1, L-1, 
		*		   L-2, O-1 to O-3, P-1 to P-4, Q-1, R-1, R-2, TD and TN admissions into "tempworker"
		gen tempworker = E_1 + E_2 + H_1B + H_1B1 + H_1C + H_2A + H_2B + H_3 + H_4 + I_1 + L_1 + ///
						 L_2 + O_1 + O_2 + O_3 + P_1 + P_2 + P_3 + P_4 + Q_1 + R_1 + R_2 + TD + TN 
						 
			br tempworker E_1 E_2 H_1B H_1B1 H_1C H_2A H_2B H_3 H_4 I_1 L_1 L_2 O_1 O_2 O_3 P_1 P_2 P_3 P_4 ///
				 Q_1 R_1 R_2 TD TN
				 
			drop E_1 E_2 H_1B H_1B1 H_1C H_2A H_2B H_3 H_4 I_1 L_1 L_2 O_1 O_2 O_3 P_1 P_2 P_3 P_4 ///
				 Q_1 R_1 R_2 TD TN
				 
		* collapse A-1 to A-3, G-1 to G-5, and N-1 to N-7 admissions into "diplomats"
		gen diplomats = A_1 + A_2 + A_3 + G_1 + G_2 + G_3 + G_4 + G_5 + N_1_7
		
			br diplomats A_1 A_2 A_3 G_1 G_2 G_3 G_4 G_5 N_1_7
			
			drop A_1 A_2 A_3 G_1 G_2 G_3 G_4 G_5 N_1_7
			
		* collpase C_1, C_2, C_3, K_1, K_2, K_3, K_4, V_1, V_2, and V_3 into "otherclasses"
		gen otherclasses = C_1 + C_2 + C_3 + K_1 + K_2 + K_3 + K_4 + V_1 + V_2 + V_3 + Other
		
			br otherclasses C_1 C_2 C_3 K_1 K_2 K_3 K_4 V_1 V_2 V_3 Other
			
			drop C_1 C_2 C_3 K_1 K_2 K_3 K_4 V_1 V_2 V_3 Other
		
		
	
			* check that all vars add too total variable
			* -----------------------------------------------------
			gen chk = Unknown + tour_bus_visa + tour_bus_other + students + tempworker + diplomats + otherclasses
								
				gen diff = total - chk
				
					fre diff 
				
				drop diff chk 
	
	* clean dataset
	* ------------------------------------------------------	

	* rename variables to match earlier data
	rename Unknown unknown
			
		* run loop to filter out missing (-) and suppressed (D)
		* -----------------------------------------------------
		foreach v of varlist total-otherclasses {
			
			replace `v' = . if `v' == 0
					
		   }
		 
		  
		* run loop to rename each variable with year suffix
		* -----------------------------------------------------
		foreach v of varlist total-otherclasses {
			
			rename `v' `v'2003
					
		 }
		   
			* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
			* -----------------------------------------------------
			drop if country == "Asia"
			drop if country == "Africa"
			drop if country == "Europe"
			drop if country == "North America"
			drop if country == "Oceania"
			drop if country == "Central America"
			drop if country == "South America"
			drop if country == "Caribbean"
			
		* sort by country to order dataset like others
		* -----------------------------------------------------
		sort country
		
			* file edits 
			* ------------
			drop if country == "French Southern and Antarctic Lands"
			
			replace country = "All other countries" if country == "All other countries 1"
			
			replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
			
			replace country = "Czech Republic" if country == "Czechia"
			
			replace country = "Cape Verde" if country == "Cabo Verde"
			
			replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
			
			replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
			
			replace country = "Congo (Brazzaville)" if country == "Congo (Brazzaville) 1"
			
			replace country = "Congo (Kinshasa)" if country == "Congo (Kinshasa) 2"
			
			replace country = "Korea" if country == "Korea 3"
			
			replace country = "United States" if country == "United States 3"
			
			replace country = "China, People's Republic" if country == "China"
			
			replace country = "All other countries" if country == "Other"
			
			replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
			
			replace country = "Czech Republic" if country == "Czechia"
			
			replace country = "Cape Verde" if country == "Cabo Verde"
			
			replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
			
			replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
			
			replace country = "British Virgin Islands" if country == "Virgin Islands, British"
			
			replace country = "US Virgin Islands" if country == "Virgin Islands, US"
			
			replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
			
			replace country = "East Timor" if country == "Timor-Leste"
			
			replace country = "Cote d'Ivoire" if country == "Cote dIvoire"
			
			replace country = "New Zealand13" if country == "New Zealand"
			
	
		compress 
	
	* save file
	save "$savedir/Non-immigrants/nonimmigrants2003.dta", replace

		clear all
		
				
* Load data: 2002: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2002_Table607.xls", clear

	* drop the first 4 rows 
	* ----------------------
	drop in 1/4
	
	drop B D H L S X AB AE AH AK AQ AR AS AW BK CC CM CQ CT CX DC 
  
		rename A country_
		rename C total_
		rename E A1_
		rename F A2_
		rename G A3_
		rename I B1_
		rename J WB_
		rename K GB_
		rename M B2_
		rename N WT_
		rename O GT_
		rename P BE_
		rename Q WR4_
		rename R GR4_
		rename T C1_
		rename U C2_
		rename V C3_
		rename W C4_
		rename Y D1_
		rename Z D2_
		rename AA DX_
		rename AC E1_
		rename AD E2_
		rename AF F1_
		rename AG M1_
		rename AI F2_
		rename AJ M2_
		rename AL G1_
		rename AM G2_
		rename AN G3_
		rename AO G4_
		rename AP G5_
		rename AT H1A_
		rename AU H1B_
		rename AV H1C_
		rename AX H2A_
		rename AY H2B_
		rename AZ H3_
		rename BA O1_
		rename BB O2_
		rename BC P1_
		rename BD P2_
		rename BE P3_
		rename BF Q1_
		rename BG Q2_
		rename BH R1_
		rename BI TC_
		rename BJ TN_
		rename BL H4_
		rename BM O3_
		rename BN P4_
		rename BO Q3_
		rename BP R2_
		rename BQ TB_
		rename BR TD_
		rename BS I1_
		rename BT J1_
		rename BU J2_
		rename BV K1_
		rename BW K2_
		rename BX L1_
		rename BY L2_
		rename BZ N1_N7_
		rename CA N8_N9_
		rename CB RE_
		rename CD CC_
		rename CE CH_
		rename CF CP_
		rename CG DA_
		rename CH DE_
		rename CI DT_
		rename CJ OP_
		rename CK WD_
		rename CL ST_
		rename CN EF_
		rename CO EP_
		rename CP ER_
		rename CR K3_
		rename CS K4_
		rename CU V1_
		rename CV V2_
		rename CW V3_
		rename CY T1_
		rename CZ T2_
		rename DA T3_
		rename DB T4_
		rename DD U1_
		rename DE U2_
		rename DF U3_
		rename DG U4_
		rename DH unknown_
		
	drop in 1/4
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "         -"
		replace `v' = "0" if `v' == "        -"
		replace `v' = "0" if `v' == "D"
		replace `v' = "0" if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 238/348
	
	drop in 236
	   
		* destring
		destring *, replace 
		
		compress
		
	* collapse variables to match other data
	* ------------------------------------------------------
	
	// unknown2003 tour_bus_visa2003 tour_bus_other2003 students2003 tempworker2003 diplomats2003 otherclasses2003
	
		* Excludes the following classes of admission:  Refugees (RE), Advance parolees (DA), Port of entry parolees (DT),
		* Deferred inspection parolees (DE), Humanitarian parolees (CH), Public interest parolees (CP), Overseas parolees (OP),
		* Withdrawals (WD), Stowaways (ST), Expedited Removals (EF,EP,ER), Crewmen (D1,D2,DX), and Visa Waiver Program Refusals (GR,WR).
		drop RE_ DA_ DT_ DE_ CH_ CP_ OP_ WD_ ST_ EF_ EP_ ER_ D1_ D2_ DX_ WR4_ GR4_ 
				
				
		* collpase GB, GT, WB, and WT into "tour_bus_visa" 
		gen tour_bus_visa =  GB_ + GT_ + WB_ + WT_ + BE_ 
		
			br tour_bus_visa GB_ GT_ WB_ WT_ BE_ 	
			
			drop  GB_ GT_ WB_ WT_ BE_ 
			
		* collpase B-1 and B-2 into "tour_bus_other" 
		gen tour_bus_other = B1_ + B2_
		
			br  tour_bus_other B1_ B2_
			
			drop  B1_ B2_
			
		* collapse F-1 to F-3, J-1, J-2, and M-1 to M-3 admissions into "students" 
		gen students = F1_ + F2_ + J1_ + J2_ + M1_ + M2_
			
			br students F1_ F2_ J1_ J2_ M1_ M2_
			
			drop F1_ F2_ J1_ J2_ M1_ M2_
			
		* collapse E-1 to E-3, H-1B, H-1B1, H-1C, H-2A, H-2B, H-2R, H-3, H-4, I-1, L-1, 
		*		   L-2, O-1 to O-3, P-1 to P-4, Q-1, R-1, R-2, TD and TN admissions into "tempworker"
		gen tempworker = E1_ + E2_ + H1A_ + H1B_ + H1C_ + H2A_ + H2B_ + H3_ + H4_ + I1_ + L1_ + ///
						 L2_ + O1_ + O2_ + O3_ + P1_ + P2_ + P3_ + P4_ + Q1_ + Q2_ + Q3_ + R1_ + R2_ + TB_ + TC_ + TD_ + TN_ 
						 
			br tempworker E1_ E2_ H1A_ H1B_ H1C_ H2A_ H2B_ H3_ H4_ I1_ L1_ ///
						  L2_ O1_ O2_ O3_ P1_ P2_ P3_ P4_ Q1_ Q2_ Q3_ R1_ R2_ TB_ TC_ TD_ TN_
				 
			drop E1_ E2_ H1A_ H1B_ H1C_ H2A_ H2B_ H3_ H4_ I1_ L1_ ///
				 L2_ O1_ O2_ O3_ P1_ P2_ P3_ P4_ Q1_ Q2_ Q3_ R1_ R2_ TB_ TC_ TD_ TN_
				 
		* collapse A-1 to A-3, G-1 to G-5, and N-1 to N-7 admissions into "diplomats"
		gen diplomats = A1_ + A2_ + A3_ + G1_ + G2_ + G3_ + G4_ + G5_ + N1_N7 + N8_N9_ 
		
			br diplomats A1_ A2_ A3_ G1_ G2_ G3_ G4_ G5_ N1_N7 N8_N9_ 
			
			drop  A1_ A2_ A3_ G1_ G2_ G3_ G4_ G5_ N1_N7 N8_N9_ 
			
		* collpase C_1, C_2, C_3, K_1, K_2, K_3, K_4, V_1, V_2, and V_3 into "otherclasses"
		gen otherclasses = C1_ + C2_ + C3_ + C4_ + K1_ + K2_ + K3_ + K4_ + V1_ + V2_ + V3_ + ///
						   T1_ + T2_ + T3_ + T4_ + U1_ + U2_ + U3_ + U4_ + CC_ ///
		
			br otherclasses C1_  C2_  C3_  C4_  K1_  K2_  K3_  K4_  V1_  V2_  V3_ T1_ T2_ T3_ T4_ U1_ U2_ U3_ U4_ CC_ 
						
			
			drop C1_  C2_  C3_  C4_  K1_  K2_  K3_  K4_  V1_  V2_  V3_ T1_ T2_ T3_ T4_ U1_ U2_ U3_ U4_ CC_ 
	
	rename *_ * 
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-otherclasses {
		
		rename `v' `v'2002
				
	}
	
		 * trim leading and trailing spaces in string
		replace country = strtrim(country)
	
			* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
			* -----------------------------------------------------
			drop if country == "Asia"
			drop if country == "Africa"
			drop if country == "Europe"
			drop if country == "North America"
			drop if country == "Oceania"
			drop if country == "Central America"
			drop if country == "South America"
			drop if country == "Caribbean"

		* file edits 
		* ------------
		
		drop if country == "French Southern & Antarctic Lands"
		
		replace country = "Unknown" if country == "Other/Unknown"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "China, People's Republic" if country == "China, People's  Republic"
		
		replace country = "Czechoslovakia" if country == "Czechoslovakia, former"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "British Virgin Islands" if country == "Islands"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
		
		replace country = "New Zealand13" if country == "New Zealand"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union, former"
		
		replace country = "Saint Helena" if country == "St. Helena"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent and the Grenadines"
		
		replace country = "Saint Pierre and Miquelon" if country == "St. Pierre and Miquelon"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
		replace country = "Yugoslavia (former)" if country == "Yugoslavia, former"
		
		
		
			compress 
	
	* save file 
		save "$savedir/Non-immigrants/nonimmigrants2002.dta", replace
	 
		clear all
		
				
* Load data: 2001: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2001_Table36.xls", clear

	* drop the first 10 rows 
	* ----------------------
	drop in 1/10
	
	drop AD
  
		rename A country
		rename B total
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "         -"
		replace `v' = "0" if `v' == "D"
		replace `v' = "0" if `v' == "X"
		replace `v' = "0" if `v' == "-"
				
	   }
	   
	* drop the last rows that are notes
	drop in 236/253
	   
		* destring
		destring *, replace 
		
		compress
		
	* collapse variables to match other data
	* ------------------------------------------------------
	
	// unknown2003 tour_bus_visa2003 tour_bus_other2003 students2003 tempworker2003 diplomats2003 otherclasses2003
				
		* collpase GB, GT, WB, and WT into "tour_bus_visa" 
		gen tour_bus_visa =  D 
		
			br tour_bus_visa D	
			
			drop  D
			
		* collpase B-1 and B-2 into "tour_bus_other" 
		gen tour_bus_other = P + Q 	
		
			br  tour_bus_other P Q
			
			drop  P Q
			
		* collapse F-1 to F-3, J-1, J-2, and M-1 to M-3 admissions into "students" 
		gen students = G + H + M + N 
			
			br students G H M  N 
			
			drop G H M  N 
			
		* collapse E-1 to E-3, H-1B, H-1B1, H-1C, H-2A, H-2B, H-2R, H-3, H-4, I-1, L-1, 
		*		   L-2, O-1 to O-3, P-1 to P-4, Q-1, R-1, R-2, TD and TN admissions into "tempworker"
		gen tempworker = F + I + J + L + S + T
						 
			br tempworker F I J L S T
				 
			drop F I J L S T
				 
		* collapse A-1 to A-3, G-1 to G-5, and N-1 to N-7 admissions into "diplomats"
		gen diplomats = C + K + R 
		
			br diplomats C K R
			
			drop  C K R
			
		* collpase C_1, C_2, C_3, K_1, K_2, K_3, K_4, V_1, V_2, and V_3 into "otherclasses"
		gen otherclasses = E + O + U + V + W + X + Y + Z + AA + AB 
		
			br otherclasses E O U V W X Y Z AA AB 
			
			drop E O U V W X Y Z AA AB 
			
		* unknown class
		rename  AC unknown 
	
	
	* run loop to rename each variable with year suffix
	foreach v of varlist total-otherclasses {
		
		rename `v' `v'2001
				
	}
	
		 * trim leading and trailing spaces in string
		replace country = strtrim(country)
	
			* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
			* -----------------------------------------------------
			drop if country == "Asia"
			drop if country == "Africa"
			drop if country == "Europe"
			drop if country == "North America"
			drop if country == "Oceania"
			drop if country == "Central America"
			drop if country == "South America"
			drop if country == "Caribbean"

		* file edits 
		* ------------
		
		drop if country == "French Southern and Antarctic Lands"
		
		replace country = "Czechoslovakia" if country == "Czechoslovakia 6"
		
		replace country = "China, People's Republic" if country == "China 7"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union 6"
		
		replace country = "Dominica" if country == "Dominica 8"
		
		replace country = "Dominican Republic" if country == "Dominican Republic 8"
		
		replace country = "Saint Helena" if country == "St. Helena"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent and the Grenadines"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "Saint Pierre and Miquelon" if country == "St. Pierre and Miquelon"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
		
		replace country = "East Timor" if country == "Timor-Leste"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
		
		replace country = "Unknown" if country == "Other/Unknown"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "New Zealand13" if country == "New Zealand"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent & the Grenadines"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
		replace country = "Yugoslavia (former)" if country == "Yugoslavia 6"
		
			compress 
			
	sort country 
	
	* save file 
		save "$savedir/Non-immigrants/nonimmigrants2001.dta", replace
	 
		clear all
		
		
* Load data: 2000: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy2000_Table36.xls", clear

	* drop the first 10 rows 
	* ----------------------
	drop in 1/10
	
	drop U
  
		rename A country
		rename B total
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "         -"
		replace `v' = "0" if `v' == "D"
		replace `v' = "0" if `v' == "X"
		replace `v' = "0" if `v' == "-"
				
	   }
	   
	* drop the last rows that are notes
	drop in 235/252
	   
		* destring
		destring *, replace 
		
		compress
		
	* collapse variables to match other data
	* ------------------------------------------------------
	
	// unknown2003 tour_bus_visa2003 tour_bus_other2003 students2003 tempworker2003 diplomats2003 otherclasses2003
				
		* collpase GB, GT, WB, and WT into "tour_bus_visa" 
		gen tour_bus_visa =  D 
		
			br tour_bus_visa D	
			
			drop  D
			
		* collpase B-1 and B-2 into "tour_bus_other" 
		gen tour_bus_other = P + Q 	
		
			br  tour_bus_other P Q
			
			drop  P Q
			
		* collapse F-1 to F-3, J-1, J-2, and M-1 to M-3 admissions into "students" 
		gen students = G + H + M + N 
			
			br students G H M  N 
			
			drop G H M  N 
			
		* collapse E-1 to E-3, H-1B, H-1B1, H-1C, H-2A, H-2B, H-2R, H-3, H-4, I-1, L-1, 
		*		   L-2, O-1 to O-3, P-1 to P-4, Q-1, R-1, R-2, TD and TN admissions into "tempworker"
		gen tempworker = F + I + J + L + S 
						 
			br tempworker F I J L S 
				 
			drop F I J L S
				 
		* collapse A-1 to A-3, G-1 to G-5, and N-1 to N-7 admissions into "diplomats"
		gen diplomats = C + K + R 
		
			br diplomats C K R
			
			drop  C K R
			
		* collpase C_1, C_2, C_3, K_1, K_2, K_3, K_4, V_1, V_2, and V_3 into "otherclasses"
		gen otherclasses = E + O 
		
			br otherclasses E O
			
			drop E O
			
		* unknown class
		rename  T unknown 
	
	
	* run loop to rename each variable with year suffix
	foreach v of varlist total-otherclasses {
		
		rename `v' `v'2000
				
	}
	
		 * trim leading and trailing spaces in string
		replace country = strtrim(country)
	
			* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
			* -----------------------------------------------------
			drop if country == "Asia"
			drop if country == "Africa"
			drop if country == "Europe"
			drop if country == "North America"
			drop if country == "Oceania"
			drop if country == "Central America"
			drop if country == "South America"
			drop if country == "Caribbean"

		* file edits 
		* ------------
		
		drop if country == "French Southern and Antarctic Lands"
		
		replace country = "Czechoslovakia" if country == "Czechoslovakia 6"
		
		replace country = "China, People's Republic" if country == "China 7"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union 6"
		
		replace country = "Yugoslavia (former)" if country == "Yugoslavia 6"
		
		replace country = "Dominica" if country == "Dominica 8"
		
		replace country = "Dominican Republic" if country == "Dominican Republic 8"
		
		replace country = "Saint Helena" if country == "St. Helena"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent and the Grenadines"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
		replace country = "Saint Pierre and Miquelon" if country == "St. Pierre and Miquelon"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
		
		replace country = "East Timor" if country == "Timor-Leste"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
		
		replace country = "Unknown" if country == "Other/Unknown"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "New Zealand13" if country == "New Zealand"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent & the Grenadines"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
			compress 
			
	sort country 
	
	* save file 
		save "$savedir/Non-immigrants/nonimmigrants2000.dta", replace
	 
		clear all
		
		
		
* Load data: 1999: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy1999_Table_36.xls", clear

	* drop the first 11 rows 
	* ----------------------
	drop in 1/11
	
	drop V
  
		rename A country
		rename B total
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "           -"
		replace `v' = "0" if `v' == "D"
		replace `v' = "0" if `v' == "X"
		replace `v' = "0" if `v' == "-"
				
	   }
	   
	* drop the last rows that are notes
	drop in 237/254
	   
		* destring
		destring *, replace 
		
		compress
		
	* collapse variables to match other data
	* ------------------------------------------------------
	
	// unknown2003 tour_bus_visa2003 tour_bus_other2003 students2003 tempworker2003 diplomats2003 otherclasses2003
				
		* collpase GB, GT, WB, and WT into "tour_bus_visa" 
		gen tour_bus_visa =  D + E
		
			br tour_bus_visa D E
			
			drop  D E
			
		* collpase B-1 and B-2 into "tour_bus_other" 
		gen tour_bus_other =  Q + R
		
			br  tour_bus_other Q R
			
			drop  Q R
			
		* collapse F-1 to F-3, J-1, J-2, and M-1 to M-3 admissions into "students" 
		gen students = H + I + N+ O 
			
			br students H I N O  
			
			drop H I N O  
			
		* collapse E-1 to E-3, H-1B, H-1B1, H-1C, H-2A, H-2B, H-2R, H-3, H-4, I-1, L-1, 
		*		   L-2, O-1 to O-3, P-1 to P-4, Q-1, R-1, R-2, TD and TN admissions into "tempworker"
		gen tempworker = G + J + K + M + T
						 
			br tempworker G J K M T 
				 
			drop G J K M T 
				 
		* collapse A-1 to A-3, G-1 to G-5, and N-1 to N-7 admissions into "diplomats"
		gen diplomats = C + L + S 
		
			br diplomats C  L S
			
			drop  C L S
			
		* collpase C_1, C_2, C_3, K_1, K_2, K_3, K_4, V_1, V_2, and V_3 into "otherclasses"
		gen otherclasses = F + P 
		
			br otherclasses F P
			
			drop F P 
			
		* unknown class
		rename  U unknown 
	
	
	* run loop to rename each variable with year suffix
	foreach v of varlist total-otherclasses {
		
		rename `v' `v'1999 
				
	}
	
		 * trim leading and trailing spaces in string
		replace country = strtrim(country)
	
			* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
			* -----------------------------------------------------
			drop if country == "Asia"
			drop if country == "Africa"
			drop if country == "Europe"
			drop if country == "North America"
			drop if country == "Oceania"
			drop if country == "Central America"
			drop if country == "South America"
			drop if country == "Caribbean"

		* file edits 
		* ------------
		
		drop if country == "French Southern and Antarctic Lands"
		
		drop if country == "French Southern & Antarctic Lands"
		
		replace country = "Czechoslovakia" if country == "Czechoslovakia 6"
		
		replace country = "China, People's Republic" if country == "China 7"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union 6"
		
		replace country = "Yugoslavia (former)" if country == "Yugoslavia 6"
		
		replace country = "Dominica" if country == "Dominica 8"
		
		replace country = "Dominican Republic" if country == "Dominican Republic 8"
		
		replace country = "Saint Helena" if country == "St. Helena"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent and the Grenadines"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
		replace country = "Saint Pierre and Miquelon" if country == "St. Pierre and Miquelon"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
		
		replace country = "East Timor" if country == "Timor-Leste"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
		
		replace country = "Unknown" if country == "Other/Unknown"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		replace country = "Sao Tome and Principe" if country == "Sao Tome & Principe"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "Cote d'Ivoire" if country == "Cote d' Ivoire"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "New Zealand13" if country == "New Zealand"
		
		replace country = "Pitcairn Island" if country == "Pitcairn Islands"
		
		replace country = "Saint Pierre and Miquelon" if country == "St Pierre and Miquelon"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent & the Grenadines"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
			compress 
			
	sort country 
	
	* save file 
		save "$savedir/Non-immigrants/nonimmigrants1999.dta", replace
	 
		clear all
		
	
	
* Load data: 1998: Non-immigrants  
* ===================================
import excel "$rawdir/Non-immigrants/fy1998_Table_38.xls", clear

	* drop the first 10 rows 
	* ----------------------
	drop in 1/10
  
		rename A country
		rename B total
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "           -"
		replace `v' = "0" if `v' == "D"
		replace `v' = "0" if `v' == "X"
		replace `v' = "0" if `v' == "-"
				
	   }
	   
	* drop the last rows that are notes
	drop in 235/247
	   
		* destring
		destring *, replace 
		
		compress
		
	* collapse variables to match other data
	* ------------------------------------------------------
	
	// unknown2003 tour_bus_visa2003 tour_bus_other2003 students2003 tempworker2003 diplomats2003 otherclasses2003
				
		* collpase GB, GT, WB, and WT into "tour_bus_visa" 
		gen tour_bus_visa =  D + E
		
			br tour_bus_visa D E
			
			drop  D E
			
		* collpase B-1 and B-2 into "tour_bus_other" 
		gen tour_bus_other =  Q + R
		
			br tour_bus_other Q R
			
			drop  Q R
			
		* collapse F-1 to F-3, J-1, J-2, and M-1 to M-3 admissions into "students" 
		gen students = H + I + N+ O 
			
			br students H I N O  
			
			drop H I N O  
			
		* collapse E-1 to E-3, H-1B, H-1B1, H-1C, H-2A, H-2B, H-2R, H-3, H-4, I-1, L-1, 
		*		   L-2, O-1 to O-3, P-1 to P-4, Q-1, R-1, R-2, TD and TN admissions into "tempworker"
		gen tempworker = G + J + K + M + T
						 
			br tempworker G J K M T 
				 
			drop G J K M T 
				 
		* collapse A-1 to A-3, G-1 to G-5, and N-1 to N-7 admissions into "diplomats"
		gen diplomats = C + L + S 
		
			br diplomats C  L S
			
			drop  C L S
			
		* collpase C_1, C_2, C_3, K_1, K_2, K_3, K_4, V_1, V_2, and V_3 into "otherclasses"
		gen otherclasses = F + P 
		
			br otherclasses F P
			
			drop F P 
			
		* unknown class
		rename  U unknown 
	
	
	* run loop to rename each variable with year suffix
	foreach v of varlist total-otherclasses {
		
		rename `v' `v'1998
				
	}
	
		 * trim leading and trailing spaces in string
		replace country = strtrim(country)
	
			* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
			* -----------------------------------------------------
			drop if country == "Asia"
			drop if country == "Africa"
			drop if country == "Europe"
			drop if country == "North America"
			drop if country == "Oceania"
			drop if country == "Central America"
			drop if country == "South America"
			drop if country == "Caribbean"

		* file edits 
		* ------------
		
		drop if country == "French Southern & Antarctic Lands"
		  		
		replace country = "Unknown republic, former Soviet Union" if country == "Unknown republic" & total1998 == 703
		
		replace country = "Unknown republic, former Czechoslovakia" if country == "Unknown republic" & total1998 == 14392
		
		replace country = "Unknown republic, former Yugoslavia" if country == "Unknown republic" & total1998 == 17296
		
		replace country = "Czechoslovakia" if country == "Czechoslovakia, former"
	 
		replace country = "China, People's Republic" if country == "China /6"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union 6"
		
		replace country = "Yugoslavia (former)" if country == "Yugoslavia, former"
		
		replace country = "Dominica" if country == "Dominica /8"
		
		replace country = "Dominican Republic" if country == "Dominican Republic /8"
		
		replace country = "Saint Helena" if country == "St. Helena"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent & the Grenadines"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
		replace country = "Saint Pierre and Miquelon" if country == "St Pierre & Miquelon"
		
		replace country = "Turks and Caicos Islands" if country == "Turks & Caicos Islands"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
		
		replace country = "East Timor" if country == "Timor-Leste"
		
		replace country = "Unknown" if country == "Other/Unknown"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		replace country = "Sao Tome and Principe" if country == "Sao Tome & Principe"
		
		replace country = "Wallis and Futuna Islands" if country == "Wallis & Futuna Islands"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union, former"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "Cote d'Ivoire" if country == "Cote d' Ivoire"
		
		replace country = "Czech Republic" if country == "Czech republic"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "New Zealand13" if country == "New Zealand"
		
		replace country = "Slovak Republic" if country == "Slovak republic"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent & the Grenadines"
		
		replace country = "Trinidad and Tobago" if country == "Trinidad & Tobago"
		
			compress 
			
	sort country 
	
	* save file 
		save "$savedir/Non-immigrants/nonimmigrants1998.dta", replace
	 
		clear all
							

* Merge Non-immigrants  data
* ===================================
cd "$savedir/Non-immigrants"
use "nonimmigrants2018.dta", clear
			 
	* merge all years together
	merge 1:1 country using "nonimmigrants2017.dta"	
		drop _merge
	merge 1:1 country using "nonimmigrants2016.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2015.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2014.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2013.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2012.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2011.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2010.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2009.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2008.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2007.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2006.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2005.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2004.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2003.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2002.dta"	
		drop _merge
	merge 1:1 country using "nonimmigrants2001.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants2000.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants1999.dta"
		drop _merge
	merge 1:1 country using "nonimmigrants1998.dta"
		drop _merge
		

	
		* reshape data to long
		* -------------------
		reshape long total tour_bus_visa tour_bus_other students tempworker diplomats otherclasses unknown, i(country) j(year)
			
				
			* replace missing with . with 0s so they properly sum 
			* ----------------------------------------------------------
			order year, first 
			order country, first 
				
				* run loop to replace missing with 0s
				foreach v of varlist total-unknown {
					
					replace `v' = 0 if `v' == .
							
				} 
				
			order total, last 
						
				* edits to completed file
				* -----------------------
				drop if country == "British Virgin"
				
				replace country = "Réunion" if country == "Reunion" 
				
				replace country = "New Zealand" if country == "New Zealand13"
				
				replace country = "Holy See, The Vatican" if country == "Holy See" 
				
				replace country = "Timor-Leste" if country == "East Timor"
				
				replace country = "Czechoslovakia (former)" if country == "Czechoslovakia"
				
				replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro"	

				drop if country == "      French Southern & Antarctic Lands" 
				
				drop if country == "Sao Tome & Principe" 
				
				replace country = "Saint Kitts and Nevis" if country == "Saint Kitts-Nevis"
				
				replace country = "Yugoslavia (former)" if country == "Yugoslavia, former"
				
				replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
				
				replace country = "Saint Helena" if country == "St. Helena"
				
				replace country = "Saint Pierre and Miquelon" if country == "St. Pierre and Miquelon"
				
				replace country = "Eswatini (formerly Swaziland)" if country == "Swaziland"
				
				replace country = "Republic of the Congo" if country == "Congo, Republic"
				
				replace country = "Democratic Republic of the Congo" if country == "Congo, Democratic Republic"
				
				replace country = "Federated States of Micronesia" if country == "Micronesia, Federated States of"
				
				replace country = "North Korea" if country == "Korea, North"
				
				replace country = "South Korea" if country == "Korea, South"
				
				replace country = "People's Republic of China" if country == "China, People's Republic"
				
				
		* create region variables (use "fast stata code.xlsx")
		* -----------------------------------------------------
		
		gen str region = "."
			
			replace region = "Africa" if country == "Algeria"
			replace region = "Africa" if country == "Angola"
			replace region = "Africa" if country == "Benin"
			replace region = "Africa" if country == "Botswana"
			replace region = "Africa" if country == "Burkina Faso"
			replace region = "Africa" if country == "Burundi"
			replace region = "Africa" if country == "Cameroon"
			replace region = "Africa" if country == "Cape Verde"
			replace region = "Africa" if country == "Central African Republic"
			replace region = "Africa" if country == "Chad"
			replace region = "Africa" if country == "Comoros"
			replace region = "Africa" if country == "Democratic Republic of the Congo"
			replace region = "Africa" if country == "Republic of the Congo"
			replace region = "Africa" if country == "Cote d'Ivoire"
			replace region = "Africa" if country == "Djibouti"
			replace region = "Africa" if country == "Egypt"
			replace region = "Africa" if country == "Equatorial Guinea"
			replace region = "Africa" if country == "Eritrea"
			replace region = "Africa" if country == "Ethiopia"
			replace region = "Africa" if country == "Gabon"
			replace region = "Africa" if country == "Gambia, The"
			replace region = "Africa" if country == "Ghana"
			replace region = "Africa" if country == "Guinea"
			replace region = "Africa" if country == "Guinea-Bissau"
			replace region = "Africa" if country == "Kenya"
			replace region = "Africa" if country == "Lesotho"
			replace region = "Africa" if country == "Liberia"
			replace region = "Africa" if country == "Libya"
			replace region = "Africa" if country == "Madagascar"
			replace region = "Africa" if country == "Malawi"
			replace region = "Africa" if country == "Mali"
			replace region = "Africa" if country == "Mauritania"
			replace region = "Africa" if country == "Mauritius"
			replace region = "Africa" if country == "Morocco"
			replace region = "Africa" if country == "Mozambique"
			replace region = "Africa" if country == "Namibia"
			replace region = "Africa" if country == "Niger"
			replace region = "Africa" if country == "Nigeria"
			replace region = "Africa" if country == "Rwanda"
			replace region = "Africa" if country == "Sao Tome and Principe"
			replace region = "Africa" if country == "Senegal"
			replace region = "Africa" if country == "Seychelles"
			replace region = "Africa" if country == "Sierra Leone"
			replace region = "Africa" if country == "Somalia"
			replace region = "Africa" if country == "South Africa"
			replace region = "Africa" if country == "Saint Helena"
			replace region = "Africa" if country == "Sudan"
			replace region = "Africa" if country == "Swaziland"
			replace region = "Africa" if country == "Tanzania"
			replace region = "Africa" if country == "Togo"
			replace region = "Africa" if country == "Tunisia"
			replace region = "Africa" if country == "Uganda"
			replace region = "Africa" if country == "Western Sahara"
			replace region = "Africa" if country == "Zambia"
			replace region = "Africa" if country == "Zimbabwe"
			replace region = "Africa" if country == "Eswatini (formerly Swaziland)"
			replace region = "Africa" if country == "Gambia"
			replace region = "Africa" if country == "Other Africa"
			replace region = "Africa" if country == "Réunion"
			replace region = "Africa" if country == "South Sudan"
			replace region = "Africa" if country == "Congo (Kinshasa)"
			replace region = "Africa" if country == "Congo (Brazzaville)"
			
			replace region = "Asia" if country == "Afghanistan"
			replace region = "Asia" if country == "Bahrain"
			replace region = "Asia" if country == "Bangladesh"
			replace region = "Asia" if country == "Bhutan"
			replace region = "Asia" if country == "Brunei"
			replace region = "Asia" if country == "Burma"
			replace region = "Asia" if country == "Cambodia"
			replace region = "Asia" if country == "People's Republic of China"
			replace region = "Asia" if country == "Cyprus"
			replace region = "Asia" if country == "Hong Kong"
			replace region = "Asia" if country == "India"
			replace region = "Asia" if country == "Indonesia"
			replace region = "Asia" if country == "Iran"
			replace region = "Asia" if country == "Iraq"
			replace region = "Asia" if country == "Israel"
			replace region = "Asia" if country == "Japan"
			replace region = "Asia" if country == "Jordan"
			replace region = "Asia" if country == "Korea"
			replace region = "Asia" if country == "Kuwait"
			replace region = "Asia" if country == "Laos"
			replace region = "Asia" if country == "Lebanon"
			replace region = "Asia" if country == "Macau"
			replace region = "Asia" if country == "Malaysia"
			replace region = "Asia" if country == "Maldives"
			replace region = "Asia" if country == "Mongolia"
			replace region = "Asia" if country == "Nepal"
			replace region = "Asia" if country == "Oman"
			replace region = "Asia" if country == "Pakistan"
			replace region = "Asia" if country == "Philippines"
			replace region = "Asia" if country == "Qatar"
			replace region = "Asia" if country == "Saudi Arabia"
			replace region = "Asia" if country == "Singapore"
			replace region = "Asia" if country == "Sri Lanka"
			replace region = "Asia" if country == "Syria"
			replace region = "Asia" if country == "Taiwan"
			replace region = "Asia" if country == "Thailand"
			replace region = "Asia" if country == "Turkey"
			replace region = "Asia" if country == "United Arab Emirates"
			replace region = "Asia" if country == "Vietnam"
			replace region = "Asia" if country == "Yemen"
			replace region = "Asia" if country == "North Korea"
			replace region = "Asia" if country == "South Korea"
			replace region = "Asia" if country == "Other Asia"
			replace region = "Asia" if country == "Timor-Leste"
			
			replace region = "Europe" if country == "Albania"
			replace region = "Europe" if country == "Andorra"
			replace region = "Europe" if country == "Armenia"
			replace region = "Europe" if country == "Austria"
			replace region = "Europe" if country == "Azerbaijan"
			replace region = "Europe" if country == "Belarus"
			replace region = "Europe" if country == "Belgium"
			replace region = "Europe" if country == "Bosnia-Herzegovina"
			replace region = "Europe" if country == "Bulgaria"
			replace region = "Europe" if country == "Croatia"
			replace region = "Europe" if country == "Czech Republic"
			replace region = "Europe" if country == "Czechoslovakia 2"
			replace region = "Europe" if country == "Denmark"
			replace region = "Europe" if country == "Estonia"
			replace region = "Europe" if country == "Finland"
			replace region = "Europe" if country == "France"
			replace region = "Europe" if country == "Georgia"
			replace region = "Europe" if country == "Germany"
			replace region = "Europe" if country == "Gibraltar"
			replace region = "Europe" if country == "Greece"
			replace region = "Europe" if country == "Hungary"
			replace region = "Europe" if country == "Iceland"
			replace region = "Europe" if country == "Ireland"
			replace region = "Europe" if country == "Italy"
			replace region = "Europe" if country == "Kazakhstan"
			replace region = "Europe" if country == "Kyrgyzstan"
			replace region = "Europe" if country == "Latvia"
			replace region = "Europe" if country == "Liechtenstein"
			replace region = "Europe" if country == "Lithuania"
			replace region = "Europe" if country == "Luxembourg"
			replace region = "Europe" if country == "Macedonia"
			replace region = "Europe" if country == "Malta"
			replace region = "Europe" if country == "Moldova"
			replace region = "Europe" if country == "Monaco"
			replace region = "Europe" if country == "Netherlands"
			replace region = "Europe" if country == "Norway"
			replace region = "Europe" if country == "Poland"
			replace region = "Europe" if country == "Portugal"
			replace region = "Europe" if country == "Romania"
			replace region = "Europe" if country == "Russia"
			replace region = "Europe" if country == "Slovak Republic"
			replace region = "Europe" if country == "Slovenia"
			replace region = "Europe" if country == "Soviet Union"
			replace region = "Europe" if country == "Spain"
			replace region = "Europe" if country == "Sweden"
			replace region = "Europe" if country == "Switzerland"
			replace region = "Europe" if country == "Tajikistan"
			replace region = "Europe" if country == "Turkmenistan"
			replace region = "Europe" if country == "Ukraine"
			replace region = "Europe" if country == "United Kingdom"
			replace region = "Europe" if country == "Uzbekistan"
			replace region = "Europe" if country == "Yugoslavia (former)"
			replace region = "Europe" if country == "Czechoslovakia (former)"
			replace region = "Europe" if country == "Greenland"
			replace region = "Europe" if country == "Kosovo"
			replace region = "Europe" if country == "Montenegro"
			replace region = "Europe" if country == "Northern Ireland"
			replace region = "Europe" if country == "Other Europe"
			replace region = "Europe" if country == "San Marino"
			replace region = "Europe" if country == "Serbia"
			replace region = "Europe" if country == "Serbia and Montenegro (former)"
			replace region = "Europe" if country == "Slovakia"
			replace region = "Europe" if country == "Soviet Union (former)"
			replace region = "Europe" if country == "Unknown republic, former Czechoslovakia"
			replace region = "Europe" if country == "Unknown republic, former Soviet Union"
			replace region = "Europe" if country == "Unknown, former Yugoslavia"
			replace region = "Europe" if country == "Yugoslavia (former)"
			replace region = "Europe" if country == "Holy See, The Vatican"
			replace region = "Europe" if country == "Serbia and Montenegro"
			
			replace region = "North America" if country == "Canada"
			replace region = "North America" if country == "Mexico"
			replace region = "North America" if country == "United States"
			replace region = "North America" if country == "Anguilla"
			replace region = "North America" if country == "Antigua-Barbuda"
			replace region = "North America" if country == "Aruba"
			replace region = "North America" if country == "Bahamas, The"
			replace region = "North America" if country == "Barbados"
			replace region = "North America" if country == "Bermuda"
			replace region = "North America" if country == "British Virgin Islands"
			replace region = "North America" if country == "Cayman Islands"
			replace region = "North America" if country == "Cuba"
			replace region = "North America" if country == "Dominica"
			replace region = "North America" if country == "Dominican Republic"
			replace region = "North America" if country == "Grenada"
			replace region = "North America" if country == "Guadeloupe"
			replace region = "North America" if country == "Haiti"
			replace region = "North America" if country == "Jamaica"
			replace region = "North America" if country == "Martinique"
			replace region = "North America" if country == "Montserrat"
			replace region = "North America" if country == "Netherlands Antilles"
			replace region = "North America" if country == "Puerto Rico"
			replace region = "North America" if country == "Saint Lucia"
			replace region = "North America" if country == "Saint Vincent and the Grenadines"
			replace region = "North America" if country == "Trinidad and Tobago"
			replace region = "North America" if country == "Turks and Caicos Islands"
			replace region = "North America" if country == "U.S. Virgin Islands"
			replace region = "North America" if country == "Belize"
			replace region = "North America" if country == "Costa Rica"
			replace region = "North America" if country == "El Salvador"
			replace region = "North America" if country == "Guatemala"
			replace region = "North America" if country == "Honduras"
			replace region = "North America" if country == "Nicaragua"
			replace region = "North America" if country == "Panama"
			replace region = "North America" if country == "Bahamas"
			replace region = "North America" if country == "Curacao"
			replace region = "North America" if country == "Other Caribbean"
			replace region = "North America" if country == "Other North America"
			replace region = "North America" if country == "Saint Kitts and Nevis"
			replace region = "North America" if country == "Saint Lucia"
			replace region = "North America" if country == "Saint Vincent and the Grenadines"
			replace region = "North America" if country == "Sint Maarten"
			replace region = "North America" if country == "Saint Pierre and Miquelon"

			replace region = "Oceania" if country == "American Samoa"
			replace region = "Oceania" if country == "Australia"
			replace region = "Oceania" if country == "Cook Islands"
			replace region = "Oceania" if country == "Fiji"
			replace region = "Oceania" if country == "French Polynesia"
			replace region = "Oceania" if country == "Kiribati"
			replace region = "Oceania" if country == "Marshall Islands"
			replace region = "Oceania" if country == "Federated States of Micronesia"
			replace region = "Oceania" if country == "Nauru"
			replace region = "Oceania" if country == "New Caledonia"
			replace region = "Oceania" if country == "New Zealand"
			replace region = "Oceania" if country == "Northern Mariana Islands"
			replace region = "Oceania" if country == "Palau"
			replace region = "Oceania" if country == "Papua New Guinea"
			replace region = "Oceania" if country == "Samoa"
			replace region = "Oceania" if country == "Solomon Islands"
			replace region = "Oceania" if country == "Tonga"
			replace region = "Oceania" if country == "Tuvalu"
			replace region = "Oceania" if country == "Vanuatu"
			replace region = "Oceania" if country == "Guam"
			replace region = "Oceania" if country == "Niue"
			replace region = "Oceania" if country == "Other Oceania"
			replace region = "Oceania" if country == "Pitcairn Island"
			replace region = "Oceania" if country == "Wallis and Futuna Islands"
			replace region = "Oceania" if country == "Christmas Island"
			replace region = "Oceania" if country == "Cocos Islands"
			
			replace region = "South America" if country == "Argentina"
			replace region = "South America" if country == "Bolivia"
			replace region = "South America" if country == "Brazil"
			replace region = "South America" if country == "Chile"
			replace region = "South America" if country == "Colombia"
			replace region = "South America" if country == "Ecuador"
			replace region = "South America" if country == "French Guiana"
			replace region = "South America" if country == "Guyana"
			replace region = "South America" if country == "Paraguay"
			replace region = "South America" if country == "Peru"
			replace region = "South America" if country == "Suriname"
			replace region = "South America" if country == "Uruguay"
			replace region = "South America" if country == "Venezuela"
			replace region = "South America" if country == "Falkland Islands"
			replace region = "South America" if country == "Other South America"
			
			replace region = "Other" if country == "All other countries"
			replace region = "Other" if country == "Not specified"
			replace region = "Other" if country == "Other republics"
			replace region = "Other" if country == "Other, not specified"
			replace region = "Other" if country == "Unknown or not reported"
			replace region = "Other" if country == "Unknown"
			replace region = "Other" if country == "Stateless"
			replace region = "Other" if country == "Unknown republic, former Yugoslavia"
			
				* check 
				br country if region == "."
				
			order region , before(country)
			
			compress 
			
			
		* combine tour_bus_other and tour_bus_visa
		* ----------------------------------------
		gen tourism_business = tour_bus_visa + tour_bus_other
		
			drop tour_bus_visa tour_bus_other
			order tourism_business, after(total)
			
		* combine otherclasses and unknown
		* ----------------------------------------
		gen other_unknown = otherclasses + unknown
		
			drop otherclasses unknown
			order other_unknown, after(total)
			
		* total check 
		gen total2 = other_unknown + tourism_business + students + tempworker + diplomats
		
			order total2, after(total)
			gen diff = total-total2
			order diff, after(total2)
			
			fre diff
		
				drop diff total2
				
				
		* replace missing with 0s with "." for consistency
		* ----------------------------------------------------------
		order region, first 
		order country, first 
				
			* run loop to replace missing with 0s
			foreach v of varlist year-tourism_business {
				
				replace `v' = . if `v' == 0
							
			} 
				
		order other_unknown, after(tourism_business)
		order total, last 		
	
	
	
	/* Notes for write-up
	   ==========================
	
	1. Admissions in the Visa Waiver category include only residents of Hong Kong admitted under the Guam and 
	   Commonwealth of Northern Mariana Islands Visa Waiver Program.
	   
	2. Denmark includes Denmark, Faroe Islands, and Greenland.
	
	3. France includes France, French Guiana, French Polynesia, French Southern and Antarctic Lands, Guadeloupe, 
	   Martinique, Mayotte, New Caledonia, Reunion, Saint Barthelemy, Saint Pierre and Miquelon, and Wallis and Futuna.
	
	4. Morocco includes Morocco and Western Sahara.
	
	5. Netherlands includes the Netherlands, Aruba, Bonaire, Curacao, Saba, Sint Eustatius, and Sint Maarten.
	
	6. New Zealand includes New Zealand, Cook Islands, Tokelau, and Niue.
	
	7. United Kingdom includes the United Kingdom, Anguilla, Bermuda, British Virgin Islands, Cayman Islands, 
	   Falkland Islands, Gibraltar, Guernsey, Isle of Man, Jersey, Montserrat, Pitcairn Islands, Saint Helena, 
	   and Turks and Caicos Islands.
	
	8. Admissions represent counts of events (i.e., arrivals) not unique individuals. Multiple entries of an 
	   individual on the same day are counted as one admission.
	
	9. The majority of short-term admissions from Canada and Mexico are excluded.
	
	10. There will be some discrepencies in total counts for each country by year because of data supression. Values do not
		correctly sum in DHS datasets
	
	11. All missing values (".") represent a zero, an actually missing value, or a value supressed for confidentiality concerns.
	
	12. Data is systematically missing for 1997 in legal permanent residents dataset, so we drop data for 1996 and 1997 so 
	    that we have data consistenlty for 20 years: 1998-2018. 
		
	13. United States includes nonimmigrants who self-report that they reside in the United States.?
	
	14. Korea includes both North and South Korea.	
	
	


