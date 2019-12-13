params <-
list(isSlides = "no")

## ----setup, include=FALSE---------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
AsSlides <- TRUE
library(org.Hs.eg.db)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)


## ---------------------------------------------------------------------------------------------------------
load(file='dataset/my_tidy.Rdata')


## ---------------------------------------------------------------------------------------------------------
head(df1)


## ---------------------------------------------------------------------------------------------------------
head(df2)


## ---------------------------------------------------------------------------------------------------------
head(df3a)


## ---------------------------------------------------------------------------------------------------------
head(df3b)


## ---------------------------------------------------------------------------------------------------------
library(tidyverse)


## ---------------------------------------------------------------------------------------------------------
# Select one variable (common_name)
select(df1, common_name)


## ---------------------------------------------------------------------------------------------------------
# Select two variables (age_classbylength and common_name)
select(df1, age_classbylength, common_name)


## ---------------------------------------------------------------------------------------------------------
# Select all but one variable (length_mm)
select(df1,-length_mm)


## ---------------------------------------------------------------------------------------------------------
# Select all a range of contiguous varibles (common_name:length_mm)
select(df1, common_name:length_mm)


## ---------------------------------------------------------------------------------------------------------
# Filter all observation where the variable common_name is Sockeye salmon
filter(df1, common_name == 'Sockeye salmon')


## ---------------------------------------------------------------------------------------------------------
# Filter all observations where the variable common_name is either Sockeye salmon or Chinook Salmon
filter(df1, common_name %in% c('Sockeye salmon', 'Chinook salmon'))


## ---------------------------------------------------------------------------------------------------------
# Filter all observations where the variable common_name ends with 'salmon'. To do this we use stringr function str_ends recognise strings that end with 'salmon'.
filter(df1, str_ends(common_name, 'salmon'))


## ---------------------------------------------------------------------------------------------------------
# Filter all observations where the variable length_mm is greater than 200 or less than 120
filter(df1, length_mm > 200 | length_mm < 120)


## ---------------------------------------------------------------------------------------------------------
# Arrange the data based on the variable length_mm
arrange(df1, length_mm)


## ---------------------------------------------------------------------------------------------------------
# Arrange the data first based on the variable common_name, 
# then secondly based on length_mm in a descending order.
arrange(df1, common_name, desc(length_mm))


## ---------------------------------------------------------------------------------------------------------
# A new variable is created based on the calculation of the
# z-score of the variable IGF1_ng_ml using scale()
mutate(df1, scale(IGF1_ng_ml))


## ---------------------------------------------------------------------------------------------------------
# A new variable is created called IGFngml_zscore, based on the 
# calculation of the z-score of the variable IGF1_ng_ml using scale()
mutate(df1, IGFngml_zscore = scale(IGF1_ng_ml))


## ---------------------------------------------------------------------------------------------------------
# First we define the common_name as a group. 
df1_byname <- group_by(df1, common_name)

# Summarise is used to count over the grouped common_names
summarise(df1_byname, count = n())


## ---------------------------------------------------------------------------------------------------------
# Summarise is used to calculate mean IGF1_ng_ml over the
# grouped common_names
summarise(df1_byname, IGF1_ng_ml_ave = mean(IGF1_ng_ml, na.rm = T))


## ---------------------------------------------------------------------------------------------------------
# Filter observations with the 2 smallest length_mm for each grouped common_names
filter(df1_byname, rank(length_mm) <= 2)


## ---------------------------------------------------------------------------------------------------------
# Filter observations with at least 5 for each grouped common_names
filter(df1_byname, n() > 5)


## ---------------------------------------------------------------------------------------------------------
# A new variable is created using z-score within the grouped common_names
mutate(df1_byname, IGFngml_zscore = scale(IGF1_ng_ml))


## ---------------------------------------------------------------------------------------------------------
# Without pipe
df1_byname <- group_by(df1, common_name)
summarise(df1_byname, IGF1_ng_ml_ave = mean(IGF1_ng_ml, na.rm=T))

# With pipe
df1 %>% 
  group_by(common_name) %>% 
  summarise(IGF1_ng_ml_ave = mean(IGF1_ng_ml, na.rm=T))


