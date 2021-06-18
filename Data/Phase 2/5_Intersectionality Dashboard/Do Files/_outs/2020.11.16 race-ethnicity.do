							
							
							* controls 
							* =================
							* raceth sex age_group NYC immig_group
														
* race-ethnicity (raceth) working age data creation and export
* ============================================================				
					
	*************************
	* race-ethnicity
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
		
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
		* gcollapse dataset: race-ethnicity
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth) 
				
					sort raceth	   
				
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if  `v' > 20  // make sure to use the 20 threshold during summmation
				
				}
				
					*check on missing
					br raceth age_group immig_group employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order sex-immig_group, after(raceth)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
	
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
				
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", replace) firstrow(variables) keepcellfmt cell(A1)
					
	*************************
	* race-ethnicity by age_group 
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: race-ethnicity by age_group 
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth age_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin raceth age_group
				
					sort raceth age_group 
				
		
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order sex, after(raceth)
			order NYC-immig_group, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A8)
		
		
	*************************
	* race-ethnicity by age_group by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: race-ethnicity by age_group by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth age_group immig_group) 
				
				* fillin to make dataset rectangular 
				fillin raceth age_group immig_group
				
					sort raceth age_group immig_group
		
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order sex, after(raceth)
			order NYC, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A34)
					
	*************************
	* race-ethnicity by age_group by NYC
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: race-ethnicity by age_group by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth age_group NYC) 
					   
				* fillin to make dataset rectangular 
				fillin raceth age_group NYC
				
				sort raceth age_group NYC
		
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order sex, after(raceth)
			order age_group, after(sex)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A185)
					
	*************************
	* race-ethnicity by age_group by NYC by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: race-ethnicity by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth age_group NYC immig_group) 
					   
				* fillin to make dataset rectangular 
				fillin raceth age_group NYC immig_group
				
					sort raceth age_group NYC immig_group
		
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order sex, after(raceth)
			order NYC, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 	
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A336)
				
	*************************
	* race-ethnicity by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: race-ethnicity by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin raceth immig_group
				
					sort raceth immig_group
				
		
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if  `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order sex-NYC, after(raceth)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A1237)
		
	*************************
	* race-ethnicity by NYC 
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: race-ethnicity by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth NYC) 
					   
					   
				* fillin to make dataset rectangular 
				fillin raceth NYC
				
					sort raceth NYC  
				
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order sex-age_group, after(raceth)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A1268)
					
					
	*************************
	* race-ethnicity by NYC by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: ace-ethnicity by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth NYC immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin raceth NYC immig_group
				
					sort raceth NYC immig_group
				
		
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order sex-age_group, after(raceth)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A1299)
											
	*************************
	* race-ethnicity by sex 
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
		
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: race-ethnicity by sex
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth sex) 
					   
					   
				* fillin to make dataset rectangular 
				fillin raceth sex
				
					sort raceth sex
		
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A1480)
					
							
	*************************
	* race-ethnicity by sex by age_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
						   
		* gcollapse dataset: race-ethnicity by sex total
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth sex age_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin raceth sex age_group
				
					sort raceth sex age_group
				
		
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A1491)
					
	*************************
	* race-ethnicity by sex by age_group by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: race-ethnicity by sex by age_group by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth sex age_group immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin raceth sex age_group immig_group
				
					sort raceth sex age_group immig_group
				
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
							replace z_`v' = . if `v' < 20
				
						}  // should be straight zeros 
						
						*check 
						br raceth sex coldeg coldeg_n z_coldeg
						
							zscore coldeg if sex == 1 & coldeg > 20, stub(zscore_) // just test males bc I don't know how to replace variable 
							
							drop zscore_coldeg
					
			
				* label variables 
				* ---------------------------------
				* variables 
				lab var coldeg "college degree, working age"
				lab var employed "employed, working age"
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A1542)
					
					
	*************************
	* race-ethnicity by sex by age_group by NYC
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
						   
		* gcollapse dataset: race-ethnicity by sex by age_group by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth sex age_group NYC) 
					   
					   
				* fillin to make dataset rectangular 
				fillin raceth sex age_group NYC
				
					sort raceth sex age_group NYC
				
		
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
					
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A1843)
					
					
	*************************
	* race-ethnicity by sex by age_group by NYC by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: race-ethnicity by sex by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth sex age_group NYC immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin raceth sex age_group NYC immig_group
				
					sort raceth sex age_group NYC immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
						format `v' %10.0fc
					
					}
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A2144)
	
	*************************
	* race-ethnicity by sex by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
				
						   
		* gcollapse dataset: race-ethnicity by sex by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth sex immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin raceth sex immig_group
				
				sort raceth sex immig_group
		
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A3945)
			
	*************************
	* race-ethnicity by sex by NYC
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
				
						   
		* gcollapse dataset: race-ethnicity by sex by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth sex NYC) 
					   
					   
				* fillin to make dataset rectangular 
				fillin raceth sex NYC 
				
				sort raceth sex NYC 
		
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A4006)	
			
	*************************
	* race-ethnicity by sex by NYC by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
				
						   
		* gcollapse dataset: ace-ethnicity by sex by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(raceth sex NYC immig_group) 
					   
					   
				* fillin to make dataset rectangular 
				fillin raceth sex NYC immig_group
				
					sort raceth sex NYC immig_group
		
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A4067)	
			
	
	*************************
	* sex
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex 
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(sex) 
				
					sort sex
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order age_group-immig_group, after(sex)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A4428)
	
	*************************
	* sex by age_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by age_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
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
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order NYC-immig_group, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A4431)
					
			
	*************************
	* sex by age_group by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by age_group by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
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
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
				gen NYC = 1
				lab def NYC_total  1 "Total - NYC status"
				lab val NYC NYC_total
				lab var NYC "total NYC status, working class"
		
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order NYC, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A4442)
	
	*************************
	* sex by age_group by NYC
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by age_group by NYC 
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
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
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A4503)	
			
	*************************
	* sex by age_group by NYC by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
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
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A4564)		
			
	*************************
	* sex by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
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
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order age_group- NYC, after(sex)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A4925)
					
	*************************
	* sex by NYC
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
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
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order age_group, after(sex)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A4938)	
		
	*************************
	* sex by NYC by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
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
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
				gen age_group = 1
				lab def age_group_total  1 "Total - Age 18 to 65"
				lab val age_group age_group_total
				lab var age_group "total age-group, working class"
				
				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if sex == 1 & `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if sex == 1 & `v' > 20 
				
				
						su `v' if sex == 2 & `v' > 20 
				
							replace z_`v' = (`v' - r(mean))/r(sd) if sex == 2 & `v' > 20 
				
				}
				
					*check 
					br raceth sex employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order age_group, after(sex)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A4951)		
			
			
	*************************
	* age_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: sex by age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(age_group) 
					   
					   
					sort age_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"

				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order sex, after(raceth)
			order NYC-immig_group, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A5024)
					
					
	*************************
	* age_group by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: age_group by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
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

				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order sex, after(raceth)
			order NYC, after(age_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A5030)
					
	*************************
	* age_group by NYC
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: age_group by NYC
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
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
				gen raceth = 1
				lab def raceth_total  1 "Total - Race-ethnicity"
				lab val raceth raceth_total
				lab var raceth "total race-ethnicty, working class"
				
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order sex, after(raceth)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A5061)
					
	*************************
	* age_group by NYC by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: age_group by NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order sex, after(raceth)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A5092)		
						
	*************************
	* NYC 
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: NYC 
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(NYC) 
					   
					   
				sort NYC 
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"

				
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order sex-age_group, after(raceth)
			order immig_group, after(NYC)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A5273)
					
	*************************
	* NYC by immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order sex-age_group, after(raceth)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				drop _fillin
				
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A5280)
					
	*************************
	* immig_group
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
	
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
				* drop if not working age population 
				drop if workingage != 1
						   
		* gcollapse dataset: NYC by immig_group
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt], by(immig_group) 
					   
					   
				sort immig_group
				
		
				* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
							
						su `v' if `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if `v' > 20 
				
				}
				
					*check 
					br raceth employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth-NYC, before(immig_group)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
			
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify)  keepcellfmt cell(A5317)	
					
					
	*************************
	* race-ethnicity: grand total
	*************************
	use "$savedir/2020.11.16 Intersectionality Dashboard Data.dta", clear
		
		* create population variable
		gen pop = raceth 
		lab var pop "population of race-ethnicity"
				
				* sort on "by" variables to speed up gcollapse 
				sort raceth sex age_group NYC immig_group
				
		
				* drop if not working age population 
				drop if workingage != 1
				
		* gcollapse dataset: race-ethnicity
		* ---------------------------------------
		gcollapse (sum) coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden (count) pop coldeg_n = coldeg employed_n = employed ///
					   hhlowincome_n = hhlowincome homeownership_n = homeownership  speakenghome_n = speakenghome  speakforlanghome_n = speakforlanghome ///
					   hhrburden_n = hhrburden hhoburden_n = hhoburden [pw = perwt] 
				
					* use loop to format each variable out of scientific notation 
					foreach v of varlist coldeg-hhoburden_n{
						
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
				
				gen immig_group = 1
				lab def immig_group_total  1 "Total - Immigrant cohort"
				lab val immig_group immig_group_total
				lab var immig_group "total immigrant cohort, working class"
				
					
					
			* calculate the z-score for each variable of interest 
			* -------------------------------------------------------
			* formula : z = (x-μ)/σ : z-score == (raw score - population mean) / standard deviation
			
				foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
					
						su `v' if  `v' > 20 
				
							gen z_`v' = (`v' - r(mean))/r(sd) if  `v' > 20  // make sure to use the 20 threshold during summmation
				
				}
				
					*check on missing
					br raceth age_group immig_group employed employed_n z_employed
					
						* If total number for the population in a category is <20, replce z-scores as missing 
						foreach v of varlist coldeg employed hhlowincome homeownership speakenghome speakforlanghome hhrburden hhoburden {
				
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
				lab var hhlowincome "low-income, working age"
				lab var homeownership "homeowners, working age"
				lab var speakenghome "speak english at home"
				lab var speakforlanghome "speak foreign language at home"
				lab var hhrburden "rent-burdened household"
				lab var hhoburden "owner-burdened household"
				
				* total population variables 
				lab var coldeg_n "total with a college degree, working age"
				lab var employed_n "total employed, working age"
				lab var hhlowincome_n "total low-income, working age"
				lab var homeownership_n "total homeowners, working age"
				lab var speakenghome_n "total speak english at home"
				lab var speakforlanghome_n "total speak foreign language at home"
				lab var hhrburden_n "total rent-burdened household"
				lab var hhoburden_n "total owner-burdened household"
				
				* z-score variables 
				lab var z_coldeg "z-score for college degree, working age"
				lab var z_employed "z-score for employed, working age"
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
			order raceth, first
			order sex-immig_group, after(raceth)
			order pop, after(immig_group)
				
					* order total variables after their corresponding counts
					foreach v of varlist coldeg-hhoburden {
						
						order `v', before(`v'_n)
						
					}
					
					order z_coldeg, after (coldeg_n)
					order z_employed, after (employed_n)
					order z_hhlowincome, after (hhlowincome_n)
					order z_homeownership, after (homeownership_n)
					order z_speakenghome, after (speakenghome_n)
					order z_speakforlanghome, after (speakforlanghome_n)
					order z_hhrburden, after (hhrburden_n)
					order z_hhoburden, after (hhoburden_n)
				
	
				* sort for excel 
				sort sex age_group NYC immig_group raceth 
				
			
					* export to excel 		
					export excel using "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings", modify) keepcellfmt cell(A5324)
			

