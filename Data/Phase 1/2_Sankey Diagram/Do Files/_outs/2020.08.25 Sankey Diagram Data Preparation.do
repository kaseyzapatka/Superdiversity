/* Superdiveristy Project: Phase 1: Sankey Diagram 
 * =======================================================
  
 * File: 2020.08.25 Sankey Diagram Data Preparation.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data (2000 and 2018) for Sankey Diagram for Phase 1 of Superdiveristy Project
 * Data: 
	- Downloaded from IPUMS at: https://usa.ipums.org/usa-action/data_requests/download
	- see Data preparation notes.txt for more on each of the variables
	
 * Date Last Updated: 2020.08.25 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/IPUMS"
global savedir "${db}/Phase 1/2_Sankey Diagram/Recoded"
global tabledir "${db}/Phase 1/2_Sankey Diagram/Tables"
global dofiledir "${db}/Phase 1/2_Sankey Diagram/Do Files"


* load NLSY data 
* ================
use "$rawdir/usa_00040.dta", clear
  
  * drop unnecessary variables
  drop cbserial
  
  
  * include households in institutional settings  - this has been approved by Van and Dan
	fre gq
  
 
* preliminary data cleaning
* ============================
		
	*****	
	* keep only data in metro area
	*****
	keep if met2013 == 35620
	drop if metro == 4 /* drop cases where metro area status is undeterminable */ 

		tab year met2013
		
		
		* check to make sure population looks correct 
		bysort year: tab  met2013 [fw = perwt]
		
	
	*****
	* create  unique id  for 
	*****
	tostring sample, gen(samplestr) format("%06.0f")
	tostring serial, gen(serialstr) format("%07.0f")
	
		* creat household id
		gen hhid = samplestr + serialstr
		
		* checking that hhid == numperc : if diff == 0, then they are the same
		* --------------------------------------------------------------------
		bysort hhid: gen hhsize = _N
		
		gen diff  = numprec - hhsize
		
			br hhid  diff numprec hhsize
			
		drop diff
			

						/* for coding purposes only - delete after cleaned coding 
						* ====================================
						 
							*****	
							* first ancestry
							*****
							* frequency by group
							bysort ancestr1: gen freq = 1
							  
								collapse  (count) freq , by (ancestr1)
								
							
							*****	
							* language
							*****
							* frequency by group
							bysort language: gen freq = 1
							  
								collapse  (count) freq , by (language) */
								
								
						
	
