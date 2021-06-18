/* Superdiveristy Project: Phase 2: Intersectionality Dashboard
 * =======================================================
  
 * File: 2020.09.11 Sankey Diagram Data Preparation.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Intersectionality Dashboard for Phase 2 of Superdiveristy Project
 * Data: 
	- Downloaded from IPUMS at: https://usa.ipums.org/usa-action/data_requests/download
	- see Data preparation notes.txt for more on each of the variables
	
 * Date Last Updated: 2020.09.11 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/IPUMS"
global savedir "${db}/Phase 2/5_Intersectionality Dashboard/Recoded"
global tabledir "${db}/Phase 2/5_Intersectionality Dashboard/Tables"
global dodir "${db}/Phase 2/5_Intersectionality Dashboard/Do Files"


* load NLSY data 
* ================
use "$rawdir/usa_00040.dta", clear
  
  * drop unnecessary variables
  drop cbserial


* preliminary data cleaning
* ============================

	*****
	* keep only data from 2014-2018 5 year ACS
	*****
	keep if year == 2018


	*****
	* keep only data in metro area
	*****
	keep if met2013 == 35620
	drop if metro == 4 /* drop cases where metro area status is undeterminable */ 

		tab year met2013
		
		* check to make sure population looks correct 
		bysort year: tab  met2013 [fw = perwt]
		bysort year: tab  metro [fw = perwt]
		
	
	*****
	* create variable to differentite NYC 5 Boros from greater metro area
	*****
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
		
			fre diff
			
			
* age groups
* ============================
fre age

	* create variable for age_group 18-24, 25-34, 35-44, 45-54, and 55-64
	gen age_group = age 
	recode age_group (18/24 = 1) (25/34 = 2) (35/44 = 3) (45/54 = 4) (55/64 = 5) (else = 0)
	lab def age_group  0 "not working age" 1 "18-24" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64"
	lab val age_group age_group
	lab var age_group "age grouped cohorts"
	
		* check 
		fre age_group

		
* sex
* ============================
fre sex

	* create male variable
	gen male = sex
	recode male (1 = 1) (2 = 0)
	lab def male  0 "female" 1 "male" 
	lab val male male
	lab var male "male"
	
	* create female variable
	gen female = sex
	recode female (1 = 0) (2 = 1)
	lab def female  0 "male" 1 "female" 
	lab val female female
	lab var female "female"
	
		* checks
		fre male female
		
	
