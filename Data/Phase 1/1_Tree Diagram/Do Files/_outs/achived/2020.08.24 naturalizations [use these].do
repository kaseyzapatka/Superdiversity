/* Superdiveristy Project: Phase 1: Tree Diagram 
 * =======================================================
  
 * File: 2020.08.24 naturalizations.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare naturalizations data for Tree Diagram for Phase 1 of Superdiveristy Project
 * Data: 
 
	- naturalizations, (Tables 20 to 24) 
		- [all of table 21]
	
 * Date Last Updated: 2020.08.24 */ 
 

* Load data: 2009-2018: Refugees 
* ===================================
import excel "$rawdir/Naturalizations/fy2009-2018_table21d.xlsx", clear

	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B naturalized2009
		rename C naturalized2010
		rename D naturalized2011
		rename E naturalized2012
		rename F naturalized2013
		rename G naturalized2014
		rename H naturalized2015
		rename I naturalized2016
		rename J naturalized2017
		rename K naturalized2018
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist naturalized2009-naturalized2013 {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 202/208
	   
		* destring
		destring naturalized2009-naturalized2013, replace 
		
		compress
	

		* file edits 
		* ------------
		replace country = "All other countries" if country == "All other countries 2"
		
		replace country = "South Korea" if country == "Korea, South 1"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
	* save file 
	save "$savedir/Naturalizations/naturalized2009-2018.dta", replace
	
	clear all 

* Load data: 1999-2008: Refugees 
* ===================================
import excel "$rawdir/Naturalizations/fy1999-2008_table21d.xls", clear

	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B naturalized1999
		rename C naturalized2000
		rename D naturalized2001
		rename E naturalized2002
		rename F naturalized2003
		rename G naturalized2004
		rename H naturalized2005
		rename I naturalized2006
		rename J naturalized2007
		rename K naturalized2008
		
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist naturalized1999-naturalized2007 {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
				
	   }
	   
	* drop the last rows that are notes
	drop in 200/347
	
	   
		* destring
		destring naturalized1999-naturalized2007, replace 
		
		compress
	

		* file edits 
		* ------------
		replace country = "Korea" if country == "Korea 1"
		
		replace country = "Yugoslavia (former)" if country == "Serbia and Montenegro 2"
		
		replace country = "Saint Kitts and Nevis" if country == "Saint Kitts-Nevis"
		
		replace country = "Eswatini (formerly Swaziland)" if country == "Swaziland"

		
	* save file 
	save "$savedir/Naturalizations/naturalized1999-2008.dta", replace
	 
	clear all 
	
	
* Load data: 1995-2005: Refugees 
* ===================================
import excel "$rawdir/Naturalizations/fy1996-2005_table21d.xls", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B naturalized1996
		rename C naturalized1997
		rename D naturalized1998
		
	drop E-K // drop 2005 and higher bc got them in last dataset
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
		replace `v' = "." if `v' == "X"
		replace `v' = "." if `v' == "NA"
				
	   }
	   
	* drop the last rows that are notes
	drop in 198/344
	   
		* destring
		destring *, replace 
		
		compress
	

		* file edits 
		* ------------
		replace country = "Yugoslavia (former)" if country == "Serbia and Montenegro1"
		
		replace country = "Saint Kitts and Nevis" if country == "Saint Kitts-Nevis"
		
		replace country = "Eswatini (formerly Swaziland)" if country == "Swaziland"
		
		
	* save file 
	save "$savedir/Naturalizations/naturalized1996-1998.dta", replace
	 
	clear all 
	
	

* Merge Refugee data and final cleaning
* ===================================
cd "$savedir/Naturalizations"
use "naturalized2009-2018.dta", clear
	
	* merge all years together
	merge 1:1 country using "naturalized1999-2008.dta"
		drop _merge
	merge 1:1 country using "naturalized1996-1998.dta"
		drop _merge
	
	
		* reshape data to long
		* -------------------
		reshape long naturalized, i(country) j(year)
			
				
				* edits to completed file
				* -----------------------				
				replace country = "North Korea" if country == "Korea, North"
				
				replace country = "South Korea" if country == "Korea, South" 
				
				replace country = "Unknown republic (former Czechoslovakia)" if country == "Unknown republic, former Czechoslovakia"
				
				replace country = "Unknown republic (former Soviet Union)" if country == "Unknown republic, former Soviet Union"
				
				replace country = "Unknown republic (former Yugoslavia" if country == "Unknown, former Yugoslavia"
				
				replace country = "Democratic Republic of the Congo" if country == "Congo, Democratic Republic"
				
				replace country = "Republic of the Congo" if country == "Congo, Republic"
				
				replace country = "People's Republic of China" if country == "China, People's Republic"
				
				replace country = "Federated States of Micronesia" if country == "Micronesia, Federated States"
				
				
				
		* create region variables (use "LPR_cheet stata code.xlsx")
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
			replace region = "Asia" if country == "Tibet"
			replace region = "Asia" if country == "Palestine"
			
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
			replace region = "Europe" if country == "Serbia and Montenegro"
			replace region = "Europe" if country == "Czechia"
			
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
			replace region = "North America" if country == "St. Kitts-Nevis"
			replace region = "North America" if country == "St. Lucia"
			replace region = "North America" if country == "St. Vincent and the Grenadines"
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
			replace region = "North America" if country == "St. Pierre and Miquelon"
			replace region = "North America" if country == "Netherlands Antilles (former)"

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
			replace region = "Other" if country == "Stateless"
			replace region = "Other" if country == "Unknown"
			
				* check 
				br country if region == "."
				
			
			order region , before(country)
			
			compress 
			
		
		* drop data for 1996 and 1997 to preserve consitency over 20 years: 1998-2018
		* ---------------------------------------------------------------------------
		drop if year == 1996 | year == 1997
						
		
	
	/* Notes for write-up
	   ==========================
	
	1. Note: Based on N-400 data for persons aged 18 and over.
	   
	2. "Korea" includes both North and South Korea
	
	3. There will be some discrepencies in total counts for each country by year because of data supression. Values do not
	   correctly sum in DHS datasets
	
 
	