## ---------------------------------------------------------------------------------------------------------
# (1) Group by common_name
# (2) Filter to all those that have length bigger then 200
# (3) Summarise is used to calculate mean IGF1_ng_ml over the grouped 
# common_names for these larger fish

df1 %>%
  group_by(common_name) %>% 
  filter(length_mm > 200) %>% 
  summarise(IGF1_ng_ml_ave = mean(IGF1_ng_ml, na.rm = T))


## ---------------------------------------------------------------------------------------------------------
# (1) Create new variable that is discrete label depending on size of the fish
# (2) Group by common_name and size
# (3) Summarise is used to calculate mean IGF1_ng_ml over the grouped 
# common_names and sizes

df1 %>%
  mutate(size = if_else(length_mm > 200, 'big_fish', 'small_fish')) %>% 
  group_by(common_name, size) %>% 
  summarise(IGF1_ng_ml_ave = mean(IGF1_ng_ml, na.rm = T))


## ---------------------------------------------------------------------------------------------------------
# (1) Create new variable that is discrete label depending on size of the fish
# (2) Group by common_name and size
# (3) Summarise is used to calculate mean IGF1_ng_ml over the grouped 
# common_names and sizes
# (4) Filter out Coho and Sockeye salmon

df1 %>%
  mutate(size = if_else(length_mm > 200, 'big_fish', 'small_fish')) %>% 
  group_by(common_name, size) %>% 
  summarise(IGF1_ng_ml_ave = mean(IGF1_ng_ml, na.rm = T)) %>%
  filter(common_name != 'Coho salmon')  %>%
  filter(common_name !='Sockeye salmon')


## ---- warning=F, message=F--------------------------------------------------------------------------------

p <- mutate(df1,size=if_else(length_mm>200, 'big_fish', 'small_fish')) %>% 
  group_by(common_name, size) %>% 
  summarize(IGF1_ng_ml_ave=mean(IGF1_ng_ml, na.rm=T)) %>% 
  filter(common_name != 'Coho salmon')  %>% 
  filter(common_name != 'Sockeye salmon') %>% 
  ggplot(aes(x = common_name, y = IGF1_ng_ml_ave, group = size, fill = size)) +
  geom_bar(stat = "identity", position = "dodge") + 
  theme(axis.text.x = element_text(angle = 90)) +
  scale_fill_brewer(palette = "Paired")


## ---- warning=F, message=F--------------------------------------------------------------------------------
p


## ---------------------------------------------------------------------------------------------------------
untidy_counts_base <- read.csv("dataset/hemato_rnaseq_counts.csv")
# Base will print out everything
untidy_counts_base


## ---------------------------------------------------------------------------------------------------------
# readr gives you a tibble. 
read_csv("dataset/hemato_rnaseq_counts.csv")



## ---------------------------------------------------------------------------------------------------------
# Tibbles carry and display extra information. 
# While reading in it is easy to specify data type. 
untidy_counts <- read_csv("dataset/hemato_rnaseq_counts.csv", col_types = cols(
    ENTREZ = col_character(),
    CD34_1 = col_integer(),
    ORTHO_1 = col_integer(),
    CD34_2 = col_integer(),
    ORTHO_2 = col_integer()
  ))
untidy_counts


## ---------------------------------------------------------------------------------------------------------
# Can use the same way as base to interact with the 
# tibble dataframe - columns
untidy_counts[,1]


## ---------------------------------------------------------------------------------------------------------
# Can use the same way as base to interact with the
# tibble dataframe - rows
untidy_counts[1,]


## ---------------------------------------------------------------------------------------------------------
# Can also not specify which dimension you pull from. 
# This will default to grabbing the column
untidy_counts[1]


## ---------------------------------------------------------------------------------------------------------
# All the prior outputs have been outputting another tibble. 
# If double brackets are used a vector is returned 
untidy_counts[[1]]


## ---------------------------------------------------------------------------------------------------------
# This is also the case if you use the dollar and colname 
# to access a column
untidy_counts$ENTREZ


## ---------------------------------------------------------------------------------------------------------
# Can convert base dataframes into tibbles
as_tibble(untidy_counts_base)


