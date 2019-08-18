
rm(list=ls())
library(dplyr)
setwd("/Users/wenrurumon/Documents/fun/kameng")
ids <- readLines('starid.txt')
i <- ids[[2]]
fun <- function(i){
	#print(i)
	#urli <- paste0('https://s.weibo.com/weibo/',i,'超话')
	urli <- paste0('https://s.weibo.com/weibo/',i)
	tag <- grep('&#xe627',readLines(urli),value=T)
	rlt <- cbind(i,table(unlist(lapply(strsplit(tag,'\"'),function(x){grep('huati',x,value=T)}))) %>% sort(decreasing=T))
	rlt
}
co <- 0
out <- lapply(ids,function(i){
	print(paste(Sys.time(),co <<- co+1))
	j <- runif(1,0,4)
	Sys.sleep(j)
	return(try(fun(i)))
})
