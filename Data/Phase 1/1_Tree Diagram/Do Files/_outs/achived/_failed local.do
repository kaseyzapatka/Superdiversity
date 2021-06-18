
// failed local

			local dtafiles : dir "$savedir/Legal Permanent Residents" files "*.dta"
			* display `"`dtafiles'"'
			
	
			
			use "$savedir/Legal Permanent Residents/2018.dta", clear
				
				foreach file of local `dtafiles' {
									
					append using `"`dtafiles'"'
			
				}
