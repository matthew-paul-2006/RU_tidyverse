## ----------------------------------------------------------------------------------------------------------------------------------------
load(file='dataset/my_tidy.Rdata')
library(tidyverse)


## ----------------------------------------------------------------------------------------------------------------------------------------
# Create a dataframe with a new variable that contains the rank 
# of the _length_ variable. Arrange this new data frame by 
# _IGF_ (lowest to highest).
df1_A <- mutate(df1, length_rank=rank(length_mm))
arrange(df1_A, IGF1_ng_ml)



## ----------------------------------------------------------------------------------------------------------------------------------------
# Create a dataframe with a new variable that is _IGF_/_length_. 
# Arrange by this new variable (highest to lowest).
df1_A <- mutate(df1, IGF_perlength=IGF1_ng_ml/length_mm)
arrange(df1_A, -IGF_perlength)

