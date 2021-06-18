/* Superdiveristy Project: Phase 1: Sankey Diagram 
 * =======================================================
  
 * File: 2020.08.15 Sankey Diagram Data Preparation.do
 * Author: Kasey Zapatka 
 * Purpose: Download, clean, and prepare data for Sankey Diagram for Phase 1 of Superdiveristy Project
 * Data: 
	- Downloaded from IPUMS at: https://usa.ipums.org/usa-action/data_requests/download
	- see Data preparation notes.txt for more on each of the variables
	
 * Date Last Updated: 2020.08.15 */ 
 

* set global filepaths
global db "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data"
global rawdir "${db}/Raw/IPUMS"
global savedir "${db}/Phase 1/2_Sankey Diagram/Recoded"
global tabledir "${db}/Phase 1/2_Sankey Diagram/Tables"


* load NLSY data 
* ================
use "$rawdir/usa_00038.dta", clear
  
  * drop unnecessary variables
  drop cbserial
  
  
  * include households in institutional settings  - this has been approved by Van and Dan
	fre gq
  
 
* preliminary data cleaning
* ============================
		
	*****	
	* keep only data in metro area
	*****
	keep if met2013 == 35620
	drop if metro == 4 /* drop cases where metro area status is undeterminable */ 

		tab year met2013
		
		
		* check to make sure population looks correct 
		bysort year: tab  met2013 [fw = perwt]
	
	*****
	* create  unique id  for 
	*****
	tostring sample, gen(samplestr) format("%06.0f")
	tostring serial, gen(serialstr) format("%07.0f")
	
		* creat household id
		gen hhid = samplestr + serialstr
		
		* checking that hhid == numperc : if diff == 0, then they are the same
		* --------------------------------------------------------------------
		bysort hhid: gen hhsize = _N
		
		gen diff  = numprec - hhsize
		
			br hhid  diff numprec hhsize
			
		

	
						/* for coding purposes only - delete after cleaned coding 
						* ====================================
						 
							*****	
							* first ancestry
							*****
							* frequency by group
							bysort ancestr1: gen freq = 1
							  
								collapse  (count) freq , by (ancestr1)
								
							
							
								
							*****	
							* language
							*****
							* frequency by group
							bysort language: gen freq = 1
							  
								collapse  (count) freq , by (language) */
								
								
						
	
	
* create clean ancestry and langauge variables 
* ====================================

*****	
* first ancestry
*****
fre ancestr1

	/* sort hhid
	br hhid ancestr1*/ 
							
		
		* clone variable for recoding 
		* IPUMS codebook: https://usa.ipums.org/usa-action/variables/ANCESTR1#description_section
		clonevar ancestry = ancestr1 
		recode ancestry (12 = 11) /// /* 12 british isles to 11 british */
						(51/73 = 51) /// /* 51 -73 to 51 italian */
						(122 = 190) /// /* 124 Germans from Russia to 190 Eastern European origins */
						(124 = 190) /// /* 124 Rom to 190 Eastern European origins */
						(181 = 195) /// /* 181 Central European, nec 195 Other European Origins, n.i.e. */
						(210/219 = 210) /// /* 210-219 to 210 mexican */
						(248 = 227) /// /* 210-219 to 210 mexican */
						(291 = 200) /// /* 291 spanish as 200 spaniard */
						(310 = 337) /// /* 310 Dutch West Indian to 337 Other West Indian */
						(315 = 314) /// /* 315 Trindiadian to 314 Trinidadian/Tobagonian */
						(321 = 337) /// /* 321 British Virgin Islander to 337 Other West Indian */
						(322 = 337) /// /* 322 British West Indian to 337 Other West Indian */
						(324 = 337) /// /* 324 Anguilla Islander to 337 Other West Indian */
						(496 = 495) /// /* 496 other arab to 495 arab */
						(523 = 522) /// /* 523 eritrean to 522 ethiopian */
						(584 = 582) /// /* 584 Zanzibar Islander to 582 Tanzanian */
						(595 = 599) /// /* 595 Other Subsaharan African to 599 African */
						(596 = 599) /// /* 595 Central African to 599 African */
						(597 = 599) /// /* 595 East African to 599 African */
						(598 = 599) /// /* 595 West African to 599 African */
						(706/716 = 706) /// /* 706-716 to 706 chinese */
						(748 = 740) /// /* 748 Okinawan to 740 Japanese */
						(793/795 = 796) /// /* 793 eurasian and 795 asian to 796 other asian */
						(814/819 = 814) /// /* 814-819 to 814 Samonan */
						(820/822 = 850) /// /* 820 Micronesian, 821 Guamanian, 822 Chamorro Islander to 850 pacific islander */
						(850/870 = 850) /// /* 850-870 to 850 pacific islander */
						(900/902 = 900) /// /* recode African-American to Afro-Ameican */
						(913 = 914) /// /* 913 Central American Indian to 914 South American Indian */
						(939/983 = 939) /// /*  939  to 983  to 939 american */
						(995/998 = 995) /// /* 995 Mixture, 996 Uncodable, 998 Other to Other and Unknown */
						(999 = .) /* 999 Not Reported to missing */ 
				
		* make sure to "modify" label changes to current label tag or you will lose all those not specified in creation of new label variable
		lab def ANCESTR1  337 "Caribbean origins, n.i.e" 490 "West Central Asian and Middle Eastern origins, n.i.e."  /// 
						  582 "Tanzanian" 599 "Other African origins, n.i.e." ///
						  607 "East and Southeast Asian origins, n.i.e." 615 "Indian" 914 "Aboriginal from Central/South America (except Maya)" ///
						  924 "Euro-Americans" 994 "Other North American origins, n.i.e." 995 "Other and Unknown", modify
						  
		lab var ancestry "recode of ancestr1 to condense categories"
		
			* check to make sure recoding of labels worked : 924 should be Euro-Americans 
			br ancestry 
		
			distinct ancestry
			
			
			table ancestry [pw = perwt]
			tab ancestry [fw = perwt]
		
	
		* create sub-regions variable 
		gen ancestry_subreg =  ancestry
		
				br ancestr1 ancestry ancestry_subreg 
				
				
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

		*label drop ancestry_subreg
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
		
		
		gen ancestry_reg =  ancestry_subreg
		
				br ancestr1 ancestry ancestry_subreg ancestry_reg 
				

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


