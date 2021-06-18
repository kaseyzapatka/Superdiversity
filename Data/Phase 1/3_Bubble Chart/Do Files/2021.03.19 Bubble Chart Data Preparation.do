/* Superdiveristy Project: Phase 1: Bubble Chart
 * =======================================================
  
 * File: 2021.03.19 Bubble Chart Data Preparation.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Bubble Chart for Phase 1 of Superdiveristy Project
 * Data: 
	- Downloaded from IPUMS at: https://usa.ipums.org/usa-action/data_requests/download
	- see Data preparation notes.txt for more on each of the variables
	
 * Date Last Updated: 2021.03.19 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/IPUMS"
global savedir "${db}/Phase 1/3_Bubble Chart/Recoded"
global tabledir "${db}/Phase 1/3_Bubble Chart/Tables"


* load IPUMS data 
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


		tab year met2013
		
		* check to make sure population looks correct 
		bysort year: tab  met2013 [fw = perwt]
		bysort year: tab  metro [fw = perwt]
		
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
	
	* create variable for five largest Hispanic groups using "ancestr1"  and "ancestr2"
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
			fre asian [fw = perwt]
			/* top asian groups: 
				
				1. chinese				32,268  
				2. asian indian			24,628 
				3. filipino				 9,112
				4. korean				 8,770
				5. bengali 				 4,556 		*/
				
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
	
	* create variable for five largest Hispanic groups using "ancestr1" and "ancestr2"
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
		
		
	*****
	* create black origin variables: 
	*****

	
		clonevar black = ancestr1
		recode black  (1/299 = 0) (400/499 = 0) (600/999 = 0)
		* recode black  (300/337 = 1) (370 = 1) (529 = 1) (541 = 1) (553 = 1) (564 = 1) (else = 0
			
		fre black 
		fre black [fw =perwt]
		
			
		/* top black groups: 
		
					top groups to code : go with top 10 groups overall 
					==================================================
					
				1	jamaican						
				2	haitian							
				3	trinidadian/tobagonian	
				4	west indian
				5	guyanese
				
					
					top groups by population : missing guyanese
					--------------------------------------------
					
					nation							pop estimates	frequency
					
				1	jamaican						325,883	    	12,905
				2	haitian							224,651			8,255
				3	african							152,158			5,631
				4	trinidadian/tobagonian			86,343			3,676
				5	west indian						83,568			3,374
				6	nigerian						54,414			2,013
				7	ghanian							30,538			1,097
				8	barbadian						24,967			1,161
				9	grenadian						20,088			819
				10	other subsaharan african		15,311			487 */
				
	
	* create variable for five largest Hispanic groups using "ancestr1"
	gen blackgrps = .
	replace blackgrps = 1 if ancestr1 == 308 /* jamaican */ 
	replace blackgrps = 2 if ancestr1 == 336 /* haitian */ 
	replace blackgrps = 3 if ancestr1 == 370 /* guyanese */ 
	replace blackgrps = 4 if ancestr1 == 314 /* trinidadian/tobagonian */ 
	replace blackgrps = 5 if ancestr1 == 335 | ancestr1 == 337 /* west indian */ 
	lab def blackgrps  1 "jamaican" 2 "haitian" 3 "guyanese" 4 "trinidadian/tobagonian" 5 "west indian"
	lab val blackgrps blackgrps
	lab var blackgrps "five largest Black immigrant groups, using 'ancestr1' only"	
	
	
	* create variable for five largest Hispanic groups using "ancestr1" and "ancestr2"
	gen blackgrps1 = .
	replace blackgrps1 = 1 if ancestr1 == 308 | ancestr2 == 308 /* jamaican */ 
	replace blackgrps1 = 2 if ancestr1 == 336 | ancestr2 == 336 /* haitian */ 
	replace blackgrps1 = 3 if ancestr1 == 370 | ancestr2 == 370 /* guyanese */ 
	replace blackgrps1 = 4 if ancestr1 == 314 | ancestr2 == 314 /* trinidadian/tobagonian */ 
	replace blackgrps1 = 5 if ancestr1 == 335 | ancestr1 == 337 | ancestr2 == 335 |  ancestr2 == 337 /* west indian */ 
	lab def blackgrps1  1 "jamaican" 2 "haitian" 3 "guyanese" 4 "trinidadian/tobagonian" 5 "west indian"
	lab val blackgrps1 blackgrps1
	lab var blackgrps1 "five largest Black immigrant groups, using either 'ancestr1' or 'ancestr2'"
	
	
* percent university degree
* ============================
fre educd 

	* create indicator of university degree or higher
	clonevar coldeg = educd
	recode coldeg (1 = .) (101/116 = 1) (else = 0) /* recode n/a as missing */ 
	*replace coldeg = . if age < 25 & coldeg == 1 /* filter out those who are less than 25 */
	replace coldeg = . if age < 25 /* filter out those who are less than 25 */
	lab def coldeg  0 "less than a college degree" 1 "college degree or higher"
	lab val coldeg coldeg
	lab var coldeg "college degree or higher'"
	
		* checks
		fre coldeg 
		
		tab coldeg raceth , col
	
	
	
* percent employed: using labor force and total pop demoninators
* ============================
fre empstat  

	* create employment variable 
	clonevar employedlf = empstat
	recode employedlf (0 = .) (1 = 1) (2 = 0) (3 = .) 
	lab def employedlf  0 "unemployed" 1 "employed" 
	lab val employedlf employedlf
	lab var employedlf "employed, labor force denominator"
	
		
	* create unemployment variable 
	clonevar unemployed = empstat
	recode unemployed (0 = .) (1 = 0) (2 = 1) (3 = .) 
	lab def unemployed  0 "employed" 1 "unemployed"
	lab val unemployed unemployed
	lab var unemployed "unemployed individuals"
	
		fre employed unemployed
		
	* create employment variable 
	clonevar employedtpop = empstat
	recode employedtpop (0 = .) (1 = 1) (2 = 0) (3 = 0) 
	lab def employedtpop  0 "unemployed" 1 "employed" 
	lab val employedtpop employedtpop
	lab var employedtpop "employed, total pop denominator"
	
	
		fre employedlf employedtpop
	

* % low income
* ===========================
fre poverty

	clonevar lowincome = poverty
	recode lowincome (1/150 = 1) (151/501 = 0) (0 = 0)
	lab def lowincome  0 "not low-income" 1 "low-income"
	lab val lowincome lowincome
	lab var lowincome "low-income = below 150% of poverty line"

	
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
	
	
* working age and working age arrivals
* ============================
fre age 

	* create working age variable 
	clonevar workingage = age
	recode workingage (0/17 = 0) (18/64 = 1) (65/95 = 0)
	lab def workingage 0 "not working age" 1 "working age"
	lab val workingage workingage
	lab var workingage  "working age, 18-64"
	
		* check 
		fre workingage 
		
		/* create arrivals flag, by combining tagging working age individuals 
		   who arrived within last 5 years */
		gen arrivals = . 
		replace arrivals = 1 if yrimmig >= 2010 & yrimmig <= 2014 & multyear == 2014
		replace arrivals = 1 if yrimmig >= 2011 & yrimmig <= 2015 & multyear == 2015
		replace arrivals = 1 if yrimmig >= 2012 & yrimmig <= 2016 & multyear == 2016
		replace arrivals = 1 if yrimmig >= 2013 & yrimmig <= 2017 & multyear == 2017
		replace arrivals = 1 if yrimmig >= 2014 & yrimmig <= 2018 & multyear == 2018
		
			sort yrimmig 
			br yrimmig if arrivals == 1
	
	* create working age variable for arrivals within last 5 years 
	clonevar workingage_arrival = workingage
	replace workingage_arrival = 0 if arrivals != 1
	lab def workingage_arrival 0 "not working age arrival" 1 "working age arrival"
	lab val workingage_arrival workingage_arrival
	lab var workingage_arrival "working age arrivals, 18-64"
	
		* check 
		fre workingage workingage_arrival
		
		
		tab coldeg raceth if workingage == 0 [fw = perwt], col
		tab coldeg raceth if workingage == 1 [fw = perwt], col
		
		tab coldeg raceth if workingage == 1 [fw = perwt], row
		tab coldeg raceth  [fw = perwt], row
		
		table raceth [pw = perwt],  c(n coldeg)  center row
		
	
	*****
	* determine order of groups based on both first and second responses to ancestry variable
	*****	
	* use these frequency tables to determine order in excel spreadsheet: "black popualtion by ancestry.xlsx"
	
		* top 10 groups by working age population counts
		fre hispangrps1 [fw = perwt] if workingage == 1, desc 
		fre asiangrps1 [fw = perwt] if workingage == 1, desc 
		fre blackgrps1 [fw = perwt] if workingage == 1, desc 
		
		* top 10 groups by totoal population counts		
		fre hispangrps1 [fw = perwt], desc 
		fre asiangrps1 [fw = perwt], desc 
		fre blackgrps1 [fw = perwt], desc 
	
	
	******
	* save dataset after all data cleaning has finished
	******
	compress 
	
	save "$savedir/2021.03.19 Bubble Chart Data.dta", replace
	
		clear all
		
		
		
	
														* ============
														* Data export
														* ============
														
														
* working age data creation and export
* ===================================

	*************************
	* race-ethnicity (raceth)
	*************************
	use "$savedir/2021.03.19 Bubble Chart Data.dta", clear
	
	* create population variable
	clonevar pop = raceth if workingage == 1
	
		* collapse dataset
		collapse (sum) coldeg employedlf employedtpop lowincome homeownership (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   employedlf_n = employedlf lowincome_n = lowincome homeownership_n = homeownership  [pw = perwt], by(raceth workingage)
		
	
				* before drop, make sure not working age sum to metro area total
				* -------------------------
				* drop observations if not working age (keep to check)
				drop if workingage == 0
				drop workingage
			
		
			* create percent variables 
			* -------------------------
			foreach v of varlist coldeg employedlf employedtpop lowincome homeownership {

				gen p`v' = (`v'/`v'_n)*100
				order `v', before(`v'_n)
				order p`v', after(`v'_n)
			
			}
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedlf "employed, labor force denominator, working age"
				lab var employedtpop "employed, total pop denominator, working age"
				lab var lowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employed, total pop denominator, working age"
				lab var employedlf_n "total employed, labor force, working age"
				lab var lowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				
				* percent variables 
				lab var pcoldeg "percent with a college degree, working age"
				lab var pemployedtpop "percent employed, total pop denominator, working age"
				lab var pemployedlf "percent employed, labor force demoninator, working age"
				lab var plowincome "percent low-income, working age"
				lab var phomeownership "percent homeowners, working age"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
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
				rename pemployedtpop Employedtpop	
				rename pemployedlf Employedlf
				rename plowincome Low_income 	
				rename phomeownership Homeowner
				
			
		* export to excel 		
		export excel using "$tabledir/2021.03.19 Bubble Chart.xlsx", sheet("calculations", modify) firstrow(variables) keepcellfmt cell(A1)
	


	*************************
	* hispanic (hispangrps1)
	*************************
	use "$savedir/2021.03.19 Bubble Chart Data.dta", clear

	* create population variable
	clonevar pop = hispangrps1 if workingage == 1
	
		* collapse dataset
		collapse (sum) coldeg employedlf employedtpop lowincome homeownership (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   employedlf_n = employedlf lowincome_n = lowincome homeownership_n = homeownership  [pw = perwt], by(hispangrps1 workingage)
					   
					   
				* before drop, make sure hisp missing and not working age sum to metro area total
				* -------------------------
				* drop everyone not hispanic
				drop if hispangrps1 == .
			
	
				* drop observations if not working age (keep to check)
				drop if workingage == 0
				drop workingage
			
		
			* create percent variables 
			* -------------------------
			foreach v of varlist coldeg employedlf employedtpop lowincome homeownership {

				gen p`v' = (`v'/`v'_n)*100
				order `v', before(`v'_n)
				order p`v', after(`v'_n)
			
			}
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedlf "employed, labor force denominator, working age"
				lab var employedtpop "employed, total pop denominator, working age"
				lab var lowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employed, total pop denominator, working age"
				lab var employedlf_n "total employed, labor force, working age"
				lab var lowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				
				* percent variables 
				lab var pcoldeg "percent with a college degree, working age"
				lab var pemployedtpop "percent employed, total pop denominator, working age"
				lab var pemployedlf "percent employed, labor force demoninator, working age"
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
				rename pemployedtpop Employedtpop	
				rename pemployedlf Employedlf
				rename plowincome Low_income 	
				rename phomeownership Homeowner
				
				* rename variable groups to be singular instead of plural 
				lab def hispangrps1  1 "puerto rican" 2 "dominican" 3 "mexican" 4 "ecuadorian" 5 "colombian", modify
				lab val hispangrps1 hispangrps1
		
			
		* export to excel 
		export excel using "$tabledir/2021.03.19 Bubble Chart.xlsx", sheet("calculations", modify) keepcellfmt cell(A7)
		
		

	*************************
	* asian (asiangrps1)
	*************************
	use "$savedir/2021.03.19 Bubble Chart Data.dta", clear
	
	* create population variable
	clonevar pop = asiangrps1 if workingage == 1

		* collapse dataset
		collapse (sum) coldeg employedlf employedtpop lowincome homeownership (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   employedlf_n = employedlf lowincome_n = lowincome homeownership_n = homeownership  [pw = perwt], by(asiangrps1 workingage)
					   
					   
				* before drop, make sure asian missing and not working age sum to metro area total
				* -------------------------
				* drop everyone not asian
				drop if asiangrps1 == .
			
	
				* drop observations if not working age (keep to check)
				drop if workingage == 0
				drop workingage
			
		
			* create percent variables 
			* -------------------------
			foreach v of varlist coldeg employedlf employedtpop lowincome homeownership {

				gen p`v' = (`v'/`v'_n)*100
				order `v', before(`v'_n)
				order p`v', after(`v'_n)
			
			}
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedlf "employed, labor force denominator, working age"
				lab var employedtpop "employed, total pop denominator, working age"
				lab var lowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employed, total pop denominator, working age"
				lab var employedlf_n "total employed, labor force, working age"
				lab var lowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				
				* percent variables 
				lab var pcoldeg "percent with a college degree, working age"
				lab var pemployedtpop "percent employed, total pop denominator, working age"
				lab var pemployedlf "percent employed, labor force demoninator, working age"
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
				rename pemployedtpop Employedtpop	
				rename pemployedlf Employedlf
				rename plowincome Low_income 	
				rename phomeownership Homeowner
				
				* rename bengali to bangladeshi
				lab def asiangrps1  1 "chinese" 2 "indian" 3 "filipino" 4 "korean" 5 "bangladeshi", modify
				lab val asiangrps1 asiangrps1
				
		
		* export to excel 
		export excel using "$tabledir/2021.03.19 Bubble Chart.xlsx", sheet("calculations", modify)  keepcellfmt cell(A12)
		
		
	*************************
	* black immigrant groups (blackgrps1)
	*************************
	use "$savedir/2021.03.19 Bubble Chart Data.dta", clear
	
	* create population variable
	clonevar pop = blackgrps1 if workingage == 1

		* collapse dataset
		collapse (sum) coldeg employedlf employedtpop lowincome homeownership (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   employedlf_n = employedlf lowincome_n = lowincome homeownership_n = homeownership  [pw = perwt], by(blackgrps1 workingage)
					   
					   
				* before drop, make sure black immgrant missing and not working age sum to metro area total
				* -------------------------
				* drop everyone not black immgrant
				drop if blackgrps1 == .
			
	
				* drop observations if not working age (keep to check)
				drop if workingage == 0
				drop workingage
			
		
			* create percent variables 
			* -------------------------
			foreach v of varlist coldeg employedlf employedtpop lowincome homeownership {

				gen p`v' = (`v'/`v'_n)*100
				order `v', before(`v'_n)
				order p`v', after(`v'_n)
			
			}
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedlf "employed, labor force denominator, working age"
				lab var employedtpop "employed, total pop denominator, working age"
				lab var lowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employed, total pop denominator, working age"
				lab var employedlf_n "total employed, labor force, working age"
				lab var lowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				
				* percent variables 
				lab var pcoldeg "percent with a college degree, working age"
				lab var pemployedtpop "percent employed, total pop denominator, working age"
				lab var pemployedlf "percent employed, labor force demoninator, working age"
				lab var plowincome "percent low-income, working age"
				lab var phomeownership "percent homeowners, working age"

				lab var pop "population of top 5 black immgrant groups"
	
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
				rename pemployedtpop Employedtpop	
				rename pemployedlf Employedlf
				rename plowincome Low_income 	
				rename phomeownership Homeowner
				
				* rename bengali to bangladeshi
				lab def blackgrps1  1 "jamaican" 2 "haitian" 3 "guyanese" 4 "trinidadian/tobagonian" 5 "west indian", modify
				lab val blackgrps1 blackgrps1
				
		
		* export to excel 
		export excel using "$tabledir/2021.03.19 Bubble Chart.xlsx", sheet("calculations", modify)  keepcellfmt cell(A17)


* working age arrivals data creation and export
* =============================================		

	*************************
	* race-ethnicity (raceth)
	*************************
	use "$savedir/2021.03.19 Bubble Chart Data.dta", clear
	
	* create population variable
	clonevar pop = raceth if workingage_arrival == 1
		
		* collapse dataset
		collapse (sum) coldeg employedlf employedtpop lowincome homeownership (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   employedlf_n = employedlf lowincome_n = lowincome homeownership_n = homeownership  [pw = perwt], by(raceth workingage_arrival)
		
	
				* before drop, make sure not working age sum to metro area total
				* -------------------------
				* drop observations if not working age arrival (keep to check)
				drop if workingage_arrival == 0
				drop workingage_arrival
			
		
			* create percent variables 
			* -------------------------
			foreach v of varlist coldeg employedlf employedtpop lowincome homeownership {

				gen p`v' = (`v'/`v'_n)*100
				order `v', before(`v'_n)
				order p`v', after(`v'_n)
			
			}
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedlf "employed, labor force denominator, working age"
				lab var employedtpop "employed, total pop denominator, working age"
				lab var lowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employed, total pop denominator, working age"
				lab var employedlf_n "total employed, labor force, working age"
				lab var lowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				
				* percent variables 
				lab var pcoldeg "percent with a college degree, working age"
				lab var pemployedtpop "percent employed, total pop denominator, working age"
				lab var pemployedlf "percent employed, labor force demoninator, working age"
				lab var plowincome "percent low-income, working age"
				lab var phomeownership "percent homeowners, working age"
								
				lab var pop "population of top 5 race-ethnic groups"
				
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
				rename pemployedtpop Employedtpop	
				rename pemployedlf Employedlf
				rename plowincome Low_income 	
				rename phomeownership Homeowner
			
		* export to excel 		
		export excel using "$tabledir/2021.03.19 Bubble Chart.xlsx", sheet("calculations", modify) firstrow(variables) keepcellfmt cell(A23)
	


	*************************
	* hispanic (hispangrps1)
	*************************
	use "$savedir/2021.03.19 Bubble Chart Data.dta", clear

	* create population variable
	clonevar pop = hispangrps1 if workingage_arrival == 1
	
		* collapse dataset
		collapse (sum) coldeg employedlf employedtpop lowincome homeownership (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   employedlf_n = employedlf lowincome_n = lowincome homeownership_n = homeownership  [pw = perwt], by(hispangrps1 workingage_arrival)
					   
					   
				* before drop, make sure hisp missing and not working age sum to metro area total
				* -------------------------
				* drop everyone not hispanic
				drop if hispangrps1 == .
			
	
				* drop observations if not working age arrival (keep to check)
				drop if workingage_arrival == 0
				drop workingage_arrival
			
		
			* create percent variables 
			* -------------------------
			foreach v of varlist coldeg employedlf employedtpop lowincome homeownership {

				gen p`v' = (`v'/`v'_n)*100
				order `v', before(`v'_n)
				order p`v', after(`v'_n)
			
			}
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedlf "employed, labor force denominator, working age"
				lab var employedtpop "employed, total pop denominator, working age"
				lab var lowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employed, total pop denominator, working age"
				lab var employedlf_n "total employed, labor force, working age"
				lab var lowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				
				* percent variables 
				lab var pcoldeg "percent with a college degree, working age"
				lab var pemployedtpop "percent employed, total pop denominator, working age"
				lab var pemployedlf "percent employed, labor force demoninator, working age"
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
				rename pemployedtpop Employedtpop	
				rename pemployedlf Employedlf
				rename plowincome Low_income 	
				rename phomeownership Homeowner
				
				* rename variable groups to be singular instead of plural 
				lab def hispangrps1  1 "puerto rican" 2 "dominican" 3 "mexican" 4 "ecuadorian" 5 "colombian", modify
				lab val hispangrps1 hispangrps1
			
		* export to excel 
		export excel using "$tabledir/2021.03.19 Bubble Chart.xlsx", sheet("calculations", modify) keepcellfmt cell(A29)
		
		

	*************************
	* asian (asiangrps1)
	*************************
	use "$savedir/2021.03.19 Bubble Chart Data.dta", clear
	
	* create population variable
	clonevar pop = asiangrps1 if workingage_arrival == 1
	
		* collapse dataset
		collapse (sum) coldeg employedlf employedtpop lowincome homeownership (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   employedlf_n = employedlf lowincome_n = lowincome homeownership_n = homeownership  [pw = perwt], by(asiangrps1 workingage_arrival)
					   
					   
				* before drop, make sure asian missing and not working age sum to metro area total
				* -------------------------
				* drop everyone not asian
				drop if asiangrps1 == .
			
	
				* drop observations if not working age (keep to check)
				drop if workingage_arrival == 0
				drop workingage_arrival
			
		
			* create percent variables 
			* -------------------------
			foreach v of varlist coldeg employedlf employedtpop lowincome homeownership {

				gen p`v' = (`v'/`v'_n)*100
				order `v', before(`v'_n)
				order p`v', after(`v'_n)
			
			}
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedlf "employed, labor force denominator, working age"
				lab var employedtpop "employed, total pop denominator, working age"
				lab var lowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employed, total pop denominator, working age"
				lab var employedlf_n "total employed, labor force, working age"
				lab var lowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				
				* percent variables 
				lab var pcoldeg "percent with a college degree, working age"
				lab var pemployedlf "percent employed, labor force denominator, working age"
				lab var pemployedtpop "percent employed, total pop demoninator, working age"
				lab var plowincome "percent low-income, working age"
				lab var phomeownership "percent homeowners, working age"
				
				lab var pop "population of top 5 asians groups"
								
			
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
				rename pemployedtpop Employedtpop	
				rename pemployedlf Employedlf
				rename plowincome Low_income 	
				rename phomeownership Homeowner
				
				* rename bengali to bangladeshi
				lab def asiangrps1  1 "chinese" 2 "indian" 3 "filipino" 4 "korean" 5 "bangladeshi", modify
				lab val asiangrps1 asiangrps1
		
		* export to excel 
		export excel using "$tabledir/2021.03.19 Bubble Chart.xlsx", sheet("calculations", modify) keepcellfmt cell(A34)
		
		
	*************************
	* black immigrant groups (blackgrps1)
	*************************
	use "$savedir/2021.03.19 Bubble Chart Data.dta", clear
	
	* create population variable
	clonevar pop = blackgrps1 if workingage_arrival == 1
	
		* collapse dataset
		collapse (sum) coldeg employedlf employedtpop lowincome homeownership (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   employedlf_n = employedlf lowincome_n = lowincome homeownership_n = homeownership  [pw = perwt], by(blackgrps1 workingage_arrival)
					   
					   
				* before drop, make sure black immigrant missing and not working age sum to metro area total
				* -------------------------
				* drop everyone not black immigrant
				drop if blackgrps1 == .
			
	
				* drop observations if not working age (keep to check)
				drop if workingage_arrival == 0
				drop workingage_arrival
			
		
			* create percent variables 
			* -------------------------
			foreach v of varlist coldeg employedlf employedtpop lowincome homeownership {

				gen p`v' = (`v'/`v'_n)*100
				order `v', before(`v'_n)
				order p`v', after(`v'_n)
			
			}
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedlf "employed, labor force denominator, working age"
				lab var employedtpop "employed, total pop denominator, working age"
				lab var lowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employed, total pop denominator, working age"
				lab var employedlf_n "total employed, labor force, working age"
				lab var lowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				
				* percent variables 
				lab var pcoldeg "percent with a college degree, working age"
				lab var pemployedlf "percent employed, labor force denominator, working age"
				lab var pemployedtpop "percent employed, total pop demoninator, working age"
				lab var plowincome "percent low-income, working age"
				lab var phomeownership "percent homeowners, working age"
				
				lab var pop "population of top 5 black immigrants groups"
								
			
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
				rename pemployedtpop Employedtpop	
				rename pemployedlf Employedlf
				rename plowincome Low_income 	
				rename phomeownership Homeowner
				
				* rename bengali to bangladeshi
				lab def blackgrps1  1 "jamaican" 2 "haitian" 3 "guyanese" 4 "trinidadian/tobagonian" 5 "west indian", modify
				lab val blackgrps1 blackgrps1
		
		* export to excel 
		export excel using "$tabledir/2021.03.19 Bubble Chart.xlsx", sheet("calculations", modify) keepcellfmt cell(A39)
		
		
		clear all
		
		
		
														* ============
														* Final Formatting
														* ============
														
														
* final formatting and export
* ===========================


		/* top 10 groups by working age population counts we will use in data viz
		
			1	dominican	   1,002,844
			2	puerto rican	 949,879
			3	chinese	         683,255
			4	mexican	         548,165
			5	indian	         515,133
			6	ecuadorian	     344,157
			7	jamaican	     341,010
			8	colombian	     245,395
			9	haitian	         235,691
			10	filipino	     199,445 */


* load data
import excel "$tabledir/2021.03.19 Bubble Chart.xlsx", sheet("calculations") firstrow clear

	* drop all counts
	drop coldeg-homeownership_n
	
	* generate sequence number for ordering 
	gen seq_n = _n
	
	* gen ordering variable 
	gen order_var = . 
	replace order_var = 1  if raceth  == "non-hispanic white"         & seq_n == 1
	replace order_var = 2  if raceth  == "non-hispanic black"         & seq_n == 2
	replace order_var = 3  if raceth  == "hispanic"                   & seq_n == 3
	replace order_var = 4  if raceth  == "non-hispanic asian"         & seq_n == 4
	replace order_var = 5  if raceth  == "non-hispanic other"         & seq_n == 5
	replace order_var = 6  if raceth  == "dominican"                  & seq_n == 7
	replace order_var = 7  if raceth  == "puerto rican"               & seq_n == 6
	replace order_var = 8  if raceth  == "chinese"                    & seq_n == 11
	replace order_var = 9  if raceth  == "mexican"                    & seq_n == 8
	replace order_var = 10  if raceth  == "indian"                    & seq_n == 12
	replace order_var = 11 if raceth  == "ecuadorian"                 & seq_n == 9
	replace order_var = 12 if raceth  == "jamaican"                   & seq_n == 16
	replace order_var = 13 if raceth  == "colombian"                  & seq_n == 10
	replace order_var = 14 if raceth  == "haitian"                    & seq_n == 17
	replace order_var = 15 if raceth  == "filipino"                   & seq_n == 13
  
	replace order_var = 16 if raceth  == ""                           & seq_n == 21
  
	replace order_var = 17 if raceth  == "raceth"                     & seq_n == 22
	replace order_var = 18 if raceth  == "non-hispanic white"         & seq_n == 23
	replace order_var = 19 if raceth  == "non-hispanic black"         & seq_n == 24
	replace order_var = 20 if raceth  == "hispanic"                   & seq_n == 25
	replace order_var = 21 if raceth  == "non-hispanic asian"         & seq_n == 26
	replace order_var = 22 if raceth  == "non-hispanic other"         & seq_n == 27
	replace order_var = 23 if raceth  == "dominican"                  & seq_n == 29
	replace order_var = 24 if raceth  == "puerto rican"               & seq_n == 28
	replace order_var = 25 if raceth  == "chinese"                    & seq_n == 33
	replace order_var = 26 if raceth  == "mexican"                    & seq_n == 30
	replace order_var = 27 if raceth  == "indian"                     & seq_n == 34
	replace order_var = 28 if raceth  == "ecuadorian"                 & seq_n == 31
	replace order_var = 29 if raceth  == "jamaican"                   & seq_n == 38
	replace order_var = 30 if raceth  == "colombian"                  & seq_n == 32
	replace order_var = 31 if raceth  == "haitian"                    & seq_n == 39
	replace order_var = 32 if raceth  == "filipino"                   & seq_n == 35
	
	* sort by new order var
	sort order_var
	
		* drop rows that are missing on order var 
		drop if order_var == . 
		
	* order variables according to lifecycle
	order Homeowner, after(Population) 
	order Low_income, after(Homeowner) 
	order University, after(Low_income) 
	order Employedlf, after(University) 
	order Employedtpop, after(Employedlf) 
	
	
	* drop extra vars
	drop seq_n order_var Employedlf
	
	

* export to excel 
export excel using "$tabledir/2021.03.19 NY Bubble Chart.xlsx", sheet("calculations", modify) firstrow(variables) keepcellfmt cell(A1)


	clear all 
	
		exit 


	
	
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
	   
	   
	   
	WORKING AGE POPULATION CODING 
	-----------------------------
	* gen ordering variable 
	gen order_var = . 
	replace order_var = 1  if raceth  == "non-hispanic white"         & seq_n == 1
	replace order_var = 2  if raceth  == "non-hispanic black"         & seq_n == 2
	replace order_var = 3  if raceth  == "hispanic"                   & seq_n == 3
	replace order_var = 4  if raceth  == "non-hispanic asian"         & seq_n == 4
	replace order_var = 5  if raceth  == "non-hispanic other"         & seq_n == 5
	replace order_var = 6  if raceth  == "dominican"                  & seq_n == 7
	replace order_var = 7  if raceth  == "puerto rican"               & seq_n == 6
	replace order_var = 8  if raceth  == "chinese"                    & seq_n == 11
	replace order_var = 9  if raceth  == "indian"                     & seq_n == 12
	replace order_var = 10 if raceth  == "mexican"                    & seq_n == 8
	replace order_var = 11 if raceth  == "jamaican"                   & seq_n == 16
	replace order_var = 12 if raceth  == "ecuadorian"                 & seq_n == 9
	replace order_var = 13 if raceth  == "colombian"                  & seq_n == 10
	replace order_var = 14 if raceth  == "haitian"                    & seq_n == 17
	replace order_var = 15 if raceth  == "korean"                     & seq_n == 14
  
	replace order_var = 16 if raceth  == ""                           & seq_n == 21
  
	replace order_var = 17 if raceth  == "raceth"                     & seq_n == 22
	replace order_var = 18 if raceth  == "non-hispanic white"         & seq_n == 23
	replace order_var = 19 if raceth  == "non-hispanic black"         & seq_n == 24
	replace order_var = 20 if raceth  == "hispanic"                   & seq_n == 25
	replace order_var = 21 if raceth  == "non-hispanic asian"         & seq_n == 26
	replace order_var = 22 if raceth  == "non-hispanic other"         & seq_n == 27
	replace order_var = 23 if raceth  == "dominican"                  & seq_n == 29
	replace order_var = 24 if raceth  == "puerto rican"               & seq_n == 28
	replace order_var = 25 if raceth  == "chinese"                    & seq_n == 33
	replace order_var = 26 if raceth  == "indian"                     & seq_n == 34
	replace order_var = 27 if raceth  == "mexican"                    & seq_n == 30
	replace order_var = 28 if raceth  == "jamaican"                   & seq_n == 38
	replace order_var = 29 if raceth  == "ecuadorian"                 & seq_n == 31
	replace order_var = 30 if raceth  == "colombian"                  & seq_n == 32
	replace order_var = 31 if raceth  == "haitian"                    & seq_n == 39
	replace order_var = 32 if raceth  == "korean"                     & seq_n == 36
	 
	   

	
	
	
	
