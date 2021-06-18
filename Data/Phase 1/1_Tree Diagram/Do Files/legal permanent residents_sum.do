/* Superdiveristy Project: Phase 1: Tree Diagram 
 * =======================================================
  
 * File: 2021.01.28 legal permanent residents_sum.do
 * Author: Kasey Zapatka 
 * Purpose: sum duplicate observations for Phase 1 of Superdiveristy Project
	
 * Date Last Updated: 2021.01.28 */ 				
				
				
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
				* collapse "Hong Kong" into "China, People's Republic" so there is one variable 
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
				
				* keep only "Hong Kong" and "China, People's Republic" 
				keep if country == "Hong Kong" | country == "China, People's Republic"
						
				* generate id to identify Hong Kong after change name 
				gen id = 1 if country == "Hong Kong"
				
					* br so you watch the process 
					br if country == "Hong Kong" | country == "China, People's Republic"
				
					* replace "Hong Kong" with "China, People's Republic" for summation 
					replace country = "China, People's Republic" if country == "Hong Kong"
				
					sort year id
				
						* run loop to sum each variables' values
						foreach v of varlist total-other {
						
							bysort country year : replace `v' = sum(`v') 
									
						}
				
					* drop "Hong Kong" observation 
					drop if id == 1
					replace id = 1
					
						* use local to save instead of create a new file
						tempfile chinasum
						save `chinasum'
						
					* load full  file 
					use "$savedir/Legal Permanent Residents/LPR1998_2019.dta", clear 
					
						* append chinasum to large dataset
						append using `chinasum'
						
								*check summation visually
								sort year country id
								
								br if country == "Hong Kong" | country == "China, People's Republic"
						
						* keep only summed China observations
						drop if country == "Hong Kong"  
						drop if country == "China, People's Republic" & id != 1
						drop id 
						
							* sort 
							sort country year 
							
							
			* save for collapse command
			save "$savedir/Legal Permanent Residents/LPR1998_2019.dta", replace 
				
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
						* collapse "Unknown republic (former Czechoslovakia)" into "Unknown" 
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
		
			
				* keep only "Unknown republic (former Czechoslovakia)" and "Unknown" 
				keep if country == "Unknown republic (former Czechoslovakia)" | country == "Unknown"
						
				* generate id to identify Unknown republic (former Czechoslovakia) after change name 
				gen id = 1 if country == "Unknown republic (former Czechoslovakia)"
				
					* br so you watch the process 
					br if country == "Unknown republic (former Czechoslovakia)" | country == "Unknown"
				
					* replace "Unknown republic (former Czechoslovakia)" with "Unknown" for summation 
					replace country = "Unknown" if country == "Unknown republic (former Czechoslovakia)"
				
					sort year id
				
						* run loop to sum each variables' values
						foreach v of varlist total-other {
						
							bysort country year : replace `v' = sum(`v') 
									
						}
				
					* drop "Unknown republic (former Czechoslovakia)" observation 
					drop if id == 1
					replace id = 1
					
						* use local to save instead of create a new file
						tempfile Czechoslovakiasum
						save `Czechoslovakiasum'
						
					* load full  file 
					use "$savedir/Legal Permanent Residents/LPR1998_2019.dta", clear 
					
						* append chinasum to large dataset
						append using `Czechoslovakiasum'
						
								*check summation visually
								sort year country id
								
								br if country == "Unknown republic (former Czechoslovakia)" | country == "Unknown"
						
						* keep only summed Czechoslovakia observations
						drop if country == "Unknown republic (former Czechoslovakia)"  
						drop if country == "Unknown" & id != 1
						drop id 
						
							* sort 
							sort country year 
				
			* save for collapse command
			save "$savedir/Legal Permanent Residents/LPR1998_2019.dta", replace 
			
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
						* collapse "Unknown republic (former Soviet Union)" into "Unknown" 
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
		
			
				* keep only "Unknown republic (former Soviet Union)" and "Unknown" 
				keep if country == "Unknown republic (former Soviet Union)" | country == "Unknown"
						
				* generate id to identify Unknown republic (former Soviet Union) after change name 
				gen id = 1 if country == "Unknown republic (former Soviet Union)"
				
					* br so you watch the process 
					br if country == "Unknown republic (former Soviet Union)" | country == "Unknown"
				
					* replace "Unknown republic (former Soviet Union)" with "Unknown" for summation 
					replace country = "Unknown" if country == "Unknown republic (former Soviet Union)"
				
					sort year id
				
						* run loop to sum each variables' values
						foreach v of varlist total-other {
						
							bysort country year : replace `v' = sum(`v') 
									
						}
				
					* drop "Unknown republic (former Soviet Union)" observation 
					drop if id == 1
					replace id = 1
					
						* use local to save instead of create a new file
						tempfile sovietunionsum
						save `sovietunionsum'
						
					* load full  file 
					use "$savedir/Legal Permanent Residents/LPR1998_2019.dta", clear 
					
						* append chinasum to large dataset
						append using `sovietunionsum'
						
								*check summation visually
								sort year country id
								
								br if country == "Unknown republic (former Soviet Union)" | country == "Unknown"
						
						* keep only summed Czechoslovakia observations
						drop if country == "Unknown republic (former Soviet Union)"  
						drop if country == "Unknown" & id != 1
						drop id 
						
							* sort 
							sort country year 
				
			* save for collapse command
			save "$savedir/Legal Permanent Residents/LPR1998_2019.dta", replace 
			
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
						* collapse "Unknown republic (former Yugoslavia)" into "Unknown" 
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
				* -----------------------------------------------------------------------------*
			
				* keep only "Unknown republic (former Yugoslavia)" and "Unknown" 
				keep if country == "Unknown republic (former Yugoslavia)" | country == "Unknown"
						
				* generate id to identify Unknown republic (former Yugoslavia) after change name 
				gen id = 1 if country == "Unknown republic (former Yugoslavia)"
				
					* br so you watch the process 
					br if country == "Unknown republic (former Yugoslavia)" | country == "Unknown"
				
					* replace "Unknown republic (former Yugoslavia)" with "Unknown" for summation 
					replace country = "Unknown" if country == "Unknown republic (former Yugoslavia)"
				
					sort year id
				
						* run loop to sum each variables' values
						foreach v of varlist total-other {
						
							bysort country year : replace `v' = sum(`v') 
									
						}
				
					* drop "Unknown republic (former Yugoslavia)" observation 
					drop if id == 1
					replace id = 1
					
						* use local to save instead of create a new file
						tempfile yugoslaviasum
						save `yugoslaviasum'
						
					* load full  file 
					use "$savedir/Legal Permanent Residents/LPR1998_2019.dta", clear 
					
						* append chinasum to large dataset
						append using `yugoslaviasum'
						
								*check summation visually
								sort year country id
								
								br if country == "Unknown republic (former Yugoslavia)" | country == "Unknown"
						
						* keep only summed Czechoslovakia observations
						drop if country == "Unknown republic (former Yugoslavia)"  
						drop if country == "Unknown" & id != 1
						drop id 
						
							* sort 
							sort country year 
				
			* save for collapse command
			save "$savedir/Legal Permanent Residents/LPR1998_2019.dta", replace 
			
			
			
			
			
			
			
			
			
