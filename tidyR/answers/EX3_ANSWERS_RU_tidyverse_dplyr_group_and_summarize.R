## ----------------------------------------------------------------------------------------------------------------------------------------
load(file='dataset/my_tidy.Rdata')
library(tidyverse)


## ----------------------------------------------------------------------------------------------------------------------------------------
# Group df1 by the variable _age_class_. 
df1_A <- group_by(df1, age_classbylength)
df1_A


## ----------------------------------------------------------------------------------------------------------------------------------------
# Filter to get the biggest 5 by the variable _length_ in each group. 
df1_A <- filter(df1_A, rank(-length_mm) <= 5)
df1_A


## ----------------------------------------------------------------------------------------------------------------------------------------
# Summarise this data frame over the variable _length_ by calculating the mean.
summarise(df1_A, mean_length_mm = mean(length_mm, na.rm = T))

