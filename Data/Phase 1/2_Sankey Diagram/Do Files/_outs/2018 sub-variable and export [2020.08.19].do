/* Superdiveristy Project: Phase 1: Sankey Diagram 
 * =======================================================
  
 * File: 2020.08.19 Sankey Diagram Data Preparation.do
 * Author: Kasey Zapatka 
 * Purpose: code sub-region and region for ancestry and sub-family and family for language for each year
   Sankey Diagram data for Phase 1 of Superdiveristy Project
 * Data: 
	- Downloaded from IPUMS at: https://usa.ipums.org/usa-action/data_requests/download
	- see Data preparation notes.txt for more on each of the variables
	
 * Date Last Updated: 2020.08.19 */ 
 
 
	*****
	* ancestry : create regions and sub-regions variable 
	*****
		
		* ancestry_subreg
		* --------------------------
		gen ancestry_subreg =  ancestry
		
				br ancestry ancestry_subreg 
				
				
		recode ancestry_subreg (924 = 0) /// /* Euro-Americans */ 
							   (22 = 1) (50 = 1) (87 = 1) (88 = 1) (97 = 1) (11 = 1) ///  /* British Isles origins */
							   (1 = 2) (26 = 2)  ///  /* French origins */
							   (3 = 3) (8 = 3) (21 = 3) (9 = 3) (32 = 3) (40 = 3) (77 = 3) (91 = 3) (187 = 3)  ///  /* Western European origins */
							   (20 = 4) (24 = 4) (49 = 4) (82 = 4) (89 = 4) (98 = 4) (183 = 4) ///  /* Northern European origins */
							   (103 = 5) (102 = 5) (111 = 5) (112 = 5) (115 = 5) (125 = 5) (128 = 5) ///  /* Eastern European origins */
							   (129 = 5) (146 = 5) (142 = 5) (144 = 5) (148 = 5) ///  /* Eastern European origins */
							   (153 = 5) (108 = 5) (171 = 5) (190 = 5) ///  /* Eastern European origins */
							   (100 = 6) (109 = 6) (46 = 6) (51 = 6) (130 = 6)  ///  /* Southern European origins */
							   (78 = 6) (84 = 6) (152 = 6) (154 = 6) (200 = 6) (295 = 6) (176 = 6) (185 = 6) ///  /* Southern European origins */
							   (5 = 7) (178 = 7) (195 = 7) ///  /* Other European origins */
							   (920 = 8) (921 = 8) (923 = 8) (922 = 8) ///  /* North American Aborginal origins */
							   (936 = 9) (939 = 9) (931 = 9) (933 = 9) (934 = 9) (935 = 9) (900 = 9) (902 = 9) /// /* Other North American origins */
							   (994 = 9) /// /* Other North American origins */
							   (300 = 10) (301 = 10) (303 = 10) (271 = 10) (275 = 10) (329 = 10) /// /* Caribbean origins */
							   (336 = 10) (308 = 10) (261 = 10) (331 = 10) (314 = 10) (335 = 10) (337 = 10) /// /* Caribbean origins */
							   (914 = 11) (231 = 11) (302 = 11) (232 = 11) (360 = 11) (233 = 11) /// /* Latin, Central and South American origins */
							   (234 = 11) (221 = 11) (235 = 11) (222 = 11) (370 = 11) /// /* Latin, Central and South American origins */
							   (290 = 11) (223 = 11) (210 = 11) (224 = 11) (225 = 11) /// /* Latin, Central and South American origins */
							   (236 = 11) (237 = 11) (226 = 11) (238 = 11) (239 = 11) (227 = 11) /// /* Latin, Central and South American origins */
							   (500 = 12) (502 = 12) (508 = 12) (513 = 12) (515 = 12) (525 = 12) /// /* Central and West Africian origins */
							   (527 = 12) (529 = 12) (530 = 12) (532 = 12) (541 = 12) (546 = 12) /// /* Central and West Africian origins */
							   (553 = 12) (564 = 12) (566 = 12) (586 = 12) (510 = 12) /// /* Central and West Africian origins */
							   (400 = 13) (402 = 13) (404 = 13) (406 = 13) /// /* North African origins */
							   (576 = 13) (411 = 13) /// /* North African origins */
							   (522 = 14) (523 = 14) (534 = 14) (561 = 14) (568 = 14) (570 = 14) /// /* Southern and East African origins */
							   (582 = 14) (588 = 14) (593 = 14)  /// /* Southern and East African origins */
							   (599 = 15) /// /* Other African origins */
							   (600 = 16) (495 = 16) (431 = 16) (482 = 16) (120 = 16) (416 = 16) (417 = 16) /// /* West Central Asian and Middle Eastern origins */
							   (419 = 16) (421 = 16) (442 = 16) (423 = 16) (425 = 16) (465 = 16) /// /* West Central Asian and Middle Eastern origins */
							   (427 = 16) (429 = 16) (434 = 16) (169 = 16) (435 = 16) (490 = 16) /// /* West Central Asian and Middle Eastern origins */
							   (603 = 17) (615 = 17) (609 = 17) (680 = 17) (650 = 17) (690 = 17) (656 = 17)  /// /* South Asian origins */
							   (700 = 18) (703 = 18) (706 = 18) (720 = 18) (768 = 18) (730 = 18) /// /* East and Southeast Asian origins */
							   (740 = 18) (750 = 18) (765 = 18) (770 = 18) (782 = 18) (776 = 18) (785 = 18) (607 = 18) /// /* East and Southeast Asian origins */
							   (796 = 19) /// /* Other Asian origins */
							   (800 = 20) (803 = 20)  /// /* Oceania */
							   (841 = 21) (811 = 21) (808 = 21) (814 = 21) (850 = 21) /// /* Pacific Islands origins */
							   (995 = 22)  /// /* Other and Unknown origins */
							   (900 = 23) /* Afro-American */

			* label drop ancestry_subreg
			lab def ancestry_subreg  0 "Euro-Americans" 1 "British Isles origins" 2 "French origins" 3 "Western European origins" 4 "Northern European origins" ///
									 5 "Eastern European origins" 6 "Southern European origins" 7 "Other European origins" ///
									 8 "North American Aborginal origins" 9 "Other North American origins" 10 "Caribbean origins" ////
									 11 "Latin, Central and South American origins" 12 "Central and West Africian origins " 13 "North African origins" ///
									 14 "Southern and East African origins" 15 "Other African origins" /// 
									 16 "West Central Asian and Middle Eastern origins" 17 "South Asian origin" ///
									 18 "East and Southeast Asian origins" 19 "Other Asian origins" 20 "Oceania" 21 "Pacific Islander origins" ///
									 22 "Other and Unknown" 23 "Afro-American"
								 
			lab val ancestry_subreg ancestry_subreg
			lab var ancestry_subreg "ancestry sub-regions"
		
		
		* ancestry_reg
		* --------------------------
		gen ancestry_reg =  ancestry_subreg
		
				br  ancestry ancestry_subreg ancestry_reg 
				

		recode ancestry_reg (0/7 = 1) ///  /* European */
							(8/11 = 2) ///  /* American */
							(12/15 = 3) ///  /* African */
							(16/19 = 4) ///  /* Asian */
							(20/21 = 5) /// /* Oceania */
							(22 = 6) /// /* Other and Unknown */
							(23 = 3) /* recode Afro-American as African */
		
			lab def ancestry_reg 1 "European" 2 "American" 3 "African" 4 "Asian" 5 "Oceania"  6 "Other and Unknown"
			lab val ancestry_reg ancestry_reg
			lab var ancestry_reg "ancestry regions"
		
			*checks 
			fre ancestry ancestry_subreg ancestry_reg
		
		
	*****
	* language : create regions and sub-regions variables  
	*****	
		
		* language_subfam
		* --------------------------
		gen language_subfam = language 
	
		recode language_subfam  (1/8 = 1) ///  /* Germanic */
								(10/14 = 2) /// /* Italic */
								(15 = 3) ///  /* Celtic */
								(16 = 4) ///  /* Hellenic */
								(17 = 5) ///  /* Albanian */
								(18/26 = 6) ///  /* Balto-Slavic */
								(28 = 7) ///  /* Armenian */
								(29/33 = 8) ///  /* Indo-Iranian */
								(34 = 9) ///  /* Uralic */
								(36 = 10) ///  /* Southern Turkic */
								(37 = 11) ///  /* Northern Turkic */
								(40 = 12) ///  /* Dravidian */
								(43 = 13) ///  /* Chinese */
								(44/47 = 14) ///  /* Tibeto-Burman */
								(48 = 15) ///  /* Japonic */
								(49 = 16) ///  /* Koreanic */
								(50/51 = 17) ///  /* Mon-Khmer */
								(52/56 = 18) ///  /* Malayo-Polynesian */
								(57/60 = 19) ///  /* Semtic */
								(61/62 = 20) ///  /* Other Afro-Asiatic */
								(63/64 = 21) ///  /* Saharan */
								(71 = 22) ///  /* Eskimo-Aleut */
								(72 = 23) ///  /* Algonquian */
								(74 = 24) ///  /* Athapascan */
								(94 = 25) ///  /* Other Native */
								(75 = 26) ///  /* Athabaskan */
								(81 = 27) ///  /* Siouan */
								(82 = 28) ///  /* Muskogean */
								(83 = 29) ///  /* Keresan */
								(84 = 30) ///  /* Iroquoian */
								(89 = 31) ///  /* Uto-Aztecan */
								(96 = 32)      /* Other-Not Reported */
			
			
			lab def language_subfam 1 "Germanic" 2 "Italic" 3 "Celtic" 4 "Hellenic" 5 "Albanian" 6 "Balto-Slavic" 7 "Armenian" ///
									8 "Indo-Iranian" 9 "Uralic" 10 "Southern Turkic" 11 "Northern Turkic" 12 "Dravidian" 13 "Chinese" ///
									14 "Tibeto-Burman" 15 "Japonic" 16 "Koreanic" 17 "Mon-Khmer" 18 "Malayo-Polynesian" 19 "Semtic" ///
									20 "Other Afro-Asiatic" 21 "Saharan" 22 "Eskimo-Aleut" 23 "Algonquian" 24 "Athapascan" 25 "Other Native" ///
									26 "Athabaskan" 27 "Siouan"	28 "Muskogean" 29 "Keresan"	 30 "Iroquoian" 31 "Uto-Aztecan" 32 "Other-Not Reported"
		
			lab val language_subfam language_subfam
			lab var language_subfam "language sub-family"
		

	
		* language_fam
		* --------------------------
		clonevar language_fam = language 
		
			* check 
			br language language_fam 
				
		recode language_fam (1/33 = 1) /// /* Indo-European */ 
							(34 = 2) /// /* Uralic */ 
							(36/37 = 3) /// /* Turkic */ 
							(40 = 4) /// /* Dravidian */ 
							(43/47 = 5) /// /* Sino-Tibetan */ 
							(48 = 6) /// /* Japonic */ 
							(49 = 7) /// /* Koreanic */ 
							(50/51 = 8) /// /* Austro-Asiatic */ 
							(52/56 = 9) /// /* Austronesian */ 
							(57/62 = 10) /// /* Afroasiatic */ 
							(63/64 = 11) /// /* Nilo-Saharan */ 
							(71 = 12) /// /* Eskimo-Aleut */ 
							(72 = 13) /// /* Algic */ 
							(74 = 14) /// /* Other Native American */ 
							(94 = 14) /// /* Other Native American */ 
							(75 = 15) /// /* Eyak-Athabaskan  */ 
							(81 = 16) /// /* Siouan-Catawaban  */ 
							(82 = 17) /// /* Muskogean  */ 
							(83 = 18) /// /* Keresan  */ 
							(84 = 19) /// /* Iroquoian  */ 
							(89 = 20) /// /* Uto-Aztecan */ 
							(96 = 21) /* Other-Not Reported */ 
							
							
			lab def language_fam 1 "Indo-European " 2 "Uralic" 3 "Turkic" 4 "Dravidian" 5 "Sino-Tibetan" 6 "Japonic"  7 "Koreanic" 8 "Austro-Asiatic" ///
								 9 "Austronesian" 10 "Afroasiatic" 11 "Nilo-Saharan" 12 "Eskimo-Aleut" 13 "Algic" 14 "Other Native American" ///
								 15 "Eyak-Athabaskan" 16 "Siouan-Catawaban" 17 "Muskogean" 18 "Keresan" 19 "Iroquoian" 20 "Uto-Aztecan" ///
								 21 "Other-Not Reported" 
			
			lab val language_fam language_fam
			lab var language_fam "language family"
		
		
		* checks 
		fre language language_subfam language_fam
		
	
	

