* prep for Z-score calculations
* ============================================================
		
	* Create percent variables for each response
	* ------------------------------------------
	foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
		gen p`v' = ((`v'/`v'_n)*100) //create percent variable
		
		order p`v', after(`v'_n) // order percent variable after N
				
	} 
		
	
	* Create grand total N variable for dataset
	* ------------------------------------------
	foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
		gen `v'_tot_n = `v'_n if raceth == "Total - Race-ethnicity" & flag == 1 //create grand total N
			
			carryforward `v'_tot_n  if flag == 1, replace // carry forward for all obs where flag == 1 
			
		order `v'_tot_n, after(`v'_n) // order percent variable after grand total
			
			format `v'_tot_n %15.0fc if flag == 1 // format to remove scientific notation
				
	} 
	
	* drop pervioulsy calculated z-scores that were not grouped   
	drop z_* 
	
		
		* check employed and coldeg variable as an example
		br raceth employed employed_n employed_tot_n pemployed if flag == 1
		
		br raceth coldeg coldeg_n coldeg_tot_n pcoldeg if flag == 1
			
* create weighed Z-scores
* ============================================================
	
	* 1. Calculate real mean percent
	* ------------------------------------------
	
				* sort by flag so that vars are at top
				sort flag2
				
		* Calculate real percent mean 
		gen pcoldeg_mean = pcoldeg if raceth == "Total - Race-ethnicity" & flag == 1
			
				* sort by flag so that vars are at top
				sort flag2
				
			* carry forward 
			carryforward pcoldeg_mean, replace
			
			
				* check with browse function 
				br raceth coldeg coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean flag flag2
				
					* missing data on new variable?
					mdesc pcoldeg_mean
				
				br raceth coldeg coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean if flag == 1
			
				
	* 2. Calculate weighted standard deviation 
	* ------------------------------------------
		
		* Calculate weighted standard deviation variable 
				
			* 2.1  normalized = subtract mean, square, and multiply by total N 
			gen coldeg_norm = (coldeg_n*(pcoldeg-pcoldeg_mean)^2) if flag == 1
				
				* format normalized vairable to remove scientific notation 
				format coldeg_norm %15.0fc if flag == 1
				
			* 2.2 column total of normalized variable 
			egen coldeg_norm_tot = total(coldeg_norm) if flag == 1
				
				* format column totoal of normalzed variable to remove scientific notion 
				format coldeg_norm_tot %15.0fc if flag == 1

			* 2.3 take square root of sum of these calculations
			gen coldeg_wghtsd = sqrt(coldeg_norm_tot/coldeg_tot_n) if flag == 1
			
				* carry forward 
				carryforward coldeg_wghtsd, replace
				
				
	* 3. Calculate Z-scores for all observations based on real mean and weighted SD
	* ------------------------------------------
		
		* Calculate z-score = (percent- mean percent) / weighted SD for obs greater than 20
		gen z_coldeg = ((pcoldeg - pcoldeg_mean)/coldeg_wghtsd) if coldeg > 20 
		
			* checks with and without flags for coldeg
			br raceth coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean coldeg_wghtsd coldeg_norm coldeg_norm_tot coldeg_norm_tot coldeg_norm z_coldeg if flag == 1
			br raceth coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean coldeg_wghtsd coldeg_norm coldeg_norm_tot coldeg_norm_tot coldeg_norm z_coldeg 
			
			
		sum z_coldeg, de
			
