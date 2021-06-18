/* Superdiveristy Project: Phase 1: Tree Diagram 
 * =======================================================
  
 * File: 2020.08.17 Refugees.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Tree Diagram for Phase 1 of Superdiveristy Project
 * Data: 
 
	- 
	- 
	
 * Date Last Updated: 2020.08.17 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/DHS"
global savedir "${db}/Phase 1/1_Tree Diagram/Recoded"
global tabledir "${db}/Phase 1/1_Tree Diagram/Tables"


* Load data: 2009-2018: Refugees 
* ===================================
import excel "$rawdir/Refugees and Asylees/Refugees/fy2009-2018_table14d.xlsx", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B refugee2009
		rename C refugee2010
		rename D refugee2011
		rename E refugee2012
		rename F refugee2013
		rename G refugee2014
		rename H refugee2015
		rename I refugee2016
		rename J refugee2017
		rename K refugee2018
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 62/68
	   
		* destring
		destring *, replace 
		
		compress
	

		* file edits 
		* ------------
		replace country = "Palestine" if country == "Unknown 2"
		
		replace country = "All other countries" if country == "All other countries 1"
		
		
	* save file 
	save "$savedir/Refugees and Asylees/refugees2009-2018.dta", replace
	 
	clear all 

* Load data: 1999-2008: Refugees 
* ===================================
import excel "$rawdir/Refugees and Asylees/Refugees/fy1999-2008_table14d.xlsx", clear


	* drop the first 13 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/13
  
		* rename each row 
		rename A country
		rename B refugee1999
		rename C refugee2000
		rename D refugee2001
		rename E refugee2002
		rename F refugee2003
		rename G refugee2004
		rename H refugee2005
		rename I refugee2006
		rename J refugee2007
		rename K refugee2008
		
	drop L-Q
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
		replace `v' = "." if `v' == "NA"
				
	   }
	   
	* drop the last rows that are notes
	drop in 67/72
	   
		* destring
		destring *, replace 
		
		compress
	

		* file edits 
		* ------------
		replace country = "Soviet Union (former)" if country == "Soviet Union, former"
		
		replace country = "Yugoslavia (former)" if country == "Yugoslavia, former"
		
		replace country = "All other countries" if country == "All Other Countries" 
		
		
	* save file 
	save "$savedir/Refugees and Asylees/refugees1999-2008.dta", replace
	 
	clear all 
	
	
* Load data: 1995-2005: Refugees 
* ===================================
import excel "$rawdir/Refugees and Asylees/Refugees/fy1996-2005_table14d.xls", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B refugee1996
		rename C refugee1997
		rename D refugee1998
		
	drop E-K // drop 2005 and higher bc got them in last dataset
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
		replace `v' = "." if `v' == "NA"
				
	   }
	   
	* drop the last rows that are notes
	drop in 64/68
	   
		* destring
		destring *, replace 
		
		compress
	

		* file edits 
		* ------------
		replace country = "Yugoslavia (former)" if country == "Serbia and Montenegro1"
		
	* save file 
	save "$savedir/Refugees and Asylees/refugees1996-1998.dta", replace
	 
	clear all 
	
	

* Merge Refugee data
* ===================================
cd "$savedir/Refugees and Asylees"
use "refugees2009-2018.dta", clear

			
	* merge all years together
	merge 1:1 country using "refugees1999-2008.dta"
		drop _merge
	merge 1:1 country using "refugees1996-1998.dta"
		drop _merge
	
	
		* reshape data to long
		* -------------------
		reshape long refugee, i(country) j(year)
			
				
				* edits to completed file
				* -----------------------				
				*replace country = "All other countries" if country == "All Other Countries" 
				
				
				
		* create region variables (use "LPR_cheet stata code.xlsx")
		* -----------------------------------------------------
		
		gen str region = "."
			
			replace region = "africa" if country == "Algeria"
			replace region = "africa" if country == "Angola"
			replace region = "africa" if country == "Benin"
			replace region = "africa" if country == "Botswana"
			replace region = "africa" if country == "Burkina Faso"
			replace region = "africa" if country == "Burundi"
			replace region = "africa" if country == "Cameroon"
			replace region = "africa" if country == "Cape Verde"
			replace region = "africa" if country == "Central African Republic"
			replace region = "africa" if country == "Chad"
			replace region = "africa" if country == "Comoros"
			replace region = "africa" if country == "Congo, Democratic Republic"
			replace region = "africa" if country == "Congo, Republic"
			replace region = "africa" if country == "Cote d'Ivoire"
			replace region = "africa" if country == "Djibouti"
			replace region = "africa" if country == "Egypt"
			replace region = "africa" if country == "Equatorial Guinea"
			replace region = "africa" if country == "Eritrea"
			replace region = "africa" if country == "Ethiopia"
			replace region = "africa" if country == "Gabon"
			replace region = "africa" if country == "Gambia, The"
			replace region = "africa" if country == "Ghana"
			replace region = "africa" if country == "Guinea"
			replace region = "africa" if country == "Guinea-Bissau"
			replace region = "africa" if country == "Kenya"
			replace region = "africa" if country == "Lesotho"
			replace region = "africa" if country == "Liberia"
			replace region = "africa" if country == "Libya"
			replace region = "africa" if country == "Madagascar"
			replace region = "africa" if country == "Malawi"
			replace region = "africa" if country == "Mali"
			replace region = "africa" if country == "Mauritania"
			replace region = "africa" if country == "Mauritius"
			replace region = "africa" if country == "Morocco"
			replace region = "africa" if country == "Mozambique"
			replace region = "africa" if country == "Namibia"
			replace region = "africa" if country == "Niger"
			replace region = "africa" if country == "Nigeria"
			replace region = "africa" if country == "Rwanda"
			replace region = "africa" if country == "Sao Tome and Principe"
			replace region = "africa" if country == "Senegal"
			replace region = "africa" if country == "Seychelles"
			replace region = "africa" if country == "Sierra Leone"
			replace region = "africa" if country == "Somalia"
			replace region = "africa" if country == "South Africa"
			replace region = "africa" if country == "St. Helena"
			replace region = "africa" if country == "Sudan"
			replace region = "africa" if country == "Swaziland"
			replace region = "africa" if country == "Tanzania"
			replace region = "africa" if country == "Togo"
			replace region = "africa" if country == "Tunisia"
			replace region = "africa" if country == "Uganda"
			replace region = "africa" if country == "Western Sahara"
			replace region = "africa" if country == "Zambia"
			replace region = "africa" if country == "Zimbabwe"
			replace region = "africa" if country == "Eswatini (formerly Swaziland)"
			replace region = "africa" if country == "Gambia"
			replace region = "africa" if country == "Other Africa"
			replace region = "africa" if country == "Réunion"
			replace region = "africa" if country == "South Sudan"
			
			replace region = "asia" if country == "Afghanistan"
			replace region = "asia" if country == "Bahrain"
			replace region = "asia" if country == "Bangladesh"
			replace region = "asia" if country == "Bhutan"
			replace region = "asia" if country == "Brunei"
			replace region = "asia" if country == "Burma"
			replace region = "asia" if country == "Cambodia"
			replace region = "asia" if country == "China, People's Republic"
			replace region = "asia" if country == "Cyprus"
			replace region = "asia" if country == "Hong Kong"
			replace region = "asia" if country == "India"
			replace region = "asia" if country == "Indonesia"
			replace region = "asia" if country == "Iran"
			replace region = "asia" if country == "Iraq"
			replace region = "asia" if country == "Israel"
			replace region = "asia" if country == "Japan"
			replace region = "asia" if country == "Jordan"
			replace region = "asia" if country == "Korea"
			replace region = "asia" if country == "Kuwait"
			replace region = "asia" if country == "Laos"
			replace region = "asia" if country == "Lebanon"
			replace region = "asia" if country == "Macau"
			replace region = "asia" if country == "Malaysia"
			replace region = "asia" if country == "Maldives"
			replace region = "asia" if country == "Mongolia"
			replace region = "asia" if country == "Nepal"
			replace region = "asia" if country == "Oman"
			replace region = "asia" if country == "Pakistan"
			replace region = "asia" if country == "Philippines"
			replace region = "asia" if country == "Qatar"
			replace region = "asia" if country == "Saudi Arabia"
			replace region = "asia" if country == "Singapore"
			replace region = "asia" if country == "Sri Lanka"
			replace region = "asia" if country == "Syria"
			replace region = "asia" if country == "Taiwan"
			replace region = "asia" if country == "Thailand"
			replace region = "asia" if country == "Turkey"
			replace region = "asia" if country == "United Arab Emirates"
			replace region = "asia" if country == "Vietnam"
			replace region = "asia" if country == "Yemen"
			replace region = "asia" if country == "Korea, North"
			replace region = "asia" if country == "Korea, South"
			replace region = "asia" if country == "Other Asia"
			replace region = "asia" if country == "Tibet"
			replace region = "asia" if country == "Palestine"
			
			replace region = "europe" if country == "Albania"
			replace region = "europe" if country == "Andorra"
			replace region = "europe" if country == "Armenia"
			replace region = "europe" if country == "Austria"
			replace region = "europe" if country == "Azerbaijan"
			replace region = "europe" if country == "Belarus"
			replace region = "europe" if country == "Belgium"
			replace region = "europe" if country == "Bosnia-Herzegovina"
			replace region = "europe" if country == "Bulgaria"
			replace region = "europe" if country == "Croatia"
			replace region = "europe" if country == "Czech Republic"
			replace region = "europe" if country == "Czechoslovakia 2"
			replace region = "europe" if country == "Denmark"
			replace region = "europe" if country == "Estonia"
			replace region = "europe" if country == "Finland"
			replace region = "europe" if country == "France"
			replace region = "europe" if country == "Georgia"
			replace region = "europe" if country == "Germany"
			replace region = "europe" if country == "Gibraltar"
			replace region = "europe" if country == "Greece"
			replace region = "europe" if country == "Hungary"
			replace region = "europe" if country == "Iceland"
			replace region = "europe" if country == "Ireland"
			replace region = "europe" if country == "Italy"
			replace region = "europe" if country == "Kazakhstan"
			replace region = "europe" if country == "Kyrgyzstan"
			replace region = "europe" if country == "Latvia"
			replace region = "europe" if country == "Liechtenstein"
			replace region = "europe" if country == "Lithuania"
			replace region = "europe" if country == "Luxembourg"
			replace region = "europe" if country == "Macedonia"
			replace region = "europe" if country == "Malta"
			replace region = "europe" if country == "Moldova"
			replace region = "europe" if country == "Monaco"
			replace region = "europe" if country == "Netherlands"
			replace region = "europe" if country == "Norway"
			replace region = "europe" if country == "Poland"
			replace region = "europe" if country == "Portugal"
			replace region = "europe" if country == "Romania"
			replace region = "europe" if country == "Russia"
			replace region = "europe" if country == "Slovak Republic"
			replace region = "europe" if country == "Slovenia"
			replace region = "europe" if country == "Soviet Union"
			replace region = "europe" if country == "Spain"
			replace region = "europe" if country == "Sweden"
			replace region = "europe" if country == "Switzerland"
			replace region = "europe" if country == "Tajikistan"
			replace region = "europe" if country == "Turkmenistan"
			replace region = "europe" if country == "Ukraine"
			replace region = "europe" if country == "United Kingdom"
			replace region = "europe" if country == "Uzbekistan"
			replace region = "europe" if country == "Yugoslavia (former)"
			replace region = "europe" if country == "Czechoslovakia (former)"
			replace region = "europe" if country == "Greenland"
			replace region = "europe" if country == "Kosovo"
			replace region = "europe" if country == "Montenegro"
			replace region = "europe" if country == "Northern Ireland"
			replace region = "europe" if country == "Other Europe"
			replace region = "europe" if country == "San Marino"
			replace region = "europe" if country == "Serbia"
			replace region = "europe" if country == "Serbia and Montenegro (former)"
			replace region = "europe" if country == "Slovakia"
			replace region = "europe" if country == "Soviet Union (former)"
			replace region = "europe" if country == "Unknown republic, former Czechoslovakia"
			replace region = "europe" if country == "Unknown republic, former Soviet Union"
			replace region = "europe" if country == "Unknown, former Yugoslavia"
			replace region = "europe" if country == "Yugoslavia (former)"
			replace region = "europe" if country == "Serbia and Montenegro"
			
			replace region = "north america" if country == "Canada"
			replace region = "north america" if country == "Mexico"
			replace region = "north america" if country == "United States"
			replace region = "north america" if country == "Anguilla"
			replace region = "north america" if country == "Antigua-Barbuda"
			replace region = "north america" if country == "Aruba"
			replace region = "north america" if country == "Bahamas, The"
			replace region = "north america" if country == "Barbados"
			replace region = "north america" if country == "Bermuda"
			replace region = "north america" if country == "British Virgin Islands"
			replace region = "north america" if country == "Cayman Islands"
			replace region = "north america" if country == "Cuba"
			replace region = "north america" if country == "Dominica"
			replace region = "north america" if country == "Dominican Republic"
			replace region = "north america" if country == "Grenada"
			replace region = "north america" if country == "Guadeloupe"
			replace region = "north america" if country == "Haiti"
			replace region = "north america" if country == "Jamaica"
			replace region = "north america" if country == "Martinique"
			replace region = "north america" if country == "Montserrat"
			replace region = "north america" if country == "Netherlands Antilles"
			replace region = "north america" if country == "Puerto Rico"
			replace region = "north america" if country == "St. Kitts-Nevis"
			replace region = "north america" if country == "St. Lucia"
			replace region = "north america" if country == "St. Vincent and the Grenadines"
			replace region = "north america" if country == "Trinidad and Tobago"
			replace region = "north america" if country == "Turks and Caicos Islands"
			replace region = "north america" if country == "U.S. Virgin Islands"
			replace region = "north america" if country == "Belize"
			replace region = "north america" if country == "Costa Rica"
			replace region = "north america" if country == "El Salvador"
			replace region = "north america" if country == "Guatemala"
			replace region = "north america" if country == "Honduras"
			replace region = "north america" if country == "Nicaragua"
			replace region = "north america" if country == "Panama"
			replace region = "north america" if country == "Bahamas"
			replace region = "north america" if country == "Curacao"
			replace region = "north america" if country == "Other Caribbean"
			replace region = "north america" if country == "Other North America"
			replace region = "north america" if country == "Saint Kitts and Nevis"
			replace region = "north america" if country == "Saint Lucia"
			replace region = "north america" if country == "Saint Vincent and the Grenadines"
			replace region = "north america" if country == "Sint Maarten"
			replace region = "north america" if country == "St. Pierre and Miquelon"

			replace region = "oceania" if country == "American Samoa"
			replace region = "oceania" if country == "Australia"
			replace region = "oceania" if country == "Cook Islands"
			replace region = "oceania" if country == "Fiji"
			replace region = "oceania" if country == "French Polynesia"
			replace region = "oceania" if country == "Kiribati"
			replace region = "oceania" if country == "Marshall Islands"
			replace region = "oceania" if country == "Micronesia, Federated States"
			replace region = "oceania" if country == "Nauru"
			replace region = "oceania" if country == "New Caledonia"
			replace region = "oceania" if country == "New Zealand"
			replace region = "oceania" if country == "Northern Mariana Islands"
			replace region = "oceania" if country == "Palau"
			replace region = "oceania" if country == "Papua New Guinea"
			replace region = "oceania" if country == "Samoa"
			replace region = "oceania" if country == "Solomon Islands"
			replace region = "oceania" if country == "Tonga"
			replace region = "oceania" if country == "Tuvalu"
			replace region = "oceania" if country == "Vanuatu"
			replace region = "oceania" if country == "Guam"
			replace region = "oceania" if country == "Niue"
			replace region = "oceania" if country == "Other Oceania"
			replace region = "oceania" if country == "Pitcairn Island"
			replace region = "oceania" if country == "Wallis and Futuna Islands"
			
			replace region = "south america" if country == "Argentina"
			replace region = "south america" if country == "Bolivia"
			replace region = "south america" if country == "Brazil"
			replace region = "south america" if country == "Chile"
			replace region = "south america" if country == "Colombia"
			replace region = "south america" if country == "Ecuador"
			replace region = "south america" if country == "French Guiana"
			replace region = "south america" if country == "Guyana"
			replace region = "south america" if country == "Paraguay"
			replace region = "south america" if country == "Peru"
			replace region = "south america" if country == "Suriname"
			replace region = "south america" if country == "Uruguay"
			replace region = "south america" if country == "Venezuela"
			replace region = "south america" if country == "Falkland Islands"
			replace region = "south america" if country == "Other South America"
			
			replace region = "other" if country == "All other countries"
			replace region = "other" if country == "Not specified"
			replace region = "other" if country == "Other republics"
			replace region = "other" if country == "Other, not specified"
			replace region = "other" if country == "Unknown or not reported"
			
				* check 
				br country if region == "."
				
			
			order region , before(country)
			
			compress 

			
* Save as dta. file and export to excel
* =====================================

save "$tabledir/refugees1996-2018.dta", replace 

export excel using "$tabledir/2020.08.17 refugees1996-2018.xlsx", sheet("data", modify) firstrow(variables)  missing(".")


	clear all
							
		
	
	/* Notes for write-up
	   ==========================
	
	1. 
	   
	2. 
	
 
	


