# Superdiveristy Project: Phase 2: Choropleth Map
# =======================================================

# File: 2020.09.22 Tidycensus data pull.R
# uthor: Kasey Zapatka 
# Purpose: Download, clean, and prepare data for Choropleth Maps for Phase 2 of Superdiversity Project
# Data: 
#   - connect to Census API using tidycensus R package
#   - see Data preparation notes.txt for more on each of the variables

# Date Last Updated: 2020.09.22 


# Prepare environment for data pull
# =======================================================

  # remove all objects in R and clear R
  remove(list=ls())

    # Load necessary packages
    # ------------------------
    my.packages <- c("tidyverse", "tidycensus", "tmap", "tigris", "sf")

        # apply necessary packages    
        lapply(my.packages, library, character.only = TRUE)

        # remove package object
        rm(my.packages)

    # install census api key
    # ----------------------- 
    census_api_key("a5cc7c61e79d106e95acfc8907ccde3264f9deae")


    # load table names table names, 2014-2018 5-Year ACS Estimates 
    # ---------------------------------------------------------------
    names18 <- load_variables(2018, "acs5", cache = TRUE) 
    
        View(names18) # view names object to chose variables

                                          
# TidyCensus Census API: 2014-2018 5-year Estimates
# =============================================================

    # specify counties 
    # -----------------------
        
        # new jersey counties 
        nj_counties <- c("003", "013", "017", "019", "023", "025", "027", "029", "031", "035", "037", "039")
        
        # new york counties 
        ny_counties <- c("005", "027", "047", "059", "061", "071", "081", "085", "087", "103")
        
    # select my variables
    # -----------------------
    my_vars <- c(pop = "B01003_001",
                racetot = "B03002_001", nhtot = "B03002_002", nhwht = "B03002_003", nhblk = "B03002_004", 
                nhnat = "B03002_005", nhasian = "B03002_006", nhpac = "B03002_007", nhother = "B03002_008",
                nhtwo = "B03002_009", 
                hisp = "B03002_012", hisptot = "B03001_003", mexican = "B03001_004", puertorican = "B03001_005", 
                dominican = "B03001_007", colombian = "B03001_020", ecuadorian = "B03001_020", 
                
                nhasiantot = "B02015_001", chinese = "B02015_007", indian ="B02015_002", 
                filipino = "B02015_008", bangladeshi = "B02015_003", korean = "B02015_012",
                
                edu_tot = "B15003_001", noedu = "B15003_002", lesshs1 = "B15003_003", 
                lesshs2 = "B15003_004", lesshs3 = "B15003_005",lesshs4 = "B15003_006", lesshs5 = "B15003_007",
                lesshs6 ="B15003_008", lesshs7 = "B15003_009", lesshs8 ="B15003_010", lesshs9 = "B15003_011", 
                lesshs10 = "B15003_012", lesshs11 = "B15003_013", lesshs12 ="B15003_014", lesshs13 = "B15003_015", 
                lesshs14 = "B15003_016", 
                
                hs = "B15003_017", ged ="B15003_018", somecol1 ="B15003_019", somecol2 = "B15003_020",
                somecol3 = "B15003_021", ba = "B15003_022", ma = "B15003_023", profdegree = "B15003_024",
                phd = "B15003_025",
                
                inc_tot = "B19001_001", inc1 = "B19001_002", inc2 = "B19001_003", inc3 = "B19001_004", 
                inc4 = "B19001_005", inc5 = "B19001_006", inc6 = "B19001_007", inc7 = "B19001_008", 
                inc8 = "B19001_009", inc9 = "B19001_010", inc10 = "B19001_011", inc11 = "B19001_012",
                inc12 = "B19001_013", inc13 = "B19001_014", inc14 = "B19001_015", inc15 = "B19001_016",
                inc16 = "B19001_017",
                inc_25_44_tot = "B19037_019", inc_22_44_1 = "B19037_020", inc_22_44_2 = "B19001_003",
                inc_22_44_3 = "B19001_004", inc_22_44_4 = "B19001_005", inc_22_44_5 = "B19001_006",
                inc_22_44_6 = "B19001_007", inc_22_44_7 = "B19001_008", inc_22_44_8 = "B19001_009", 
                inc_22_44_9 = "B19001_010", inc_22_44_10 = "B19001_011", inc_22_44_11 = "B19001_012", 
                inc_22_44_12 = "B19001_013", inc_22_44_13 = "B19001_014", inc_22_44_14 = "B19001_015", 
                inc_22_44_15 = "B19001_016", inc_22_44_16 = "B19001_017",
                inc_25_44_tot = "B19037_019", inc_45_65_1 = "B19037_020", inc_45_65_2 = "B19001_003",
                inc_45_65_3 = "B19001_004", inc_45_65_4 = "B19001_005", inc_45_65_5 = "B19001_006",
                inc_45_65_6 = "B19001_007", inc_45_65_7 = "B19001_008", inc_45_65_8 = "B19001_009", 
                inc_45_65_9 = "B19001_010", inc_45_65_10 = "B19001_011", inc_45_65_11 = "B19001_012", 
                inc_45_65_12 = "B19001_013", inc_45_65_13 = "B19001_014", inc_45_65_14 = "B19001_015", 
                inc_45_65_15 = "B19001_016", inc_45_65_16 = "B19001_017",
                
                imm_tot = "B05005_001", imm2010 = "B05005_002", imm2010_n = "B05005_003", 
                imm2010_fb = "B05005_004", imm2000 = "B05005_007", imm2000_n = "B05005_008",
                imm2000_fb = "B05005_009", imm1990 = "B05005_012", imm1990_n = "B05005_013",
                imm1990_fb = "B05005_014", immbefore1990 = "B05005_017", immbefore1990_n= "B05005_018",
                immbefore1990_fb = "B05005_019",
                
                citizen_tot = "B05001_001", citizen_US = "B05001_002", citizen_PR = "B05001_003",
                citizen_abroad = "B05001_004", citizen_nat = "B05001_005", not_citizen = "B05001_006",
                
                moveintot = "B07001_001", stayed = "B07001_017", 
                moveincounty = "B07001_033", moveinstate = "B07001_049", 
                moveindiffstate = "B07001_065", moveinabroad = "B07001_081",
                
                ancestry_tot = "B04006_001", ancestry2 = "B04006_002", ancestry3 = "B04006_003",	
                ancestry4 = "B04006_004",	ancestry5 = "B04006_005",	ancestry6 = "B04006_006",	
                ancestry7 = "B04006_007",	ancestry8 = "B04006_008",	ancestry9 = "B04006_009",	
                ancestry10 = "B04006_010", ancestry11 = "B04006_011", ancestry12 = "B04006_012", 
                ancestry13 = "B04006_013", ancestry14 = "B04006_014", ancestry15 = "B04006_015", 
                ancestry16 = "B04006_016", ancestry17 = "B04006_017", ancestry18 = "B04006_018", 
                ancestry19 = "B04006_019", ancestry20 = "B04006_020", ancestry21 = "B04006_021", 
                ancestry22 = "B04006_022", ancestry23 = "B04006_023", ancestry24 = "B04006_024", 
                ancestry25 = "B04006_025", ancestry26 = "B04006_026", ancestry27 = "B04006_027", 
                ancestry28 = "B04006_028", ancestry29 = "B04006_029", ancestry30 = "B04006_030", 
                ancestry31 = "B04006_031", ancestry32 = "B04006_032", ancestry33 = "B04006_033", 
                ancestry34 = "B04006_034", ancestry35 = "B04006_035", ancestry36 = "B04006_036", 
                ancestry37 = "B04006_037", ancestry38 = "B04006_038", ancestry39 = "B04006_039", 
                ancestry40 = "B04006_040", ancestry41 = "B04006_041", ancestry42 = "B04006_042", 
                ancestry43 = "B04006_043", ancestry44 = "B04006_044", ancestry45 = "B04006_045", 
                ancestry46 = "B04006_046", ancestry47 = "B04006_047", ancestry48 = "B04006_048", 
                ancestry49 = "B04006_049", ancestry50 = "B04006_050", ancestry51 = "B04006_051", 
                ancestry52 = "B04006_052", ancestry53 = "B04006_053", ancestry54 = "B04006_054", 
                ancestry55 = "B04006_055", ancestry56 = "B04006_056", ancestry57 = "B04006_057", 
                ancestry58 = "B04006_058", ancestry59 = "B04006_059", ancestry60 = "B04006_060", 
                ancestry61 = "B04006_061", ancestry62 = "B04006_062", ancestry63 = "B04006_063", 
                ancestry64 = "B04006_064", ancestry65 = "B04006_065", ancestry66 = "B04006_066", 
                ancestry67 = "B04006_067", ancestry68 = "B04006_068", ancestry69 = "B04006_069", 
                ancestry70 = "B04006_070", ancestry71 = "B04006_071", ancestry72 = "B04006_072", 
                ancestry73 = "B04006_073", ancestry74 = "B04006_074", ancestry75 = "B04006_075", 
                ancestry76 = "B04006_076", ancestry77 = "B04006_077", ancestry78 = "B04006_078", 
                ancestry79 = "B04006_079", ancestry80 = "B04006_080", ancestry81 = "B04006_081", 
                ancestry82 = "B04006_082", ancestry83 = "B04006_083", ancestry84 = "B04006_084", 
                ancestry85 = "B04006_085", ancestry86 = "B04006_086", ancestry87 = "B04006_087", 
                ancestry88 = "B04006_088", ancestry89 = "B04006_089", ancestry90 = "B04006_090", 
                ancestry91 = "B04006_091", ancestry92 = "B04006_092", ancestry93 = "B04006_093", 
                ancestry94 = "B04006_094", ancestry95 = "B04006_095", ancestry96 = "B04006_096", 
                ancestry97 = "B04006_097", ancestry98 = "B04006_098", ancestry99 = "B04006_099", 
                ancestry100 = "B04006_100", ancestry101 = "B04006_101", ancestry102 = "B04006_102", 
                ancestry103 = "B04006_103", ancestry104 = "B04006_104", ancestry105 = "B04006_105", 
                ancestry106 = "B04006_106", ancestry107 = "B04006_107", ancestry108 = "B04006_108", 
                ancestry109 = "B04006_109")
    
    # new jersey call 
    # ----------------------
     nj <- get_acs(state = "NJ", county = nj_counties, geography = "tract",  year = 2018,  # specify geographies and year
                   variables = my_vars,
                   geometry = TRUE, # specify that we want geometry (shapefiles)
                   output = "wide") # specify that we want the output to be wide
        
    glimpse(nj)
        
    # new york call 
    # ----------------------
    ny <- get_acs(state = "NY", county = ny_counties, geography = "tract",  year = 2018,  # specify geographies and year 
                  variables = my_vars,
                  geometry = TRUE, # specify that we want geometry (shapefiles)
                  output = "wide") # specify that we want the output to be wide
        
    glimpse(ny)
    
    
    # rbind nj and ny calls together into one dataset
    # -----------------------
    nj.ny.metro <- rbind(nj,ny)
  
    # map the counties to make sure it's what we want
    # ------------------------------------------
    map.nj.ny.metro  <- tm_shape(nj.ny.metro) +
      tm_polygons("popE") + 
      tm_view()
    
    
    
    # view map 
    map.nj.ny.metro
    
        # remove nj and ny data pulls
        rm(nj)
        rm(ny)
        rm(names18)
        rm(map.nj.ny.metro)
      


