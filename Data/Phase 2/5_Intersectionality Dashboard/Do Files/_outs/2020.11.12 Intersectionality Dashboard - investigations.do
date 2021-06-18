/* Superdiveristy Project: Phase 2: Intersectionality Dashboard
 * =======================================================
  
 * File: 2020.11.12 Intersectionality Dashboard - investigations.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Intersectionality Dashboard for Phase 2 of Superdiveristy Project
 * Data: 
	- Downloaded from IPUMS at: https://usa.ipums.org/usa-action/data_requests/download
	- see Data preparation notes.txt for more on each of the variables
	
 * Date Last Updated: 2020.11.12 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/IPUMS"
global savedir "${db}/Phase 2/5_Intersectionality Dashboard/Recoded"
global tabledir "${db}/Phase 2/5_Intersectionality Dashboard/Tables"
global dodir "${db}/Phase 2/5_Intersectionality Dashboard/Do Files"


* load data and create frames 
* ================
use  "$savedir/2020.11.11 Intersectionality Dashboard Data.dta", clear 

	* brooklyn 
	* -----------------------------
	frame rename default brooklyn
	
		* keep only manhattan data
			keep if statecountyfipstr == "36047"
			
				* check 
				fre statecountyfipstr
	
		
	
	* manhattan 
	* -----------------------------
	frame create manhattan

		frame change manhattan 
		
		* run supplementary race do.files
		use  "$savedir/2020.11.11 Intersectionality Dashboard Data.dta", clear 
			
			* keep only manhattan data
			keep if statecountyfipstr == "36061"
			
				* check 
				fre statecountyfipstr
				
	* queens 
	* -----------------------------
	frame create queens

		frame change queens 
		
		* run supplementary race do.files
		use  "$savedir/2020.11.11 Intersectionality Dashboard Data.dta", clear 
			
			* keep only manhattan data
			keep if statecountyfipstr == "36081"
			
				* check 
				fre statecountyfipstr
				
	* bronx 
	* -----------------------------
	frame create bronx

		frame change bronx 
		
		* run supplementary race do.files
		use  "$savedir/2020.11.11 Intersectionality Dashboard Data.dta", clear 
			
			* keep only manhattan data
			keep if statecountyfipstr == "36005"
			
				* check 
				fre statecountyfipstr
			
				
		
			frame dir
		
* summary statistics 
* ================

frame change manhattan

	* gen cburden
	gen cburden = 0
	replace cburden = 1 if rburden == 1  
	replace cburden = 1 if oburden == 1  
	lab var cburden "cost burdened"

	fre rburden oburden cburden lowincome
	
	
		br cburden lowincome poverty hhinc grent anngrent grent_hhinc rburden oburden hhsize
		
		br cburden lowincome poverty hhinc grent anngrent grent_hhinc rburden oburden hhsize if cburden == 0 & lowincome == 1
		
		
	* create new poverty measure 
		fre poverty

	clonevar lowincome2 = poverty
	recode lowincome2 (1/150 = 1) (151/501 = 0) (0 = 0)
	lab def lowincome2  0 "not low-income" 1 "low-income"
	lab val lowincome2 lowincome2
	lab var lowincome2 "low-income = below 150% of poverty line"

	
		* check 
		fre lowincome2 lowincome
		
		
frame change bronx

	* gen cburden
	gen cburden = 0
	replace cburden = 1 if rburden == 1  
	replace cburden = 1 if oburden == 1  
	lab var cburden "cost burdened"

	fre rburden oburden cburden lowincome
	
	
		br cburden lowincome poverty hhinc grent anngrent grent_hhinc rburden oburden hhsize
		
		br cburden lowincome poverty hhinc grent anngrent grent_hhinc rburden oburden hhsize if cburden == 0 & lowincome == 1
		
		
	* create new poverty measure 
		fre poverty

	clonevar lowincome2 = poverty
	recode lowincome2 (1/150 = 1) (151/501 = 0) (0 = 0)
	lab def lowincome2  0 "not low-income" 1 "low-income"
	lab val lowincome2 lowincome2
	lab var lowincome2 "low-income = below 150% of poverty line"

	
		* check 
		fre lowincome2 lowincome
		br lowincome2 lowincome age poverty hhinc if poverty == 0
		
		

	
	
	

	
