## ----------------------------------------------------------------------------------------------------------------------------------------
load(file='dataset/my_tidy.Rdata')
library(tidyverse)


## ----------------------------------------------------------------------------------------------------------------------------------------
# Create a dataframe of the variables _age_ and _IGF_ of only the _Steelhead_ fish
df1_A <- filter(df1, common_name == 'Steelhead')
select(df1_A, age_classbylength, IGF1_ng_ml)


## ----------------------------------------------------------------------------------------------------------------------------------------
# Create a dataframe of all variables but the _IGF_ values, for all fish that begin with _S_
df1_A <- filter(df1, str_starts(common_name,'S'))
select(df1_A, -IGF1_ng_ml)

