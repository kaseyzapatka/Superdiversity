/* 


	Outlier issue
	* -----------------
	- Still not sure what to do about this outlier, I think we need it because 
	  it represents an important group of individuals, however, small .  */
	  
	  
* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/IPUMS"
global savedir "${db}/Phase 2/5_Intersectionality Dashboard/Recoded"
global tabledir "${db}/Phase 2/5_Intersectionality Dashboard/Tables"

														
* race-ethnicity (raceth) working age data creation and export
* ============================================================

	*************************
	* race-ethnicity total
	*************************
	use "$savedir/2020.09.11 Intersectionality Dashboard Data.dta", clear
	
	* create population variable
	clonevar pop = raceth if workingage == 1
	lab var pop "population of race-ethnicity"
	
	
	* problem with immigration group coding: individual would be 34 years old if came in pre-1980 immig_group via 2014 data
	* -------------------------------------------------------------------------------------------------------
	tab coldeg if raceth == 1 & age_group == 2 & sex == 1 & immig_group == 1
	gen tag = 1 if raceth == 1 & age_group == 2 & sex == 1 & immig_group == 1
		
		sort tag 
		br tag raceth age yrimmig age_group sex immig_group