## ---------------------------------------------------------------------------------------------------------
# Once it is a tibble it is straight forward to modify the datatype
untidy_counts_base <- as_tibble(untidy_counts_base) %>%
  mutate_at(vars(ENTREZ), as.character)
untidy_counts_base


## ---------------------------------------------------------------------------------------------------------
# Some tools are not tibble friendly. Calling as.data.frame is 
# sufficient to convert it back to a base data frame
as.data.frame(untidy_counts_base) %>% head(n=12)




## ---- warning=FALSE, message=FALSE, cache=T, eval=T, echo=F-----------------------------------------------
# Lets load in some packages
library(org.Hs.eg.db)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)

# Lets use the ENTREZ ID as a key
keys <- untidy_counts$ENTREZ

# We can use the ENTREZ ID to look up Gene Symbol
symbols <- AnnotationDbi::select(org.Hs.eg.db, keys = keys,columns = "SYMBOL", keytype = "ENTREZID")

# We can use the ENTREZ ID to look up the chormosome the gene resides on
chrs <- AnnotationDbi::select(TxDb.Hsapiens.UCSC.hg19.knownGene, keys = keys, columns = "TXCHROM", keytype = "GENEID")

# We can use the ENTREZ ID to get a list of genes with grange of their exons
geneExons <- exonsBy(TxDb.Hsapiens.UCSC.hg19.knownGene,by = "gene")[keys]




## ---- eval=T, echo=F--------------------------------------------------------------------------------------
txsLength <- sapply(geneExons, function(x){ x %>%
    GenomicRanges::reduce() %>%
    width() %>%
    sum() })
counts_metadata <- tibble(ID = symbols$ENTREZID, SYMBOL = symbols$SYMBOL, CHR = chrs$TXCHROM, LENGTH = txsLength)


## ---------------------------------------------------------------------------------------------------------
counts_metadata


## ---------------------------------------------------------------------------------------------------------
untidy_counts


## ---------------------------------------------------------------------------------------------------------
untidy_counts


## ---------------------------------------------------------------------------------------------------------
# New columns Sample and Counts are created from whole dataframe
tidier_counts <- gather(untidy_counts, key="Sample", value="counts", -ENTREZ)
tidier_counts



## ---------------------------------------------------------------------------------------------------------
spread(tidier_counts, key="Sample", value="counts")




## ---------------------------------------------------------------------------------------------------------
tidier_counts


## ---------------------------------------------------------------------------------------------------------
tidier_counts


## ---------------------------------------------------------------------------------------------------------
# Separate allows you to break a strings in a variable by a separator.
# In this case the cell type and replicate number are broken by underscore
tidier_counts <- separate(tidier_counts, Sample, sep = "_", into=c("CellType","Rep"), remove=TRUE)
tidier_counts


## ---------------------------------------------------------------------------------------------------------
# Unite can go the other way. This can sometime be useful i.e. if you want a specific sample ID
unite(tidier_counts, Sample, CellType, Rep, remove=FALSE)


## ---------------------------------------------------------------------------------------------------------
# Remember you can always pipe everything together into a single expression
tidy_counts <- untidy_counts %>% 
  gather(key=Sample, value=counts, -ENTREZ) %>% 
  separate(Sample, sep = "_", into = c("CellType","Rep"), remove=FALSE)
tidy_counts


## ---------------------------------------------------------------------------------------------------------
tidy_counts


## ---------------------------------------------------------------------------------------------------------
counts_metadata


## ---------------------------------------------------------------------------------------------------------
inner_join(tidy_counts, counts_metadata, by = c("ENTREZ" = "ID"))


## ---------------------------------------------------------------------------------------------------------
# In this pipe I group by gene, summarise the data based on the
# sum of counts, and filter for anything that has a count greater
# than 0. 
expressed_genes <- tidy_counts %>% 
  group_by(ENTREZ) %>% 
  summarise(count_total=sum(counts)) %>% 
  filter(count_total>0)
expressed_genes


## ---------------------------------------------------------------------------------------------------------
# Left join shows all genes as my full data frame tidy_counts is 
# used as the backbone. The filtered expressed genes is secondary, 
# and has missing values (unexpressed genes) which are filled with NA
left_join(tidy_counts, expressed_genes, by = c("ENTREZ" = "ENTREZ"))


