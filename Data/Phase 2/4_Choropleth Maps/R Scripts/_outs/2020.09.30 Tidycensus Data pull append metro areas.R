



  my_vars <- c(pop = "B01003_001",
             racetot = "B03002_001")

# TidyCensus call
# =======================================================
    # new jersey counties 
    # -----------------------
    nj_counties <- c("003", "013", "017", "019", "023", "025", "027", "029", "031", "035", "037", "039")
  
    
    # new jersey call 
    # -----------------------
    nj <- get_acs(state = "NJ", county = nj_counties, geography = "tract",  year = 2018,  # specify state, geography, and year
                      variables = my_vars,
                      geometry = TRUE, # specify that we want geometry (shapefiles)
                      output = "wide") # specify that we want the output to be wide
  
        glimpse(nj)
  
    # map the counties to make sure it's what we want
    # ------------------------------------------
    test.map.nj  <- tm_shape(nj) +
          tm_polygons("popE") + 
          tm_view()
    
    
    
    test.map.nj

    
    # new jersey counties 
    # -----------------------
    ny_counties <- c("005", "027", "047", "059", "061", "071", "081", "085", "087", "103")
    
    
    # new jersey call 
    # -----------------------
    ny <- get_acs(state = "NY", county = ny_counties, geography = "tract",  year = 2018,  # specify state, geography, and year
                  variables = my_vars,
                  geometry = TRUE, # specify that we want geometry (shapefiles)
                  output = "wide") # specify that we want the output to be wide
    
    glimpse(ny)
    
    # map the counties to make sure it's what we want
    # ------------------------------------------
    test.map.ny  <- tm_shape(ny) +
      tm_polygons("popE") + 
      tm_view()
    
    
    
    test.map.ny

# new york counties 

# Append datasets
# =======================================================
    nj.ny.metro <- rbind(nj,ny)
    
    glimpse(nj.ny.metro)
    
    # map the counties to make sure it's what we want
    # ------------------------------------------
    map.nj.ny.metro  <- tm_shape(nj.ny.metro) +
      tm_polygons("popE") + 
      tm_view()
    
    
    
    map.nj.ny.metro

    
    
    
    # remove overlap counties
    # -----------------------------------------
    test.metro <- test %>% 
          filter()
  
  my_counties <- fips_codes %>%
  filter(state %in% my_states)



      



# test maping the boro borders
cat.maps.wide.function <- function(data, varname, ltitle, legendlabel, colorplaette){
    tm_shape(data, unit = "mi") +
    tm_polygons(col = varname , # add variable(s)
                style = "cat", # set break pattern to object LQ.cuts
                palette = colorplaette,  # set color fill to blue refreshing
                border.col = "grey40", # color the borders white
                border.alpha = 0.5, # set border transparency
                title = ltitle, # title for legend
                colorNA = "white", # color of missing data
                textNA = "Missing data or ineligible to gentrify",
                labels = legendlabel) + 
    tm_style("bw") +
    tm_layout(panel.label.bg.color ="NA", 
              frame = FALSE, 
              bg.color = "transparent") + # panel label color
    tm_legend(legend.title.fontface = 2,  # legend bold
              legend.title.size = 0.80, 
              legend.text.size = 0.60, 
              legend.bg.alpha = 0, 
              legend.width = 5) + 
    # tm_credits("*Missing includes tracts not eligible", 
    #     position = c(0.018, 0.85)) +
    tm_scale_bar(color.dark = "gray60", # Customize scale bar and north arrow
                 position = c(0.6, 0.05)) +  # set position of the scale bar
    tm_compass(type = "4star", 
               size = 2.5, # set size of the compass
               fontsize = 0.5, # set font size of the compass
               color.dark = "gray60", # color the compass
               text.color = "gray60", # color the text of the compass
               position = c(0.5, 0.05))  # set position of the compass
    }
    


test.map <- cat.maps.wide.function(
        data = test,
        varname = "popE", 
        colorplaette = reds, 
        ltitle = "", 
        legendlabel = c("Decrease in residential housing price", 
                        "Increase in residential housing price"))


test.map