* clean ancestry and langauge variables 
* ====================================

	*****	
	* first ancestry
	*****
	fre ancestr1

		/* sort hhid
		br hhid ancestr1*/ 
								
			
			* clone variable for recoding 
			* IPUMS codebook: https://usa.ipums.org/usa-action/variables/ANCESTR1#description_section
			clonevar ancestry = ancestr1 
			recode ancestry (12 = 11) /// /* 12 british isles to 11 british */
							(51/73 = 51) /// /* 51 -73 to 51 italian */
							(122 = 190) /// /* 124 Germans from Russia to 190 Eastern European origins */
							(124 = 190) /// /* 124 Rom to 190 Eastern European origins */
							(181 = 195) /// /* 181 Central European, nec 195 Other European Origins, n.i.e. */
							(210/219 = 210) /// /* 210-219 to 210 mexican */
							(248 = 227) /// /* 210-219 to 210 mexican */
							(291 = 200) /// /* 291 spanish as 200 spaniard */
							(310 = 337) /// /* 310 Dutch West Indian to 337 Other West Indian */
							(315 = 314) /// /* 315 Trindiadian to 314 Trinidadian/Tobagonian */
							(321 = 337) /// /* 321 British Virgin Islander to 337 Other West Indian */
							(322 = 337) /// /* 322 British West Indian to 337 Other West Indian */
							(324 = 337) /// /* 324 Anguilla Islander to 337 Other West Indian */
							(496 = 495) /// /* 496 other arab to 495 arab */
							(523 = 522) /// /* 523 eritrean to 522 ethiopian */
							(584 = 582) /// /* 584 Zanzibar Islander to 582 Tanzanian */
							(595 = 599) /// /* 595 Other Subsaharan African to 599 African */
							(596 = 599) /// /* 595 Central African to 599 African */
							(597 = 599) /// /* 595 East African to 599 African */
							(598 = 599) /// /* 595 West African to 599 African */
							(706/716 = 706) /// /* 706-716 to 706 chinese */
							(748 = 740) /// /* 748 Okinawan to 740 Japanese */
							(793/795 = 796) /// /* 793 eurasian and 795 asian to 796 other asian */
							(814/819 = 814) /// /* 814-819 to 814 Samonan */
							(820/822 = 850) /// /* 820 Micronesian, 821 Guamanian, 822 Chamorro Islander to 850 pacific islander */
							(850/870 = 850) /// /* 850-870 to 850 pacific islander */
							(900/902 = 900) /// /* recode African-American to Afro-Ameican */
							(913 = 914) /// /* 913 Central American Indian to 914 South American Indian */
							(939/983 = 939) /// /*  939  to 983  to 939 american */
							(995/999 = 995) /* 995 Mixture, 996 Uncodable, 998 Other to Other and Unknown */
							*(999 = .) /* 999 Not Reported to missing */ 
					
			* make sure to "modify" label changes to current label tag or you will lose all those not specified in creation of new label variable
			lab def ANCESTR1  337 "Caribbean origins, n.i.e" 490 "West Central Asian and Middle Eastern origins, n.i.e."  /// 
							  582 "Tanzanian" 599 "Other African origins, n.i.e." ///
							  607 "East and Southeast Asian origins, n.i.e." 615 "Indian" 914 "Aboriginal from Central/South America (except Maya)" ///
							  924 "Euro-Americans" 994 "Other North American origins, n.i.e." 995 "Other and Unknown", modify
							  
			lab var ancestry "recode of ancestr1 to condense categories"
			
				* check to make sure recoding of labels worked : 924 should be Euro-Americans 
				br ancestry 
			
				distinct ancestry
				
			
		
	*****	
	* language
	*****
	fre language
				
				//	IPUMS codebook for language: 
				//		- https://usa.ipums.org/usa-action/variables/LANGUAGE#codes_section 
				
				
				//	Ethnologue: Langauge family: 
				//		- https://www.ethnologue.com/browse/families		
				
		
		* investigate why some people have no language
		tab age language if language == 0 // 6% of respondents didn't report or the question was not applicable
		
		* recode original language variable 
		replace language = 96 if language == 0 /* replace" NA/Blank" as missing bc too young to speak */
		replace language = 96 if language == 95 /* replace "No Language" as missing  */

		
		
			* recode language 
			recode language (56 = 55) ///  /* recode to 55 "Micronesian, Polynesian */
							(58 = 57)      /* recode to 57 "Arabic */
						
			
			lab def LANGUAGE  3 "yiddish" 14 "romanian" 60 "amharic, ethiopian" 62 "other afro-asiatic" ///
							  63 "sub-saharan african" 64 "other sub-saharan african" 96 "Other and Unknown", modify
									
			lab val language LANGUAGE
			lab var language "language spoken"
			
			
	*****	
	* logs to identify population numbers
	*****
	
		* run log to capture total population
		* ------------------------------------
		log using "$tabledir/pweigthvsfweights.log", replace
				
			* total population : remember these numbers are not disaggreated by year
			tab  met2013 [fw = perwt]
					
			* weighted estimates for ancestry 
			table ancestry [pw = perwt]
			tab ancestry [fw = perwt]
					  
				
		log close 
				
		* run log to capture total population
		* ------------------------------------
		log using "$tabledir/byyear.log", replace
				
			* by year
			table language  [pw = perwt] , by (year) c(count ancestr1)  
			table language  [fw = perwt] , by (year) c(count ancestr1)
					
		log close 
		
		
	
	
* save condensed dataset after cleaning
* ====================================
compress
	
save "$savedir/2020.08.25 Sankey Diagram Data.dta", replace
	
	clear all
														
														
	
* 2000: collapse dataset using "contract" command
* ===================================
use "$savedir/2020.08.25 Sankey Diagram Data.dta", clear
		
		keep ancestry language perwt year
		 
		* sort by ancestry then language 
		sort ancestry language 

	* 2000: contract command
 	* -----------------------------------------------
	contract ancestry language [fw = perwt] if year == 2000 , freq(count) zero 
	
	order count, first
	
	
	* 2000: sub-variable creation and export to excel 		
	* ------------------------------------------------
	do "$dofiledir/2000 sub-variable and export.do"
	
	
* 2018: collapse dataset using "contract" command
* ===================================
use "$savedir/2020.08.25 Sankey Diagram Data.dta", clear
		
		keep ancestry language perwt year
		 
		* sort by ancestry then language 
		sort ancestry language 

	* 2018: contract command
 	* -----------------------------------------------
	contract ancestry language [fw = perwt] if year == 2018 , freq(count) zero
	
	order count, first
	
	
	* 2018: sub-variable creation and export to excel 		
	* ------------------------------------------------
	do "$dofiledir/2018 sub-variable and export.do"
	
		
	exit 

	
	/* Notes for write-up
	   ==========================
	
	1. We chose to include individuals who were surveyed in instituitions (1.87%) 
	   and group quarters (1.92%), which consisted of a total of 3.79% of all
	   individuals. 
	   
	2. About 6% of respondents didn't report speaking a language or the question 
	   was not applicable. This was because they were likely too young to speak a 
	   langauge. Those without a language were incldued in "Other and Unknown".
	