## ---------------------------------------------------------------------------------------------------------
# Right join shows only genes that survived filtering as it is using 
# the second dataframe as the backbone for the new dataframe. 
tidy_counts_expressed <- right_join(tidy_counts, expressed_genes, by = c("ENTREZ" = "ENTREZ"))
tidy_counts_expressed %>% print(n=20)


## ---------------------------------------------------------------------------------------------------------
# Semi join only keeps observations in x that are matched in y. y is 
# only used as a reference and is not in output
semi_join(tidy_counts, expressed_genes)


## ---------------------------------------------------------------------------------------------------------
# Anti join only keeps observations in x that are not matched in y. 
# y is only used as a reference and is not in output
anti_join(tidy_counts, expressed_genes)



## ---------------------------------------------------------------------------------------------------------
#Theres a wide range of writing  options. Can specify the delmiter directly or use a specific function
write_delim(tidy_counts_expressed_norm, '../expressed_genes_output.csv', delim =',')

write_csv(tidy_counts_expressed_norm, '../expressed_genes_output.csv')


## ---------------------------------------------------------------------------------------------------------
# Map is the tidy equivalent to apply. Here we take our untidy counts, 
# trim of IDs, and then calculate means for each column. By default the 
# output is a list
untidy_counts %>% 
  dplyr::select(-ENTREZ) %>% 
  map(mean)


## ---------------------------------------------------------------------------------------------------------
# Same as the above line, but using map_dbl specifies the outputs is 
# going to be a double
untidy_counts %>% 
  dplyr::select(-ENTREZ) %>% 
  map_dbl(mean)


## ---------------------------------------------------------------------------------------------------------
# Summary sometimes also works in this context
tidy_counts %>% 
  group_by(Sample) %>% 
  summarize(mean_counts = mean(counts))


## ---------------------------------------------------------------------------------------------------------
# This is an alternative method for doing this with an tidied frame
tidy_counts %>% 
  split(.$Sample) %>% 
  map_dbl(~mean(.$counts))


## ---------------------------------------------------------------------------------------------------------
# pmap is a map variant for dealing with multiple inputs. This can be 
# used to apply a function on a row by row basis
list(untidy_counts$ORTHO_1, untidy_counts$ORTHO_2) %>% 
  pmap_dbl(mean)



## ---------------------------------------------------------------------------------------------------------
# Nest all the data by sample
tidy_counts_nest <- tidy_counts_expressed_norm %>% 
  group_by(Sample) %>%
  nest()

# Looking at tibble it is a new datatype that appears simplified
tidy_counts_nest

tidy_counts_nest$data %>% is()


## ---------------------------------------------------------------------------------------------------------
# The data is still there, nested within one of the variables
tidy_counts_nest$data[[1]]


## ---------------------------------------------------------------------------------------------------------
# Map can be used to apply functions across nested dataframes.
# Here we calculate a linear model. This is also saved in the tibble. 
tidy_counts_nest <- tidy_counts_nest %>% 
  mutate(my_model = map(data, ~lm(CPM ~ TPM, data = .)))

tidy_counts_nest

tidy_counts_nest$my_model[[1]]


## ---------------------------------------------------------------------------------------------------------
# Tidy also has the ability to "tidy" up outputs from common statistical 
# packages, using broom.
library(broom)

tidy_counts_nest <- tidy_counts_nest %>% 
  mutate(my_tidy_model = map(my_model, broom::tidy))

tidy_counts_nest


## ---------------------------------------------------------------------------------------------------------
tidy_counts_nest$my_tidy_model[[1]]


## ---------------------------------------------------------------------------------------------------------
# Unnesting to get everything back into a dataframe is very straightforward
tidy_counts_nest %>%
  unnest(my_tidy_model)


## ---------------------------------------------------------------------------------------------------------
# Unnesting can be done sequentially to keep adding to master dataframe
tidy_counts_nest %>%
  unnest(my_tidy_model) %>% 
  unnest(data)



## ---------------------------------------------------------------------------------------------------------

brc <- c("Tom", "Ji-Dung", "Matt")

# Extract substrings from a range. Here the 1st to 3rd character
brc %>% str_sub(1, 3)

