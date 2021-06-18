


* create weighed Z-scores: total
* ============================================================
	
	* 1. Calculate real mean percent
	* ------------------------------------------
	
				* sort by flag so that vars are at top
				sort flag2
				
		* Calculate real percent mean 
		foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
			gen p`v'_mean = p`v' if raceth == "Total - Race-ethnicity" & sexflag  == 1
			
				* sort by flag so that vars are at top
				sort flag2
			
			carryforward p`v'_mean, replace
				
		} 
	
				* check with browse function 
				br raceth coldeg coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean flag flag2
				
					* missing data on new variable?
					mdesc pcoldeg_mean
				
				br raceth coldeg coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean if sexflag  == 1
			
				
	* 2. Calculate grand weighted standard deviation 
	* ------------------------------------------
		
		* Calculate weighted standard deviation variable 
				
			* 2.1  normalized = subtract mean, square, and multiply by total N 
			foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
				gen `v'_norm = (`v'_n*(p`v' - p`v'_mean)^2) if sexflag  == 1
				
					format `v'_norm  %15.0fc if sexflag  == 1 // format normalized vairable to remove scientific notation 
		
			} 
			
				* checks
				br raceth coldeg coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean coldeg_norm if sexflag  == 1
				
			* 2.2 column total of normalized variable 
			foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
				egen `v'_norm_tot = total(`v'_norm) if sexflag  == 1
				
					format `v'_norm_tot %15.0fc if sexflag  == 1 // format column totoal of normalzed variable to remove scientific notion 
		
			} 
			
				* checks
				br raceth coldeg coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean coldeg_norm coldeg_norm_tot if sexflag  == 1

			* 2.3 take square root of sum of these calculations
			foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
				gen `v'_wghtsd = sqrt(`v'_norm_tot/`v'_tot_n) if sexflag  == 1
			
					* carry forward 
					carryforward `v'_wghtsd, replace
		
			} 
			
				* checks
				br raceth coldeg coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean coldeg_norm coldeg_tot coldeg_wghtsd if sexflag  == 1
			
				
				
	* 3. Calculate Z-scores for all observations based on real mean and weighted SD
	* ------------------------------------------
		
		* Calculate z-score = (percent- mean percent) / weighted SD for obs greater than 20
		foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
				gen z_`v' = ((p`v' - p`v'_mean)/`v'_wghtsd) if `v' > 20 
		
		} 
		
			* checks with and without flags for coldeg
			br raceth coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean coldeg_wghtsd coldeg_norm coldeg_norm_tot coldeg_norm_tot coldeg_norm z_coldeg if sexflag  == 1
			br raceth coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean coldeg_wghtsd coldeg_norm coldeg_norm_tot coldeg_norm_tot coldeg_norm z_coldeg 
			
					sum z_coldeg, de
					
			br raceth employed_n employed_tot_n pemployed pemployed_mean employed_wghtsd employed_norm employed_norm_tot employed_norm_tot employed_norm z_employed if sexflag  == 1
			br raceth employed_n employed_tot_n pemployed pemployed_mean employed_wghtsd employed_norm employed_norm_tot employed_norm_tot employed_norm z_employed 
			
					sum z_employed, de

					
					
					
					
* create weighed Z-scores: male
* ============================================================
	
	br raceth sex age_group NYC immig_group if sex == "male" & age_group == "Total - Age 18 to 65" &  NYC == "Total - NYC status" & immig_group == "Total - Immigrant cohort"
	
	
	
	
	* 1. Calculate real mean percent
	* ------------------------------------------
	
				* sort by flag so that vars are at top
				sort flag2
				
		* Calculate real percent mean 
		foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
			gen p`v'_mean = p`v' if raceth == "Total - Race-ethnicity" & sexflag  == 1
			
				* sort by flag so that vars are at top
				sort flag2
			
			carryforward p`v'_mean, replace
				
		} 
	
				* check with browse function 
				br raceth coldeg coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean flag flag2
				
					* missing data on new variable?
					mdesc pcoldeg_mean
				
				br raceth coldeg coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean if sexflag  == 1
			
				
	* 2. Calculate grand weighted standard deviation 
	* ------------------------------------------
		
		* Calculate weighted standard deviation variable 
				
			* 2.1  normalized = subtract mean, square, and multiply by total N 
			foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
				gen `v'_norm = (`v'_n*(p`v' - p`v'_mean)^2) if sexflag  == 1
				
					format `v'_norm  %15.0fc if sexflag  == 1 // format normalized vairable to remove scientific notation 
		
			} 
			
				* checks
				br raceth coldeg coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean coldeg_norm if sexflag  == 1
				
			* 2.2 column total of normalized variable 
			foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
				egen `v'_norm_tot = total(`v'_norm) if sexflag  == 1
				
					format `v'_norm_tot %15.0fc if sexflag  == 1 // format column totoal of normalzed variable to remove scientific notion 
		
			} 
			
				* checks
				br raceth coldeg coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean coldeg_norm coldeg_norm_tot if sexflag  == 1

			* 2.3 take square root of sum of these calculations
			foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
				gen `v'_wghtsd = sqrt(`v'_norm_tot/`v'_tot_n) if sexflag  == 1
			
					* carry forward 
					carryforward `v'_wghtsd, replace
		
			} 
			
				* checks
				br raceth coldeg coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean coldeg_norm coldeg_tot coldeg_wghtsd if sexflag  == 1
			
				
				
	* 3. Calculate Z-scores for all observations based on real mean and weighted SD
	* ------------------------------------------
		
		* Calculate z-score = (percent- mean percent) / weighted SD for obs greater than 20
		foreach v of varlist coldeg employed lowincome homeownership speakenghome speakforlanghome rburden oburden {
				
				gen z_`v' = ((p`v' - p`v'_mean)/`v'_wghtsd) if `v' > 20 
		
		} 
		
			* checks with and without flags for coldeg
			br raceth coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean coldeg_wghtsd coldeg_norm coldeg_norm_tot coldeg_norm_tot coldeg_norm z_coldeg if sexflag  == 1
			br raceth coldeg_n coldeg_tot_n pcoldeg pcoldeg_mean coldeg_wghtsd coldeg_norm coldeg_norm_tot coldeg_norm_tot coldeg_norm z_coldeg 
			
					sum z_coldeg, de
					
			br raceth employed_n employed_tot_n pemployed pemployed_mean employed_wghtsd employed_norm employed_norm_tot employed_norm_tot employed_norm z_employed if sexflag  == 1
			br raceth employed_n employed_tot_n pemployed pemployed_mean employed_wghtsd employed_norm employed_norm_tot employed_norm_tot employed_norm z_employed 
			
					sum z_employed, de
			
	
