## ----------------------------------------------------------------------------------------------------------------------------------------
load(file='dataset/my_tidy.Rdata')
library(tidyverse)


## ----------------------------------------------------------------------------------------------------------------------------------------
# Use Group to focus computation on each sample. Use mutate to make 
# new variable that is the CPM
tidy_counts_expressed_norm <- tidy_counts_expressed  %>% 
  group_by(Sample) %>% 
  mutate(CPM=(counts/sum(counts))*1000000)


## ----------------------------------------------------------------------------------------------------------------------------------------
# Join our tidy data to the metadata, then make new variable that is the TPM
tidy_counts_expressed_norm <- tidy_counts_expressed_norm %>% 
  inner_join(counts_metadata, by = c("ENTREZ" = "ID")) %>%  
  mutate(TPM=(counts/sum(counts/LENGTH))*(1000000/LENGTH))


## ----------------------------------------------------------------------------------------------------------------------------------------
# Simple X-Y plot comparing TPM and CPM. 
p <- tidy_counts_expressed_norm %>% 
  ggplot(aes(x=CPM, y=TPM)) + 
  geom_point() + 
  scale_x_continuous(name="log2(CPM)",trans='log2') + 
  scale_y_continuous(name="log2(TPM)",trans='log2')
p

