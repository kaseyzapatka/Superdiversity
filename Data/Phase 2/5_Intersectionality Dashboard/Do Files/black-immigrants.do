							
							
							* controls 
							* =================
							* blackgrps1 sex age_group NYC immig_group
														
* black immigrant groups (blackgrps1) working age data creation and export
* ============================================================
	
	*************************
	* black immigrant groups
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
		
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
		* gcollapse dataset: black immigrant groups
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1) 
				
				
					* drop missing for blackgrps1
					drop if blackgrps1 == .
					
					sort blackgrps1	
					
					* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if  `v' > 20  // make sure to use the 20 threshold during summmation
				
				}
				
					*check on missing
					br blackgrps1 age_group immig_group employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						} 
						
						*check 
						br blackgrps1 age_group immig_group coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_)
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order sex-immig_group, after(blackgrps1)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
	
				* sort for excel 
				sort sex age_group NYC immig_group blackgrps1 
				
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", replace) firstrow(variables) keepcellfmt cell(A1)
					
	*************************
	* black immigrant groups by age_group 
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: black immigrant groups by age_group 
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 age_group) 
					   
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
					
				* fillin to make dataset rectangular 
				fillin blackgrps1 age_group
				
					sort blackgrps1 age_group 
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order sex, after(blackgrps1)
			order NYC-immig_group, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A8)
		
		
	*************************
	* black immigrant groups by age_group by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: black immigrant groups by age_group by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 age_group immig_group) 
				
				* drop missing for blackgrps1
				drop if blackgrps1 == .
					
				* fillin to make dataset rectangular 
				fillin blackgrps1 age_group immig_group
				
					sort blackgrps1 age_group immig_group
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order sex, after(blackgrps1)
			order NYC, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A34)
					
	*************************
	* black immigrant groups by age_group by NYC
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: black immigrant groups by age_group by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 age_group NYC) 
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
					
				* fillin to make dataset rectangular 
				fillin blackgrps1 age_group NYC
				
				sort blackgrps1 age_group NYC
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order sex, after(blackgrps1)
			order age_group, after(sex)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A185)
					
	*************************
	* black immigrant groups by age_group by NYC by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: black immigrant groups by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 age_group NYC immig_group) 
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
					
				* fillin to make dataset rectangular 
				fillin blackgrps1 age_group NYC immig_group
				
					sort blackgrps1 age_group NYC immig_group
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order sex, after(blackgrps1)
			order NYC, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 	
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A336)
				
	*************************
	* black immigrant groups by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: black immigrant groups by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 immig_group) 
					   
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
					
				* fillin to make dataset rectangular 
				fillin blackgrps1 immig_group
				
					sort blackgrps1 immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if  `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order sex-NYC, after(blackgrps1)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A1237)
		
	*************************
	* black immigrant groups by NYC 
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: black immigrant groups by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 NYC) 
					   
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
					
				* fillin to make dataset rectangular 
				fillin blackgrps1 NYC
				
					sort blackgrps1 NYC  
				
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order sex-age_group, after(blackgrps1)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A1268)
					
					
	*************************
	* black immigrant groups by NYC by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: ace-ethnicity by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 NYC immig_group) 
					   
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
				
				* fillin to make dataset rectangular 
				fillin blackgrps1 NYC immig_group
				
					sort blackgrps1 NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order sex-age_group, after(blackgrps1)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A1299)
											
	*************************
	* black immigrant groups by sex 
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
		
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: black immigrant groups by sex
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 sex) 
					   
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
					
				* fillin to make dataset rectangular 
				fillin blackgrps1 sex
				
					sort blackgrps1 sex
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order age_group-immig_group, after(sex)	
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A1480)
					
							
	*************************
	* black immigrant groups by sex by age_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
						   
		* gcollapse dataset: black immigrant groups by sex total
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 sex age_group) 
					   
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
					
				* fillin to make dataset rectangular 
				fillin blackgrps1 sex age_group
				
					sort blackgrps1 sex age_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order NYC-immig_group, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A1491)
					
	*************************
	* black immigrant groups by sex by age_group by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: black immigrant groups by sex by age_group by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 sex age_group immig_group) 
					   
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
					
				* fillin to make dataset rectangular 
				fillin blackgrps1 sex age_group immig_group
				
					sort blackgrps1 sex age_group immig_group
				
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order NYC, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A1542)
					
					
	*************************
	* black immigrant groups by sex by age_group by NYC
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
						   
		* gcollapse dataset: black immigrant groups by sex by age_group by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 sex age_group NYC) 
					   
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
					
				* fillin to make dataset rectangular 
				fillin blackgrps1 sex age_group NYC
				
					sort blackgrps1 sex age_group NYC
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
					
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A1843)
					
					
	*************************
	* black immigrant groups by sex by age_group by NYC by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: black immigrant groups by sex by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 sex age_group NYC immig_group) 
					   
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
					
				* fillin to make dataset rectangular 
				fillin blackgrps1 sex age_group NYC immig_group
				
					sort blackgrps1 sex age_group NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A2144)
	
	*************************
	* black immigrant groups by sex by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
				
						   
		* gcollapse dataset: black immigrant groups by sex by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 sex immig_group) 
					     
				* drop missing for blackgrps1
				drop if blackgrps1 == .
				
				* fillin to make dataset rectangular 
				fillin blackgrps1 sex immig_group
				
				sort blackgrps1 sex immig_group
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order age_group-NYC, after(sex)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A3945)
			
	*************************
	* black immigrant groups by sex by NYC
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
				
						   
		* gcollapse dataset: black immigrant groups by sex by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 sex NYC) 
					   
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
				
				* fillin to make dataset rectangular 
				fillin blackgrps1 sex NYC 
				
				sort blackgrps1 sex NYC 
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order age_group, after(sex)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A4006)	
			
	*************************
	* black immigrant groups by sex by NYC by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
				
						   
		* gcollapse dataset: ace-ethnicity by sex by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(blackgrps1 sex NYC immig_group) 
					   
					   
				* drop missing for blackgrps1
				drop if blackgrps1 == .
				
				* fillin to make dataset rectangular 
				fillin blackgrps1 sex NYC immig_group
				
					sort blackgrps1 sex NYC immig_group
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order age_group, after(sex)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A4067)	
			
	
	*************************
	* sex
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex 
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(sex) 
				
					sort sex
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order age_group-immig_group, after(sex)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A4428)
	
	*************************
	* sex by age_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by age_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(sex age_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex age_group
				
					sort sex age_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order NYC-immig_group, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A4431)
					
			
	*************************
	* sex by age_group by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by age_group by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(sex age_group immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex age_group immig_group
				
					sort sex age_group immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
		
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order NYC, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A4442)
	
	*************************
	* sex by age_group by NYC
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by age_group by NYC 
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(sex age_group NYC) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex age_group NYC
				
					sort sex age_group NYC
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A4503)	
			
	*************************
	* sex by age_group by NYC by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
				
						   
		* gcollapse dataset: sex by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(sex age_group NYC immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex age_group NYC immig_group
				
					sort sex age_group NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A4564)		
			
	*************************
	* sex by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(sex immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex immig_group
				
					sort sex immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order age_group- NYC, after(sex)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A4925)
					
	*************************
	* sex by NYC
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(sex NYC) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex NYC
				
					sort sex NYC
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order age_group, after(sex)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A4938)	
		
	*************************
	* sex by NYC by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(sex NYC immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin sex NYC immig_group
				
					sort sex NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br blackgrps1 sex employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 sex  coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order age_group, after(sex)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A4951)		
			
			
	*************************
	* age_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(age_group) 
					   
					   
					sort age_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order sex, after(blackgrps1)
			order NYC-immig_group, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A5024)
					
					
	*************************
	* age_group by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: age_group by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(age_group immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin age_group immig_group
					
					sort age_group immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order sex, after(blackgrps1)
			order NYC, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A5030)
					
	*************************
	* age_group by NYC
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: age_group by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(age_group NYC) 
					   
					   
				* fillin to make dataset rectangular 
				fillin age_group NYC
				 
					sort age_group NYC
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order sex, after(blackgrps1)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A5061)
					
	*************************
	* age_group by NYC by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(age_group NYC immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin age_group NYC immig_group
				
					sort age_group NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
				gen sex = 1
				lab def sex_total  1 "Total - Sex"
				lab val sex sex_total
				lab var sex "total sex, working class"
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order sex, after(blackgrps1)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A5092)		
						
	*************************
	* NYC 
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: NYC 
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(NYC) 
					   
					   
				sort NYC 
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order sex-age_group, after(blackgrps1)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A5273)
					
	*************************
	* NYC by immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(NYC immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin NYC immig_group
				
					sort NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order sex-age_group, after(blackgrps1)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A5280)
					
	*************************
	* immig_group
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
	
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(immig_group) 
					   
					   
				sort immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
								
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br blackgrps1 employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br blackgrps1 coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1-NYC, before(immig_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify)  keepcellfmt cell(A5317)	
					
					
	*************************
	* black immigrant groups: grand total
	*************************
	use "$savedir/2021.03.19 Intersectionality Dashboard Data-blackgrps1.dta", clear
		
		* create population variable
		gen pop = blackgrps1 
		lab var pop "population of black immigrant groups"
				
				* sort on "by" variables to speed up gcollapse 
				sort blackgrps1 sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
		* gcollapse dataset: race-ethnicity
		* ---------------------------------------
		gcollapse (sum) coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employedtpop_n = employedtpop ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt] 
				
					* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
					
				* generate total variables
				gen blackgrps1 = 1
				lab def blackgrps1_total  1 "Total - black immigrant groups"
				lab val blackgrps1 blackgrps1_total
				lab var blackgrps1 "total black immigrant groups, working class"
				
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
			
				foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if  `v' > 20  // make sure to use the 20 threshold during summmation
				
				}
				
					*check on missing
					br blackgrps1 age_group immig_group employedtpop employedtpop_n z_employedtpop
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employedtpop hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						} 
						
						*check 
						br blackgrps1 age_group immig_group coldeg coldeg_n z_coldeg
						
							zscore coldeg if coldeg > 20, stub(zscore_)
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employedtpop "employedtpop, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employedtpop_n "total employedtpop, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employedtpop "z-score for employedtpop, working age"
				lab var z_hhlowincome "z-score for low-income, working age"
				lab var z_homeownership "z-score for homeowners, working age"
				lab var z_speakenghome "z-score for speak english at home"
				lab var z_speakforlanghome "z-score for speak foreign language at home"
				lab var z_hhrburden "z-score for rent-burdened household"
				lab var z_hhoburden "z-score for owner-burdened household"
	
				lab var pop "population of top 5 race-ethnic groups"				
			
			* format data for excel read-out
			* -------------------------
			* order pop to front
			order blackgrps1, first
			order sex-immig_group, after(blackgrps1)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employedtpop, after (employedtpop_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
	
				* sort for excel 
				sort sex age_group NYC immig_group blackgrps1 
			
					* export to excel 		
					export excel using "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings", modify) keepcellfmt cell(A5324)	
			

* black immigrant groups (blackgrps1) working age data creation and export
* ============================================================
import excel "$tabledir/2021.03.19 Intersectionality Dashboard-black-immigrants.xlsx", sheet("strings") firstrow clear

		* sort 
		sort sex age_group NYC immig_group blackgrps1 

			* drop missing rows 
			drop in 1/31
		
	* check that datset is rectangular
	fre  sex age_group NYC immig_group blackgrps1 
		
		* sort 
		sort sex age_group NYC immig_group blackgrps1 
	
		* rename bengali to bangladeshi
		replace blackgrps1 = "bangladeshi" if blackgrps1 == "bengali" 
		
	* generate black flag
	gen blackflag = 2
	
	gen blackorderflag = 0
	replace blackorderflag = 1 if blackgrps1 != "Total - black immigrant groups"
	
		* check 
		br sex age_group NYC immig_group blackgrps1 blackflag blackorderflag
		
	
* save data for merge 
save "$savedir/2021.03.19 Intersectionality Dashboard-black-immigrants.dta", replace 
		
	clear all


					