* language spoken at home 
* -------------------------

	/* 
	
	IPUMS codebook for language: 
		- https://usa.ipums.org/usa-action/variables/LANGUAGE#codes_section 
	
	
	Ethnologue: Langauge family: 
		- https://www.ethnologue.com/browse/families		*/
	
	
	
*****	
* language
*****
fre language

	/* sort hhid
	br hhid language */
	
	tab age language if language == 0 /* 6% of respondents didn't report or the question was not applicable */
	
	* recode original language variable 
	replace language = . if language == 0 /* replace" NA/Blank" as missing bc too young to speak */
	replace language = . if language == 95 /* replace "No Language" as missing  */

	
	
		* recode language 
		recode language (56 = 55) ///  /* recode to 55 "Micronesian, Polynesian */
						(58 = 57)      /* recode to 57 "Arabic */
					
		
		lab def LANGUAGE  3 "yiddish" 14 "romanian" 60 "amharic, ethiopian" 62 "other afro-asiatic" ///
						  63 "sub-saharan african" 64 "other sub-saharan african" , modify
								
		lab val language LANGUAGE
		lab var language "language spoken"
	
	
		* create sub-family variable 
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
		

	
		* create family variable 
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
		
		
	
		* keep only needed variables
		keep ancestry ancestry_subreg ancestry_reg language language_subfam language_fam perwt
		
		 
		
	******
	* save dataset after all data cleaning has finished
	******
	compress
	
	save "$savedir/2020.08.15 Sankey Diagram Data.dta", replace
	
		clear all
		
		
	
														* ============
														* Data export
														* ============
														
														
	
* working age data creation and export
* ===================================
use "$savedir/2020.08.15 Sankey Diagram Data.dta", clear
		
		keep ancestry language perwt
		
		* sort by ancestry then language 
		sort ancestry language 

	* contract command 	
	contract ancestry language [fw = perwt], zero percent(percentage)
	
	
	* export to excel 		
	export excel using "$tabledir/2020.08.15 Sankey Diagram.xlsx", sheet("calculations", modify) firstrow(variables) keepcellfmt cell(A1)
		
		
		

								
	
* collapse function - may have to run this before I run some of the cleaning 
* -------------------------

* use the contract command because it produces frequency by each of the variables specified in the command 
contract ancestry language, zero percent(percentage)

contract language ancestr1 [fw = perwt], zero percent(percentage)

	language language_subfam language_fam
	
	
	
	
	
	
	
	
	
	/* Notes for write-up
	   ==========================
	
	1. We chose to include individuals who were surveyed in instituitions (1.87%) 
	   and group quarters (1.92%), which consisted of a total of 3.79% of all
	   individuals. 
	   
	2. 
	