# prepare choropleth data to clean in Stata
# =======================================================

  # remove geometry from choropleth data
  # -----------------------
  choropleth <- nj.ny.metro %>%
                st_drop_geometry()

        # check class
        class(choropleth)
        glimpse(choropleth)
        
        
  # write choropleth to csv
  # -----------------------
  write_csv(choropleth, "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data/Raw/ACS/Choropleth Maps.csv")
        

        
        
        
        
        
        
        
    
      LEFT OFF HERE
      
      - need to figure out how to make into a shapefile
      - need to clean data in Stata so that we have the variables we want

# prepare and write shapefile
# =======================================================
   
      # 
      print(nj.ny.metro)
      glimpse(nj.ny.metro)
      head(nj.ny.metro)
      
         
st_write(nj.ny.metro, "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data/Phase 2/6_Shapefiles/Shapefile/shapefile.shp", delete_layer = TRUE)

      
      glimpse(shapefile)
      
      class(shapefile)
    
    
    
    
    
    
    
    
        
# call made to Census API for variables. 
ACS.2018 <- get_acs(state = my_states, geography = "tract", year = 2018,  # specify state, geography, and year
                    variables = my_vars,
                    geometry = TRUE, # specify that we want geometry (shapefiles)
                    output = "wide") # specify that we want the output to be wide

