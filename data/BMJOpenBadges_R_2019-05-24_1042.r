#Clear existing data and graphics
rm(list=ls())
graphics.off()
#Load Hmisc library
library(Hmisc)
#Read Data
data=read.csv('BMJOpenBadges_DATA_2019-05-24_1042_anonymous.csv')
#Setting Labels

label(data$record_id)="Record ID"
label(data$article_submission_date)="Journal article submission date to BMJ Open"
label(data$article_title)="Title of Journal Article "
label(data$bmjopen_id)="BMJ Open ID number"
label(data$opt_in_date)="Opt-in date"
label(data$corresponding_author)="Corresponding Author Name"
label(data$author_email)="Corresponding Author Email "
label(data$study_type)="Type of Study"
label(data$publication_status)="Journal article publication status "
label(data$article_version)="What is the article version?    You should be able to tell if it is a re-submission based on the BMJ Open paper number, e.g. • Original submission: bmjopen-2017-012212 • First re-submission: bmjopen-2017-012212.R1 • Second re-submission: bmjopen-2017-012212.R2 "
label(data$excluded)="Is this article excluded from this Study?  Papers will be excluded if: • The papers title contains the word `Protocol • They are meta-analysis or systematic reviews • They are case series, opinion pieces or some other publication type where there is no data. • Any authors on the paper have a relationship with the QUT study team.  • They are still under review at the time we assess data sharing  • The contact author has already been approached to be part of the study • They are rejected after peer-review • They are rejected after initial screening by BMJ Open editors  "
label(data$data_sharing_statement_verbatim_prequt)="Data Sharing Statement Verbatim pre-QUT recruitment  Copy and paste the data sharing statement of the article verbatim.  This is the statement that the authors have written in their original submission to BMJ Open (pre-QUT recruitment)"
label(data$data_sharing_statement_verbatim_postqut)="Data Sharing Statement Verbatim post-QUT recruitment   Copy and paste the data sharing statement of the accepted article verbatim "
label(data$data_sharing_statement)="Data Sharing Statement  This is the final data sharing choice of the accepted article "
label(data$article_accepted)="Has the article been accepted for publication at BMJ Open?"
label(data$weblink_data)="If data is available at a third party depository, link to dataset  If no link is available, simply type no"
label(data$time_check)="Time to check for open data (minutes)"
label(data$qut_recruitment_date)="QUT recruitment date"
label(data$random)="Randomised group"
label(data$badge)="Badge allocation"
label(data$withdrawn)="Has the participant withdrawn from the Study? "
label(data$withdrawal_date)="If the participant has withdrawn from the Study, what is the date of withdrawal?  "
label(data$data_collection_complete)="Complete?"
#Setting Units


#Setting Factors(will create new variable for factors)
data$study_type.factor = factor(data$study_type,levels=c("1","2","3","4","5","6","7","8","9"))
data$publication_status.factor = factor(data$publication_status,levels=c("1","2","3"))
data$article_version.factor = factor(data$article_version,levels=c("1","2"))
data$excluded.factor = factor(data$excluded,levels=c("1","0"))
data$data_sharing_statement.factor = factor(data$data_sharing_statement,levels=c("1","2","3"))
data$article_accepted.factor = factor(data$article_accepted,levels=c("1","0"))
data$random.factor = factor(data$random,levels=c("1","2"))
data$badge.factor = factor(data$badge,levels=c("1","0"))
data$withdrawn.factor = factor(data$withdrawn,levels=c("1","0"))
data$data_collection_complete.factor = factor(data$data_collection_complete,levels=c("0","1","2"))

levels(data$study_type.factor)=c("Randomised Controlled Trial","Meta-analysis and Systematic Review","Case--Control","Observational Study","Prospective Observational Study (Cohort Study)","Case Series and Case Reports","Cross-sectional Study","Ideas, Editorials and Opinions","Qualitative Study")
levels(data$publication_status.factor)=c("Under review","Rejected","Published")
levels(data$article_version.factor)=c("Original submission","Re-submission")
levels(data$excluded.factor)=c("Yes","No")
levels(data$data_sharing_statement.factor)=c("No additional data is available","Data is available upon request","Data is available at a third party depository")
levels(data$article_accepted.factor)=c("Yes","No")
levels(data$random.factor)=c("control","intervention")
levels(data$badge.factor)=c("Yes","No")
levels(data$withdrawn.factor)=c("Yes","No")
levels(data$data_collection_complete.factor)=c("Incomplete","Unverified","Complete")
