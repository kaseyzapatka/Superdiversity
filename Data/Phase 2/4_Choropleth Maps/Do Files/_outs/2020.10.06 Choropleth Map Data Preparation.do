/* Superdiveristy Project: Phase 2: Choropleth Map
 * =======================================================
  
 * File: 2020.10.06 Choropleth Map Data Preparation.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Intersectionality Dashboard for Phase 2 of Superdiveristy Project
 * Data: 
	- Downloaded from IPUMS at: https://usa.ipums.org/usa-action/data_requests/download
	- see Data preparation notes.txt for more on each of the variables
	
 * Date Last Updated: 2020.10.06 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/ACS"
global savedir "${db}/Phase 2/4_Choropleth Maps/Recoded"
global BCsavedir "${db}/Phase 1/3_Bubble Chart/Recoded"
global tabledir "${db}/Phase 2/4_Choropleth Maps/Tables"
global dodir "${db}/Phase 2/4_Choropleth Maps/Do Files"

				
* run a do file to create a tract-PUMA crosswalk and calculate 80th percentile floor for household income
* ================				
run "$dodir/2020.10.08 Tract to Puma Crosswalk and Income Floor 80th Percentile.do"
						
* load tract-level census data obtained from R using Tidycensus package
* ================
import delimited "$rawdir/tract data for Choropleth Maps.csv", clear
	
	
* preliminary data cleaning
* ============================

	* clean and prep important geo variables  
	* --------------------------------------
		
		* sting tractid
		tostring geoid, gen(tractid) format("%12.0f")
		lab var tractid "tractid: state-county-tract fips"
		
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
				fre statecountyfipstr // checks out... we should drop countyfips 36000 in all microdata bc that is a residual category 
	
		
		* order to front of dataset 
		order statecountyfipstr, after(tractid)
		order state, after(statecountyfipstr)
		order county, after(state)
		order tract, after(county)
		
		
	* collapase dataset to metro area using tract-PUMA crosswalk
	* ----------------------------------------------------------
	merge 1:1 tractid using "$crossdir/tract-PUMA crosswalk for metro area.dta"
	
		* drop tracts that didn't match
		drop if _merge != 3
		
			drop _merge
			
			* checks
			distinct puma // should be 146 unique PUMAs
			distinct tractid // should be 4,520 unique tracts
		
		
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
	
	
	* count number of ethnicities per tract to create normalization variable
	* -------------------------------------------------------
	br tractid ancestry*
	
		* run loop to replace ancestry values as missing for rownonmiss count
		foreach v of varlist ancestry2-ancestry109 {
			
			replace `v' = . if `v' == 0
			
		}
	
		* count rownonmiss to count number of different ancestries pertract 
		egen number_ancestry_tract = rownonmiss(ancestry2-ancestry109) 
		
			* checks
			fre number_ancestry_tract
			
			* check popualation of tracts where number_ancestry_tract == 0
			fre pop if number_ancestry_tract == 0 // these tracts have no population 
			
			
			
* variables for "Traditional Maps"
* ============================

	* immigrants 
	* ---------------------------
	gen immigrants = citizen_nat + not_citizen
	lab var immigrants "all foreign-born residents"
	
	lab var citizen_tot "total citizens"
	
		* create MSA-level variables for Location Quotients
		egen immigrantsMSA = total(immigrants)
		lab var immigrantsMSA "foreign-born residents, MSA total"
		
		egen citizen_totMSA = total(citizen_tot)
		lab var citizen_totMSA "total citizens, MSA total"
		
			* format variables
			format immigrantsMSA citizen_totMSA %15.0fc
	
	
	* recent immigrants 
	* ---------------------------
	gen recentimmigrants = imm2010_fb
	lab var recentimmigrants "foreign-born residents who entered the US in 2010 or later"
	
		* create MSA-level variables for Location Quotients
		egen recentimmigrantsMSA = total(recentimmigrants)
		lab var recentimmigrantsMSA "foreign-born residents who entered the US in 2010 or later, MSA total"
		
			* format variables
			format recentimmigrantsMSA immigrantsMSA %15.0fc // immigrants variable is same as adding up all immigrant variables from recentimmigrant categories
			
				* checks
				br recentimmigrants immigrants recentimmigrantsMSA immigrantsMSA 
	
	
	
	* high income 
	* ---------------------------
	gen highincome = inc15 + inc16
	lab var highincome "number of household making more than $150,000"
	
		* create MSA-level variables for Location Quotients
		egen highincomeMSA = total(highincome)
		lab var highincomeMSA "number of household making more than $150,000, MSA total"
		
		egen inc_totMSA = total(inc_tot)
		lab var inc_totMSA "number of households, MSA total"
		
			* format variables
			format highincomeMSA inc_totMSA %15.0fc 
			
				* checks
				br  highincome inc_tot  highincomeMSA inc_totMSA // ~ top 21% of households
	
	
	
	* race-ethnicty and minority groups 
	* ---------------------------
	
		
		* create MSA-level variables for Location Quotients: race-ethncity 
			
			* racetot MSA total
			egen racetotMSA = total(racetot)
			lab var racetotMSA "race-ethnicity totals, MSA total"
			
			* nhwht
			egen nhwhtMSA = total(nhwht)
			lab var nhwhtMSA "non-Hispanic White, MSA total"
			
			* nhblk
			egen nhblkMSA = total(nhblk)
			lab var nhblkMSA "non-Hispanic Black, MSA total"
			
			* nhasian
			egen nhasianMSA = total(nhasian)
			lab var nhasianMSA "non-Hispanic Asian, MSA total"
			
			* nhother
			rename nhother other 
				
			gen nhother = other + nhnat + nhpac + nhtwo
			lab var nhother "non-Hispanic Other"
			
			egen nhotherMSA = total(nhother)
			lab var nhotherMSA "non-Hispanic Other, MSA total"
			
			* hispanic
			rename hisp hispanic
			lab var nhother "Hispanic"
			
			egen hispanicMSA = total(hispanic)
			lab var hispanicMSA "Hispanic, MSA total"
			
				* checks 
				br nhwht nhblk nhasian nhother hispanic racetot
				
					* make sure they sum to racetot
					gen check = nhwht + nhblk + nhasian + nhother + hispanic
					gen diff = racetot - check
					
						fre diff
						
						drop check diff 
						
			
				* format variables
				format nhwhtMSA nhblkMSA nhasianMSA nhotherMSA hispanicMSA racetotMSA %15.0fc 
				
					* checks
					br  nhwhtMSA nhblkMSA nhasianMSA nhotherMSA hispanicMSA racetotMSA // sums correctly
			
		* create MSA-level variables for Location Quotients: top 5 hispanic groups
		
			
			* puerto rican
			egen puertoricanMSA = total(puertorican)
			lab var puertoricanMSA "puerto rican, MSA total"
			
			* dominican
			egen dominicanMSA = total(dominican)
			lab var dominicanMSA "dominican, MSA total"
			
			* mexican
			egen mexicanMSA = total(mexican)
			lab var mexicanMSA "mexican, MSA total"
			
			* ecuadorian
			egen ecuadorianMSA = total(ecuadorian)
			lab var ecuadorianMSA "ecuadorian, MSA total"
			
			* colombian
			egen colombianMSA = total(colombian)
			lab var colombianMSA "colombian, MSA total"
			
			
		* create MSA-level variables for Location Quotients: top 5 asian groups
		
			* chinese
			egen chineseMSA = total(chinese)
			lab var chineseMSA "chinese, MSA total"
			
			* indian
			egen indianMSA = total(indian)
			lab var indianMSA "indian, MSA total"
			
			* filipino
			egen filipinoMSA = total(filipino)
			lab var filipinoMSA "filipino, MSA total"
			
			* korean
			egen koreanMSA = total(korean)
			lab var koreanMSA "korean, MSA total"
			
			* bangladeshi
			egen bangladeshiMSA = total(bangladeshi)
			lab var bangladeshiMSA "bangladeshi, MSA total"
			
		
			* checks
			br chineseMSA nhasianMSA // ~ 37% of all asains
			br indianMSA nhasianMSA // ~ 29% of all asains
			br filipinoMSA nhasianMSA // ~ 9% of all asains
			br koreanMSA nhasianMSA // ~ 9% of all asains
			br bangladeshiMSA nhasianMSA // ~ 4% of all asains = totals to 88% 
			
			br puertoricanMSA hispanicMSA // ~ 26% of all hispanics 
			br dominicanMSA hispanicMSA // ~ 23% of all hispanics 
			br mexicanMSA hispanicMSA // ~ 12% of all hispanics 
			br ecuadorianMSA hispanicMSA // ~ 8% of all hispanics 
			br colombianMSA hispanicMSA // ~ 6% of all hispanics = totals to 75% 
	
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
			
			
		
		* recent immigrants 
		* ---------------------------
		gen LQrecentimmigrants = (recentimmigrants/immigrants)/(recentimmigrantsMSA/immigrantsMSA) 
		
			* place in quantiles
			xtile LQrecentimmigrants_index = LQrecentimmigrants, nquantiles(15)
			
			
		* high-income
		* ---------------------------
		gen LQhighincome = (highincome/inc_tot)/(highincomeMSA/inc_totMSA) 
		
			* place in quantiles
			xtile LQhighincome_index = LQhighincome, nquantiles(15)
			
			
		* race-ethnicty and minority groups 
		* ---------------------------
		
			* race-ethncity 
			
				* nhwht 
				gen LQnhwht = (nhwht/racetot)/(nhwhtMSA/racetotMSA) 
			
					* place in quantiles
					xtile LQnhwht_index = LQnhwht, nquantiles(15)
				
				* nhblk
				gen LQnhblk = (nhblk/racetot)/(nhblkMSA/racetotMSA) 
			
					* place in quantiles
					xtile LQnhblk_index = LQnhblk, nquantiles(15)
					
				* nhasian
				gen LQnhasian = (nhasian/racetot)/(nhasianMSA/racetotMSA) 
			
					* place in quantiles
					xtile LQnhasian_index = LQnhasian, nquantiles(15)
				
				* nhother
				gen LQnhother = (nhother/racetot)/(nhotherMSA/racetotMSA) 
			
					* place in quantiles
					xtile LQnhother_index = LQnhother, nquantiles(15)
					
				* hispanic 
				gen LQhispanic = (hispanic/racetot)/(hispanicMSA/racetotMSA) 
			
					* place in quantiles
					xtile LQhispanic_index = LQhispanic, nquantiles(15)
					
			* top 5 hispanic groups
			
				* puerto rican 
				gen LQpuertorican = (puertorican/hispanic)/(puertoricanMSA/hispanicMSA) 
			
					* place in quantiles
					xtile LQpuertorican_index = LQpuertorican, nquantiles(15)
				
				* dominican
				gen LQdominican = (dominican/hispanic)/(dominicanMSA/hispanicMSA) 
			
					* place in quantiles
					xtile LQdominican_index = LQdominican, nquantiles(15)
					
				* mexican
				gen LQmexican = (mexican/hispanic)/(mexicanMSA/hispanicMSA) 
			
					* place in quantiles
					xtile LQmexican_index = LQmexican, nquantiles(15)
				
				* ecuadorian
				gen LQecuadorian = (ecuadorian/hispanic)/(ecuadorianMSA/hispanicMSA) 
			
					* place in quantiles
					xtile LQecuadorian_index = LQecuadorian, nquantiles(15)
					
				* colombian 
				gen LQcolombian = (colombian/hispanic)/(colombianMSA/hispanicMSA) 
			
					* place in quantiles
					xtile LQcolombian_index = LQcolombian, nquantiles(15)
				
				
			* top 5 asian groups
			
				* chinese
				gen LQchinese = (chinese/nhasian)/(chineseMSA/nhasianMSA) 
			
					* place in quantiles
					xtile LQchinese_index = LQchinese, nquantiles(15)
				
				* indian
				gen LQindian = (indian/nhasian)/(indianMSA/nhasianMSA) 
			
					* place in quantiles
					xtile LQindian_index = LQindian, nquantiles(15)
					
				* filipino
				gen LQfilipino = (filipino/nhasian)/(filipinoMSA/nhasianMSA) 
			
					* place in quantiles
					xtile LQfilipino_index = LQfilipino, nquantiles(15)
				
				* korean
				gen LQkorean = (korean/nhasian)/(koreanMSA/nhasianMSA) 
			
					* place in quantiles
					xtile LQkorean_index = LQkorean, nquantiles(15)
					
				* bangladeshi 
				gen LQbangladeshi = (bangladeshi/nhasian)/(bangladeshiMSA/nhasianMSA) 
			
					* place in quantiles
					xtile LQbangladeshi_index = LQbangladeshi, nquantiles(15)
				
		
		
* variables for "Superdiversity Maps"
* ============================
	
	* ethnicity variables 
	* ---------------------------
	gen ethnicity = number_ancestry_tract
	
		* generate percentile for percent of total that moved in
		xtile ethnicity_index = ethnicity, nquantiles(3)
		lab var ethnicity_index "ethnicity cut into 3 percentiles"
	
	gen ethnicity_norm = number_ancestry_tract/ancestry_tot // ancestry_tot == pop
	
		* generate percentile index for percent of total that moved in
		xtile ethnicity_norm_index = ethnicity_norm, nquantiles(3)
		lab var ethnicity_norm_index "ethnicity_norm cut into 3 percentiles"
	
	
	* mobility var as percent of total that moved into census tract 
	* ---------------------------------------------------------------------
	br tractid moveintot moveincounty moveinstate moveindiffstate moveinabroad stayed
	
		* generate "moved into" variable 
		gen movedinto = moveincounty + moveinstate + moveindiffstate + moveinabroad
		
			* checks: make sure movedinto and stayed = moveintote
			gen check = movedinto + stayed
			gen diffck = moveintot - check 
			
				fre diffck // should be straight 0s
				
				* drop un-necessary variables 
				drop check diffck 
			
		* generate percent of total that moved in
		gen pmovedinto = (movedinto/moveintot)*100
		lab var pmovedinto "percent of total that moved into census tract within the last year"
		
		* generate percentile index for percent of total that moved in
		xtile pmovedinto_index = pmovedinto, nquantiles(3)
		lab var pmovedinto_index "pmovedinto cut into 3 percentiles"
		
		
	* income deciles
	* ---------------------------
	br inc_tot inc1 inc2 inc3 inc4 inc5 inc6 inc7 inc8 inc9 inc10 inc11 inc12 inc13 inc14 inc15 inc16
	
		* use loop to create percent variable for each income group
		foreach v of varlist inc1-inc16 {

			gen p`v' =  (`v'/inc_tot)
			lab var p`v' "percent of income"
			
			gen p`v'sq =  p`v'^2
			lab var p`v'sq "square of percent of income"
			
			order p`v', after(`v') // order percent after variable 
			order p`v'sq, after(p`v') // order square after percent variable 
			
		}
		
		
			* random check 
			br inc8 pinc8 inc_tot
			
			gen check = pinc1 + pinc2 + pinc3 + pinc4 + pinc5 + pinc6 + pinc7 + pinc8 + pinc9 + pinc10 + pinc11 + pinc12 + pinc13 + pinc14 + pinc15 + pinc16
				
				fre check
				drop check 
				
		
		* generate Simpson's Generalized Index of Entropy (SI)
		gen SIincome_cat = 1 - (pinc1sq + pinc2sq + pinc3sq + pinc4sq + pinc5sq + pinc6sq + pinc7sq + pinc8sq + pinc9sq + pinc10sq + ///
							pinc11sq + pinc12sq + pinc13sq + pinc14sq + pinc15sq + pinc16sq)
		lab var SIincome_cat "Simpson's Index for income categories"
		
		* generate percentile index for Simpson's Generalized Index of Entropy (SI)
		xtile SIincome_cat_index = SIincome, nquantiles(3)
		lab var SIincome_cat_index "Simpson's Index for income categories, cut into 3 percentiles"
		
			* checks 
			sum SIincome_cat, de 
			
				sort SIincome_cat
			
			br SIincome_cat SIincome_cat_index
			
			
	* immigration status
	* ---------------------------
	br immigrants imm2010_fb imm2000_fb  imm1990_fb immbefore1990_fb
	
		* use loop to create percent variable for each income group
		foreach v of varlist imm2010_fb imm2000_fb  imm1990_fb immbefore1990_fb {

			gen p`v' =  (`v'/immigrants)
			lab var p`v' "percent of immigrant category"
			
			gen p`v'sq =  p`v'^2
			lab var p`v'sq "square of percent of immigrant category"
			
			order p`v', after(`v') // order percent after variable 
			order p`v'sq, after(p`v') // order square after percent variable 
			
		}
		
			* random check 
			br imm2010_fb pimm2010_fb immigrants
			
			gen check = pimm2010_fb + pimm2000_fb  + pimm1990_fb + pimmbefore1990_fb
				
				fre check
				drop check 
				
		
		* generate Simpson's Generalized Index of Entropy (SI)
		gen SIimmigration_cat = 1 - (pimm2010_fbsq + pimm2000_fbsq  + pimm1990_fbsq + pimmbefore1990_fbsq)
		lab var SIimmigration_cat "Simpson's Index for immigration categories"
		
		* generate percentile index for Simpson's Generalized Index of Entropy (SI)
		xtile SIimmigration_cat_index = SIimmigration_cat, nquantiles(3)
		lab var SIimmigration_cat_index "Simpson's Index for immigration categories, cut into 3 percentiles"
		
			* checks 
			sum SIimmigration_cat, de 
			
				sort SIimmigration_cat
			
			br SIimmigration_cat SIimmigration_cat_index
	
	
	* educational status
	* ---------------------------
	br edu_tot noedu lesshs1 lesshs2 lesshs3 lesshs4 lesshs5 lesshs6 lesshs7 lesshs8 lesshs9 lesshs10 lesshs11 lesshs12 /// 
	   lesshs13 lesshs14 hs ged somecol1 somecol2 somecol3 ba ma profdegree phd
	
		* create educational attainment groups 
			
			gen lesshighschool = noedu + lesshs1 + lesshs2 + lesshs3 + lesshs4 + lesshs5 + lesshs6 + lesshs7 + lesshs8 + lesshs9 + lesshs10 + lesshs11 + lesshs12 + /// 
				lesshs13 + lesshs14
			lab var lesshighschool "less than high school degree"
			
			gen highschool = hs + ged 
			lab var highschool "high school degree"
			
			gen somecollege = somecol1 + somecol2 + somecol3
			lab var somecollege "Postsecondary education without a college degree"
			
			gen collegeorhigher = ba + ma + profdegree + phd
			lab var collegeorhigher "college degree or higher"
			
				br lesshighschool highschool somecollege collegeorhigher edu_tot // checks out
		
		
		* use loop to create percent variable for each income group
		foreach v of varlist lesshighschool highschool somecollege collegeorhigher {

			gen p`v' =  (`v'/edu_tot)
			lab var p`v' "percent of educational attainment category"
			
			gen p`v'sq =  p`v'^2
			lab var p`v'sq "square of percent of educational attainment category"
			
			order p`v', after(`v') // order percent after variable 
			order p`v'sq, after(p`v') // order square after percent variable 
			
		}
		
			* random check 
			br somecollege psomecollege edu_tot
			
			gen check = plesshighschool + phighschool + psomecollege + pcollegeorhigher
				
				fre check
				drop check 
				
		
		* generate Simpson's Generalized Index of Entropy (SI)
		gen SIeducation_cat = 1 - (plesshighschoolsq + phighschoolsq  + psomecollegesq + pcollegeorhighersq)
		lab var SIeducation_cat "Simpson's Index for educational attainment categories"
		
		* generate percentile index for Simpson's Generalized Index of Entropy (SI)
		xtile SIeducation_cat_index = SIeducation_cat, nquantiles(3)
		lab var SIeducation_cat_index "Simpson's Index for educational attainment categories, cut into 3 percentiles"
		
			* checks 
			sum SIeducation_cat, de 
			
				sort SIeducation_cat
			
			br SIeducation_cat SIeducation_cat_index
			
	
	
* Save dataset for later use
* =================================
save "$savedir/2020.10.07 Choropleth Map Data.dta", replace

	
* Traditional maps: saving and exporting
* =================================
use "$savedir/2020.10.07 Choropleth Map Data.dta", clear 
			
		* sort on tract id variable 
		sort tractid 
		
		lab var pop "tract population"
	
	* keep on the variables needed 
	* ----------------------------
	keep tractid pop LQimmigrants LQimmigrants_index LQrecentimmigrants LQrecentimmigrants_index LQhighincome LQhighincome_index LQnhwht LQnhwht_index ///
		 LQnhblk LQnhblk_index LQnhasian LQnhasian_index LQnhother LQnhother_index LQhispanic LQhispanic_index LQpuertorican LQpuertorican_index /// 
		 LQdominican LQdominican_index LQmexican LQmexican_index LQecuadorian LQecuadorian_index LQcolombian LQcolombian_index LQchinese LQchinese_index ///
		 LQindian LQindian_index LQfilipino LQfilipino_index LQkorean LQkorean_index LQbangladeshi LQbangladeshi_index
		 
		 
	* export to excel 
	* ----------------------
	export excel using "$tabledir/2020.10.07 Choropleth Map - traditional map.xlsx", sheet("data", replace) firstrow(variables) keepcellfmt cell(A1)	
		
			
		
* Superdiversity maps: saving and exporting
* =================================
use "$savedir/2020.10.07 Choropleth Map Data.dta", clear 

	* ethncity  
	rename ethnicity Ethnicity_raw_count
	rename ethnicity_index Ethnicity_index
	
	rename ethnicity_norm Ethnicity_raw_norm
	rename ethnicity_norm_index Ethnicity_norm_index
	
		lab var Ethnicity_raw_count "ethnicity raw count"
		lab var Ethnicity_raw_norm "ethnicity raw count, normalized"
	
	* mobility 
	rename pmovedinto Mobility_raw_pct
	rename pmovedinto Mobility_index
	
	* income 
	rename SIincome_cat Income_raw_SI
	rename SIincome_cat_index Income_index
	
	* immigration 
	rename SIimmigration_cat Immig_category_raw_SI
	rename SIimmigration_cat_index Immig_category_index
	
	* education 
	rename SIeducation_cat Education_raw_SI
	rename SIeducation_cat_index Education_index
		
		* check 
		sort Mobility_index Mobility_raw_pct
		
		
	* keep only variables necessary for analysis
	keep tractid pop Ethnicity_raw_count Ethnicity_index Ethnicity_raw_norm Ethnicity_norm_index Mobility_raw_pct Mobility_index Income_raw_SI Income_index  ///		
		 Immig_category_raw_SI  Immig_category_index Education_raw_SI Education_index
	
		
			
		* desc variables 
		desc 
		

		* sort on tract id variable
		sort tractid

* export to excel 
* ----------------------
export excel using "$tabledir/2020.10.07 Choropleth Map - superdiversity map.xlsx", sheet("data", replace) firstrow(variables) keepcellfmt cell(A1)	
	
	
	clear all 
	
	exit 
		
		
		
		/* Notes for write-up
	   ==========================
	
	1. Income categories were combined to create 9 or 10. To determine the threshold for 
	   high income, we cut the income distribution of the metro area using individual-level
	   micro data into deciles. The lower-bound of the 8th decile was $160,899. Since census 
	   tract-level data comes pre-divided into buckets, the closest threshold to this is 
	   $150,000 or higher. When we count the number of individuals within the meto areas that
	   have a household incoem of $150,000 or higher, this consists of approximately 21% of all
	   metro area households. We feel this is a very close approximation to the 80th percentile. 
	
	2. The variable for educational attainment for college degree includes individuals with equal to
	   or more than a college degree.
	
	3.
	
	
	
	
	
/* income categories 

* lab var inc25 "Households with income less than $25,000"
* lab var inc50 "Households with income $25,000 - $49,999"
* lab var inc75 "Households with income $50,000 to $74,999"
* lab var inc100 "Households with income $75,000 to $99,999"
* lab var inc125 "Households with income $100,000 to $124,9999"
* lab var inc125up "Households with income $125,000 and above"
  
  
