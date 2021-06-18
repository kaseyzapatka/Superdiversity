/* Superdiveristy Project: Phase 1: Tree Diagram 
 * =======================================================
  
 * File: 2020.08.23 Tree Diagram Data Preparation.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Tree Diagram for Phase 1 of Superdiveristy Project
	- data on legal permanent residents
	- data on refugees and asylees
	- data on naturalizations
	- data on non-immigrant admissions 
	
 * Data: 
 
	- can be accessed on DHS website : https://www.dhs.gov/immigration-statistics/yearbook
	 
		* variables 
		* ===========
		- sending regions 
		- countries
		- various categories of admissions for each class
		- year of admission
			- 1998-2018 
		
		status groups 
		* -------------------------
		- lawful permanent residents, (Tables 1 to 12) 
				- [all of table 10]
		- refugees and asylees, (Tables 13 to 19) 
				- [all of table 14, 17, 19]
		- naturalizations, (Tables 20 to 24) 
				- [all of table 21]
		- non-immigrant admissions (Tables 25 to 32)
				- [all of table 28] - 2004 and older data are not consistenly the same table 
		
		
		Categories of admission for each class : Data structure : 4 shees in one excel file
		* ===========================================
		
			1 Legal permanent residents 
			* -------------------------
				- family-based
					- relatives
					- family sponsored preferences 
				- employment-based
				- diversity visas 
				- other 
					- refugees and asylees
					- residual category (other). 
					
			2 refugees and asylees
			* -------------------------
				- refugees 
				- asylees
					- defend-asylees 
					- affirm-asylees
				- total of the two
				
			3 naturalization 
			* -------------------------
				- totals
			
			4 non-immigrant
			* -------------------------
				- temporary workers and their families, 
				- students and exchange visitors, 
				- diplomats, 
				- tourists and business travelers, 
				- residual category (other). 
			
	
 * Date Last Updated: 2020.08.23 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/DHS"
global savedir "${db}/Phase 1/1_Tree Diagram/Recoded"
global tabledir "${db}/Phase 1/1_Tree Diagram/Tables"
global dofiledir "${db}/Phase 1/1_Tree Diagram/Do Files"


	* run legal permanent residents do.files 
	* ===================================
	do "$dofiledir/legal permanent residents.do"
	
		* Sort and order data
		* ---------------------------------------
		order region, first
		order country, after(region)
		
		sort region country year
		
		* Export to final excel
		* ---------------------------------------

		export excel using "$tabledir/2020.08.23 Tree Diagram 1998-2018.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
		
			clear all

		
	* run refugees and asylees do.files 
	* ===================================
	do "$dofiledir/refugees.do"
	
	do "$dofiledir/affirm-asylees.do"
	
	do "$dofiledir/defend-asylees.do"
	
		* Merge all three datsets into one
		* ---------------------------------------
		use "$savedir/Refugees and Asylees/Combined/defend-asylees1998-2018.dta", clear 
		
			merge 1:1 country year using "$savedir/Refugees and Asylees/Combined/affirm-asylees1998-2018.dta"
				
				drop _merge
				
			merge 1:1 country year using "$savedir/Refugees and Asylees/Combined/refugees1998-2018.dta"
				
				drop _merge
				
		* Combine "affirm_asylees" and "defend_asylees" into one variable 
		* ---------------------------------------
		* run loop to replace missing with 0s
		foreach v of varlist defend_asylees affirm_asylees refugee {
			
			replace `v' = 0 if `v' == .
					
		} 
		
		* combine into one variable 
		gen asylees = affirm_asylees + defend_asylees
			
				drop affirm_asylees defend_asylees
				
			rename refugee refugees
		
		* Create "total" variable and replace 0s with missing
		* ---------------------------------------
		gen total = refugees + asylees
		
			foreach v of varlist refugees asylees total{
			
				replace `v' = . if `v' == 0
					
			} 
		
		* Sort and order data
		* ---------------------------------------
		order region, first
		order country, after(region)
		
		sort region country year
		
		* Export to final excel
		* ---------------------------------------
		export excel using "$tabledir/2020.08.23 Tree Diagram 1998-2018.xlsx", sheet("refugees-asylees", modify) firstrow(variables)  missing(".")
		
			clear all
		
	
	* run naturalizations do.file 
	* ===================================
	do "$dofiledir/naturalizations.do"
	
	
		* Sort and order data
		* ---------------------------------------
		order region, first
		order country, after(region)
		
		sort region country year
		
		
		* Export to final excel
		* ---------------------------------------
		export excel using "$tabledir/2020.08.23 Tree Diagram 1998-2018.xlsx", sheet("naturalizations", modify) firstrow(variables)  missing(".")
		
			clear all
	
	
	* run non-immigrant do.file
	* ===================================
	do "$dofiledir/non-immigrants.do"
	
		* Sort and order data
		* ---------------------------------------
		order region, first
		order country, after(region)
		
		sort region country year
		
		* Export to final excel
		* ---------------------------------------
		export excel using "$tabledir/2020.08.23 Tree Diagram 1998-2018.xlsx", sheet("non-immigrants", modify) firstrow(variables)  missing(".")
		
			clear all
	
	
	/* Notes for write-up
	   ==========================
	
	1. Why is there data on just Korea?
	   
	2. Why is there data on US?
	


