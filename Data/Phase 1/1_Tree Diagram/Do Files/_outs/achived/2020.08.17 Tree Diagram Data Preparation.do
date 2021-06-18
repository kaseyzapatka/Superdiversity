/* Superdiveristy Project: Phase 1: Tree Diagram 
 * =======================================================
  
 * File: 2020.08.17 Tree Diagram Data Preparation.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Tree Diagram for Phase 1 of Superdiveristy Project
 * Data: 
 
	- can be accessed on DHS website : https://www.dhs.gov/immigration-statistics/yearbook
	- 
	
 * Date Last Updated: 2020.08.17 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/DHS"
global savedir "${db}/Phase 1/1_Tree Diagram/Recoded"
global tabledir "${db}/Phase 1/1_Tree Diagram/Tables"
global dofiledir "${db}/Phase 1/1_Tree Diagram/Do Files"


	* run legal permanent residents do.files 
	* ===================================
	do "$dofiledir/legal permanent residents.do"
		
	* run refugees and asylees do.files 
	* ===================================
	do "$dofiledir/refugees.do"
	
	do "$dofiledir/affirm-asylees.do"
	
	do "$dofiledir/defend-asylees.do"
	
	* run naturalizations do.file 
	* ===================================
	do "$dofiledir/naturalizations.do"
	
	* run non-immigrant do.file
	* ===================================
	do "$dofiledir/non-immigrants.do"
	
	
	
* Merge Refugee data
* ===================================
cd "$tabledir"
use "affirm-asylees1996-2018.dta", clear

			
	* merge all years together
	merge 1:1 country year using "defend-asylees1996-2018.dta"
		drop _merge
	merge 1:1 country year using "refugees1996-2018.dta"
		drop _merge
		
		
	merge 1:1 country year using "refugees1996-2018.dta"
		drop _merge
	
	
	
	
	
		* variables 
		* ===========
		- sending regions and countries, 
		- categories of admissions, 
		- year of admission. 
 
 
		* scope 
		* ========
		compile for each year 1996-2018 
		
		status groups 
		- lawful permanent residents, (Tables 1 to 12) 
				- [all of table 10]
		- refugees and asylees, (Tables 13 to 19) 
				- [all of table 14, 17, 19]
		- naturalizations, (Tables 20 to 24) 
				- [all of table 21]
		- non-immigrant admissions (Tables 25 to 32)
				- [all of table 28] - supplemental table 2 for 2004 and younger?
		
		
		immigrant classes of admission
			- family-based, 
			- employment-based, 
			- diversity visas, 
			- refugees and asylees
			- residual category (other). 
			
		non-immigrant
			- temporary workers and their families, 
			- students and exchange visitors, 
			- diplomats, 
			- tourists and business travelers, 
			- residual category (other). 
	
	// 1996
	- not specified 
	- other "region"
	- others
	
	
	/* Notes for write-up
	   ==========================
	
	1. Why is there data on Korea until 2008?
	   
	2. Why is there data on US
	


