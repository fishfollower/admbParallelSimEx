fsa<-read.table("baserun/fsa.std", header=TRUE)

plotit <-function (fit, what, ylab=what, trans=function(x)x ,...){
 idx<-fit$name==what
 y<-fit[idx,3]
 ci<-y+fit[idx,4]%o%c(-2,2)
 x<-1:length(y)
 plot(x,trans(y), ylab=ylab, type="l", lwd=3, ylim=range(c(trans(ci),0)), las=1,...)
 polygon(c(x,rev(x)), y = c(trans(ci[,1]),rev(trans(ci[,2]))), border = gray(.5,alpha=.5), col = gray(.5,alpha=.5))
 grid(col="black")
}


load("allsim.RData")
pdf("fig1.pdf",8,8)
  plotit(fsa, "ssb")
  d<-lapply(sims, function(f)lines(f[f[,2]=="ssb",3], col=gray(.4,alpha=.5)))
dev.off()