* Create race/ethnicity, Hispanic and Asian origin variables 
* ===========================================================
fre race hispan

	* create hispanic binary for non-hispanic coding of raceth 
	gen hispanic_binary = hispan 
	recode hispanic_binary (1/4 = 1)
	lab def hispanic_binary  0 "not hispanic" 1 "hispanic"
	lab val hispanic_binary hispanic_binary
	lab var hispanic_binary "hispanic binary indicator"
	
	* create variable for five basic race groups
	gen raceth = . 
	replace raceth = 1 if race == 1 & hispanic_binary == 0
	replace raceth = 2 if race == 2 & hispanic_binary == 0
	replace raceth = 3 if hispanic_binary == 1 
	replace raceth = 4 if race == 4 | race == 5 | race == 6 & hispanic_binary == 0
	replace raceth = 5 if race == 3 | race == 7 | race == 8 | race == 9 & hispanic_binary == 0
	lab def raceth  1 "non-hispanic white" 2 "non-hispanic black" 3 "hispanic" 4 "non-hispanic asian" 5 "non-hispanic other"
	lab val raceth raceth
	lab var raceth "race and ethnicity variable"

	
		* check the weighted estimates of each race-ethnicity in NY metro area
		table raceth [pw = perwt]
		tab raceth [fw = perwt]
	
	*****
	* create hispanic origin variables: hispangrps_hispand, mexican1, mexican2, hispanicgrps, hispangrps1, hispangrps2
	*****
	* create variable for five largest Hispanic groups
	clonevar hispangrps_hispand = hispand
	recode hispangrps_hispand (200 = 1) (460 = 2) (100 = 3) (424 = 4) (423 = 5) (else = . )
	lab def hispangrps_hispand  1 "puerto ricans" 2 "dominicans" 3 "mexicans" 4 "ecuadorians" 5 "columbians"
	lab val hispangrps_hispand hispangrps_hispand
	lab var hispangrps_hispand "five largest Hispanic groups, based on hispan variable"
	
	
		* create mexican category for use in creating hispangrps1 and hispangrps2		
		gen mexican1 = . 
		replace  mexican1 = 1 if ancestr1 == 210  /* mexican */ 
		replace  mexican1 = 1 if ancestr1 == 211  /* mexican-american */ 
		replace  mexican1 = 1 if ancestr1 == 213  /* chicano/chicana */ 
		replace  mexican1 = 1 if ancestr1 == 218  /* nuevo mexicano */ 
		replace  mexican1 = 1 if ancestr1 == 219  /* californio */
		lab var mexican1 "mexican based on either 'ancestr1'"
		
		gen mexican2 = . 
		replace  mexican2 = 1 if ancestr2 == 210 /* mexican */ 
		replace  mexican2 = 1 if ancestr2 == 211 /* mexican-american */ 
		replace  mexican2 = 1 if ancestr2 == 213 /* chicano/chicana */ 
		replace  mexican2 = 1 if ancestr2 == 218 /* nuevo mexicano */ 
		replace  mexican2 = 1 if ancestr2 == 219 /* californio */
		lab var mexican2 "mexican based on 'ancestr2''"
		
		
			* check 
			fre mexican1 mexican2
			
			* check mexican category 
			fre ancestr1 if  ancestr1 == 210 | ancestr1 == 211 | ancestr1 == 213 | ancestr1 == 218 | ancestr1 == 219 
			fre ancestr2 if  ancestr2 == 210 | ancestr2 == 211 | ancestr2 == 213 | ancestr2 == 218 | ancestr2 == 219 
	
	* create variable for five largest Hispanic groups using "ancestr1"
	gen hispangrps = .
	replace hispangrps = 1 if ancestr1 == 261 /* puerto rican */ 
	replace hispangrps = 2 if ancestr1 == 275 /* dominican */ 
	replace hispangrps = 3 if mexican1 == 1 /* mexicans */
	replace hispangrps = 4 if ancestr1 == 235 /* ecuadorians */ 
	replace hispangrps = 5 if ancestr1 == 234 /* colombians */ 
	lab def hispangrps  1 "puerto ricans" 2 "dominicans" 3 "mexicans" 4 "ecuadorians" 5 "colombians"
	lab val hispangrps hispangrps
	lab var hispangrps "five largest Hispanic groups, using 'ancestr1' only"
	
	* create variable for five largest Hispanic groups using "ancestr1"
	gen hispangrps1 = .
	replace hispangrps1 = 1 if ancestr1 == 261 | ancestr2 == 261 /* puerto rican */ 
	replace hispangrps1 = 2 if ancestr1 == 275 | ancestr2 == 275 /* dominican */ 
	replace hispangrps1 = 3 if mexican1 == 1   | mexican2 == 1  /* mexicans */
	replace hispangrps1 = 4 if ancestr1 == 235 | ancestr2 == 235 /* ecuadorians */ 
	replace hispangrps1 = 5 if ancestr1 == 234 | ancestr2 == 234 /* colombians */ 
	lab def hispangrps1  1 "puerto ricans" 2 "dominicans" 3 "mexicans" 4 "ecuadorians" 5 "colombians"
	lab val hispangrps1 hispangrps1
	lab var hispangrps1 "five largest Hispanic groups, using either 'ancestr1' or 'ancestr2''"
	
		
		* check 
		fre hispangrps_hispand hispangrps hispangrps1
	
	*****
	* create asian origin variables: 
	*****
	/* helpful links on asian population in NY metro area: 
		- http://www.aafny.org/cic/briefs/2017citycouncilbrief.pdf
		- https://www.pewresearch.org/topics/asian-americans/  */ 
		
		
		clonevar asian = ancestr1
		recode asian (1/599 = 0) (800/999 = 0)
		
			fre asian
			/* top asian groups: 
				
				1. chinese				31,271 
				2. asian indian			23,483 
				3. filipino				 8,782
				4. korean				 8,516
				5. bengali 				 4,535 		*/ 
				
			* collapse chinese thru macao into single chinese variable: https://usa.ipums.org/usa-action/variables/ANCESTR1#codes_section
			clonevar chinese1 = ancestr1
			recode chinese1 (706/718 = 1) (else = 0)
			lab def chinese1  1 "chinese" 0 "all else"
			lab val chinese1 chinese1
			lab var chinese1 "chinese based on 'ancestr1''"
			
			clonevar chinese2 = ancestr2
			recode chinese2 (706/718 = 1) (else = 0) 
			lab def chinese2  1 "chinese" 0 "all else"
			lab val chinese2 chinese2
			lab var chinese2 "chinese based on 'ancestr2''"
			
					fre chinese1 chinese2 
					
			* collapse asian indian thru tamil into indian variable:  https://usa.ipums.org/usa-action/variables/ANCESTR1#codes_section
			clonevar indian1 = ancestr1
			recode indian1 (615/656 = 1) (else = 0)
			lab def indian1  1 "indian" 0 "all else"
			lab val indian1 indian1
			lab var indian1 "indian based on 'ancestr1''"
			
			clonevar indian2 = ancestr2
			recode indian2 (615/656 = 1) (else = 0) 
			lab def indian2  1 "indian" 0 "all else"
			lab val indian2 indian2
			lab var indian2 "indian based on 'ancestr2''"
			
					fre indian1 indian2 
	
	* create variable for five largest Hispanic groups using "ancestr1"
	gen asiangrps = .
	replace asiangrps = 1 if chinese1 == 1 /* chinese */ 
	replace asiangrps = 2 if indian1 == 275 /* indian */ 
	replace asiangrps = 3 if ancestr1 == 720 /* filipino */
	replace asiangrps = 4 if ancestr1 == 750 /* korean */ 
	replace asiangrps = 5 if ancestr1 == 603 /* bengali */ 
	lab def asiangrps  1 "chinese" 2 "indian" 3 "filipino" 4 "korean" 5 "bengali"
	lab val asiangrps asiangrps
	lab var asiangrps "five largest Asian groups, using 'ancestr1' only"
	
	* create variable for five largest Hispanic groups using "ancestr1"
	gen asiangrps1 = .
	replace asiangrps1 = 1 if chinese1 == 1   | chinese2 == 1 /* chinese */
	replace asiangrps1 = 2 if indian1 == 1    | indian2 == 1 /* indin */ 
	replace asiangrps1 = 3 if ancestr1 == 720 | ancestr2 == 720  /* filipino */
	replace asiangrps1 = 4 if ancestr1 == 750 | ancestr2 == 750 /* korean */ 
	replace asiangrps1 = 5 if ancestr1 == 603 | ancestr2 == 603 /* bengali */ 
	lab def asiangrps1  1 "chinese" 2 "indian" 3 "filipino" 4 "korean" 5 "bengali"
	lab val asiangrps1 asiangrps1
	lab var asiangrps1 "five largest Asian groups, using either 'ancestr1' or 'ancestr2''"
	
		* check 
		fre asiangrps asiangrps1

