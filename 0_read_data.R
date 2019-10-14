# 0_read_data.R
# get data from REDCap
# May 2019
library(dplyr)
library(stringr)

# run the data processing file that was automatically generated from REDCap
setwd('data')
source('BMJOpenBadges_R_2019-05-24_1042.r')
setwd('..')

## tidy data
# convert dates
# convert data sharing statements
# convert times
data = mutate(data, 
              opt_in_date = as.Date(as.character(opt_in_date)),
              qut_recruitment_date = as.Date(as.character(qut_recruitment_date)),
              time_check = as.numeric(as.character(time_check)),
              data_sharing_statement_verbatim_prequt = as.character(data_sharing_statement_verbatim_prequt),
              data_sharing_statement_verbatim_postqut = as.character(data_sharing_statement_verbatim_postqut)
)
## process words in the final data sharing statement
# count the number of words
data = mutate(data, 
              data_sharing_statement_verbatim_postqut = str_replace_all(string=data_sharing_statement_verbatim_postqut, pattern='  ', replacement = ' '), # remove any double spaces
              n.words = str_count(string=data_sharing_statement_verbatim_postqut, pattern=' '), # count spaces
              n.words = ifelse(n.words==0, 0, n.words+1)) # add missing word (from counting spaces) if result is non zero 
              
# save
data = dplyr::select(data, -'corresponding_author', -author_email) # remove identifying information
save(data, file='data/AnalysisReady.RData')
