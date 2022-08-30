
packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'stringr', 'rgdal', 'spdplyr', 'geojsonio', 'rmapshaper', 'jsonlite', 'rgeos', 'sp', 'sf', 'maptools', 'leaflet', 'leaflet.extras')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

output_store <- 'C:/Users/ASUS/OneDrive/Documents/GitHub/laph_walkthrough_2022/laph_walkthrough/src'

comparison_df <- data.frame(sig_title = c('Signficantly better', 'Similar', 'Signifcantly worse'), sig_class = c('lower', 'similar', 'better'))

comparison_df %>% 
  toJSON() %>% 
  write_lines(paste0(output_store, '/comparison_values.json'))

# Scraping OHIDs fingertips service for data ####

# Grab ALL fingertips indicator IDs
all_fingertip_indicators <- read_csv(url('https://fingertips.phe.org.uk/api/indicator_metadata/csv/all'))%>% 
  rename(ID = 'Indicator ID',
         Indicator_Name = 'Indicator')

indicators <- read_csv("C:/Users/ASUS/OneDrive/Documents/GitHub/la-ph-walkthrough/meta_frame.csv")

fingertips_ids <- all_fingertip_indicators %>% 
  filter(ID %in% indicators$ID) %>% 
  filter(!ID %in% c('90356', '11001'))

# Create a table of metadata for the indicators
indicator_metadata <- fingertips_ids %>%
  rename(Source = 'Data source') %>%
  select(ID, Indicator_Name, Unit, Definition, Rationale, Methodology, Source) %>% 
  mutate(ID = as.character(ID))

for(i in 1:length(unique(fingertips_ids$ID))){
  
  # If I equals 1 then create an overall data frame (compiled_df) for adding all the individual indicator dataframes to it
  if(i == 1){compiled_df <- data.frame(ID = character(), Area_Name = character(), Type  = character(), Sex  = character(), Age = character(), Category_type = character(), Category  = character(),Period = character(),Value = numeric(),Lower_CI= numeric(), Upper_CI = numeric(),Numerator = numeric(), Denominator  = numeric(), Note = character(), Compared_to_eng = character(),Compared_to_parent = character(), TimeperiodSortable = numeric(), Time_coverage = character())}
  
  id_x <- unique(fingertips_ids$ID)[i]
  
  loopy <- read_csv(url(paste0('https://fingertips.phe.org.uk/api/all_data/csv/for_one_indicator?indicator_id=', id_x))) %>% 
    select(!c('Parent Code', 'Indicator Name', 'Parent Name', 'Lower CI 99.8 limit', 'Upper CI 99.8 limit', 'Recent Trend', 'New data', 'Compared to goal')) %>% 
    rename(ID = 'Indicator ID',
           Area_Code = 'Area Code',
           Area_Name = 'Area Name',
           Type = 'Area Type',
           Period = 'Time period',
           Lower_CI = 'Lower CI 95.0 limit',
           Upper_CI = 'Upper CI 95.0 limit',
           Category_type = 'Category Type',
           Numerator = 'Count',
           Note = 'Value note',
           Compared_to_eng = 'Compared to England value or percentiles',
           TimeperiodSortable = 'Time period Sortable',
           Time_coverage = 'Time period range') %>% 
    rename(Compared_to_parent = 17) %>% # Column 17 might be called something different depending on the indicator so we can use the column index (17) 
    mutate(ID = as.character(ID)) %>% 
    mutate(Period = as.character(Period))
  
  compiled_df <- compiled_df %>% 
    bind_rows(loopy)
  
}

# We can create an object of all the West Sussex areas which can be used throughout the script, rather than typing out all areas each time.
wsx_areas <- c( 'Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing', 'West Sussex')

latest_df <- compiled_df %>% 
  filter(Type %in% c('UA', 'County', 'England', 'District')) %>% 
  group_by(ID) %>% 
  filter(TimeperiodSortable == max(TimeperiodSortable)) %>%
  filter(Area_Name %in% wsx_areas) %>% 
  left_join(indicator_metadata, by = 'ID') %>% 
  select(ID, Indicator_Name, Area_Name, Sex, Age, Period, Value, significance = Compared_to_eng) %>% 
  mutate(significance = ifelse(significance == 'Not compared', 'NA', tolower(significance))) %>% 
  filter(Area_Name == 'West Sussex')

data.frame(Indicator_Name = 'Start of life', significance = 'section_circle') %>% 
  bind_rows(latest_df) %>% 
  toJSON() %>% 
  write_lines(paste0(output_store, '/wsx_values.json'))
