/* Superdiveristy Project: Phase 2: Website Text 
 * =======================================================
  
 * File: 2020.10.16 Website Text .do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Bubble Chart for Phase 1 of Superdiveristy Project
 * Data: 
	- Downloaded from IPUMS at: https://usa.ipums.org/usa-action/data_requests/download
	- see Data preparation notes.txt for more on each of the variables
	
 * Date Last Updated: 2020.10.16 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/IPUMS"
global savedir "${db}/Phase 1/3_Bubble Chart/Recoded"
global tabledir "${db}/Phase 1/3_Bubble Chart/Tables"



*************************
* load Bubble Chart Data
*************************
use "$savedir/2020.10.09 Bubble Chart Data.dta", clear
	

* what percent of NY-NJ-PH residents are native born?
* =================================================

fre metro met2013
	
	* immigrants
	* -----------------------------
	fre yrimmig 

		* create immigrant grouped cohort variable : (born in US. pre-1980, 1981-1990, 1991-2000, 2001-10, 2011-18)
		gen immgrants = yrimmig
		recode immgrants (0 = 0) (else = 1) 
		lab def immgrants  0 " born in US" 1 "immigrant" 
		lab val immgrants immgrants
		lab var immgrants "immigrants"
		
			* check 
			fre immgrants
			
	* immigrant groups
	* -----------------------------
	fre yrimmig 

		* create immigrant grouped cohort variable : (born in US. pre-1980, 1981-1990, 1991-2000, 2001-10, 2011-18)
		gen immgrant_group = yrimmig
		recode immgrant_group (0 = 0) (1/1979 = 1) (1980/1990 = 2) (1991/2000 = 3) (2001/2010 = 4) (2011/2018 = 5)
		lab def immgrant_group  0 " born in US" 1 "pre 1980" 2 "1980-1990" 3 "1991-2000" 4 "2001-2010" 5 "2011-2018", modify
		lab val immgrant_group immgrant_group
		lab var immgrant_group "immigrant groups"
		
			* check 
			fre immgrant_group immgrants
			
	* birth place
	* -----------------------------
	fre bpl 

		* create immigrant grouped cohort variable : (born in US. pre-1980, 1981-1990, 1991-2000, 2001-10, 2011-18)
		gen native = bpl
		recode native (0/99 = 1) (else = 0) 
		lab def native  0 "not born in US" 1 "born in US" 
		lab val native native
		lab var native "native born"
		
			* check 
			fre native immgrant_group immgrants
			
	*  -----------------------------		
	* what percent of NY-NJ-PH residents are native born? : 70.27% are native, 29.73% are immigrants 
	*  -----------------------------
	
	
	fre raceth
	
	
* Is NYC on a path to be a majority-minority city?
* =================================================	
	
	* create variable to differentite NYC 5 Boros from greater metro area
	*  -----------------------------
	fre countyfip
	
		* string state and countyfips vars
		tostring statefip, gen(statefipstr) format("%02.0f")
		tostring countyfip, gen(countyfipstr) format("%03.0f")
		
			lab var statefipstr "statefips string"
			lab var countyfipstr "countyfips string"
		
		* concatenate state and countryfips vars
		gen statecountyfipstr = statefipstr + countyfipstr
		lab var statecountyfipstr "state + countyfips string"
		
		* check 
		br statefip statefipstr countyfip countyfipstr
		
		
	* create variable that flags residents within NYC 5 boros
	gen NYC = 0
	replace NYC = 1 if statecountyfipstr == "36005" // Bronx
	replace NYC = 2 if statecountyfipstr == "36047" // Brooklyn
	replace NYC = 3 if statecountyfipstr == "36061" // Manhattan
	replace NYC = 4 if statecountyfipstr == "36081" // Queens
	replace NYC = 5 if statecountyfipstr == "36085" // Staten Island
	
	lab def NYC  0 "not NYC 5 boros" 1 "Bronx" 2 "Brooklyn" 3 "Manhattan" 4 "Queens" 5 "Staten Island"
	lab val NYC NYC
	lab var NYC "residents within NYC 5 boros or greater NYC metro area"
	
		* check 
		mdesc NYC // should be 0 missing
		
		fre NYC
		
		table NYC [fw = perwt] // NYC 5 boros should total to 8.4 million 
		
		

	
			* frequency tables
			*  -----------------------------
			tab raceth [fw = perwt] if  NYC != 0 
			
				*  -----------------------------
				*  majority-minority NYC at 32%
				*  -----------------------------
			

			tab raceth [fw = perwt] 
			
				*  -----------------------------
				*  yes, majority-minority NYC at 46%, but much whiter
				*  -----------------------------
			

			
			
			
	
