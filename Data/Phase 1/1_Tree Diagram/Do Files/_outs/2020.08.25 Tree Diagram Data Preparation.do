/* Superdiveristy Project: Phase 1: Tree Diagram 
 * =======================================================
  
 * File: 2020.08.25 Tree Diagram Data Preparation.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Tree Diagram for Phase 1 of Superdiveristy Project:
	- legal permanent residents
	- refugees and asylees
	- naturalizations
	- non-immigrant admissions 
	
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
			
	
 * Date Last Updated: 2020.08.25 */ 
 

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
		order country, first
		
			order region, after(country)
			
			order total, last 
		
		sort country region year
		
		* drop categories with all missing 
		* ---------------------------------------
		drop if country == "Other Europe"
		drop if country == "Other Caribbean"
		drop if country == "Other North America"
		drop if country == "Other South America"
		drop if country == "Other Oceania"
		drop if country == "Other Asia"
		drop if country == "Other Africa"
		drop if country == "Not specified"
		drop if country == "Other republics"
		drop if country == "Other, not specified"
		
		* save data and export to excel 
		* ---------------------------------------
		save "$savedir/Legal Permanent Residents/LPR1998_2018.dta", replace 
				
				preserve
				
					keep if year == 2018
					
					export excel using "$tabledir/PRNY2018.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2017
					
					export excel using "$tabledir/PRNY2017.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2016
					
					export excel using "$tabledir/PRNY2016.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2015
					
					export excel using "$tabledir/PRNY2015.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				
				preserve
				
					keep if year == 2014
					
					export excel using "$tabledir/PRNY2014.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2013
					
					export excel using "$tabledir/PRNY2013.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2012
					
					export excel using "$tabledir/PRNY2012.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2011
					
					export excel using "$tabledir/PRNY2011.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2010
					
					export excel using "$tabledir/PRNY2010.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2009
					
					export excel using "$tabledir/PRNY2009.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2008
					
					export excel using "$tabledir/PRNY2008.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2007
					
					export excel using "$tabledir/PRNY2007.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2006
					
					export excel using "$tabledir/PRNY2006.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2005
					
					export excel using "$tabledir/PRNY2005.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2004
					
					export excel using "$tabledir/PRNY2004.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2003
					
					export excel using "$tabledir/PRNY2003.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2002
					
					export excel using "$tabledir/PRNY2002.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2001
					
					export excel using "$tabledir/PRNY2001.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2000
					
					export excel using "$tabledir/PRNY2000.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 1999
					
					export excel using "$tabledir/PRNY1999.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore				
				
				preserve
				
					keep if year == 1998
					
					export excel using "$tabledir/PRNY1998.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
				
				
		clear all 
			
		
	* run non-immigrant do.file
	* ===================================
	do "$dofiledir/non-immigrants.do"
		
		* Sort and order data
		* ---------------------------------------
		order country, first
		
			order region, after(country)
			
			order total, last 
		
		sort country region year
		
		
		* save data and export to excel 
		* ---------------------------------------
		save "$savedir/Non-immigrants/nonimmigrants1998_2018.dta", replace 
			
				preserve
				
					keep if year == 2018
					
					export excel using "$tabledir/TRNY2018.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2017
					
					export excel using "$tabledir/TRNY2017.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2016
					
					export excel using "$tabledir/TRNY2016.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2015
					
					export excel using "$tabledir/TRNY2015.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				
				preserve
				
					keep if year == 2014
					
					export excel using "$tabledir/TRNY2014.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2013
					
					export excel using "$tabledir/TRNY2013.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2012
					
					export excel using "$tabledir/TRNY2012.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2011
					
					export excel using "$tabledir/TRNY2011.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2010
					
					export excel using "$tabledir/TRNY2010.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2009
					
					export excel using "$tabledir/TRNY2009.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2008
					
					export excel using "$tabledir/TRNY2008.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2007
					
					export excel using "$tabledir/TRNY2007.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2006
					
					export excel using "$tabledir/TRNY2006.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2005
					
					export excel using "$tabledir/TRNY2005.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2004
					
					export excel using "$tabledir/TRNY2004.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2003
					
					export excel using "$tabledir/TRNY2003.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2002
					
					export excel using "$tabledir/TRNY2002.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2001
					
					export excel using "$tabledir/TRNY2001.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 2000
					
					export excel using "$tabledir/TRNY2000.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				preserve
				
					keep if year == 1999
					
					export excel using "$tabledir/TRNY1999.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore				
				
				preserve
				
					keep if year == 1998
					
					export excel using "$tabledir/TRNY1998.xlsx", sheet("non-immigrant", modify) firstrow(variables)  missing(".")
					
				restore
				
				
		clear all 
	
	
	/* Notes for write-up
	   ==========================
	
	1. Why is there data on just Korea?
	   
	2. Why is there data on US?
	


