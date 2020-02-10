## ----------------------------------------------------------------------------------------------------------------------------------------
load(file='dataset/my_tidy.Rdata')
library(tidyverse)


## ----------------------------------------------------------------------------------------------------------------------------------------
tidy_counts_expressed_norm %>% 
  mutate(ATPase = str_starts(SYMBOL,'ATP')) %>% 
  split(.$Sample) %>% 
  map(~sum(.$ATPase))

tidy_counts_expressed_norm %>% 
  mutate(Hox = str_starts(SYMBOL,'HOX')) %>%
  split(.$Sample) %>% 
  map(~sum(.$HOX))


## ----------------------------------------------------------------------------------------------------------------------------------------
tidy_counts_expressed_norm %>% 
  filter(str_starts(SYMBOL,'ATP'))


## ----------------------------------------------------------------------------------------------------------------------------------------
tidy_counts_expressed_norm %>% 
  filter(str_starts(SYMBOL,'ATP')) %>%
  mutate(ATPtype = str_replace_all(SYMBOL,'ATP','' )) %>%
  mutate(ATPtype = str_to_lower(ATPtype))


