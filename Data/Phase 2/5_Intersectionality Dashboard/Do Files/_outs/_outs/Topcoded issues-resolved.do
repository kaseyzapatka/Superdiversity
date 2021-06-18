/* clean monthly gross rent variable 


	Top-coding issue
	* -----------------
	- identified values above topcode
	- see my IPUMS ACS post asking about values above top-code : https://forum.ipums.org/t/top-coded-monthly-gross-rent-values-seem-to-vary-more-widely-than-expected/3748/2
	- Basically, rentgrs is calcualted from summing top-coded rent and several topcoded utility variables, which is why rentgrs 
	  can be greater than 2014-2018 topcode of $3900.  */
	  
	

* top-coding issue 
* ====================	  
fre rentgrs
		
		sort rentgrs multyear
		
		br rentgrs multyear 
		
			log using "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data/Phase 2/5_Intersectionality Dashboard/Logs/top-coded.log", replace
			
			* table showing rentgrs above 2018 top-code in 2018 and in NY: should only be one variable?
			fre rentgrs if rentgrs > 3900 & multyear == 2018 & statefip == 36
			
			fre rent if rent > 3900 & multyear == 2018 & statefip == 36
			fre rent if rent > 3900 & multyear == 2017 & statefip == 36
			fre rent if rent > 3900 & multyear == 2016 & statefip == 36
			fre rent if rent > 3900 & multyear == 2015 & statefip == 36
			fre rent if rent > 3900 & multyear == 2014 & statefip == 36
			
			br rentgrs multyear statefip if rentgrs > 3900 & multyear == 2018 & statefip == 36
			
			br rent multyear statefip if rent > 3900 & multyear == 2018 & statefip == 36
			
			br rent rentgrs multyear statefip if rent > 3900 & multyear == 2016 & statefip == 36
		
			log close 
			
