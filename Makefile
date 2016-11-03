.PHONY = all clean run data est collect plot
SEED = 123456
NOSIM = 100
MODEL = fsa

all: plot

simdirs := $(shell echo 'cat(formatC(1:$(NOSIM), digits=6, flag="0"))' | R --slave)
datadone := $(foreach dir,$(simdirs),$(dir)/datafolderdone)
estfiles := $(foreach dir,$(simdirs),$(dir)/$(MODEL).std)

$(MODEL): $(MODEL).tpl
	admb $(MODEL)
	rm *.obj *.htp $(MODEL).cpp

baserun/$(MODEL).std: $(MODEL) $(MODEL).dat
	mkdir $(@D) 
	cp $(MODEL) $(MODEL).dat $(@D)
	cd $(@D); ./$(MODEL) 

run: baserun/$(MODEL).std

$(datadone): simone.R
	mkdir $(@D)
	cd $(@D); touch datafolderdone;

SIMLINE = 'set.seed($(SEED)); \
           sapply(dir(pattern="^[[:digit:]]"), \
             function(d){\
               setwd(paste(d,sep="")); \
               source("../simone.R"); \
               setwd("..")\
             }\
           )' 

alldatadone: $(datadone) baserun/$(MODEL).std
	echo $(SIMLINE) | R --vanilla --slave;
	touch alldatadone

data: alldatadone

$(estfiles): alldatadone $(MODEL)
	cp $(MODEL) $(@D)
	cd $(@D); ./$(MODEL) > out

est: $(estfiles)

COLLECTALL = 'dn<-dir(pattern="^[[:digit:]]");\
              sims<-lapply(dn,function(d){setwd(d);sim<-read.table("$(MODEL).std",header=TRUE);setwd("..");sim});\
              save(sims,file="allsim.RData")'

allsim.RData: $(estfiles)
	echo $(COLLECTALL) | R --vanilla --slave

collect: allsim.RData

fig1.pdf: allsim.RData baserun/$(MODEL).std
	echo 'source("plot.R")' | R --vanilla --slave

plot: fig1.pdf

clean: 
	rm -rf 0* *~ alldatadone allsim.RData $(MODEL) baserun fig1.pdf
