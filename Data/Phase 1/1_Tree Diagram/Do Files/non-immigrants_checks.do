/* Superdiveristy Project: Phase 1: Tree Diagram 
 * =======================================================
  
 * File: 2020.08.26 non-immigrants_checks.do
 * Author: Kasey Zapatka 
 * Purpose: Check accuracy of "other" categoery for non-immigrant data for Tree Diagram for Phase 1 of Superdiveristy Project
 * Data: 
 
	- Department of Homeland Security supplementary files: https://www.dhs.gov/immigration-statistics/nonimmigrant
	
	
 * Date Last Updated: 2020.08.26 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/DHS"
global savedir "${db}/Phase 1/1_Tree Diagram/Recoded"
global tabledir "${db}/Phase 1/1_Tree Diagram/Tables"
global dofiledir "${db}/Phase 1/1_Tree Diagram/Do Files"


* Load data: 2018: Non-immigrants, supplementary data
* ===================================
import excel "$rawdir/Non-immigrants/checks/fy2018_nonimmsuptable1d.xlsx", clear

	* transpose datset 
	* ----------------------------------------------------------
	drop in 1/3
	
	drop B		
	
		* transpose dataset 
		sxpose, clear  
	
	drop in 2
	drop _var65 - _var80
	
		* rename variables using "fast stata code.xlsx", sheetname (non-immigrants)
		* ----------------------------------------------------------
		rename _var1 country
		rename _var2 total
		rename _var3 A1
		rename _var4 A2
		rename _var5 A3
		rename _var6 B1
		rename _var7 B2
		rename _var8 C1
		rename _var9 C2
		rename _var10 C3
		rename _var11 CW1
		rename _var12 CW2
		rename _var13 E1
		rename _var14 E2
		rename _var15 E3
		rename _var16 F1
		rename _var17 F2
		rename _var18 F3
		rename _var19 G1
		rename _var20 G2
		rename _var21 G3
		rename _var22 G4
		rename _var23 G5
		rename _var24 GMB
		rename _var25 GMT
		rename _var26 H1B
		rename _var27 H1B1
		rename _var28 H1C
		rename _var29 H2A
		rename _var30 H2B
		rename _var31 H2R10
		rename _var32 H3
		rename _var33 H4
		rename _var34 I1
		rename _var35 J1
		rename _var36 J2
		rename _var37 K1
		rename _var38 K2
		rename _var39 K3
		rename _var40 K4
		rename _var41 L1
		rename _var42 L2
		rename _var43 M1
		rename _var44 M2
		rename _var45 N1_N7
		rename _var46 O1
		rename _var47 O2
		rename _var48 O3
		rename _var49 P1
		rename _var50 P2
		rename _var51 P3
		rename _var52 P4
		rename _var53 Q1
		rename _var54 R1
		rename _var55 R2
		rename _var56 TD
		rename _var57 TN
		rename _var58 V1
		rename _var59 V2
		rename _var60 V3
		rename _var61 WB
		rename _var62 WT
		rename _var63 Other
		rename _var64 Unknown
		
			drop in 1
			
	
	* run loop to filter out missing (-) and suppressed (D)
	* ------------------------------------------------------
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
		replace `v' = "0" if `v' == "X"
				
	   }
	   
	   destring, replace 
  	
	
	* collapse variables to match other data
	* ------------------------------------------------------
	
		* collpase GB, GMB, GT, GMT, WB, and WT admissions into "tour_bus_visa" 
		gen tour_bus_visa =  GMB + GMT + WB + WT
		
			br tour_bus_visa GMB GMT WB WT	
			
			drop  GMB GMT WB WT	
			
		* collpase B-1 and B-2 into "tourbusother" 
		gen tour_bus_other = B1 + B2
		
			br  tour_bus_other B1 B2
			
			drop  B1 B2
			
		* collapse F-1 to F-3, J-1, J-2, and M-1 to M-3 admissions into "students" 
		gen students = F1 + F2 + F3 + J1 + J2 + M1 + M2 
			
			br students F1 F2 F3 J1 J2 M1 M2
			
			drop F1 F2 F3 J1 J2 M1 M2

			
		* collapse E-1 to E-3, H-1B, H-1B1, H-1C, H-2A, H-2B, H-2R, H-3, H-4, I-1, L-1, 
		*		   L-2, O-1 to O-3, P-1 to P-4, Q-1, R-1, R-2, TD and TN admissions into "tempworker"
		gen tempworker = CW1 + CW2 + E1 + E2 + E3 + H1B + H1B1 + H1C + H2A + H2B + H2R10 + H3 + H4 + I1 + L1 + ///
						 L2 + O1 + O2 + O3 + P1 + P2 + P3 + P4 + Q1 + R1 + R2 + TD + TN 
						 
			br tempworker CW1 CW2 E1 E2 E3 H1B H1B1 H1C H2A H2B H2R10 H3 H4 I1 L1 L2 O1 O2 O3 P1 P2 P3 P4 ///
				 Q1 R1 R2 TD TN
				 
			drop CW1 CW2  E1 E2 E3 H1B H1B1 H1C H2A H2B H2R10 H3 H4 I1 L1 L2 O1 O2 O3 P1 P2 P3 P4 ///
				 Q1 R1 R2 TD TN
				 
		* collapse A-1 to A-3, G-1 to G-5, and N-1 to N-7 admissions into "diplomats"
		gen diplomats = A1 + A2 + A3 + G1 + G2 + G3 + G4 + G5 + N1_N7
		
			br diplomats A1 A2 A3 G1 G2 G3 G4 G5 N1_N7
			
			drop A1 A2 A3 G1 G2 G3 G4 G5 N1_N7
			
		* collpase C1, C2, C3, K1, K2, K3, K4, V1, V2, and V3 into "otherclasses"
		gen otherclasses = C1 + C2 + C3 + K1 + K2 + K3 + K4 + V1 + V2 + V3 + Other
		
			br otherclasses C1 C2 C3 K1 K2 K3 K4 V1 V2 V3 Other
			
			drop C1 C2 C3 K1 K2 K3 K4 V1 V2 V3 Other
		
		
			* check that all vars add too total variable
			* -----------------------------------------------------
			gen chk = Unknown + tour_bus_visa + tour_bus_other + students + tempworker + diplomats + otherclasses
								
				gen diff = total - chk
				
					fre diff 
				
				drop diff chk 
	
	* clean dataset
	* ------------------------------------------------------	

	* rename variables to match earlier data
	rename Unknown unknown

		  
		* run loop to rename each variable with year suffix
		* -----------------------------------------------------
		foreach v of varlist total-otherclasses {
			
			rename `v' `v'2018ck
					
		 }
		   
			* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
			* -----------------------------------------------------
			drop if country == "Asia"
			drop if country == "Africa"
			drop if country == "Europe"
			drop if country == "North America"
			drop if country == "Oceania"
			drop if country == "Central America"
			drop if country == "South America"
			drop if country == "Caribbean"
			
		* sort by country to order dataset like others
		* -----------------------------------------------------
		sort country
		
			* file edits 
			* ------------
			replace country = "All other countries" if country == "All other countries 1"
			
			replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
			
			replace country = "Czech Republic" if country == "Czechia"
			
			replace country = "Cape Verde" if country == "Cabo Verde"
			
			replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
			
			replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
			
			replace country = "Congo, Republic" if country == "Congo (Brazzaville) 1"
			
			replace country = "Congo, Democratic Republic" if country == "Congo (Kinshasa) 2"
			
			replace country = "Korea, North" if country == "Korea, North 3"
			
			replace country = "Korea, South" if country == "Korea, South 4"
			
			replace country = "Korea" if country == "Korea 3"
			
			replace country = "United States" if country == "United States 5"
			
			replace country = "China, People's Republic" if country == "China"
			
			replace country = "All other countries" if country == "Other"
			
			replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
			
			replace country = "Czech Republic" if country == "Czechia"
			
			replace country = "Cape Verde" if country == "Cabo Verde"
			
			replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
			
			replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
			
			replace country = "British Virgin Islands" if country == "Virgin Islands, British"
			
			replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
			
			replace country = "East Timor" if country == "Timor-Leste"
			
			replace country = "Cote d'Ivoire" if country == "Cote dIvoire"
			
			replace country = "New Zealand13" if country == "New Zealand"
			
			replace country = "China, People's Republic" if country == "China, People's Republic2,3"
			
			replace country = "Denmark" if country == "Denmark4"
			
			replace country = "France" if country == "France5"
			
			replace country = "Morocco" if country == "Morocco6"
			
			replace country = "Netherlands" if country == "Netherlands7"
			
			replace country = "New Zealand" if country == "New Zealand8"
			
			replace country = "Serbia and Montenegro" if country == "Serbia and Montenegro (former)"
			
			replace country = "United Kingdom" if country == "United Kingdom9"
			
			replace country = "Australia" if country == "Australia1"
				
	
		compress 
		
		order total, last
	
	* save file
	save "$savedir/Non-immigrants/checks/nonimmigrants2018.dta", replace

		clear all
		
		
		
		
* Load data: 2014: Non-immigrants, supplementary data
* ===================================
import excel "$rawdir/Non-immigrants/checks/2014_nonimmsuptable1d.xls", clear

	* transpose datset 
	* ----------------------------------------------------------
	drop in 1/3
	
	drop B		
	
		* transpose dataset 
		sxpose, clear  
	
	drop in 2
	drop _var66 - _var87
	
	drop _var15
	
		* rename variables using "fast stata code.xlsx", sheetname (non-immigrants)
		* ----------------------------------------------------------
		rename _var1 country
		rename _var2 total
		rename _var3 A1
		rename _var4 A2
		rename _var5 A3
		rename _var6 B1
		rename _var7 B2
		rename _var8 C1
		rename _var9 C2
		rename _var10 C3
		rename _var11 CW1
		rename _var12 CW2
		rename _var13 E1
		rename _var14 E2
		rename _var16 E3
		rename _var17 F1
		rename _var18 F2
		rename _var19 F3
		rename _var20 G1
		rename _var21 G2
		rename _var22 G3
		rename _var23 G4
		rename _var24 G5
		rename _var25 GMB
		rename _var26 GMT
		rename _var27 H1B
		rename _var28 H1B1
		rename _var29 H1C
		rename _var30 H2A
		rename _var31 H2B
		rename _var32 H2R10
		rename _var33 H3
		rename _var34 H4
		rename _var35 I1
		rename _var36 J1
		rename _var37 J2
		rename _var38 K1
		rename _var39 K2
		rename _var40 K3
		rename _var41 K4
		rename _var42 L1
		rename _var43 L2
		rename _var44 M1
		rename _var45 M2
		rename _var46 N1_N7
		rename _var47 O1
		rename _var48 O2
		rename _var49 O3
		rename _var50 P1
		rename _var51 P2
		rename _var52 P3
		rename _var53 P4
		rename _var54 Q1
		rename _var55 R1
		rename _var56 R2
		rename _var57 TD
		rename _var58 TN
		rename _var59 V1
		rename _var60 V2
		rename _var61 V3
		rename _var62 WB
		rename _var63 WT
		rename _var64 Other
		rename _var65 Unknown
		
			drop in 1
			
	
	* run loop to filter out missing (-) and suppressed (D)
	* ------------------------------------------------------
	foreach v of varlist * {
		
		replace `v' = "0" if `v' == "-"
		replace `v' = "0" if `v' == "D"
		replace `v' = "0" if `v' == "X"
				
	   }
	   
	   destring, replace 
  	
	
	* collapse variables to match other data
	* ------------------------------------------------------
	
		* collpase GB, GMB, GT, GMT, WB, and WT admissions into "tour_bus_visa" 
		gen tour_bus_visa =  GMB + GMT + WB + WT
		
			br tour_bus_visa GMB GMT WB WT	
			
			drop  GMB GMT WB WT	
			
		* collpase B-1 and B-2 into "tourbusother" 
		gen tour_bus_other = B1 + B2
		
			br  tour_bus_other B1 B2
			
			drop  B1 B2
			
		* collapse F-1 to F-3, J-1, J-2, and M-1 to M-3 admissions into "students" 
		gen students = F1 + F2 + F3 + J1 + J2 + M1 + M2 
			
			br students F1 F2 F3 J1 J2 M1 M2
			
			drop F1 F2 F3 J1 J2 M1 M2
			
		* collapse E-1 to E-3, H-1B, H-1B1, H-1C, H-2A, H-2B, H-2R, H-3, H-4, I-1, L-1, 
		*		   L-2, O-1 to O-3, P-1 to P-4, Q-1, R-1, R-2, TD and TN admissions into "tempworker"
		gen tempworker = CW1 + CW2 + E1 + E2 + E3 + H1B + H1B1 + H1C + H2A + H2B + H2R10 + H3 + H4 + I1 + L1 + ///
						 L2 + O1 + O2 + O3 + P1 + P2 + P3 + P4 + Q1 + R1 + R2 + TD + TN 
						 
			br tempworker CW1 CW2 E1 E2 E3 H1B H1B1 H1C H2A H2B H2R10 H3 H4 I1 L1 L2 O1 O2 O3 P1 P2 P3 P4 ///
				 Q1 R1 R2 TD TN
				 
			drop CW1 CW2  E1 E2 E3 H1B H1B1 H1C H2A H2B H2R10 H3 H4 I1 L1 L2 O1 O2 O3 P1 P2 P3 P4 ///
				 Q1 R1 R2 TD TN
				 
		* collapse A-1 to A-3, G-1 to G-5, and N-1 to N-7 admissions into "diplomats"
		gen diplomats = A1 + A2 + A3 + G1 + G2 + G3 + G4 + G5 + N1_N7
		
			br diplomats A1 A2 A3 G1 G2 G3 G4 G5 N1_N7
			
			drop A1 A2 A3 G1 G2 G3 G4 G5 N1_N7
			
		* collpase C1, C2, C3, K1, K2, K3, K4, V1, V2, and V3 into "otherclasses"
		gen otherclasses = C1 + C2 + C3 + K1 + K2 + K3 + K4 + V1 + V2 + V3 + Other
		
			br otherclasses C1 C2 C3 K1 K2 K3 K4 V1 V2 V3 Other
			
			drop C1 C2 C3 K1 K2 K3 K4 V1 V2 V3 Other
		
		
			* check that all vars add too total variable
			* -----------------------------------------------------
			gen chk = Unknown + tour_bus_visa + tour_bus_other + students + tempworker + diplomats + otherclasses
								
				gen diff = total - chk
				
					fre diff 
				
				drop diff chk 
	
	* clean dataset
	* ------------------------------------------------------	

	* rename variables to match earlier data
	rename Unknown unknown

		  
		* run loop to rename each variable with year suffix
		* -----------------------------------------------------
		foreach v of varlist total-otherclasses {
			
			rename `v' `v'2014ck
					
		 }
		   
			* drop country totals, Africa, Asia, Europe, North America, Oceania, Central America, Caribbean, and South America
			* -----------------------------------------------------
			drop if country == "Asia"
			drop if country == "Africa"
			drop if country == "Europe"
			drop if country == "North America"
			drop if country == "Oceania"
			drop if country == "Central America"
			drop if country == "South America"
			drop if country == "Caribbean"
			
		* sort by country to order dataset like others
		* -----------------------------------------------------
		sort country
		
			* file edits 
			* ------------
			replace country = "All other countries" if country == "All other countries 1"
			
			replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
			
			replace country = "Czech Republic" if country == "Czechia"
			
			replace country = "Cape Verde" if country == "Cabo Verde"
			
			replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
			
			replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
			
			replace country = "Congo, Republic" if country == "Congo (Brazzaville)5"
			
			replace country = "Congo, Democratic Republic" if country == "Congo (Kinshasa)6"
			
			replace country = "Korea, North" if country == "Korea, North9"
			
			replace country = "Korea, South" if country == "Korea, South10"
			
			replace country = "Korea" if country == "Korea 3"
			
			replace country = "United States" if country == "United States 5"
			
			replace country = "China, People's Republic" if country == "China3,4"
			
			replace country = "All other countries" if country == "Other"
			
			replace country = "Saint Kitts-Nevis" if country == "Saint Kitts and Nevis"
			
			replace country = "Czech Republic" if country == "Czechia"
			
			replace country = "Cape Verde" if country == "Cabo Verde"
			
			replace country = "Antigua-Barbuda" if country == "Antigua and Barbuda"
			
			replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
			
			replace country = "British Virgin Islands" if country == "Virgin Islands, British"
			
			replace country = "Micronesia, Federated States of" if country == "Micronesia, Federated States"
			
			replace country = "East Timor" if country == "Timor-Leste"
			
			replace country = "Cote d'Ivoire" if country == "Cote dIvoire"
			
			replace country = "New Zealand13" if country == "New Zealand"
			
			replace country = "China, People's Republic" if country == "China, People's Republic2,3"
			
			replace country = "Denmark" if country == "Denmark7"
			
			replace country = "France" if country == "France8"
			
			replace country = "Morocco" if country == "Morocco11"
			
			replace country = "Netherlands" if country == "Netherlands12"
			
			replace country = "New Zealand" if country == "New Zealand13"
			
			replace country = "Serbia and Montenegro" if country == "Serbia and Montenegro (former)"
			
			replace country = "United Kingdom" if country == "United Kingdom14"
			
			replace country = "Australia" if country == "Australia1"
			
			replace country = "Canada" if country == "Canada2"
			
			replace country = "Eswatini (formerly Swaziland)" if country == "Swaziland"
				
	
		compress 
		
		order total, last
	
	* save file
	save "$savedir/Non-immigrants/checks/nonimmigrants2014.dta", replace

		clear all
							

* Merge Non-immigrants data
* ===================================
cd "$savedir/Non-immigrants"
use "nonimmigrants2018.dta", clear

		merge 1:1 country using "nonimmigrants2014.dta"	
		
		replace country = "New Zealand" if country == "New Zealand13"
		
		drop if country == "Swaziland"
		
		drop _merge

	* merge dsupplement years for accuracy test
	cd "$savedir/Non-immigrants/checks"
	merge 1:1 country using "nonimmigrants2018.dta"	
		drop _merge 
		
	merge 1:1 country using "nonimmigrants2014.dta"	
		drop _merge
		
		drop if country == "Eswatini (formerly Swaziland)"
		
		br country unknown2018 unknown2018ck
		
		br country otherclasses2018 otherclasses2018ck
				
		* log the results for 2018	
		* ------------------------------------------
		log using "$savedir/Non-immigrants/checks/nonimmigrants2018-check.log", replace
		
			* run loop to check differences
			foreach v of varlist  total2018-unknown2018 {
						
				* replace `v' = 0 if `v' == .
				gen d_`v' = `v' - `v'ck
								
			} 
			
			* check fre of diff vars 
			fre d_total2018  // no difference
			fre d_tour_bus_visa2018 // very small differences 
			fre d_tour_bus_other2018 // differences likely due to BCC admissions?
			fre d_students2018 // small differences -  could be due to inclusion of F3
			fre d_tempworker2018 // 84 % are within 5 points
			fre d_diplomats2018 // 98% are within 5 points
			fre d_otherclasses2018 // 89% of the the data have obs within 5points, Mexico & Canada are the outliers but not in later years
			fre d_unknown2018 // 99% are within 2points
			
		
		log close
		
				
		* log the results for 2014
		* ------------------------------------------
		log using "$savedir/Non-immigrants/checks/nonimmigrants2014-check.log", replace
		
			* run loop to check differences
			foreach v of varlist  total2014 tour_bus_visa2014 tour_bus_other2014 students2014 tempworker2014 diplomats2014 otherclasses2014 unknown2014{
						
				* replace `v' = 0 if `v' == .
				gen d_`v' = `v' - `v'ck
								
			} 
			
			* check fre of diff vars 
			fre d_total2014  // no difference
			fre d_tour_bus_visa2014 // 100% are within 2points
			fre d_tour_bus_other2014 // 99% are within 2
			fre d_students2014 // 91% are with 2
			fre d_tempworker2014 // 85 % are within 5 points
			fre d_diplomats2014 // 99.5% are within 5 points
			fre d_otherclasses2014 // 90% of the the data have obs within 5points 
			fre d_unknown2014 // 99% are within 2points
			
		
		log close
		
	* save data for further analysis
	save "$savedir/Non-immigrants/checks/nonimmigrants2018_2014-checks.dta", replace
	
