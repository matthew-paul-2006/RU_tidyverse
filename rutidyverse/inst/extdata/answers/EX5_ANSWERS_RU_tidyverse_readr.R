## ----------------------------------------------------------------------------------------------------------------------------------------
library(tidyverse)


## ----------------------------------------------------------------------------------------------------------------------------------------
untidy_counts_test <- read_csv("dataset/hemato_rnaseq_counts.csv", col_types = cols(
    ENTREZ = col_character(),
    CD34_1 = col_integer(),
    ORTHO_1 = col_character(),
    CD34_2 = col_factor(),
    ORTHO_2 = col_logical()
  ))

untidy_counts_test$CD34_1 %>% head(n=8)
untidy_counts_test$ORTHO_1 %>% head(n=8)
untidy_counts_test$CD34_2 %>% head(n=8)
untidy_counts_test$ORTHO_2 %>% head(n=8)