# Extract substrings from a range. Here the 2nd to 2nd to last character
brc %>% str_sub(2, -2)


# Assign values back to substrings. Here the 2nd to 2nd to last character is replaced with X.
str_sub(brc, 2, -2) <- 'X'
brc


## ---------------------------------------------------------------------------------------------------------
brc2 <- c("Tom  ", "  Ji  -Dung", "Matt   ")

# Trim whitespace from strings
brc2 <- str_trim(brc2)
brc2 

# Can add whitespace to strings to get consistent length. Here all are 10 characters
str_pad(brc2, width=10, side='left')


## ---------------------------------------------------------------------------------------------------------
# Lets reuse our counts tibble. pull from dplyr can be used to grab a tibble 
# column and make it into a vector
tidy_counts_expressed_norm %>% 
  pull(SYMBOL) %>%
  head()

# Here we pull our gene symbols from our tibble into a vector, and then convert 
# them into title style capitalization
tidy_counts_expressed_norm %>% 
  pull(SYMBOL) %>% 
  str_to_title() %>% 
  head()


## ---------------------------------------------------------------------------------------------------------
# String manipulation functions can be used on tibbles using mutate. Here we convert
# gene symbols to title style capitalization
tidy_counts_expressed_norm %>% 
  mutate(SYMBOL = str_to_title(SYMBOL))


## ---------------------------------------------------------------------------------------------------------
# Here we convert chromosome annotation to capitals
tidy_counts_expressed_norm %>% 
  mutate(CHR = str_to_upper(CHR))


## ---------------------------------------------------------------------------------------------------------
# Find patterns in different ways
# Detect gives a T/F whether the pattern 'salmon' is present in vector
df1 %>% 
  pull(common_name) %>% 
  str_detect('salmon')


## ---------------------------------------------------------------------------------------------------------
# Subset returns the match if the pattern 'salmon' is present in vector
df1 %>% 
  dplyr::pull(common_name) %>% 
  str_subset('salmon') 


## ---------------------------------------------------------------------------------------------------------
# Ends is similar to detect as it gives gives a T/F whether the pattern 'salmon' 
# is present in vector, but the pattern has to be at the end. 
df1 %>% 
  dplyr::pull(common_name) %>% 
  str_ends('salmon') 

df1 %>% 
  filter(str_ends(common_name,'salmon'))


## ---------------------------------------------------------------------------------------------------------
#Count gives you the total number of times your pattern appears in each chracter in the vector
df1 %>% 
  dplyr::pull(common_name) %>% 
  str_count('salmon')

df1 %>% 
  dplyr::pull(common_name) %>% 
  str_count('o')


## ---------------------------------------------------------------------------------------------------------
#Replace
df1 %>% 
  dplyr::pull(common_name) %>%
  str_replace_all('Steelhead','Steelhead trout' )


## ---------------------------------------------------------------------------------------------------------
df1 %>% 
  mutate(common_name = str_replace_all(common_name,'Steelhead','Steelhead trout' ))


## ---------------------------------------------------------------------------------------------------------
# Vectors are easy to turn into factors with factor()
tidy_counts_expressed_norm_samples <- tidy_counts_expressed_norm %>% 
  pull(Sample) %>% 
  factor() 

tidy_counts_expressed_norm_samples %>% head(n=10)


## ---------------------------------------------------------------------------------------------------------
# Can also modify the data type of a tibble column with as_facotr, in an approach we have used before.
tidy_counts_expressed_norm %>% 
  ungroup() %>% 
  mutate_at(vars(Sample), as_factor) 


## ---------------------------------------------------------------------------------------------------------
tidy_counts_expressed_norm %>% 
  ungroup() %>% 
  mutate_at(vars(Sample), as_factor) %>% 
  pull(Sample) %>% head(n=10)


## ---------------------------------------------------------------------------------------------------------
# When you factorize you can use a vector to determine the order
my_levels1<-c('ORTHO_1','ORTHO_2','CD34_1','CD34_2')
tidy_counts_expressed_norm %>% 
  pull(Sample) %>% 
  factor(levels = my_levels1 ) %>% head(n=10)

