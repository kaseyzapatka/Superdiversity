							
							
							* controls 
							* =================
							* raceth sex age_group NYC immig_group
														
* race-ethnicity (raceth) working age data creation and export
* ============================================================

	
	*************************
	* race-ethnicity
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
		
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
		* collapse dataset: race-ethnicity
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth) 
					   
				
					* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
				* generate total variables
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"
				
					
					
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if  `v' > 20  // make sure to use the 20 threshold during summmation
				
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
				order sex-immig_group, after(raceth)
				
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
				
	
				* sort for excel 
				sort sex age_group  raceth NYC immig_group
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", replace) firstrow(variables) keepcellfmt cell(A1)
		
		
	*************************
	* race-ethnicity by sex 
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
				
						   
		* collapse dataset: race-ethnicity by sex
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth sex) 
					   
					   
				sort raceth sex
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
				
				* generate total variables 
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"
				
				
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
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
				order age_group-immig_group, after(sex)
				
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
				
			
				* sort for excel 
				sort sex age_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A8)
					
					
					
	*************************
	* race-ethnicity by sex by age_group
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
						   
		* collapse dataset: race-ethnicity by sex total
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth sex age_group) 
					   
					   
				sort raceth sex age 
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
				
				* generate total variables 
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"
				
				
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
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
				order NYC-immig_group, after(age_group)
				
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
				
			
				* sort for excel 
				sort sex age_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A19)
					
	*************************
	* race-ethnicity by sex by age_group by NYC
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
						   
		* collapse dataset: race-ethnicity by sex total
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth sex age_group NYC) 
					   
					   
				sort raceth sex age NYC 
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
				
				* generate total variables 
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"
				
				
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
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
				order immig_group, after(NYC)
				
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
				
			
				* sort for excel 
				sort sex age_group NYC raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A70)
					
					
	*************************
	* race-ethnicity by sex by age_group by NYC by immig_group
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: race-ethnicity by sex total
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth sex age_group NYC immig_group) 
					   
					   
				sort sex age_group NYC immig_group raceth 
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
				
				
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
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A371)
					
	*************************
	* race-ethnicity by age_group 
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: race-ethnicity by age_group 
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth age_group) 
					   
					   
				sort age_group 
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"
				
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
				order sex, after(raceth)
				order NYC-immig_group, after(age_group)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A2004)
					
					
	*************************
	* race-ethnicity by age_group by NYC
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: race-ethnicity by age_group by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth age_group NYC) 
					   
					   
				sort age_group NYC 
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"
				
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
				order sex, after(raceth)
				order immig_group, after(NYC)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A2030)
				
				
	*************************
	* race-ethnicity by age_group by NYC by immig_group
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: race-ethnicity by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth age_group NYC immig_group) 
					   
					   
				sort age_group NYC immig_group 
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order sex, after(raceth)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A2181)
			
	*************************
	* race-ethnicity by NYC 
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: race-ethnicity by sex total
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth NYC) 
					   
					   
				sort NYC  
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order sex-age_group, after(raceth)
			order immig_group, after(NYC)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3010)
	
	*************************
	* race-ethnicity by NYC by immig_group
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: race-ethnicity by sex total
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth NYC immig_group) 
					   
					   
				sort NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order sex-age_group, after(raceth)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3041)
					
	
	*************************
	* race-ethnicity by immig_group
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: race-ethnicity by sex total
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(raceth immig_group) 
					   
					   
				sort immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if  `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order sex-NYC, after(raceth)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3222)
	
	*************************
	* sex
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: race-ethnicity by sex total
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(sex) 
					   
					   
				sort sex
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"
				
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
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order raceth, first
			order age_group-immig_group, after(sex)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3253)
	
	*************************
	* sex by age_group
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: race-ethnicity by sex total
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(sex age_group) 
					   
					   
				sort sex age_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"
				
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
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order raceth, first
			order NYC-immig_group, after(age_group)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3256)
					
					
	*************************
	* sex by age_group by NYC
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: sex by age_group by NYC 
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(sex age_group NYC) 
					   
					   
				sort sex age_group NYC
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"
				
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
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order raceth, first
			order immig_group, after(NYC)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3267)
					
	*************************
	* sex by age_group by NYC by immig_group
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: sex by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(sex age_group NYC immig_group) 
					   
					   
				sort sex age_group NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
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
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order raceth, first
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3328)
					
	*************************
	* age_group
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: sex by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(age_group) 
					   
					   
				sort age_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"

				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order raceth, first
			order sex, after(raceth)
			order NYC-immig_group, after(age_group)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3664)
					
					
	*************************
	* age_group by NYC
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: age_group by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(age_group NYC) 
					   
					   
				sort age_group NYC
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
		
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"

				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order raceth, first
			order sex, after(raceth)
			order immig_group, after(NYC)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3670)
					
	*************************
	* age_group by NYC by immig_group
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(age_group NYC immig_group) 
					   
					   
				sort age_group NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order raceth, first
			order sex, after(raceth)
			order immig_group, after(NYC)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3701)
					
	*************************
	* NYC 
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: NYC 
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(NYC) 
					   
					   
				sort NYC 
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
			
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant chort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant chort, working class"

				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order raceth, first
			order sex-age_group, after(raceth)
			order immig_group, after(NYC)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3871)
					
	*************************
	* NYC by immig_group
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(NYC immig_group) 
					   
					   
				sort NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order raceth, first
			order sex-age_group, after(raceth)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3878)
					
	*************************
	* immig_group
	*************************
	use "$savedir/2020.09.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up collapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(immig_group) 
					   
					   
				sort immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
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
			order raceth-NYC, before(immig_group)
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
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.16 Intersectionality Dashboard.xlsx", sheet("strings", modify)  keepcellfmt cell(A3915)		
					