* immigrantation groups 
* ============================
fre yrimmig 

	* create immigrant grouped cohort variable : (born in US. pre-1980, 1981-1990, 1991-2000, 2001-10, 2011-18)
	gen immig_group = yrimmig
	recode immig_group (0 = 0) (1/1979 = 1) (1980/1990 = 2) (1991/2000 = 3) (2001/2010 = 4) (2011/2018 = 5)
	lab def immig_group  0 " born in US" 1 "pre 1980" 2 "1980-1990" 3 "1991-2000" 4 "2001-2010" 5 "2011-2018", modify
	lab val immig_group immig_group
	lab var immig_group "immigrant cohort"
	
		* check 
		fre immig_group
	
	
* percent university degree
* ============================
fre educd 

	* create indicator of university degree or higher
	clonevar coldeg = educd
	recode coldeg (1 = .) (101/116 = 1) (else = 0) /* recode n/a as missing */ 
	replace coldeg = . if age < 25 /* filter out those who are less than 25 */
	lab def coldeg  0 "less than a college degree" 1 "college degree or higher"
	lab val coldeg coldeg
	lab var coldeg "college degree or higher'"
	
		* checks
		fre coldeg 
		
		tab coldeg raceth , col
	
	
	
* percent employed
* ============================
fre empstat  

	* create employment variable 
	clonevar employed = empstat
	recode employed (0 = .) (1 = 1) (2 = 0) (3 = .) 
	lab def employed  0 "unemployed" 1 "employed" 
	lab val employed employed
	lab var employed "employed individuals"
	
		
	* create unemployment variable 
	clonevar unemployed = empstat
	recode unemployed (0 = .) (1 = 0) (2 = 1) (3 = .) 
	lab def unemployed  0 "employed" 1 "unemployed"
	lab val unemployed unemployed
	lab var unemployed "unemployed individuals"
	
		* check 
		fre employed unemployed
	

