# Here goes the code for simulating one data set
# The seed should _not_ be set here
#
# the example below is very model and format specific. 

lC<-as.matrix(read.table("../baserun/fsa.rep", header=FALSE, nrow=7))
lS<-as.matrix(read.table("../baserun/fsa.rep", header=FALSE, skip=7))
std<-read.table("../baserun/fsa.std", header=TRUE)
sdC<-sqrt(exp(std[std$name=="logVarLogCatch",3]))
sdS<-sqrt(exp(std[std$name=="logVarLogSurvey",3]))
C<-exp(lC+rnorm(prod(dim(lC)), mean=0, sd=sdC))
S<-exp(lS+rnorm(prod(dim(lS)), mean=0, sd=sdS))

lin<-readLines("../fsa.dat") # replacing catch and survey lines with simulated values
idxcatch<-grep("# catch in numbers", lin)
idxsurvey<-grep("# Q1 survey", lin)
for(i in 1:nrow(C))lin[idxcatch+i]<-paste(C[i,], collapse=" ")
for(i in 1:nrow(S))lin[idxsurvey+i]<-paste(S[i,], collapse=" ")
writeLines(lin,"fsa.dat")
