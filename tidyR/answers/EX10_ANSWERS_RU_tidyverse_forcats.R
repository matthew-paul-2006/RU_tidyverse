## ----------------------------------------------------------------------------------------------------------------------------------------
load(file='dataset/my_tidy.Rdata')
library(tidyverse)


## ----------------------------------------------------------------------------------------------------------------------------------------
tidy_counts_expressed_norm %>%
  mutate(length_cat=if_else(LENGTH<3000, 'short', if_else(LENGTH>6000, 'long', 'medium')))


## ----------------------------------------------------------------------------------------------------------------------------------------
tidy_counts_expressed_norm %>%
  mutate(length_cat=if_else(LENGTH<3000, 'short', if_else(LENGTH>6000, 'long', 'medium'))) %>%
  mutate(length_cat=as_factor(length_cat)) %>%
  mutate(length_cat=fct_relevel(length_cat,levels=c('long', 'medium','short')))


## ----------------------------------------------------------------------------------------------------------------------------------------
tidy_counts_expressed_norm %>%
  mutate(length_cat=if_else(LENGTH<3000, 'short', if_else(LENGTH>6000, 'long', 'medium'))) %>%
  mutate(length_cat=as_factor(length_cat)) %>%
  mutate(length_cat=fct_relevel(length_cat,levels=c('long', 'medium','short')))  %>% 
  ggplot(aes(x=length_cat, y=TPM)) + 
  geom_boxplot() + 
  scale_y_continuous(trans='log2')