* race-ethnicity (raceth) working age data creation and export
* ============================================================
import excel "$tabledir/2020.11.16 Intersectionality Dashboard-race-ethnicity.xlsx", sheet("strings") firstrow clear

		* sort 
		sort sex age_group NYC immig_group raceth 

			* drop missing rows 
			drop in 1/31
		
	* check that datset is rectangular
	fre  sex age_group NYC immig_group raceth 
		
		* sort 
		sort sex age_group NYC immig_group raceth 
		
	* drop all previously created z-score variables 
	* -----------------------------------
	drop z_*
	
	* create flags for grand totals
	* ----------------------------
	br raceth sex age_group NYC immig_group if sex == "Total - Sex" & age_group == "Total - Age 18 to 65" &  NYC == "Total - NYC status" & immig_group == "Total - Immigrant cohort"
	
		* generate grandtotalflg to mark grand totals 
		gen grandtotalflg = 1  if sex == "Total - Sex" & age_group == "Total - Age 18 to 65" &  NYC == "Total - NYC status" & immig_group == "Total - Immigrant cohort"
		
			* check
			fre grandtotalflg
		
		* generate grandtotalorderflg to order total catergory first for coding purposes
		gen grandtotalorderflg = 1  if grandtotalflg == 1
		replace grandtotalorderflg = 0  if raceth == "Total - Race-ethnicity" & grandtotalflg == 1 
		
	
	* create flags for grand sex totals : male
	* --------------------------------------------
	br raceth sex age_group NYC immig_group if sex == "male" & age_group == "Total - Age 18 to 65" &  NYC == "Total - NYC status" & immig_group == "Total - Immigrant cohort"
	
		* generate femaletotalflg to mark sex totals for male
		gen maletotalflg = 1  if sex == "male" & age_group == "Total - Age 18 to 65" &  NYC == "Total - NYC status" & immig_group == "Total - Immigrant cohort"
		
			* check
			fre maletotalflg
		
		* generate maletotalorderflg to order total catergory first for coding purposes
		gen maletotalorderflg = 1  if maletotalflg == 1
		replace maletotalorderflg = 0  if raceth == "Total - Race-ethnicity" & maletotalflg == 1
		
			* check
			fre maletotalflg maletotalorderflg
	
	
	* create flags for grand sex totals : female
	* --------------------------------------------
	br raceth sex age_group NYC immig_group if sex == "female" & age_group == "Total - Age 18 to 65" &  NYC == "Total - NYC status" & immig_group == "Total - Immigrant cohort"
	
		* generate femaletotalflg to mark sex totals for male
		gen femaletotalflg = 1  if sex == "female" & age_group == "Total - Age 18 to 65" &  NYC == "Total - NYC status" & immig_group == "Total - Immigrant cohort"
		
			* check
			fre femaletotalflg
		
		* generate femaletotalorderflg to order total catergory first for coding purposes
		gen femaletotalorderflg = 1  if femaletotalflg == 1
		replace femaletotalorderflg = 0  if raceth == "Total - Race-ethnicity" & femaletotalflg == 1 
		
			* check
			fre femaletotalflg femaletotalorderflg
			
				
	
* save data for merge 
save "$savedir/2020.11.16 Intersectionality Dashboard-race-ethnicity.dta", replace 

	clear all
	


					
