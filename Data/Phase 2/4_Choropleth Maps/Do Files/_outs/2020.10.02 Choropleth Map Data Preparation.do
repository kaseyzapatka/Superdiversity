/* Superdiveristy Project: Phase 2: Choropleth Map
 * =======================================================
  
 * File: 2020.10.02 Choropleth Map Data Preparation.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Intersectionality Dashboard for Phase 2 of Superdiveristy Project
 * Data: 
	- Downloaded from IPUMS at: https://usa.ipums.org/usa-action/data_requests/download
	- see Data preparation notes.txt for more on each of the variables
	
 * Date Last Updated: 2020.10.02 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/ACS"
global savedir "${db}/Phase 2/4_Choropleth Maps/Recoded"
global tabledir "${db}/Phase 2/4_Choropleth Maps/Tables"
global dodir "${db}/Phase 2/4_Choropleth Maps/Do Files"


* load NLSY data 
* ================
import delimited "$rawdir/Choropleth Maps.csv", clear
	
	
* preliminary data cleaning
* ============================

	* clean and prep important geo variables  
	* --------------------------------------
		
		* sting tractid
		tostring geoid, gen(tractid) format("%12.0f")
		
			* drop geoid because it is not string
			drop geoid
		
		* generate sub-strings for state, county, and tract
		gen state = substr(tractid, 1,2) // specifies first digit, length of string
		lab var state "state string"
		
		gen county = substr(tractid, 3,3) 
		lab var county "county string"
		
		gen tract = substr(tractid, 6,6) 
		lab var tract "tract string"
		
			* combine state and county
			gen statecountyfipstr = state + county
			lab var statecountyfipstr "state + countyfips string"
			
				* check statecountyfipstr against list 
				fre statecountyfipstr // checks out... but check for tract 36000 
	
		
		* order to front of dataset 
		order statecountyfipstr, after(tractid)
		order state, after(statecountyfipstr)
		order county, after(state)
		order tract, after(county)
		
	* Calculate Coefficents of Variation (CVs)
	* ----------------------------------------------
	rename *m *em // rename with "em" suffix so loop will work 
	
	
	* loop to calculate Coefficents of Variation (CVs)
	foreach v of varlist pope racetote nhtote nhwhte nhblke nhnate nhasiane nhpace nhothere nhtwoe hispe hisptote mexicane puertoricane dominicane /// 
				colombiane nhasiantote chinesee indiane filipinoe bangladeshie koreane edu_tote noedue lesshs1e lesshs2e lesshs3e lesshs4e lesshs5e ///
				lesshs6e lesshs7e lesshs8e lesshs9e lesshs10e lesshs11e lesshs12e lesshs13e lesshs14e hse gede somecol1e somecol2e somecol3e bae mae ///
				profdegreee phde inc_tote inc1e inc2e inc3e inc4e inc5e inc6e inc7e inc8e inc9e inc10e inc11e inc12e inc13e inc14e inc15e inc16e ///
				inc_25_44_tote inc_22_44_1e imm_tote imm2010e imm2010_ne imm2010_fbe imm2000e imm2000_ne imm2000_fbe imm1990e imm1990_ne imm1990_fbe ///
				immbefore1990e immbefore1990_ne immbefore1990_fbe citizen_tote citizen_use citizen_pre citizen_abroade citizen_nate not_citizene ///
				moveintote stayede moveincountye moveinstatee moveindiffstatee moveinabroade {

		gen cv_`v' =  ((`v'm/1.645)/`v')*100 /* CV = (SE/Estimates)  SE = MOE / 1.645  citation: Spielman & Folch (2015) page 3 */ 
		lab var cv_`v' "coefficent of variation"
		
		gen `v'_cv12 = 1 if cv_`v' < 12
		lab var `v'_cv12 "1 == useable at 12% threshold"
	
		
	}
			* checks
			sort cv_pope
				
				br pope popem cv_pope pope_cv12
				
					fre pope_cv12
			
			sort cv_hse 
				
				br hse hsem cv_hse hse_cv12
					
				fre hse_cv12
		
		* drop margins of error variables 
		drop *em
		
		* drop trailing "e" for estimates from R 
		rename *e *
	
	
	* count number of ethnicities per tract for normalization 
	* -------------------------------------------------------
	br tractid ancestry*
	
		* run loop to replace ancestry values as missing for rownonmiss count
		foreach v of varlist ancestry2-ancestry109 {
			
			replace `v' = . if `v' == 0
			
		}
	
		* count rownonmiss to count number of different ancestries pertract 
		egen number_ancestry_tract = rownonmiss(ancestry2e-ancestry109e) 
		
			* checks
			fre number_ancestry_tract
			
			* check popualation of tracts where number_ancestry_tract == 0
			fre pope if number_ancestry_tract == 0 // these tracts have no population 
			
