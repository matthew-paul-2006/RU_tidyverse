## ----------------------------------------------------------------------------------------------------------------------------------------
load(file='dataset/my_tidy.Rdata')
library(tidyverse)


## ----------------------------------------------------------------------------------------------------------------------------------------
df1 %>% 
  filter(common_name!='Coho salmon') %>% 
  filter(common_name!='Sockeye salmon') %>% 
  group_by(common_name) %>% 
  nest()


## ----------------------------------------------------------------------------------------------------------------------------------------
df1 %>% 
  filter(common_name!='Coho salmon') %>% 
  filter(common_name!='Sockeye salmon') %>% 
  group_by(common_name) %>% 
  nest() %>%
  mutate(my_model = map(data, ~lm(length_mm ~ IGF1_ng_ml, data = ., na.action = na.omit)))



## ----------------------------------------------------------------------------------------------------------------------------------------
df1_nest <- df1 %>% 
  filter(common_name!='Coho salmon') %>% 
  filter(common_name!='Sockeye salmon') %>% 
  group_by(common_name) %>% 
  nest() %>%
  mutate(my_model = map(data, ~lm(length_mm ~ IGF1_ng_ml, data = ., na.action = na.omit))) %>%
  mutate(predictions = map(my_model, predict)) 

df1_nest

df1_nest %>% pull(predictions)


