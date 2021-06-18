/* Superdiveristy Project: Phase 2: Choropleth Map
 * =======================================================
  
 * File: 2020.10.08 Tract to Puma Crosswalk and Income Floor 80th Percentile.do
 * Author: Kasey Zapatka 
 * Purpose: 
	- Download, clean, and prepare tract to puma cross walk for Choropleth Map for Phase 2 of Superdiveristy Project
	- Determine income floor for 80th percentile for Choropleth Map for Phase 2 of Superdiveristy Project
 * Data: 
	- using IPUMS data from Bubble Chart
	- crosswalk downloadable at : http://mcdc.missouri.edu/applications/geocorr2014.html 
	
 * Date Last Updated: 2020.10.08 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/ACS"
global savedir "${db}/Phase 2/4_Choropleth Maps/Recoded"
global BCsavedir "${db}/Phase 1/3_Bubble Chart/Recoded"
global tabledir "${db}/Phase 2/4_Choropleth Maps/Tables"
global dodir "${db}/Phase 2/4_Choropleth Maps/Do Files"
global crossdir "${db}/Phase 2/4_Choropleth Maps/Crosswalks"

* determine floor for the 80th percentile in household income 
* ============================================
use "$BCsavedir/2020.09.10 Bubble Chart Data.dta", clear 

		* create deciles for hhincome
		xtile hhincome_index = hhincome, nquantiles(10)
		
		sum hhincome if hhincome_index == 8, de // use $150,000 threshold or the top two income categories 
		
	* create list of state pumas
	* --------------------------------------
	* string state and puma vars
	tostring statefip, gen(statefipstr) format("%02.0f")
	tostring puma, gen(pumastr) format("%05.0f")
		
			lab var statefipstr "statefips"
			lab var pumastr "puma"
		
		* concatenate state and countryfips vars
		gen str statepuma = statefipstr + pumastr
		lab var statepuma "statefips + puma"	
		
	* create population variable 
	* --------------------------------------
	gen pop = 1
		
	* create population variable 
	* --------------------------------------
	collapse (count) pop, by(statepuma)
	
		* generate sub-strings for state and PUMA 
		gen state = substr(statepuma, 1,2) // specifies first digit, length of string
		lab var state "state"
		
		gen puma = substr(statepuma, 3,5) 
		lab var puma "puma"
		
	
	* export to excel 
	* ----------------------
	* export delimited using "$crossdir/PUMAs for NY Metro.csv", replace
	save "$crossdir/metro area PUMAs.dta", replace
	
	
* acquire tract to PUMA crosswalk
* ============================================
* this website will create tract to PUMA crosswalks: 
* http://mcdc.missouri.edu/applications/geocorr2014.html

* import crosswalk
import delimited "$crossdir/tract to PUMA crosswalk for NY and NJ.csv", varnames(1) clear

	* keep only needed variables 
	keep county tract state puma12 pumaname cntyname
	
	drop in 1
	
		* clean geography variables
		* ----------------------------
		rename county countyfips
		
		rename puma12 puma
	
			* create county sub-strings 
			gen county = substr(countyfips, 3,3) // specifies first digit, length of string
			lab var county "county"
			
			gen str8 statepuma = state + puma
			lab var statepuma "state + puma"
			
		
			* remove decimal from tract variable 
			replace tract = subinstr(tract,".","",.)
			
				* create tractid
				gen str11 tractid = countyfips + tract 
				
		
		* order
		order state, first
		order county, after(state)
		order statepuma, after(puma)
		order tractid, first

		* merge with list of metro area pumas
		* ----------------------------
		merge m:1 statepuma using "$crossdir/metro area PUMAs.dta"
		
			* drop if not in universe
			drop if _merge != 3
			
				drop _merge pop 
			
			* check 
			distinct puma // should be 146 distinct pumas 
			
			distinct tractid // every tractid should be distinct
			
			
		sort tractid
		
			* labels
			lab var tractid "tractid: state-county-tract fips"
			lab var state  "state"
			lab var county "county"
			lab var countyfips  "state + county"
			lab var tract "tract"
			lab var puma "PUMA" 
			lab var statepuma "state + PUMA"
			lab var cntyname "county name"
			lab var pumaname "PUMA name"
			
			
		* save as tract-puma crosswalk
		* ----------------------------
		save "$crossdir/tract-PUMA crosswalk for metro area.dta", replace 
		
		
		clear all
		
			
			
		
