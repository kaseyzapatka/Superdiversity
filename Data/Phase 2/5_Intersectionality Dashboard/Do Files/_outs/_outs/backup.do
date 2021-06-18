												
														
* race-ethnicity (raceth) working age data creation and export
* ============================================================

	*************************
	* race-ethnicity total
	*************************
	use "$savedir/2020.09.11 Intersectionality Dashboard Data.dta", clear
	
					   
		* collapse dataset: total age 
		* -------------------------
		
		* create population variable
		clonevar pop = raceth if workingage == 1
		lab var pop "population of race-ethnicity"
				
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
				
