# Superdiveristy Project: Phase 2: Choropleth Map
# =======================================================

# File: 2020.10.09 Tidycensus data pull.R
# uthor: Kasey Zapatka 
# Purpose: Download, clean, and prepare data for Choropleth Maps for Phase 2 of Superdiversity Project
#         and prepare shapefile as deliverable # 6
# Data: 
#   - connect to Census API using tidycensus R package
#   - see Data preparation notes.txt for more on each of the variables

# Date Last Updated: 2020.10.09


# Prepare environment for data pull
# =======================================================

  # remove all objects in R and clear R
  remove(list=ls())

    # Load necessary packages
    # ------------------------
    my.packages <- c("tidyverse", "tidycensus", "tmap", "tigris", "sf", "readxl", "geojsonsf")

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
        
    # select my variables
    # -----------------------
    my_vars <- c(pop = "B01003_001",
                racetot = "B03002_001", nhtot = "B03002_002", nhwht = "B03002_003", nhblk = "B03002_004", 
                nhnat = "B03002_005", nhasian = "B03002_006", nhpac = "B03002_007", nhother = "B03002_008",
                nhtwo = "B03002_009", 
                hisp = "B03002_012", hisptot = "B03001_003", mexican = "B03001_004", puertorican = "B03001_005", 
                dominican = "B03001_007", colombian = "B03001_020", ecuadorian = "B03001_021", 
                
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
    
        
    # call 
    # ----------------------
    ACS.2018 <- get_acs(state = c("NJ", "NY"), geography = "tract",  year = 2018,  # specify geographies and year
                   variables = my_vars,
                   geometry = TRUE, # specify that we want geometry (shapefiles)
                   output = "wide") # specify that we want the output to be wide
        
    glimpse(ACS.2018)


  
    # map the counties to make sure it's what we want
    # ------------------------------------------
    tmap_mode("view")
    
    map.states  <- tm_shape(ACS.2018) +
                        tm_polygons("popE") 
                      
    # view test map 
    map.states
    
        # remove nj and ny data pulls
        rm(names18)
        rm(map.states)
        rm(my_vars)
      


# prepare and export choropleth data to Stata
# =======================================================

  # remove geometry from choropleth data
  # -----------------------
  choropleth <- ACS.2018 %>%
                st_drop_geometry()

        # check class
        class(choropleth)
        glimpse(choropleth)
        
        
  # write choropleth to csv
  # -----------------------
  write_csv(choropleth, "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data/Raw/ACS/2020.10.09 tract data for Choropleth Maps.csv")
        
        # remove uncessary vectors
        rm(choropleth)
        
                                # =======================================================
                                # Prepare data in Stata for Traditional and Superdiversity maps
                                # using 2020.10.09 Choropleth Map Data Preparation.do
                                # =======================================================
        
        
      
# Create metro area shapefile for Stamen
# =======================================================    

  # drop everything but GEOID and geometry for shapefile
  # -----------------------------------------------------
  shapefile <- ACS.2018 %>% 
               rename(tractid = GEOID) %>% 
               select(tractid, geometry)
        
  glimpse(shapefile)

  
  # merge with Traditional and Superdiversity data that has been prepared in Stata
  # -----------------------------------------------------
  
      # merge: read in traditional map data
      traditional <- read_excel("/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data/Phase 2/4_Choropleth Maps/Tables/2020.10.09 Choropleth Map - traditional map.xlsx")
  
    glimpse(traditional)
  
      superdiversity <- read_excel("/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data/Phase 2/4_Choropleth Maps/Tables/2020.10.09 Choropleth Map - superdiversity map.xlsx") 
      
    glimpse(superdiversity)
    
          # merge: traditional map
          shapefile.traditional <- right_join(shapefile, traditional, by = "tractid")

          glimpse(shapefile)
          glimpse(traditional)
          glimpse(shapefile.traditional)
                  
          # merge: superdiversity map
          shapefile.superdiversity <- right_join(shapefile, superdiversity, by = "tractid")
      
          glimpse(shapefile.superdiversity)

            # remove csv files no longer needed
            rm(traditional)
            rm(superdiversity)
    
  
  # visualize shapefile to make sure it looks like metro area
  # -----------------------------------------------------
  map.traditional <- tm_shape(shapefile.traditional) +
                     tm_polygons() 
            
  map.traditional
  
      # save traditional.missing map
      tmap_save(map.traditional, "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data/Phase 2/4_Choropleth Maps/Rmaps/Tradional.html", width = 5, height = 7)
  

  # visualize shapefile to make sure it looks like metro area
  # -----------------------------------------------------
  map.superdiversity  <- tm_shape(shapefile.superdiversity) +
                         tm_polygons() 
    
  map.superdiversity
    
      
      # save superdiversity.missing map
      tmap_save(map.superdiversity, "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data/Phase 2/4_Choropleth Maps/Rmaps/Superdiversity.html", width = 5, height = 7)
      
    rm(map.traditional)
    rm(map.superdiversity)
    rm(shapefile)
    
# prepare and write shapefile for Deliverable
# =======================================================
      
  # drop everything but GEOID and geometry for shapefile delivery to Stamen
  # -----------------------------------------------------
  shapefile <- shapefile.traditional %>% 
               select(tractid, geometry)
  
  glimpse(shapefile) # should have only 2 variables and 4,683 cases
  
  
          # visualize shapefile to make sure it looks like metro area
          # -----------------------------------------------------
          map.shapefile  <- tm_shape(shapefile) +
                            tm_polygons() 
          
          map.shapefile
          
            # remove unnecessary objects
            rm(map.shapefile)
           

      # final checks
      print(shapefile)
      glimpse(shapefile)
      head(shapefile)
      
      # write shapefile for export for Stamen
      # -----------------------------------------------------       
      st_write(shapefile, "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data/Phase 2/6_Shapefiles/Shapefile/shapefile.shp", delete_layer = TRUE)
      
          
          glimpse(shapefile)
          
          class(shapefile)
          
          # remove shapefile
          rm(shapefile)
    
    
      # load shapefile just exported as check
      # -----------------------------------------------------    
      shapefile <-st_read("/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data/Phase 2/6_Shapefiles/Shapefile/shapefile.shp")
      
    

      # convert shapefile to json : not sure if this is necessary
      # -----------------------------------------------------    
      geojson <- sf_geojson(shapefile)
      
      class(geojson)
      str(geojson)
      

      
      # write shapefile to json using SF package : try this first
      # -----------------------------------------------------    
       st_write(shapefile, "/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data/Phase 2/6_Shapefiles/Shapefile/shapefile.geojson", delete_layer = TRUE)
      
      geo <- st_read("/Users/Dora/Library/Mobile Documents/com~apple~CloudDocs/Projects/Superdiversity/Data/Phase 2/6_Shapefiles/Shapefile/shapefile.geojson")
      
      class(geo)

# check out this link
# https://gis.stackexchange.com/questions/372599/in-r-how-to-read-in-geojson-file-modify-then-export-back-as-new-geojson-file


