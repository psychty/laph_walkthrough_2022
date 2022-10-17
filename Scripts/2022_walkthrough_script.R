# Enable repository from ropensci
# options(repos = c(
#   ropensci = 'https://ropensci.r-universe.dev',
#   CRAN = 'https://cloud.r-project.org'))


packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'stringr', 'rgdal', 'spdplyr', 'geojsonio', 'rmapshaper', 'jsonlite', 'rgeos', 'sp', 'sf', 'maptools', 'leaflet', 'leaflet.extras', 'readODS', 'fingertipsR')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

output_store <- 'C:/Users/ASUS/OneDrive/Documents/GitHub/laph_walkthrough_2022/laph_walkthrough/src'

# Scraping OHIDs fingertips service for data ####

# This is the part that can be modified across profiles.
# We read this in each time for each area
indicator_template <- read_csv('./laph_walkthrough_2022/Data/starting_template_walkthrough_utla.csv') %>% 
  mutate(UKHSA_ID = as.character(UKHSA_ID))

# The API will only respond to fingertips IDs (and will fail if we give it a blank ID) so we need to remove those
OHID_indicators <- indicator_template %>% 
  select(UKHSA_ID) %>% 
  filter(!is.na(UKHSA_ID)) %>% 
  unique()

indicator_last_updated <- indicator_update_information(OHID_indicators$UKHSA_ID) %>% 
  mutate(Month_year = format(LastDataUploadDate, '%B-%Y'))

# Create a table of metadata for the indicators
indicator_metadata <-  indicator_metadata(OHID_indicators$UKHSA_ID) %>% 
  select(IndicatorID, Indicator_Name = Indicator, Unit, Definition, Rationale, Methodology, Source = 'Data source') %>% 
  left_join(indicator_last_updated, by = 'IndicatorID')

OHID_area_types <- area_types()

indicator_df <- fingertips_data(OHID_indicators$UKHSA_ID,
                                AreaCode = c('E10000032', 'E10000011', 'E06000043', 'E12000008', 'E92000001'),
                                AreaTypeID = 'All',
                                rank = TRUE,
                                categorytype = FALSE)

indicator_df %>% 
  group_by(IndicatorID, Sex, AreaName) %>% 
  summarise(n()) %>% 
  View()

indicator_df %>% 
  filter(AreaType %in% c('Counties & UAs (from Apr 2021)'),
         AreaName == 'Brighton and Hove') %>% 
  group_by(IndicatorID) %>% 
  filter(TimeperiodSortable == max(TimeperiodSortable)) %>% 
  select(AreaName, IndicatorID, IndicatorName, Sex, Age, Timeperiod, Timeperiodrange) %>% 
  View()

# UTLA version
# We can create an object of all the West Sussex areas which can be used throughout the script, rather than typing out all areas each time.
utla_areas <- c('West Sussex', 'East Sussex', 'Brighton and Hove', 'South East region')

latest_df <- compiled_df %>% 
  filter(Type %in% c('UA', 'County', 'England', 'District', 'Region')) %>% 
  group_by(ID) %>% 
  filter(TimeperiodSortable == max(TimeperiodSortable)) %>%
  filter(Area_Name %in% utla_areas) %>% 
  left_join(indicator_metadata, by = 'ID') %>% 
  select(UKHSA_ID = ID, Indicator_Name, Area_Name, Sex, Age, Period, Value, Lower_CI, Upper_CI, Numerator, significance_Eng = Compared_to_eng) %>% 
  mutate(significance_Eng = ifelse(significance_Eng == 'Not compared', 'NA', tolower(significance_Eng))) %>% 
  mutate(UKHSA_ID = as.character(UKHSA_ID))

i = 1

Area_x <- utla_areas[i]

latest_df_x <- latest_df %>% 
  filter(Area_Name == Area_x)

area_x_indicator_df <- indicator_template %>% 
  left_join(latest_df_x, by = c('UKHSA_ID', 'Sex'))



  toJSON() %>% 
  write_lines(paste0(output_store, '/wsx_values.json'))


# Additional indicators not in fingertips ####

download.file('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1063549/children-in-low-income-families-local-area-statistics-2014-to-2021.ods',
              './laph_walkthrough_2022/Data/Children_low_income_families.ods',
              mode = 'wb')

children_in_poverty <- read_ods('./laph_walkthrough_2022/Data/Children_low_income_families.ods',
                                sheet = '1_Relative_Local_Authority',
                                skip = 9)