# When you factorize anything not in the given levels is turned to NA
my_levels2<-c('ORTHO_1','CD34_1')
tidy_counts_expressed_norm %>% 
  pull(Sample) %>% 
  factor(levels = my_levels2 ) %>% head(n=10)

# Its straightforward to grab the levels from the factor
tidy_counts_expressed_norm_samples %>% 
  levels()



## ---------------------------------------------------------------------------------------------------------

p <- tidy_counts_expressed_norm %>% 
  ungroup() %>% 
  mutate_at(vars(Sample), as_factor) %>% 
  group_by(Sample) %>% 
  summarize(mean_count=mean(counts)) %>% 
  ggplot(aes(x=Sample, y= mean_count)) + 
  geom_bar(stat = "identity") + 
  theme(axis.text.x = element_text(angle = 90))


## ---------------------------------------------------------------------------------------------------------
p


## ---------------------------------------------------------------------------------------------------------
# fct_relevel - reorder manually
tidy_counts_expressed_norm %>% 
  ungroup() %>% 
  mutate_at(vars(Sample), as_factor) %>%
  mutate(Sample = fct_relevel(Sample, my_levels1)) %>% 
  pull(Sample) %>% head(n=10)

# fct_relevel - reorder manually
tidy_counts_expressed_norm %>% 
  ungroup() %>% 
  mutate_at(vars(Sample), as_factor) %>%
  mutate(Sample = fct_relevel(Sample, my_levels2)) %>% 
  pull(Sample) %>% head(n=10)



## ---------------------------------------------------------------------------------------------------------
# fct_reorder - reorder based on the data. Here we are ordering based
# on mean counts for each sample.
tidy_counts_expressed_norm %>%
  ungroup() %>% 
  mutate_at(vars(Sample), as_factor) %>% 
  mutate(Sample = fct_reorder(Sample, counts, mean)) %>% 
  pull(Sample) %>% head(n=10)



## ---------------------------------------------------------------------------------------------------------

p <- tidy_counts_expressed_norm %>% 
  ungroup() %>% 
  mutate_at(vars(Sample), as_factor) %>%
  mutate(Sample=fct_relevel(Sample, my_levels1)) %>% 
  group_by(Sample) %>% 
  summarize(mean_count=mean(counts)) %>% 
  ggplot(aes(x=Sample, y= mean_count)) + 
  geom_bar(stat = "identity") + 
  theme(axis.text.x = element_text(angle = 90))


## ---------------------------------------------------------------------------------------------------------
p


## ---------------------------------------------------------------------------------------------------------

df1$age_classbylength

# Recoding levels to give them a new name
df1 %>% 
  mutate_at(vars(age_classbylength), as_factor) %>%
  mutate(age_classbylength=fct_recode(age_classbylength, "mixed juvenile" = "mixed age juvenile")) %>%
  pull(age_classbylength)

# Recoding levels to change to add one factor to another factor
df1 %>% 
  mutate_at(vars(age_classbylength), as_factor) %>% 
  mutate(age_classbylength=fct_recode(age_classbylength, "juvenile" = "mixed age juvenile")) %>%
  pull(age_classbylength)



## ---------------------------------------------------------------------------------------------------------
# fct_count - Count up the number of each
df1 %>% 
  mutate_at(vars(age_classbylength), as_factor) %>% 
  pull(age_classbylength) %>% 
  fct_count()


## ---------------------------------------------------------------------------------------------------------
# fct_infreq - mask rare factors by giving them a general summary term i.e. Other
df1 %>% 
  mutate_at(vars(age_classbylength), as_factor) %>%
  mutate(age_classbylength=fct_lump(age_classbylength, n=2)) %>%
  pull(age_classbylength)

df1 %>% 
  mutate_at(vars(age_classbylength), as_factor) %>%
  mutate(age_classbylength=fct_lump(age_classbylength, n=2)) %>%
  pull(age_classbylength) %>% 
  fct_count()


## ---------------------------------------------------------------------------------------------------------
# Normally facotrs do not like to be combined as levels in one may not exist in the other.
# Factor concatenation with fct_c help get around this. 
A <- factor(c('Tom','Ji-Dung'))
B <- factor('Matt')
fct_c(A, B)

