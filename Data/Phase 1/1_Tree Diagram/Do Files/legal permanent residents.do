/* Superdiveristy Project: Phase 1: Tree Diagram 
 * =======================================================
  
 * File: 2021.01.28 legal permanent residents.do
 * Author: Kasey Zapatka 
 * Purpose: Clean and prepare legal permanent data for Tree Diagram for Phase 1 of Superdiveristy Project
 * Data:
 
	- Department of Homeland Security yearbook dataset : https://www.dhs.gov/immigration-statistics/yearbook
		
	- Tabels 1-12 : https://www.dhs.gov/immigration-statistics/yearbook/2019
	- 2019 thru 1998
	
 * Date Last Updated: 2021.01.28 */ 
 


		
* Load data: 2019: legal permanent residents 
* ===================================
import excel "$rawdir/Legal Permanent Residents/fy2019_table10d.xlsx", clear


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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
	   }
	   
	* drop the last rows that are notes
	drop in 201/204
	   
		* destring
		destring *, replace 
		
		compress
		
	* run loop to rename each variable with year suffix
	foreach v of varlist total-other {
		
		rename `v' `v'2019
				
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
		
		replace country = "Swaziland" if country == "Eswatini (formerly Swaziland)"
		
		replace country = "Macedonia" if country == "North Macedonia (formerly Macedonia)"
		
		replace country = "Netherlands Antilles" if country == "Netherlands Antilles (former)"
	
	* save file 
	save "$savedir/Legal Permanent Residents/2019.dta", replace
	 
	clear all 

* Load data: 2018: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
		
		replace country = "Swaziland" if country == "Eswatini (formerly Swaziland)"
	
	* save file 
	save "$savedir/Legal Permanent Residents/2018.dta", replace
	 
	clear all 
	 
* Load data: 2017: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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

* Load data: 2016: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
	
	
* Load data: 2015: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
	
* Load data: 2014: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
	
* Load data: 2013: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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

* Load data: 2012: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
	
* Load data: 2011: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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

* Load data: 2010: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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

* Load data: 2009: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
		 
* Load data: 2008: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
	
* Load data: 2007: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
	 
* Load data: 2006: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
	 
* Load data: 2005: legal permanent residents 
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
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
	 
* Load data: 2004: legal permanent residents 
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
		rename K cancellation
		rename I refugee_assylee
		rename L other
		
		drop F G H 
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
		replace country = "Trinidad and Tobago" if country == "Trinidad & Tobago"
		
		replace country = "Turks and Caicos Islands" if country == "Turks & Caicos Islands"
		
		
	* combine "cancellation" with "other" into one variable
	* ----------------------------------------------------------
	rename other residual
			
	gen other2004 = cancellation + residual 
				
		* drop extra variables 
		drop residual cancellation
		
		
	* save file
	save "$savedir/Legal Permanent Residents/2004.dta", replace

	clear all
		 
	 
* Load data: 2003: legal permanent residents 
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
		rename K cancellation
		rename I refugee_assylee
		rename L other
		
		drop F G H
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
		replace country = "Trinidad and Tobago" if country == "Trinidad & Tobago"
		
		replace country = "Turks and Caicos Islands" if country == "Turks & Caicos Islands"
	
	* combine "cancellation" with "other" into one variable
	* ----------------------------------------------------------
	rename other residual
			
	gen other2003 = cancellation + residual 
				
		* drop extra variables 
		drop residual cancellation
	
	
	* save file
	save "$savedir/Legal Permanent Residents/2003.dta", replace

	clear all
		 
* Load data: 2002: legal permanent residents 
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
		rename K cancellation
		rename I refugee_assylee
		rename L other
		
		
		drop F G H
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
		replace country = "Yugoslavia, former" if country == "Yugoslavia 1"
		
		
	* combine "cancellation" with "other" into one variable
	* ----------------------------------------------------------
	rename other residual
			
	gen other2002 = cancellation + residual 
				
		* drop extra variables 
		drop residual cancellation
		
	
	* save file
	save "$savedir/Legal Permanent Residents/2002.dta", replace

	clear all
		
* Load data: 2001: legal permanent residents 
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
		rename K cancellation
		rename I refugee_assylee
		rename L other
		
		
		drop F G H 
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
		replace country = "Yugoslavia, former" if country == "Yugoslavia 1"
		
		
	* combine "cancellation" with "other" into one variable
	* ----------------------------------------------------------
	rename other residual
			
	gen other2001 = cancellation + residual 
				
		* drop extra variables 
		drop residual cancellation
		
		
	* save file
	save "$savedir/Legal Permanent Residents/2001.dta", replace
	
	clear all

* Load data: 2000: legal permanent residents 
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
		rename K IRCA
		rename L cancellation
		rename I refugee_assylee
		rename M other
		
		
		drop F G H 
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "        -"
		replace `v' = "0" if `v' == "D"
				
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
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
		replace country = "Yugoslavia, former" if country == "Yugoslavia 2"
		
		
	* combine "cancellation" with "other" into one variable
	* ----------------------------------------------------------
	rename other residual
			
	gen other2000 = IRCA + cancellation + residual 
				
		* drop extra variables 
		drop  residual  IRCA cancellation
		
		
	* save file
	save "$savedir/Legal Permanent Residents/2000.dta", replace

	clear all

* Load data: 1999: legal permanent residents 
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
		rename K IRCA
		rename L cancellation
		rename I refugee_assylee
		rename M other
		
		
		drop F G H 
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
		replace country = "Yugoslavia, former" if country == "Yugoslavia  /2"
		

	* combine "cancellation" with "other" into one variable
	* ----------------------------------------------------------
	rename other residual
			
	gen other1999 = IRCA + cancellation + residual 
				
		* drop extra variables 
		drop  residual  IRCA cancellation
	
	* save file
	save "$savedir/Legal Permanent Residents/1999.dta", replace

	clear all
	
	
* Load data: 1998: legal permanent residents 
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
		rename K IRCA
		rename L cancellation
		rename I refugee_assylee
		rename M other
		
		
		drop F G H N O
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
		replace country = "Unknown republic (former Yugoslavia)" if country == "Unknown " & total1998 == 2408
		
		replace country = "Unknown republic (former Soviet Union)" if country == "Unknown republic" & total1998 == 6336
		
		replace country = "Unknown republic (former Czechoslovakia)" if country == "Unknown republic" & total1998 == 342
		
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
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
		replace country = "Trinidad and Tobago" if country == "Trinidad & Tobago"
		
		replace country = "Turks and Caicos Islands" if country == "Turks & Caicos Islands"
		
		replace country = "Wallis and Futuna Islands" if country == "Wallis & Futuna Islands"

	
	* combine "cancellation" with "other" into one variable
	* ----------------------------------------------------------
	rename other residual
			
	gen other1998 = IRCA + cancellation + residual 
				
		* drop extra variables 
		drop  residual  IRCA cancellation
		
		
	* save file
	save "$savedir/Legal Permanent Residents/1998.dta", replace

	clear all
		
	
									**************
									* Missing 1997: will drop 1997 and 1996 
									**************
		
		
	
* Load data: 1996: legal permanent residents 
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
		rename K IRCA
		rename L cancellation
		rename I refugee_assylee
		rename M other
		
		
		drop F G H  
		
	* run loop to filter out missing (-) and suppressed (D)
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
				
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
		
		replace country = "Saint Kitts-Nevis" if country == "St. Kitts-Nevis"
		
	* combine "cancellation" with "other" into one variable
	* ----------------------------------------------------------
	rename other residual
			
	gen other1996 = IRCA + cancellation + residual 
				
		* drop extra variables 
		drop  residual  IRCA cancellation
	
	* save file
	save "$savedir/Legal Permanent Residents/1996.dta", replace

	clear all
	
	

* Merge legal permanent residents data
* ===================================
cd "$savedir/Legal Permanent Residents"
use "2019.dta", clear
			 
	* merge all years together
	merge 1:1 country using "2018.dta"	
		drop _merge
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
		
				* replace missing with 0s so that they properly sum 
				* ----------------------------------------------------------
				order country, first 
					
					* run loop to replace missing with 0s
					foreach v of varlist year-other {
						
						replace `v' = 0 if `v' == .
								
					} 
		
			* save for collapse command
			save "$savedir/Legal Permanent Residents/LPR1998_2019.dta", replace 
			
				
* Merge legal permanent residents data
* ===================================
do "$dofiledir/legal permanent residents_sum.do"
			
				
		* major edits to completed file
		* -----------------------
		
				drop if country == "      French Southern & Antarctic Lands" 
				
				drop if country == "Sao Tome & Principe" 
				
				replace country = "Unknown or not reported" if country == "Unknown" // these were recoded differently in 1996
				
				replace country = "Réunion" if country == "Reunion" // these were recoded differently in 1996
				
				replace country = "Saint Kitts and Nevis" if country == "Saint Kitts-Nevis"
				
				replace country = "Yugoslavia (former)" if country == "Yugoslavia, former"
				
				replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
				
				replace country = "Saint Helena" if country == "St. Helena"
				
				replace country = "Saint Pierre and Miquelon" if country == "St. Pierre and Miquelon"
				
				replace country = "Eswatini" if country == "Swaziland"
				
				replace country = "Republic of the Congo" if country == "Congo, Republic"
				
				replace country = "Democratic Republic of the Congo" if country == "Congo, Democratic Republic"
				
				replace country = "Federated States of Micronesia" if country == "Micronesia, Federated States of"
				
				replace country = "North Korea" if country == "Korea, North"
				
				replace country = "South Korea" if country == "Korea, South"
				
				replace country = "People's Republic of China" if country == "China, People's Republic"
				
				replace country = "Myanmar (Burma)" if country == "Burma"
				
				
			
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
			replace region = "Africa" if country == "Eswatini"
			replace region = "Africa" if country == "Gambia"
			replace region = "Africa" if country == "Other Africa"
			replace region = "Africa" if country == "Réunion"
			replace region = "Africa" if country == "South Sudan"
			
			replace region = "Americas" if country == "Canada"
			replace region = "Americas" if country == "Mexico"
			replace region = "Americas" if country == "United States"
			replace region = "Americas" if country == "Anguilla"
			replace region = "Americas" if country == "Antigua-Barbuda"
			replace region = "Americas" if country == "Aruba"
			replace region = "Americas" if country == "Bahamas, The"
			replace region = "Americas" if country == "Barbados"
			replace region = "Americas" if country == "Bermuda"
			replace region = "Americas" if country == "British Virgin Islands"
			replace region = "Americas" if country == "Cayman Islands"
			replace region = "Americas" if country == "Cuba"
			replace region = "Americas" if country == "Dominica"
			replace region = "Americas" if country == "Dominican Republic"
			replace region = "Americas" if country == "Grenada"
			replace region = "Americas" if country == "Guadeloupe"
			replace region = "Americas" if country == "Haiti"
			replace region = "Americas" if country == "Jamaica"
			replace region = "Americas" if country == "Martinique"
			replace region = "Americas" if country == "Montserrat"
			replace region = "Americas" if country == "Netherlands Antilles"
			replace region = "Americas" if country == "Puerto Rico"
			replace region = "Americas" if country == "Saint Kitts-Nevis"
			replace region = "Americas" if country == "Saint Lucia"
			replace region = "Americas" if country == "Saint Vincent and the Grenadines"
			replace region = "Americas" if country == "Trinidad and Tobago"
			replace region = "Americas" if country == "Turks and Caicos Islands"
			replace region = "Americas" if country == "U.S. Virgin Islands"
			replace region = "Americas" if country == "Belize"
			replace region = "Americas" if country == "Costa Rica"
			replace region = "Americas" if country == "El Salvador"
			replace region = "Americas" if country == "Guatemala"
			replace region = "Americas" if country == "Honduras"
			replace region = "Americas" if country == "Nicaragua"
			replace region = "Americas" if country == "Panama"
			replace region = "Americas" if country == "Bahamas"
			replace region = "Americas" if country == "Curacao"
			replace region = "Americas" if country == "Other Caribbean"
			replace region = "Americas" if country == "Other Americas"
			replace region = "Americas" if country == "Saint Kitts and Nevis"
			replace region = "Americas" if country == "Saint Lucia"
			replace region = "Americas" if country == "Saint Vincent and the Grenadines"
			replace region = "Americas" if country == "Sint Maarten"
			replace region = "Americas" if country == "Saint Pierre and Miquelon"
			replace region = "Americas" if country == "Argentina"
			replace region = "Americas" if country == "Bolivia"
			replace region = "Americas" if country == "Brazil"
			replace region = "Americas" if country == "Chile"
			replace region = "Americas" if country == "Colombia"
			replace region = "Americas" if country == "Ecuador"
			replace region = "Americas" if country == "French Guiana"
			replace region = "Americas" if country == "Guyana"
			replace region = "Americas" if country == "Paraguay"
			replace region = "Americas" if country == "Peru"
			replace region = "Americas" if country == "Suriname"
			replace region = "Americas" if country == "Uruguay"
			replace region = "Americas" if country == "Venezuela"
			replace region = "Americas" if country == "Falkland Islands"
			replace region = "Americas" if country == "Other Americas"
			replace region = "Americas" if country == "Other South America"
			replace region = "Americas" if country == "Other North America"
			
			replace region = "Asia" if country == "Afghanistan"
			replace region = "Asia" if country == "Bahrain"
			replace region = "Asia" if country == "Bangladesh"
			replace region = "Asia" if country == "Bhutan"
			replace region = "Asia" if country == "Brunei"
			replace region = "Asia" if country == "Myanmar (Burma)"
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
			replace region = "Europe" if country == "Unknown republic (former Czechoslovakia)"
			replace region = "Europe" if country == "Unknown republic (former Soviet Union)"
			replace region = "Europe" if country == "Unknown republic (former Yugoslavia)"

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
			
			replace region = "Unknown" if country == "All other countries"
			replace region = "Unknown" if country == "Not specified"
			replace region = "Unknown" if country == "Other republics"
			replace region = "Unknown" if country == "Other, not specified"
			replace region = "Unknown" if country == "Unknown or not reported"
			replace region = "Unknown" if country == "Stateless"

			
				* check 
				br country if region == "."
				
			
			order region , before(country)
			
			compress 
			

		
* final cleaning of dataset before export
* =========================================		
	
	* replace missing with 0s so that they properly sum 
	* ----------------------------------------------------------
	order region, first 
	order country, first 
		
		* run loop to replace missing with 0s
		foreach v of varlist year-other {
			
			replace `v' = 0 if `v' == .
					
		} // zero changes should be made
		
						
			* combine "family_sponsored" and "relative" into "family-based" category
			* ----------------------------------------------------------------------
			gen family_based = family_sponsored + relative 
						
				* drop extra variables 
				drop family_sponsored relative
				
				* order variables
				order family_based, after(total)
				
				* check that all vars add too total variable
				gen chk = family_based + employment + diversity + refugee_assylee + other
						
				gen diff = total - chk
						
					fre diff // WILL BE SOME DISCREPENCY BECAUSE OF DATA SUPRESSION 82.24 = 0
					
					pause 
					
						drop chk diff 
						
			* re-calculate total so that they sum correctly
			* ----------------------------------------------------------------------
			rename total old_total	
			
			* check that all vars add too total variable
				gen total = family_based + employment + diversity + refugee_assylee + other
						
				gen diff = old_total - total
						
					fre diff // should be the same fre table as previous diff
					
						drop diff old_total
						
				

	* drop data for 1996 and 1997 to preserve consitency over 20 years: 1998-2018
	* ---------------------------------------------------------------------------
	drop if year == 1996
	
	
	/* Notes for write-up
	   ==========================
	   
	1. Central America and the Caribbean were included in the North American region
	
	2. Check all the non-specified countries 
	
	3. There will be some discrepencies in total counts for each country by year because of data supression. Values do not
	   correctly sum in DHS datasets
	
	4. All missing values (".") represent a zero, an actually missing value, or a value supressed for confidentiality concerns.
	
	5. Data is systematically missing for 1997, so we drop data for 1996 and 1997 so that we have data consistenlty for 20 years: 1998-2018. 
	