glimpse(ACS.2018)

  class(ACS.2018)
  
  
  tm()



  























##########                                 ##########  
# calculate new margins of error for summed variables
##########                                 ##########  

# variables to test summation with 
#   - profmgmt variables
#   - age variables 
#   - college variables 
#   - blt variables 
#   - move-in variables

# sum appropriate variables and bring margins of error with them 
ACS.2016.vars.sums <- ACS.2016.vars %>%
  group_by(GEOID) %>%
  # sum male and female profmgmt and calculate appropriate margin of erorr using moe_sum
  summarize(profmgmtE = sum(m_profmgmtE,f_profmgmtE), 
            profmgmtM = moe_sum(m_profmgmtM,f_profmgmtM, profmgmtE),
            
            # sum male and female ag18to19 and calculate appropriate margin of erorr using moe_sum
            ag18to19E = sum(m_ag18to19E, f_ag18to19E), 
            ag18to19M = moe_sum(m_ag18to19M, f_ag18to19M, ag18to19E),
            
            # sum male and female ag20 and calculate appropriate margin of erorr using moe_sum
            ag20E = sum(m_ag20E, f_ag20E), 
            ag20M = moe_sum(m_ag20M, f_ag20M, ag20E),   
            
            # sum male and female ag21 and calculate appropriate margin of erorr using moe_sum
            ag21E = sum(m_ag21E, f_ag21E), 
            ag21M = moe_sum(m_ag21M, f_ag21M, ag21E),     
            
            # sum male and female ag22to24 and calculate appropriate margin of erorr using moe_sum
            ag22to24E = sum(m_ag22to24E, f_ag22to24E), 
            ag22to24M = moe_sum(m_ag22to24M, f_ag22to24M, ag22to24E),    
            
            # sum male and female age25to29 and calculate appropriate margin of erorr using moe_sum
            ag25to29E = sum(m_ag25to29E, f_ag25to29E), 
            ag25to29M = moe_sum(m_ag25to29M, m_ag25to29M, ag25to29E),  
            
            # sum male and female age30to34 and calculate appropriate margin of erorr using moe_sum
            ag30to34E = sum(m_ag30to34E, f_ag30to34E), 
            ag30to34M = moe_sum(m_ag30to34M, f_ag30to34M, ag30to34E),
            
            # sum male and female age25to34 and calculate appropriate margin of erorr using moe_sum  
            ag18to20E = sum(ag18to19E, ag20E), 
            ag18to20M = moe_sum(ag18to19M, ag20M, ag18to20E),
            
            # sum male and female age25to34 and calculate appropriate margin of erorr using moe_sum  
            ag18to21E = sum(ag18to20E, ag21E), 
            ag18to21M = moe_sum(ag18to20M, ag21M, ag18to21E),
            
            # sum male and female age25to34 and calculate appropriate margin of erorr using moe_sum  
            ag18to24E = sum(ag18to21E, ag22to24E), 
            ag18to24M = moe_sum(ag18to21M, ag22to24M, ag18to24E),
            
            # sum male and female age25to34 and calculate appropriate margin of erorr using moe_sum  
            ag18to29E = sum(ag18to24E, ag25to29E), 
            ag18to29M = moe_sum(ag18to24M, ag25to29M, ag18to29E),
            
            # sum male and female age25to34 and calculate appropriate margin of erorr using moe_sum  
            ag18to34E = sum(ag18to29E, ag30to34E), 
            ag18to34M = moe_sum(ag18to29M, ag30to34M, ag18to34E),
            
            # sum male and female col variable ands calculate appropriate margin of erorr using moe_sum  
            colE = sum(m_colE, f_colE), 
            colM = moe_sum(m_colM, f_colM, colE),
            
            # sum male and female ma variable ands calculate appropriate margin of erorr using moe_sum  
            maE = sum(m_maE, f_maE), 
            maM = moe_sum(m_maM, f_maM, maE),
            
            # sum male and female ma variable ands calculate appropriate margin of erorr using moe_sum  
            pdE = sum(m_pdE, f_pdE), 
            pdM = moe_sum(m_pdM, f_pdM, pdE),
            
            # sum male and female ma variable ands calculate appropriate margin of erorr using moe_sum  
            phdE = sum(m_phdE, f_phdE), 
            phdM = moe_sum(m_phdM, f_phdM, phdE),
            
            # sum ma and pd and calculate appropriate margin of erorr using moe_sum  
            mapdE = sum(maE, pdE), 
            mapdM = moe_sum(maM, pdM, mapdE),
            
            # sum mapd and phd and calculate appropriate margin of erorr using moe_sum  
            pgradE = sum(mapdE, phdE), 
            pgradM = moe_sum(mapdM, phdM, pgradE),
            
            # sum col and pgrad and calculate appropriate margin of erorr using moe_sum  
            baE = sum(colE, pgradE), 
            baM = moe_sum(colM, pgradM, baE),
            
            # sum blt2010 and blt2000to2009 and calculate appropriate margin of erorr using moe_sum  
            blt2010E = sum(blt2014orlaterE, blt2010to2013E), 
            blt2010M = moe_sum(blt2014orlaterM, blt2010to2013M, blt2010E),
            
            # sum blt2010 and blt2000to2009 and calculate appropriate margin of erorr using moe_sum  
            blt2000E = sum(blt2010E, blt2000to2009E), 
            blt2000M = moe_sum(blt2010M, blt2000to2009M, blt2000E),
            
            # sum blt2000 and blt1990to1999 and calculate appropriate margin of erorr using moe_sum  
            blt1990E = sum(blt2000E, blt1990to1999E), 
            blt1990M = moe_sum(blt2000M, blt1990to1999M, blt1990E),
            
            # sum blt1990 and blt1980to1989 and calculate appropriate margin of erorr using moe_sum  
            blt1980E = sum(blt1990E, blt1980to1989E), 
            blt1980M = moe_sum(blt1990M, blt1980to1989M, blt1980E),
            
            # sum moveincounty and moveinstate and calculate appropriate margin of erorr using moe_sum  
            movesum1E = sum(moveincountyE, moveinstateE), 
            movesum1M = moe_sum(moveincountyM, moveinstateM, movesum1E),
            
            # sum movesum1 and moveindiffstate and calculate appropriate margin of erorr using moe_sum  
            movesum2E = sum(movesum1E, moveindiffstateE), 
            movesum2M = moe_sum(movesum1M, moveindiffstateM, movesum2E),
            
            # sum movesum2 and moveinabroad and calculate appropriate margin of erorr using moe_sum  
            movedinE = sum(movesum2E, moveinabroadE), 
            movedinM = moe_sum(movesum2M, moveinabroadM, movedinE))

