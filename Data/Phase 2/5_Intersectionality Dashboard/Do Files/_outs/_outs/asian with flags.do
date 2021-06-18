							
							
							* controls 
							* =================
							* asiangrps1 sex age_group NYC immig_group
														
* asian groups (asiangrps1) working age data creation and export
* ============================================================
	
	*************************
	* asian groups
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
		
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
		* collapse dataset: asian groups
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1) 
				
				
					* drop missing for asiangrps1
					drop if asiangrps1 == .
					
					sort asiangrps1	
					
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
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
					
					
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if  `v' > 20  // make sure to use the 20 threshold during summmation
				
				}
				
					*check on missing
					br asiangrps1 age_group immig_group employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						} 
						
						*check 
						br asiangrps1 age_group immig_group coldeg coldeg_n z_coldeg
						
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
			order sex-immig_group, after(asiangrps1)
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
				sort sex age_group NYC immig_group asiangrps1 
					
					* generate flag for z-score creation 
					gen flag = 3 
				
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", replace) firstrow(variables) keepcellfmt cell(A1)
					
	*************************
	* asian groups by age_group 
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: asian groups by age_group 
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 age_group) 
					   
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
					
				* fillin to make dataset rectangular 
				fillin asiangrps1 age_group
				
					sort asiangrps1 age_group 
				
		
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
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order sex, after(asiangrps1)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A8)
		
		
	*************************
	* asian groups by age_group by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: asian groups by age_group by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 age_group immig_group) 
				
				* drop missing for asiangrps1
				drop if asiangrps1 == .
					
				* fillin to make dataset rectangular 
				fillin asiangrps1 age_group immig_group
				
					sort asiangrps1 age_group immig_group
		
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
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order sex, after(asiangrps1)
			order NYC, after(age_group)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A34)
					
	*************************
	* asian groups by age_group by NYC
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: asian groups by age_group by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 age_group NYC) 
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
					
				* fillin to make dataset rectangular 
				fillin asiangrps1 age_group NYC
				
				sort asiangrps1 age_group NYC
		
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
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order sex, after(asiangrps1)
			order age_group, after(sex)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A185)
					
	*************************
	* asian groups by age_group by NYC by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: asian groups by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 age_group NYC immig_group) 
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
					
				* fillin to make dataset rectangular 
				fillin asiangrps1 age_group NYC immig_group
				
					sort asiangrps1 age_group NYC immig_group
		
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order sex, after(asiangrps1)
			order NYC, after(age_group)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 	
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A336)
				
	*************************
	* asian groups by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: asian groups by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 immig_group) 
					   
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
					
				* fillin to make dataset rectangular 
				fillin asiangrps1 immig_group
				
					sort asiangrps1 immig_group
				
		
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order sex-NYC, after(asiangrps1)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A1237)
		
	*************************
	* asian groups by NYC 
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: asian groups by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 NYC) 
					   
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
					
				* fillin to make dataset rectangular 
				fillin asiangrps1 NYC
				
					sort asiangrps1 NYC  
				
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
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order sex-age_group, after(asiangrps1)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A1268)
					
					
	*************************
	* asian groups by NYC by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: ace-ethnicity by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 NYC immig_group) 
					   
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
				
				* fillin to make dataset rectangular 
				fillin asiangrps1 NYC immig_group
				
					sort asiangrps1 NYC immig_group
				
		
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order sex-age_group, after(asiangrps1)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A1299)
											
	*************************
	* asian groups by sex 
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
		
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: asian groups by sex
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 sex) 
					   
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
					
				* fillin to make dataset rectangular 
				fillin asiangrps1 sex
				
					sort asiangrps1 sex
		
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
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A1480)
					
							
	*************************
	* asian groups by sex by age_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
						   
		* collapse dataset: asian groups by sex total
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 sex age_group) 
					   
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
					
				* fillin to make dataset rectangular 
				fillin asiangrps1 sex age_group
				
					sort asiangrps1 sex age_group
				
		
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
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A1491)
					
	*************************
	* asian groups by sex by age_group by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: asian groups by sex by age_group by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 sex age_group immig_group) 
					   
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
					
				* fillin to make dataset rectangular 
				fillin asiangrps1 sex age_group immig_group
				
					sort asiangrps1 sex age_group immig_group
				
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
				
				* generate total variables
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
			
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex coldeg coldeg_n z_coldeg
						
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
			order NYC, after(age_group)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A1542)
					
					
	*************************
	* asian groups by sex by age_group by NYC
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
						   
		* collapse dataset: asian groups by sex by age_group by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 sex age_group NYC) 
					   
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
					
				* fillin to make dataset rectangular 
				fillin asiangrps1 sex age_group NYC
				
					sort asiangrps1 sex age_group NYC
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
				
				* generate total variables 
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A1843)
					
					
	*************************
	* asian groups by sex by age_group by NYC by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: asian groups by sex by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 sex age_group NYC immig_group) 
					   
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
					
				* fillin to make dataset rectangular 
				fillin asiangrps1 sex age_group NYC immig_group
				
					sort asiangrps1 sex age_group NYC immig_group
				
		
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A2144)
	
	*************************
	* asian groups by sex by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
				
						   
		* collapse dataset: asian groups by sex by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 sex immig_group) 
					     
				* drop missing for asiangrps1
				drop if asiangrps1 == .
				
				* fillin to make dataset rectangular 
				fillin asiangrps1 sex immig_group
				
				sort asiangrps1 sex immig_group
		
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order age_group-NYC, after(sex)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A3945)
			
	*************************
	* asian groups by sex by NYC
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
				
						   
		* collapse dataset: asian groups by sex by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 sex NYC) 
					   
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
				
				* fillin to make dataset rectangular 
				fillin asiangrps1 sex NYC 
				
				sort asiangrps1 sex NYC 
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
				
				* generate total variables
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
		
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order age_group, after(sex)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A4006)	
			
	*************************
	* asian groups by sex by NYC by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
				
						   
		* collapse dataset: ace-ethnicity by sex by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(asiangrps1 sex NYC immig_group) 
					   
					   
				* drop missing for asiangrps1
				drop if asiangrps1 == .
				
				* fillin to make dataset rectangular 
				fillin asiangrps1 sex NYC immig_group
				
					sort asiangrps1 sex NYC immig_group
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
				
				* generate total variables
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
		
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order age_group, after(sex)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A4067)	
			
	
	*************************
	* sex
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: sex 
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
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
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
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A4428)
	
	*************************
	* sex by age_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: sex by age_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(sex age_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex age_group
				
					sort sex age_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A4431)
					
			
	*************************
	* sex by age_group by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: sex by age_group by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(sex age_group immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex age_group immig_group
				
					sort sex age_group immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
		
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
			order NYC, after(age_group)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A4442)
	
	*************************
	* sex by age_group by NYC
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: sex by age_group by NYC 
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(sex age_group NYC) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex age_group NYC
				
					sort sex age_group NYC
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A4503)	
			
	*************************
	* sex by age_group by NYC by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: sex by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(sex age_group NYC immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex age_group NYC immig_group
				
					sort sex age_group NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A4564)		
			
	*************************
	* sex by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: sex by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(sex immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex immig_group
				
					sort sex immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
				* generate total variables
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
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
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
			order age_group- NYC, after(sex)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A4925)
					
	*************************
	* sex by NYC
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: sex by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(sex NYC) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex NYC
				
					sort sex NYC
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
				* generate total variables
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
			order age_group, after(sex)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A4938)	
		
	*************************
	* sex by NYC by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: sex by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(sex NYC immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex NYC immig_group
				
					sort sex NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
				* generate total variables
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
				
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
					br asiangrps1 sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 sex  coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
			order age_group, after(sex)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A4951)		
			
			
	*************************
	* age_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
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
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"

				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br asiangrps1 employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
			order sex, after(asiangrps1)
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
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A5024)
					
					
	*************************
	* age_group by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: age_group by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(age_group immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin age_group immig_group
					
					sort age_group immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
		
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
					br asiangrps1 employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
			order sex, after(asiangrps1)
			order NYC, after(age_group)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A5030)
					
	*************************
	* age_group by NYC
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: age_group by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(age_group NYC) 
					   
					   
				* fillin to make dataset rectangular 
				fillin age_group NYC
				 
					sort age_group NYC
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
		
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"

				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br asiangrps1 employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
			order sex, after(asiangrps1)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A5061)
					
	*************************
	* age_group by NYC by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(age_group NYC immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin age_group NYC immig_group
				
					sort age_group NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
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
					br asiangrps1 employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
			order sex, after(asiangrps1)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A5092)		
						
	*************************
	* NYC 
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
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
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
			
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"

				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br asiangrps1 employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
			order sex-age_group, after(asiangrps1)
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
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A5273)
					
	*************************
	* NYC by immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* collapse dataset: NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt], by(NYC immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin NYC immig_group
				
					sort NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
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
					br asiangrps1 employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
			order sex-age_group, after(asiangrps1)
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
				drop _fillin
				
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A5280)
					
	*************************
	* immig_group
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
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
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
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
					br asiangrps1 employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br asiangrps1 coldeg coldeg_n z_coldeg
						
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
			order asiangrps1-NYC, before(immig_group)
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
				sort sex age_group NYC immig_group asiangrps1 
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify)  keepcellfmt cell(A5317)	
					
					
	*************************
	* asian groups: grand total
	*************************
	use "$savedir/2020.09.18 Intersectionality Dashboard Data.dta", clear
		
		* create population variable
		gen pop = asiangrps1 
		lab var pop "population of Asian groups"
				
				* sort on "by" variables to speed up collapse 
				sort asiangrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
		* collapse dataset: race-ethnicity
		* ---------------------------------------
		gcollapse (sum) coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   lowincome_n = lowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   rburden_n = rburden oburden_n = oburden [pw = perwt] 
				
					* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-oburden_n{
						
						format `v' %10.0fc
					
					}
					
				* generate total variables
				gen asiangrps1 = 1
				lab def asiangrps1_total  1 "Total - Asian groups"
				lab val asiangrps1 asiangrps1_total
				lab var asiangrps1 "total asian groups, working class"
				
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
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
					
					
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if  `v' > 20  // make sure to use the 20 threshold during summmation
				
				}
				
					*check on missing
					br asiangrps1 age_group immig_group employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
							replace z_`v' = . if `v' < 20
				
						} 
						
						*check 
						br asiangrps1 age_group immig_group coldeg coldeg_n z_coldeg
						
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
			order asiangrps1, first
			order sex-immig_group, after(asiangrps1)
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
				sort sex age_group NYC immig_group asiangrps1 
				
					* generate flag for z-score creation 
					gen flag = 3
			
					* export to excel 		
					export excel using "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings", modify) keepcellfmt cell(A5324)	
			

* asian groups (asiangrps1) working age data creation and export
* ============================================================
import excel "$tabledir/2020.09.18 Intersectionality Dashboard-asian.xlsx", sheet("strings") firstrow clear

	* sort 
	sort sex age_group NYC immig_group asiangrps1 

		* drop missing rows 
		drop in 1/31
	
	* check that datset is rectangular
	fre  sex age_group NYC immig_group asiangrps1 
		
	* sort 
	sort sex age_group NYC immig_group asiangrps1 
	
		* rename bengali to bangladeshi
		replace asiangrps1 = "bangladeshi" if asiangrps1 == "bengali" 
		
	* fre of flag
	fre flag
	
* save data for merge 
save "$savedir/2020.09.18 Intersectionality Dashboard-asian.dta", replace 
		
	clear all


					
