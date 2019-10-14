# 1_consort_plot.R
# CONSORT plot for badge study
# Feb 2019
library(diagram)
library(dplyr)

load('data/AnalysisReady.RData') # from 0_read_data.R

# manage data
for.consort = select(data, record_id, study_type.factor, publication_status.factor, excluded.factor, random.factor, withdrawn.factor) %>%
  mutate(excluded.pre.random = is.na(random.factor)==TRUE |study_type.factor =='Meta-analysis and Systematic Review') # were not even randomised

# dummy recruitment numbers
consort.assessed = nrow(for.consort)
consort.excluded = sum(for.consort$excluded.pre.random)
consort.randomised = consort.assessed - consort.excluded
random = filter(for.consort, is.na(random.factor) == FALSE & study_type.factor !='Meta-analysis and Systematic Review') # now remove non-randomised papers
allocate.control = sum(random$random.factor=='control')
allocate.treatment = sum(random$random.factor=='intervention')
rejected.control = filter(random, random.factor=='control') %>%
  summarise(count = sum(publication_status.factor == 'Rejected'))
rejected.treatment = filter(random, random.factor=='intervention') %>%
  summarise(count = sum(publication_status.factor == 'Rejected'))
review.control = filter(random, random.factor=='control') %>%
  summarise(count = sum(publication_status.factor == 'Under review'))
review.treatment = filter(random, random.factor=='intervention') %>%
  summarise(count = sum(publication_status.factor == 'Under review'))
withdrawn.treatment = filter(random, random.factor=='intervention') %>%
  summarise(count = sum(withdrawn.factor == 'Yes', na.rm=TRUE))
withdrawn.control = filter(random, random.factor=='control') %>%
  summarise(count = sum(withdrawn.factor == 'Yes', na.rm=TRUE))
lost.fu.control = review.control$count + rejected.control$count + withdrawn.control$count
lost.fu.treatment = review.treatment$count + rejected.treatment$count + withdrawn.treatment$count
analysed.treatment = allocate.treatment - lost.fu.treatment
analysed.control = allocate.control - lost.fu.control
# labels
b = c('Enrollment', 'Allocation', 'Follow-up', 'Analysis')
l1 = paste('Assessed for eligibility (n=', consort.assessed, ')', sep='') # numbers from above
l2 = paste('Excluded (n=', consort.excluded, ')', sep='')
l3 = paste('Randomised (n=', consort.randomised,')', sep='')
l4 = paste('Allocated to control (n=', allocate.control ,')', sep='')
l5 = paste('Allocated to intervention (n=', allocate.treatment ,')', sep='')
l6 = paste('Excluded post-randomisation (n=', lost.fu.control, ')\n', # control lost to fu
           '- Paper rejected (n=', rejected.control$count,')\n', 
#           '- Under review (n=', review.control$count,')\n', # no longer needed
           '- Participant withdrew (n=', withdrawn.control$count,')', sep='')
l7 = paste('Excluded post-randomisation (n=', lost.fu.treatment, ')\n', # treatment lost to fu
           '- Paper rejected (n=', rejected.treatment$count,')\n', 
#           '- Under review (n=', review.treatment$count,')\n', 
           '- Participant withdrew (n=', withdrawn.treatment$count,')', sep='')
l8 = paste('Analysed (n=', analysed.control, ')', sep='')
l9 = paste('Analysed (n=', analysed.treatment, ')', sep='')
labels = c(l1, l2, l3, l4, l5, l6, l7, l8, l9, b)
n.labels = length(labels)
### make data frame of box chars
frame = read.table(sep='\t', stringsAsFactors=F, skip=0, header=T, text='
i	x	y	box.col	box.type	box.prop	box.size
1	0.5	0.94	white	square	0.25	0.16
2	0.76	0.82	white	square	0.17	0.21
3	0.5	0.7	white	square	0.25	0.15
4	0.26	0.5	white	square	0.21	0.2
5	0.76	0.5	white	square	0.21	0.2
6	0.26	0.33	white	square	0.29	0.2
7	0.76	0.33	white	square	0.29	0.2
8	0.26	0.15	white	square	0.2	0.2
9	0.76	0.15	white	square	0.2	0.2
10	0.1	0.95	light blue	round	0.7	0.035
11	0.51	0.6	light blue	round	0.7	0.035
12	0.51	0.425	light blue	round	0.7	0.035
13	0.51	0.23	light blue	round	0.7	0.035')
pos = as.matrix(subset(frame, select=c(x, y)))
M = matrix(nrow = n.labels, ncol = n.labels, byrow = TRUE, data = 0)
M[3, 1] = "' '"
M[4, 3] = "' '"
M[5, 3] = "' '"
M[6, 4] = "' '"
M[7, 5] = "' '"
M[8, 6] = "' '"
M[9, 7] = "' '"
tcol = rep('black', n.labels)
to.blank = c(2,4:9)
tcol[to.blank] = 'transparent' # blank some boxes to add text as right aligned
#postscript('figures/consort.flow.eps', width=7.5, height=7, horiz=F)
tiff('figures/consort.flow.tif', width=7.5, height=7, units='in', res=300, compression = 'lzw')
par(mai=c(0,0.04,0.04,0.04))
plotmat(M, pos = pos, name = labels, lwd = 1, shadow.size=0, curve=0,
        box.lwd = 2, cex.txt = 1, box.size = frame$box.size, box.col=frame$box.col,
        box.type = frame$box.type, box.prop = frame$box.prop, txt.col = tcol)
# add left-aligned text; -0.185 controls the horizontal indent
for (i in to.blank){
  text(x=pos[i,1] - 0.185, y=pos[i,2], adj=c(0,0.5), labels=labels[i]) # minus controls text position
}
# extra arrow to excluded
arrows(x0=0.5, x1=0.55, y0=0.82, length=0.12)
dev.off()