# compare checks
arrange(ACS.2016.vars, GEOID) %>% 
  glimpse()

arrange(ACS.2016.vars.sums, GEOID) %>% 
  glimpse()


# create age.sums to check final age summation
ACS.2016.vars.sums.check <- ACS.2016.vars %>% 
  group_by(GEOID)   %>%
  summarize(agesum = sum(m_ag18to19E, m_ag20E, m_ag21E, m_ag22to24E, m_ag25to29E, m_ag30to34E, 
                         f_ag18to19E, f_ag20E, f_ag21E, f_ag22to24E, f_ag25to29E, f_ag30to34E),
            
            blt1980sum = sum(blt2014orlaterE, blt2010to2013E, blt2000to2009E, blt1990to1999E, blt1980to1989E),
            
            moveinsum = sum(moveincountyE, moveinstateE, moveindiffstateE, moveinabroadE),
            
            pgradsum = sum(m_colE, f_colE, m_maE, f_maE, m_pdE, f_pdE, m_phdE, f_phdE))

arrange(ACS.2016.vars.sums, GEOID) %>%  # compare sums with sum checks
  glimpse()

arrange(ACS.2016.vars.sums.check, GEOID) %>%  # compare sums with sum checks
  glimpse()

names(ACS.2016.vars) # names of variables needed in final dataset