* create group totals
* ====================================		
	
	* create group totals and format variables 
	* ----------------------------------
	foreach v of varlist ancestry-language_fam {
					
		bysort `v' : egen `v'_tot = sum(count)
			
		format `v'_tot %15.0g
		recast float `v'_tot
					
	}

		* population checks : all numbers check out : 19,333,311 
		fre ancestry_reg_tot
		
		fre ancestry_subreg_tot
	
		fre language_fam_tot
		
		fre language_subfam_tot
		
	
			
		
* export to excel 		
* ====================================	

	* set local for varorder and run loop to order vars in correct order for export 
	* -----------------------------------
	local varorder = "ancestry ancestry_subreg ancestry_reg language language_subfam language_fam count ancestry_tot ancestry_subreg_tot ancestry_reg_tot language_subfam_tot language_fam_tot"
	
	// local varorder = "ancestry ancestry_tot ancestry_subreg ancestry_subreg_tot ancestry_reg ancestry_reg_tot language language_subfam language_subfam_tot language_fam  language_fam_tot count"

			foreach var in local `varorder' {
									
				order `varorder', last
			
			}
				
	
				
	* export data to excel
	* -----------------------------------
	sort ancestry 
	
	export excel using "$tabledir/2020.08.19 Sankey Diagram.xlsx", sheet("2018", modify) firstrow(variables) keepcellfmt cell(A1)
	
		clear all 
		
	
			
			
			
		