* % low income
* ===========================
fre poverty

	clonevar lowincome = poverty
	recode lowincome (0/150 = 1) (151/501 = 0)
	lab def lowincome  0 "not low-income" 1 "low-income"
	lab val lowincome lowincome
	lab var lowincome "low-income = below 150% of poverty line"

	
		* check 
		fre lowincome
	
* % homeownership
* ============================
fre ownershp ownershpd

	* create homeownership variable 
	clonevar homeownership = ownershp
	recode homeownership (0 = .) (1 = 1) (2 = 0) 
	lab def homeownership  0 "does not own home" 1 "owns home"
	lab val homeownership homeownership
	lab var homeownership "homeownership, binary"
	
		* check 
		fre  ownershp homeownership
		
		
* % speak english at home
* ============================
fre speakeng

	* create homeownership variable 
	clonevar speakenghome = speakeng
	recode speakenghome (0 = .) (1 = 0) (2/6 = 1) 
	lab def speakenghome  0 "speaks foreign language at home" 1 "speak english at home"
	lab val speakenghome speakenghome
	lab var speakenghome "speaks english at home"
	
		* check 
		fre speakenghome
		
* % don't speak english at home
* ============================
fre speakeng

	* create homeownership variable 
	clonevar speakforlanghome = speakeng
	recode speakforlanghome (0 = .) (1 = 1) (2/6 = 0) 
	lab def speakforlanghome  0 "speaks english at home" 1 "speak foreign language at home"
	lab val speakforlanghome speakforlanghome
	lab var speakforlanghome "speaks foreign languge at home"
	
		* check 
		fre speakenghome speakforlanghome
		