# create a dataset of only the needed variables from the original dataset
ACS.2016.vars.need <- ACS.2016.vars %>% 
  select( c("GEOID", "popE", "popM", "maleE", "maleM", "nhwhtE", "nhwhtM", "empE", "empM", "pop25upE",
            "pop25upM","huE", "huM","occE", "occM", "vacE", "vacM", "stayedE", "stayedM", "moveintotE",
            "moveintotM","mhincE", "mhincM", "geometry")) %>% 
  arrange(GEOID)

arrange(ACS.2016.vars.need, GEOID) %>%  # view in order by GEOID
  glimpse()


glimpse(ACS.2016.vars.need)

# add newly calcuated sum vars to the dataset for only the needed variables for percent calculation dataset
ACS.2016.vars.sums <- bind_cols(ACS.2016.vars.need, ACS.2016.vars.sums) %>% 
  select(-c("GEOID1","geometry1", "movesum1E", "movesum1M", "movesum2E", "movesum2M",
            "ag18to20E", "ag18to20M", "ag18to21E", "ag18to21M", "ag18to24E", "ag18to24M", "ag18to29E", 
            "ag18to29M", "ag18to19E", "ag18to19M", "ag20E", "ag20M", "ag21E", "ag21M", "ag22to24E",
            "ag22to24M", "ag25to29E", "ag25to29M", "ag30to34E", "ag30to34M", 
            "mapdE", "mapdM"))