* variables for "Traditional Maps"
* ============================


	* immigrants 
	* ---------------------------
	gen immigrants = citizen_nat + not_citizen
	
		* create MSA 
		egen immigrantsMSA = total(immigrants)
		
		egen citizen_totMSA = total(citizen_tot)
		
			* format variables
			format immigrantsMSA citizen_totMSA %15.0fc
	
	
	* recent immigrants 
	* ---------------------------
	gen recentimmigrants = 
	
	
	* high income 
	* ---------------------------
	gen highincome = 
	
	
	* minority groups
	* ---------------------------
	gen highincome = 
	
	
	
	* calculate Location Quotients
	* ---------------------------
	/* FORMULA FOR CALCULATING LOCATIONAL QUOTIENTS website: http://www.economicswiki.com/economics-tutorials/location-quotient/

		LQi	= (ei/e) / (Ei/E)
		
			where,
		
				LQi	=  location quotient for sector in the regional economy
				ei	=  employment in sector i in the regional economy
				e	=  total employment in the local region
				Ei	=  employment in industry i in the national economy
				E	=  total employment in the national economy										 */
	
	
	* immigrants 
	* ---------------------------
	gen LQimmigrants = (immigrants/citizen_tot)/(immigrantsMSA/citizen_totMSA) 
	
		* place in quantiles
		xtile LQimmigrants_index = LQimmigrants, nquantiles(15)
		
	
	
* create necessary variables 
* ============================
	
	* create ethnicity variables 
	* ---------------------------
	gen ethnicity = number_ancestry_tract
	
		* generate percentile for percent of total that moved in
		xtile ethnicity_index = ethnicity, nquantiles(3)
		lab var ethnicity_index "ethnicity cut into 3 percentiles"
	
	gen ethnicity_norm = number_ancestry_tract/ancestry_tote 
	
		* generate percentile for percent of total that moved in
		xtile ethnicity_norm_index = ethnicity_norm, nquantiles(3)
		lab var ethnicity_norm_index "ethnicity_norm cut into 3 percentiles"
	

	* create mobility var as percent of total that moved into census tract 
	* ---------------------------------------------------------------------
	br tractid moveintote moveincountye moveinstatee moveindiffstatee moveinabroade stayede
	
		* generate "moved into" variable 
		gen movedinto = moveincountye + moveinstatee + moveindiffstatee + moveinabroade
		
			* checks: make sure movedinto and stayed = moveintote
			gen check = movedinto + stayede
			gen diffck = moveintote- check 
			
				fre diffck // should be straight 0s
				
				* drop un-necessary variables 
				drop check diffck 
			
		* generate percent of total that moved in
		gen pmovedinto = (movedinto/moveintote)*100
		lab var pmovedinto "percent of total that moved into census tract within the last year"
		
		* generate percentile for percent of total that moved in
		xtile pmovedinto_index = pmovedinto, nquantiles(3)
		lab var pmovedinto_index "pmovedinto cut into 3 percentiles"
		
		
* final naming of necessary variable 
* =================================


	* ethncity  
	rename pmovedinto Mobility_raw_pct
	rename pmovedinto Mobility_index
	
	* mobility 
	rename pmovedinto Mobility_raw_pct
	rename pmovedinto Mobility_index
	
	
	br tractid Mobility_raw_pct Mobility_index
		
		* check 
		sort Mobility_index Mobility_raw_pct
	
	
		
			
		
		
	
	
	
	
	
	
	

  
  
  