* % in affordable housing
* ============================
	
	* clean household income variable
	* ----------------------------------
	sort hhincome
	
		br hhincome // no cases cross -$19,998 bottom coded
		
	gsort -hhincome 
	
		br hhincome // many cases are topcoded at 9999999
		
		* create new household income variable: hhinc
		clonevar hhinc = hhincome
		recode hhinc (9999999 = .) // replace missing 9999999 as missing, these individuals are in group quarters
		* replace hhinc = . if hhinc < 1 
		lab var hhinc "household income, purged of topcoded"
		
			br hhinc gq
			
			br hhinc hhincome
			
	
	* clean gross rent variable and prep for creation of housing affordability variable
	* ----------------------------------
	* see for topcoded values https://usa.ipums.org/usa/volii/top_bottom_codes.shtml
	* see IPUMS ACS for resolution of my top-coding question
	*  	- https://forum.ipums.org/t/top-coded-monthly-gross-rent-values-seem-to-vary-more-widely-than-expected/3748/2
	fre rentgrs
		
		sort rentgrs multyear
		
		br rentgrs multyear 
			
		* create gross rent variable 
		gen grent = rentgrs
		recode grent (0 = .) // replace N/A as missing 
		lab var grent "gross rent"
			
			* check to make sure all owned units are not included as renting
			replace grent = . if ownershp == 1  // 0 changes should be made
		
		* create annual gross rent
		gen anngrent = (grent*12)
		lab var anngrent "annual gross rent"
		
			* checks 
			br grent anngrent hhinc

	
	* clean owner cost variable and prep for creation of data
	* ----------------------------------
	// doesn't seem to be any topcoded variables
	fre owncost
	
		* create ownercost variable
		gen ownercost = owncost
		recode ownercost (99999 = .) // replace missing as "."
		lab var ownercost "homeowner costs"
		
			* checks make sure all owned units are replaced as missing if rented
			br  ownercost owncost ownershp
			
			replace ownercost = . if ownershp == 2  // 0 changes should be made
		
		* create annual ownercost variable
		gen annownercost = (ownercost*12)
		lab var annownercost "annual homeowner costs"
		
	* create rent burden indicators for renters and homeowners separately
	* -------------------------------------------------------------------
	* generate housing costs to hhincome variables 
	gen grent_hhinc = anngrent/hhincome
	lab var grent_hhinc "annual gross rent to hh income"
		
	gen ownercost_hhinc = annownercost/hhincome
	lab var ownercost_hhinc "annual owner costs to hh income"


		* generate rent burden variables 

		/* Note that rent burden is usually divided into rent burden and 
		severely rent burdened. For this project, however, we are only looking 
		at individuals who are rent burdened as defined by paying more than 
		30% in housing costs. */
		
		
		* generate renter cost burden
		gen rburden = . 
		replace rburden = 1 if grent_hhinc > .3 
		replace rburden = 0 if grent_hhinc < .3
		replace rburden = . if grent_hhinc == . 
		
		lab var rburden "renter burdened"
		
			* checks 
			br rburden grent_hhinc anngrent hhinc
		
		* generate owner housing cost burden
		gen oburden = . 
		replace oburden = 1 if ownercost_hhinc > .3 
		replace oburden = 0 if ownercost_hhinc < .3
		replace oburden = . if ownercost_hhinc == . 
		
		lab var oburden "owner burdened"
		
			* checks 
			br serial rburden oburden anngrent grent_hhinc ownercost_hhinc annownercost hhinc
		
	
	
* working age 
* ============================
fre age 

	* create working age variable 
	clonevar workingage = age
	recode workingage (0/17 = 0) (18/64 = 1) (65/95 = 0) 
	lab def workingage 0 "not working age" 1 "working age"
	lab val workingage workingage
	lab var workingage  "working age, 18-64"

	
		* check 
		fre workingage age
			
			sort age
				
		br workingage age
		
	
	******
	* save dataset after all data cleaning has finished
	******
	compress 
	
	save "$savedir/2020.09.11 Intersectionality Dashboard Data.dta", replace
	
		clear all
		
		
														* ============
														* Data export
														* ============
													
														
