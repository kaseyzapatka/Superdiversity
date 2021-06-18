/* Superdiveristy Project: Phase 1: Sankey Diagram 
 * =======================================================
  
 * File: 2020.07.13 Sankey Diagram Data Preparation.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Sankey Diagram for Phase 1 of Superdiveristy Project
 * Data: 
	- Downloaded from IPUMS at: https://usa.ipums.org/usa-action/data_requests/download
	- see Data preparation notes.txt for more on each of the variables
	
 * Date Last Updated: 07/14/2020 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/IPUMS"
global savedir "${db}/Phase 1/2_Sankey Diagram/Recoded"



* load NLSY data 
* ================
use "$rawdir/usa_00035.dta", clear
  
  * drop unnecessary variables
  drop cbserial
  
  
  * do we want to include households in institutional settings? 
  
 
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
		
	
	
* create popultion variable, clean ancestry and langauge variables 
* ====================================

/* population variable
* -------------------------
gen pop = _N */


* first ancestry
* -------------------------
fre ancestr1

	sort hhid
	br hhid ancestr1

	* clone variable for recoding 
	* IPUMS codebook: https://usa.ipums.org/usa-action/variables/ANCESTR1#description_section
	clonevar ancestry = ancestr1 
	recode ancestry (995/999 = 999)  /* recode  "RESIDUAL" as "other category */

	lab val ancestry ancestry
	lab var ancestry "recode of ancestr1 to condense categories"
	
	
	gen ancestry_subreg =  ancestry
	recode ancestry_subreg
	
	lab def ancestry_subreg  1 "Western European" 2 "Eastern European" 3 "Other Europe" 4 "Hispanic" 5 "West Indies" 
							 6 "non-Hispanic Central & South American" 7 "North Africa/Southwest Asian" 8 "Subsaharan Africa"
							 9 "Other Subsaharan Africa" 10 "South Asia" 11 "Other Asia" 12 "Pacific" 13 "North American non-Hispanic"
							 14 "Other"
	
	
	
	/* gen ancestry_region =  ancestr1
	recode
	
	american 
	european
	african
	asian
	
	other or unknown
	- prob undo dteh missing or recode to same number */
	
	

* language spoken at home 
* -------------------------
fre language
tab age language if language == 0 /* 6% of respondents didn't report or the question was not applicable */
	
	* Do we want to drop respondents under a certain age?
	replace language = . if language == 0 /* replace" NA/Blank" as missing bc too young to speak */
	replace language = . if language == 95 /* replace "No Language" as missing  */
	replace language = . if language == 96 /* replace "Other/Not Reported"  as missing -- not sure why these are missing*/
	
	
		sort language
		br perid age language ancestr1
	
	/* create a var that counts individual languages
	bysort language: egen lang_tot = count(language)
		
		sort language
		br perid age language lang_tot

	gen language_N = language		*/
		
	
	
	
* collapse function
* -------------------------
	
contract language ancestr1, zero percent(percentage)

contract language ancestr1 [fw = perwt], zero percent(percentage)

	
	*tab  ancestr1 if ancestr1 == 261 [fw = perwt]



	desctable i.raceth age hhincome i.educ, filename("$savedir/descriptivesEX1") stats(mean median)
  
  
  
  
  
  
  
	* save csv as stata dta
	* save "$savedir/2020.07.11 NLSY97 recode.dta", replace


