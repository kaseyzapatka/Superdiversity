/* Superdiveristy Project: Phase 1: Tree Diagram 
 * =======================================================
  
 * File: 2020.08.16 legal permanent residents.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Tree Diagram for Phase 1 of Superdiveristy Project
 * Data: 
 
	- 
	- 
	
 * Date Last Updated: 2020.08.16 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/DHS"
global savedir "${db}/Phase 1/1_Tree Diagram/Recoded"
global tabledir "${db}/Phase 1/1_Tree Diagram/Tables"


* Load data: 2018: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2018_table10d.xlsx", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C relative
		rename D family_sponsored
		rename E employment
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 199/202
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2018
				
	   }

		* file edits 
		* ------------
		replace country = "All other countries" if country == "All other countries1"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "Cape Verde" if country == "Cabo Verde"
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
	
	* save file 
	save "$savedir/Legal Permanent Residents/2018.dta", replace
	 
	clear all 
	 
* Load data: 2017: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2017_table10d.xlsx", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C relative
		rename D family_sponsored
		rename E employment
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 201/204
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2017
				
	   }

		* file edits 
		* ------------
		replace country = "All other countries" if country == "All other countries1"
		
		replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
		
		replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
		
		replace country = "Cape Verde" if country == "Cabo Verde" 
		
		replace country = "Czech Republic" if country == "Czechia"
		
		replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
		
		replace country = "British Virgin Islands" if country == "Virgin Islands, British"
		
	* save file 
	save "$savedir/Legal Permanent Residents/2017.dta", replace
	 
	clear all 

* Load data: 2016: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2016_table10d.xls", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 204/207
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2016
				
	   }
	   
	   * file edits 
	   * ------------
	   replace country = "All other countries" if country == "All other countries 1"
	   
	   replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
	   
	   replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
	   
	   replace country = "Cape Verde" if country == "Cabo Verde"
	   
	   replace country = "Czech Republic" if country == "Czechia"
	   
	   replace country = "Netherlands Antilles" if country == "Netherlands Antilles (former)"
	   
	   replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
	   
	   replace country = "British Virgin Islands" if country == "Virgin Islands, British"

	* save file 
	save "$savedir/Legal Permanent Residents/2016.dta", replace
	 
	clear all 
	
	
* Load data: 2015: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2015_table10d.xls", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 201/204
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2015
				
	   }
		
		* file edits 
		* ------------
		replace country = "All other countries" if country == "All other countries1"
		
		replace country = "Netherlands Antilles" if country == "Netherlands Antilles (former)"
		
	* save file 
	save "$savedir/Legal Permanent Residents/2015.dta", replace
	 
	clear all 
	
* Load data: 2014: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2014_table10d.xls", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 200/203
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2014
				
	   }

		* file edits 
		* ------------	
		replace country = "Netherlands Antilles" if country == "Netherlands Antilles (former)"
		
		replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro"
		
	* save file 
	save "$savedir/Legal Permanent Residents/2014.dta", replace
	 
	clear all 
	
* Load data: 2013: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2013_table10d.xls", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 195/199
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2013
				
	   }

		* file edits 
		* ------------		
		replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro"
		
	* save file 
	save "$savedir/Legal Permanent Residents/2013.dta", replace
	 
	clear all 

* Load data: 2012: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2012_table10d.xls", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 200/203
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2012
				
	   }

		* file edits 
		* ------------	
		replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro 1"
		
	* save file 
	save "$savedir/Legal Permanent Residents/2012.dta", replace
	 
	clear all
	
* Load data: 2011: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2011_table10d.xls", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 196/199
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2011
				
	   }

		* file edits 
		* ------------	
		replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro 1"
		
		
	* save file 
	save "$savedir/Legal Permanent Residents/2011.dta", replace
		 
	clear all

* Load data: 2010: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2010_table10d.xlsx", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 202/205
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2010
				
	   }

		* file edits 
		* ------------
		replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro1"
		
	* save file 
	save "$savedir/Legal Permanent Residents/2010.dta", replace
	
	clear all

* Load data: 2009: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2009_table10d.xlsx", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 202/208
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2009
				
	   }
		
		* file edits 
		* ------------
		replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro1"
		
	* save file 
	save "$savedir/Legal Permanent Residents/2009.dta", replace
		 
	clear all
		 
* Load data: 2008: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2008_table10d.xls", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 196/203
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2008
				
	   }

		* file edits 
		* ------------
		replace country = "Korea" if country == "Korea1"
		
		replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro2"
		
	* save file 
	save "$savedir/Legal Permanent Residents/2008.dta", replace
	 
	clear all
	
* Load data: 2007: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2007_table10d.xls", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 196/202
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2007
				
	   }

		* file edits 
		* ------------
		replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro1"
		
	* save file 
	save "$savedir/Legal Permanent Residents/2007.dta", replace
	 
	clear all
	 
* Load data: 2006: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2006_table10d.xls", clear


	* drop the first 15 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/15
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 197/204
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2006
				
	   }
	
		
		* file edits 
		* ------------
		replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro 1"
		
	* save file 
	save "$savedir/Legal Permanent Residents/2006.dta", replace
	 
	clear all
	 
* Load data: 2005: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2005_table10d.xls", clear


	* drop the first 18 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/18
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename F diversity
		rename G refugee_assylee
		rename H other
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 195/198
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2005
				
	}

		* file edits 
		* ------------
		replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro¹"
		
		
		* save file 
		save "$savedir/Legal Permanent Residents/2005.dta", replace
	 
		clear all
	 
* Load data: 2004: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2004_table08d.xls", clear


	* drop the first 9 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/9
	
	drop M-AM
  
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename J diversity
		rename I refugee_assylee
		rename L other
		
		drop F G H K
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 222/228
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2004
				
	 }
	   
		* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
		drop if country == "Asia"
		drop if country == "Africa"
		drop if country == "Europe"
		drop if country == "North America"
		drop if country == "Oceania"
		drop if country == "Central America"
		drop if country == "South America"
		drop if country == "Caribbean"
		
	* sort by country to order dataset like others
	sort country
		
		* file edits 
		* ------------
		replace country = "Unknown" if country == "Unknown or not reported"
		
		replace country = "United Kingdom" if country == "United Kingdom 3"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "Czechoslovakia (former)" if country == "Czechoslovakia 1"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "Jordan" if country == "Jordan 4"
		
		replace country = "Sao Tome and Principe" if country == "Sao Tome & Principe"
		
		replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro 2"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union 1"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent & the Grenadines"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Trinidad and Tobago" if country == "Trinidad & Tobago"
		
		replace country = "Turks and Caicos Islands" if country == "Turks & Caicos Islands"
		
		
		
	   
	* save file
	save "$savedir/Legal Permanent Residents/2004.dta", replace

	clear all
		 
	 
* Load data: 2003: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2003_table08d.xls", clear


	* drop the first 9 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/9
	
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename J diversity
		rename I refugee_assylee
		rename L other
		
		drop F G H K
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 222/228
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2003
				
	 }
	   
		* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
		drop if country == "Asia"
		drop if country == "Africa"
		drop if country == "Europe"
		drop if country == "North America"
		drop if country == "Oceania"
		drop if country == "Central America"
		drop if country == "South America"
		drop if country == "Caribbean"
		
	* sort by country to order dataset like others
	sort country
		

		* file edits 
		* ------------
		replace country = "Unknown" if country == "Unknown or not reported"
		
		replace country = "United Kingdom" if country == "United Kingdom 3"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "Czechoslovakia (former)" if country == "Czechoslovakia 1"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "Jordan" if country == "Jordan 4"
		
		replace country = "Serbia and Montenegro (former)" if country == "Serbia and Montenegro 2"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union 1"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent & the Grenadines"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Trinidad and Tobago" if country == "Trinidad & Tobago"
		
		replace country = "Turks and Caicos Islands" if country == "Turks & Caicos Islands"
	
	* save file
	save "$savedir/Legal Permanent Residents/2003.dta", replace

	clear all
		 
* Load data: 2002: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2002_table08d.xls", clear


	* drop the first 9 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/9
	
	drop M-X
	
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename J diversity
		rename I refugee_assylee
		rename L other
		
		
		drop F G H K
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 234/236
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2002
				
	 }
	   
		* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
		drop if country == "Asia"
		drop if country == "Africa"
		drop if country == "Europe"
		drop if country == "North America"
		drop if country == "Oceania"
		drop if country == "Central America"
		drop if country == "South America"
		drop if country == "Caribbean"
		
	* sort by country to order dataset like others
	sort country
	
	compress

		* file edits 
		* ------------
		replace country = "Unknown" if country == "Unknown or not reported"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "Czechoslovakia (former)" if country == "Czechoslovakia 1"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union 1"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent and the Grenadines"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Yugoslavia, former" if country == "Yugoslavia 1"
		
	* save file
	save "$savedir/Legal Permanent Residents/2002.dta", replace

	clear all
		
* Load data: 2001: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2001_table08d.xls", clear


	* drop the first 9 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/9
	
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename J diversity
		rename I refugee_assylee
		rename L other
		
		
		drop F G H K
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 228/230
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2001
				
	 }
	   
		* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
		drop if country == "Asia"
		drop if country == "Africa"
		drop if country == "Europe"
		drop if country == "North America"
		drop if country == "Oceania"
		drop if country == "Central America"
		drop if country == "South America"
		drop if country == "Caribbean"
		
	* sort by country to order dataset like others
	sort country
	
	compress

		* file edits 
		* ------------
		replace country = "Unknown" if country == "Unknown or not reported"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "Czechoslovakia (former)" if country == "Czechoslovakia 1"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union 1"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent and the Grenadines"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Yugoslavia, former" if country == "Yugoslavia 1"
		
		
	* save file
	save "$savedir/Legal Permanent Residents/2001.dta", replace
	
	clear all

* Load data: 2000: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2000_table08d.xls", clear


	* drop the first 9 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/9
	
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename J diversity
		rename I refugee_assylee
		rename M other
		
		
		drop F G H K L
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 224/227
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2000
				
	 }
	    
	 * trim leading and trailing spaces in string
	 replace country = strtrim(country)
		
		* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
		drop if country == "Asia"
		drop if country == "Africa"
		drop if country == "Europe"
		drop if country == "North America"
		drop if country == "Oceania"
		drop if country == "Central America"
		drop if country == "South America"
		drop if country == "Caribbean"
		
	* sort by country to order dataset like others
	sort country
	
	compress

		* file edits 
		* ------------
		replace country = "Unknown" if country == "Unknown or not reported"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "Czechoslovakia (former)" if country == "Czechoslovakia 2"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union 2"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent and the Grenadines"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Yugoslavia, former" if country == "Yugoslavia 2"
		

		
	* save file
	save "$savedir/Legal Permanent Residents/2000.dta", replace

	clear all

* Load data: 1999: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy1999_table08d.xls", clear


	* drop the first 9 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/9
	
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename J diversity
		rename I refugee_assylee
		rename M other
		
		
		drop F G H K L
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 218/221
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'1999
				
	 }
	    
	 * trim leading and trailing spaces in string
	 replace country = strtrim(country)
		
		* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
		drop if country == "Asia"
		drop if country == "Africa"
		drop if country == "Europe"
		drop if country == "North America"
		drop if country == "Oceania"
		drop if country == "Central America"
		drop if country == "South America"
		drop if country == "Caribbean"
		
	* sort by country to order dataset like others
	sort country
	
	compress

		* file edits 
		* ------------
		replace country = "Unknown" if country == "Unknown or not reported"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "Czechoslovakia (former)" if country == "Czechoslovakia  /2"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union  /2"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent and the Grenadines"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Yugoslavia, former" if country == "Yugoslavia  /2"
		

	
	* save file
	save "$savedir/Legal Permanent Residents/1999.dta", replace

	clear all
	
	
* Load data: 1998: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy1998_table08d.xls", clear


	* drop the first 10 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/10
	
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename J diversity
		rename I refugee_assylee
		rename M other
		
		
		drop F G H K L N O
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 226/228
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'1998
				
	 }

		* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
		drop if country == "Asia"
		drop if country == "Africa"
		drop if country == "Europe"
		drop if country == "North America"
		drop if country == "Oceania"
		drop if country == "Central America"
		drop if country == "South America"
		drop if country == "Caribbean"

		
	* sort by country to order dataset like others
	sort country
	
	compress
		

		* file edits 
		* ------------
		* cleaning errors
		replace country = "Unknown, former Yugoslavia" if country == "Unknown "
		replace country = "Unknown republic, former Soviet Union" if country == "Unknown republic" & total1998 == 6336
		replace country = "Unknown republic, former Czechoslovakia" if country == "Unknown republic" & total1998 == 342
		
		replace country = "Unknown" if country == "Unknown or not reported"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "Congo, Republic" if country == "Congo, Republic "
		
		replace country = "Czechoslovakia (former)" if country == "Czechoslovakia, former"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "Micronesia, Federated States" if country == "Micronesia Federated States"
		
		replace country = "Sao Tome and Principe" if country == "Sao Tome & Principe"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union, former"
		
		replace country = "Saint Vincent and the Grenadines" if country == "St. Vincent & the Grenadines"
		
		replace country = "Saint Lucia" if country == "St. Lucia"
		
		replace country = "Trinidad and Tobago" if country == "Trinidad & Tobago"
		
		replace country = "Turks and Caicos Islands" if country == "Turks & Caicos Islands"
		
		replace country = "Wallis and Futuna Islands" if country == "Wallis & Futuna Islands"

		
	* save file
	save "$savedir/Legal Permanent Residents/1998.dta", replace

	clear all
		

		
		
									*******
									*Missing 1997
									*******
		
		
	
* Load data: 1996: LPR 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy1996_table08d.xlsx", clear


	* drop the first 14 rows bc they are country level aggregates 
	* ----------------------------------------------------------
	drop in 1/14
	
		* rename each row 
		rename A country
		rename B total
		rename C family_sponsored
		rename D employment
		rename E relative
		rename J diversity
		rename I refugee_assylee
		rename M other
		
		
		drop F G H K L 
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "." if `v' == "-"
		replace `v' = "." if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 120/125
	drop in 118
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'1996
				
	 }

		* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
		drop if country == "Asia"
		drop if country == "Africa"
		drop if country == "Europe"
		drop if country == "North America"
		drop if country == "Oceania"
		drop if country == "Central America"
		drop if country == "South America"
		drop if country == "Caribbean"
		
	* sort by country to order dataset like others
	sort country
	
	compress

		* file edits 
		* ------------
		replace country = "Unknown" if country == "Unknown or not reported"
		
		replace country = "Bahamas" if country == "Bahamas, The"
		
		replace country = "Czechoslovakia (former)" if country == "Czechoslovakia, former"
		
		replace country = "Gambia" if country == "Gambia, The"
		
		replace country = "Soviet Union (former)" if country == "Soviet Union, former"
		
		replace country = "Trinidad and Tobago" if country == "Trinidad & Tobago"
		
		
	
	* save file
	save "$savedir/Legal Permanent Residents/1996.dta", replace

	clear all
	
	

* Merge LPR data
* ===================================
cd "$savedir/Legal Permanent Residents"
use "2018.dta", clear
			 
	* merge all years together
	merge 1:1 country using "2017.dta"	
		drop _merge
	merge 1:1 country using "2016.dta"
		drop _merge
	merge 1:1 country using "2015.dta"
		drop _merge
	merge 1:1 country using "2014.dta"
		drop _merge
	merge 1:1 country using "2013.dta"
		drop _merge
	merge 1:1 country using "2012.dta"
		drop _merge
	merge 1:1 country using "2011.dta"
		drop _merge
	merge 1:1 country using "2010.dta"
		drop _merge
	merge 1:1 country using "2009.dta"
		drop _merge
	merge 1:1 country using "2008.dta"
		drop _merge
	merge 1:1 country using "2007.dta"
		drop _merge
	merge 1:1 country using "2006.dta"
		drop _merge
	merge 1:1 country using "2005.dta"
		drop _merge
	merge 1:1 country using "2004.dta"
		drop _merge
	merge 1:1 country using "2003.dta"
		drop _merge
	merge 1:1 country using "2002.dta"	
		drop _merge
	merge 1:1 country using "2001.dta"
		drop _merge
	merge 1:1 country using "2000.dta"
		drop _merge
	merge 1:1 country using "1999.dta"
		drop _merge
	merge 1:1 country using "1998.dta"
		drop _merge
	merge 1:1 country using "1996.dta"
		drop _merge
	
		* reshape data to long
		* -------------------
		reshape long total relative family_sponsored employment diversity refugee_assylee other, i(country) j(year)
			
				
				* edits to completed file
				* -----------------------
				drop if country == "      French Southern & Antarctic Lands" 
				drop if country == "Sao Tome & Principe" 
				
				replace country = "Unknown or not reported" if country == "Unknown" // these were recoded differently in 1996
				
				replace country = "Réunion" if country == "Reunion" // these were recoded differently in 1996
				
				replace country = "Saint Kitts and Nevis" if country == "Saint Kitts-Nevis"
				
				replace country = "Yugoslavia (former)" if country == "Yugoslavia, former"
				
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

save "$tabledir/legal-perm-res1996-2018.dta", replace 

export excel using "$tabledir/2020.08.17 legal-perm-res1996-2018.xlsx", sheet("data", modify) firstrow(variables)  missing(".")


	clear all
	
		
	
	/* Notes for write-up
	   ==========================
	
	1. Renamed the "Czechia" to the "Czech Republic" for consistency.
	   
	2. Central America and the Caribbean were included in the North American region
	
	3. Check all the non-specified countries 
	


