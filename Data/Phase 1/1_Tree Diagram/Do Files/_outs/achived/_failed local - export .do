		
		
		
		
		use "$savedir/Legal Permanent Residents/LPR1998_2018.dta", clear 
	
				
			*tostring year, replace
			
			local fileyr "2018 " " 2017 " " 2016"
			* di  `fileyr'
			
			
			foreach file in local fileyr {
				
				
					keep if year == `fileyr'
					
					export excel using "$tabledir/PR`year'.xlsx", sheet("legal-perm-res", modify) firstrow(variables)  missing(".")
					
				restore
			 }
			 
			 
			
			 
			 
			 
			 
			 