* race-ethnicity (raceth) working age data creation and export
* ============================================================

	*************************
	* race-ethnicity 
	*************************
	do "$dodir/race-ethnicity.do"
	
	* create population variable
	clonevar pop = raceth if workingage == 1
	lab var pop "population of race-ethnicity"
	
					   
		* collapse dataset: total 
		* -------------------------
		
				* sort on "by" variables to speed up collapse 
				sort raceth age_group NYC immig_group
		
		* collapse 		
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth age_group NYC immig_group) 
					   
				* sort on "by" variables    
				sort raceth age_group NYC immig_group 
		
	
				* before drop, make sure not working age sum to metro area total
				* -------------------------
				* drop observations if not working age (keep to check)
				drop if age_group == 0
					
					
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if  `v' > 20 
				
				}
				
					*check on missing
					br raceth age_group immig_group employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						} 
						
						*check 
						br raceth age_group immig_group coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_)
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employed "employed, working age"
				lab var lowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var rburden "rent-burdened household"
				lab var oburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var lowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var rburden_n "total rent-burdened household"
				lab var oburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
				lab var z_lowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_rburden "z-score for rent-burdened household"
				lab var z_oburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			
				* order pop to front
				order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-oburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_lowincome, after (lowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_rburden, after (rburden_n)
					order z_oburden, after (oburden_n)
					
				
				* format variables and percents 
				foreach v of varlist coldeg-z_oburden {
					
					format `v' %10.0g
					recast float `v'
				}
				
			
				* generate total sex variable 
				gen sex = 1
				lab def sex  1 "Total - Sex"
				lab val sex sex
				lab var sex "total sex, working class"
				
					order sex, after (raceth)
	
	
				* sort for excel 
				sort sex raceth age_group immig_group
			
					* export to excel 		
					export excel using "$tabledir/2020.09.09 Intersectionality Dashboard.xlsx", sheet("strings", replace) firstrow(variables) keepcellfmt cell(A1)
		
		
	*************************
	* race-ethnicity by sex
	*************************
	use "$savedir/2020.09.11 Intersectionality Dashboard Data.dta", clear
	
	* create population variable
	clonevar pop = raceth if workingage == 1
	lab var pop "population of race-ethnicity"
	
						   
		* collapse dataset: by sex  
		* -------------------------
		
				* sort on "by" variables to speed up collapse 
				sort raceth age_group NYC immig_group
	
		* collapse	
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth age_group NYC sex immig_group) 
					   
					   
				sort raceth age_group sex NYC immig_group 
		
	
				* before drop, make sure not working age sum to metro area total
				* -------------------------
				* drop observations if not working age (keep to check)
				drop if age_group == 0
					
					
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
						replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth age_group sex immig_group employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth age_group sex immig_group coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_)
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employed "employed, working age"
				lab var lowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var rburden "rent-burdened household"
				lab var oburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var lowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var rburden_n "total rent-burdened household"
				lab var oburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
				lab var z_lowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_rburden "z-score for rent-burdened household"
				lab var z_oburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			
				* order pop to front
				order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-oburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_lowincome, after (lowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_rburden, after (rburden_n)
					order z_oburden, after (oburden_n)
					
				
				* format variables and percents 
				foreach v of varlist coldeg-z_oburden {
					
					format `v' %10.0g
					recast float `v'
				}
				
			
				* sort for excel 
				sort sex raceth age_group immig_group
			
					* export to excel 		
					export excel using "$tabledir/2020.09.09 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A148)
				


	*************************
	* hispanic (hispangrps1)
	*************************
	use "$savedir/2020.09.11 Intersectionality Dashboard Data.dta", clear

	* create population variable
	clonevar pop = hispangrps1 if workingage == 1
	
		* collapse dataset
		collapse (sum) coldeg employed lowincome homeownership (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  [pw = perwt], by(hispangrps1 workingage)
					   
					   
				* before drop, make sure hisp missing and not working age sum to metro area total
				* -------------------------
				* drop everyone not hispanic
				drop if hispangrps1 == .
			
	
				* drop observations if not working age (keep to check)
				drop if workingage == 0
				drop workingage
			
		
			* create percent variables 
			* -------------------------
			foreach v of varlist coldeg employed lowincome homeownership {

				gen p`v' = (`v'/`v'_n)*100
				order `v', before(`v'_n)
				order p`v', after(`v'_n)
			
			}
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employed "employed, working age"
				lab var lowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var lowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				
				* percent variables 
				lab var pcoldeg "percent with a college degree, working age"
				lab var pemployed "percent employed, working age"
				lab var plowincome "percent low-income, working age"
				lab var phomeownership "percent homeowners, working age"
								
				lab var pop "population of top 5 hispanic groups"
				
			* format data for excel read-out
			* -------------------------
			
				* order variables to end
				order p* , last
			
				
				* format variables and percents 
				foreach v of varlist coldeg-phomeownership {
					
					format `v' %10.0g
					recast float `v'
				}
				
				* rename to mimic superdiversity data example
				rename pop Population 
				rename pcoldeg University 
				rename pemployed Employed	
				rename plowincome Low_income 	
				rename phomeownership Homeowner
				
				* rename variable groups to be singular instead of plural 
				lab def hispangrps1  1 "puerto rican" 2 "dominican" 3 "mexican" 4 "ecuadorian" 5 "colombian", modify
				lab val hispangrps1 hispangrps1
		
			
		* export to excel 
		export excel using "$tabledir/2020.09.11 Intersectionality Dashboard.xlsx", sheet("calculations", modify) keepcellfmt cell(A7)
		
		

	*************************
	* asian (asiangrps1)
	*************************
	use "$savedir/2020.09.11 Intersectionality Dashboard Data.dta", clear
	
	* create population variable
	clonevar pop = asiangrps1 if workingage == 1

		* collapse dataset
		collapse (sum) coldeg employed lowincome homeownership (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  [pw = perwt], by(asiangrps1 workingage)
					   
					   
				* before drop, make sure asian missing and not working age sum to metro area total
				* -------------------------
				* drop everyone not asian
				drop if asiangrps1 == .
			
	
				* drop observations if not working age (keep to check)
				drop if workingage == 0
				drop workingage
			
		
			* create percent variables 
			* -------------------------
			foreach v of varlist coldeg employed lowincome homeownership {

				gen p`v' = (`v'/`v'_n)*100
				order `v', before(`v'_n)
				order p`v', after(`v'_n)
			
			}
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employed "employed, working age"
				lab var lowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var lowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				
				* percent variables 
				lab var pcoldeg "percent with a college degree, working age"
				lab var pemployed "percent employed, working age"
				lab var plowincome "percent low-income, working age"
				lab var phomeownership "percent homeowners, working age"

				lab var pop "population of top 5 asian groups"
	
			* format data for excel read-out
			* -------------------------
			
				* order variables to end
				order p* , last
			
				
				* format variables and percents 
				foreach v of varlist coldeg-phomeownership {
					
					format `v' %10.0g
					recast float `v'
				}
				
				* rename to mimic superdiversity data example
				rename pop Population 
				rename pcoldeg University 
				rename pemployed Employed	
				rename plowincome Low_income 	
				rename phomeownership Homeowner
				
				* rename bengali to bangladeshi
				lab def asiangrps1  1 "chinese" 2 "indian" 3 "filipino" 4 "korean" 5 "bangladeshi", modify
				lab val asiangrps1 asiangrps1
				
		
		* export to excel 
		export excel using "$tabledir/2020.09.11 Intersectionality Dashboard.xlsx", sheet("calculations", modify)  keepcellfmt cell(A12)




	
	
	/* Notes for write-up
	   ==========================
	
	1. The 5th category of "raceth" is composed of American Indian/Native American, 
	   other major race, two or more races, and three or more major races. 
	
	2. To create the chinese variable, we collapse Chinese, Cantonese, Manchurian, 
	   Mandarin, Mongolian, Tibetan, Hong Kong, and Macao into one "Chinese"
	   cateogry. Taiwanese was not included in the chinese variable. 
	
	3. To create the Indian variable, we collapse Asian Indian, Andaman Islander, 
	   Andhra Pradesh, Assamese, Goanese, Gujarati, Karnatakan, Keralan, Maharashtran,
	   Madrasi, Mysore, Naga, Pondicherry, Pondicherry, and Tamil into one "Indian" 
	   category. 
	   
	4. The percent low income variable was calculated by comparing that individual's
	   family income to the national poverty line. An individual whose family income
	   did not exceed 150% of the poverty line was marked as "low-income," whereas those
	   whose family income did were marked as "not low-income."
	
	5. To create the working age variable, we recode individuals not between the ages
	   of 18 and 65 as misssing. To create the working age arrivals variable, we only 
	   flag those of working age who arrived within the last 5 years for each survey
	   year. So, a working age arrival in survey year 2014 was someone who arrived 
	   between 2010 and 2014, while a working age arrival in 2018 was someone who 
	   arrived between 2014 and 2018. 
	   
	6. Note that the education base variable only includes individuals older than
	   25 years of age.
	   
	7. We included individuals that were currently in school in our calculations, 
	   hoping not to exclude the many immigrant students attending public colleges
	   like CUNY that have non-traditional academic paths.
	   
	 
	   

	
	
	
	