arrange(ACS.2016.vars.sums, GEOID) %>%  # view in order by GEOID
  glimpse()

##########                                 ##########  
# calculate new margins of error for percent variables
##########                                 ########## 

# calculate final percent variables
ACS.2016.vars.percents <- ACS.2016.vars.sums %>%
  group_by(GEOID) %>%
  # calculate appropriate margin of erorr using moe_prop for proportions
  mutate(pmaleE = ((maleE/popE)*100), 
         pmaleM = (moe_prop(maleE, popE, maleM, popM)*100), 
         
         # calculate percent ag18to34E and appropriate margin of erorr using moe_prop
         pag18to34E = ((ag18to34E/popE)*100), 
         pag18to34M = (moe_prop(ag18to34E, popE, ag18to34M, popM)*100),
         
         # calculate percent nhwht and appropriate margin of erorr using moe_prop
         pnhwhtE = ((nhwhtE/popE)*100), 
         pnhwhtM = (moe_prop(nhwhtE, popE, nhwhtM, popM)*100),
         
         # calculate percent profmgmt and appropriate margin of erorr using moe_prop
         pprofmgmtE = ((profmgmtE/empE)*100), 
         pprofmgmtM = (moe_prop(profmgmtE, empE, profmgmtM, empM)*100), 
         
         # calculate the vacancy rate and appropriate margin of erorr using moe_prop
         vacrE = ((vacE/huE)*100), 
         vacrM = (moe_prop(vacE, huE, vacM, huM)*100), 
         
         # calculate percent ba and up and appropriate margin of erorr using moe_prop
         pbaE = ((baE/pop25upE)*100), 
         pbaM = (moe_prop(baE, pop25upE, baM, pop25upM)*100),
         
         # calculate percent moved in and appropriate margin of erorr using moe_prop
         pmovedinE = ((movedinE/moveintotE)*100), 
         pmovedinM = (moe_prop(movedinE, moveintotE, movedinM, moveintotM)*100),
         
         # calculate percent moved in and appropriate margin of erorr using moe_prop
         pblt1990E = ((blt1990E/occE)*100), 
         pblt1990M = (moe_prop(blt1990E, occE, blt1990M, occM)*100)) %>% 
  
  arrange(GEOID)

arrange(ACS.2016.vars.percents, GEOID) %>% 
  glimpse()

# preserve geometry in a verions of the final dataset  
ACS.2016.vars.final <- ACS.2016.vars.percents %>% 
  mutate(year = 2016)

arrange(ACS.2016.vars.final, GEOID) %>% 
  glimpse()

# strip geometry from dataframe for conversion to csv to export to Stata
# Stata cannot handle sf objects, must be a dataframe
ACS.2016.vars.final.df <- ACS.2016.vars.final %>% 
  st_set_geometry(NULL)

class(ACS.2016.vars.final.df)
arrange(ACS.2016.vars.final.df, GEOID) %>% 
  glimpse()


# write data as a csv
write_csv(ACS.2016.vars.final.df, path = "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Granger Gentrification/Urban Studies/2019.08.13 Response Memo/Data/2020.01.17 Tidy Census MOE pull/ACS.2016.vars.csv")














