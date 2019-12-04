
rm(list=ls())
library(dplyr)
setwd('/Users/wenrurumon/Desktop/kameng/talk')
raw <- lapply(dir(pattern='txt'),readLines)

#################################################
#################################################

x <- readLines('aidoushuodehua.txt')
sel <- which(x=="########################")
sel1 <- c(1,sel+1)[-(length(sel)+1)]
sel2 <- sel
rlt <- list()
for(i in 1:length(sel1)){
  rlt[[i]] <- x[sel1[i]:(sel2[i]-1)]
}
rlt <- rlt[sapply(rlt,function(x){x[[1]]})==names(which.max(table(sapply(rlt,function(x){x[[1]]}))))]
rlt.date <- sapply(rlt,function(x){x[2]})
rlt.content <- sapply(rlt,function(x){
  x <- (x[3:(length(x)-3)])
  x <- paste(gsub(' ','',x[x!='']),collapse='\n')
  x2 <- strsplit(x,'——')
  if(length(x2[[1]])==1){
    c(content=x2[[1]],id='NULL')
  } else {
    id <- x2[[1]][length(x2[[1]])]
    content <- gsub(paste0('——',id),'',x)
    if(length(id)==0){id <- 'NULL'}
    c(content=content,id=id)
  }
}) %>% t
rlt1 <- rlt.content
write.csv(rlt.content,'aidoushuodehua.csv')

#################################################
#################################################

x <- readLines('aidouyulubot.txt')
sel <- which(x=="########################")
sel1 <- c(1,sel+1)[-(length(sel)+1)]
sel2 <- sel
rlt <- list()
for(i in 1:length(sel1)){
  rlt[[i]] <- x[sel1[i]:(sel2[i]-1)]
}
rlt <- rlt[sapply(rlt,function(x){x[[1]]})==names(which.max(table(sapply(rlt,function(x){x[[1]]}))))]

rlt.date <- sapply(rlt,function(x){x[2]})
rlt.content <- sapply(rlt,function(x){
  x <- (x[3:(length(x)-3)])
  x <- paste(gsub(' ','',x[x!='']),collapse='\n')
  x2 <- strsplit(x,'——')
  if(length(x2[[1]])==1){
    c(content=x2[[1]],id='NULL')
  } else {
    id <- x2[[1]][length(x2[[1]])]
    content <- gsub(paste0('——',id),'',x)
    if(length(id)==0){id <- 'NULL'}
    c(content=content,id=id)
  }
}) %>% t
rlt2 <- rlt.content
write.csv(rlt.content,'aidouyulubot.csv')

#################################################
#################################################

x <- readLines('mingxingaidouyulubot.txt')
sel <- which(x=="########################")
sel1 <- c(1,sel+1)[-(length(sel)+1)]
sel2 <- sel
rlt <- list()
for(i in 1:length(sel1)){
  rlt[[i]] <- x[sel1[i]:(sel2[i]-1)]
}
rlt <- rlt[sapply(rlt,function(x){x[[1]]})==names(which.max(table(sapply(rlt,function(x){x[[1]]}))))]

rlt.date <- sapply(rlt,function(x){x[2]})
rlt.content <- sapply(rlt,function(x){
  x <- (x[3:(length(x)-3)])
  x <- paste(gsub(' ','',x[x!='']),collapse='\n')
  x2 <- strsplit(x,'——')
  if(length(x2[[1]])==1){
    c(content=x2[[1]],id='NULL')
  } else {
    id <- x2[[1]][length(x2[[1]])]
    content <- gsub(paste0('——',id),'',x)
    if(length(id)==0){id <- 'NULL'}
    c(content=content,id=id)
  }
}) %>% t
rlt3 <- rlt.content
write.csv(rlt.content,'mingxingaidouyulubot.csv')

#################################################
#################################################

x <- readLines('wodeaidouyulubot.txt')
sel <- which(x=="########################")
sel1 <- c(1,sel+1)[-(length(sel)+1)]
sel2 <- sel
rlt <- list()
for(i in 1:length(sel1)){
  rlt[[i]] <- x[sel1[i]:(sel2[i]-1)]
}
rlt <- rlt[sapply(rlt,function(x){x[[1]]})==names(which.max(table(sapply(rlt,function(x){x[[1]]}))))]

rlt.date <- sapply(rlt,function(x){x[2]})
rlt.content <- sapply(rlt,function(x){
  x <- (x[3:(length(x)-3)])
  x <- paste(gsub(' ','',x[x!='']),collapse='\n')
  x2 <- strsplit(x,'——')
  if(length(x2[[1]])==1){
    c(content=x2[[1]],id='NULL')
  } else {
    id <- x2[[1]][length(x2[[1]])]
    content <- gsub(paste0('——',id),'',x)
    if(length(id)==0){id <- 'NULL'}
    c(content=content,id=id)
  }
}) %>% t
rlt4 <- rlt.content
write.csv(rlt.content,'wodeaidouyulubot.csv')

#################################################
#################################################

rlt <- rbind(rlt1,rlt2,rlt3,rlt4)
rlt <- as.data.frame(rlt) %>% arrange(id)
write.csv(rlt,'rlt1202.csv',fileEncoding="UTF-8")

######

rm(list=ls())
library(dplyr)
setwd('/Users/wenrurumon/Desktop/kameng/talk')
f <- dir(pattern='html')[-2:-3]
x <- lapply(f,function(f){
  x <- readLines(f)
  x <- grep('https://c-ssl.duitang.com/uploads/item/',x,value=T)
  x <- sapply(strsplit(x,'\"'),function(x){x[[2]]})
  grep('https',x,value=T)
})
for(i in 1:length(x)){
  write.csv(cbind(x[[i]]),paste0(f[i],'.output'),row.names=F,quote=F)
}

#################################################
#################################################

rm(list=ls())
library(dplyr)
setwd('/Users/wenrurumon/Desktop/kameng/talk')
f <- dir(pattern='html2')
x <- lapply(f,function(f){
  x <- readLines(f)
  x <- grep('photo_pict',x,value=T)
  sapply(strsplit(x,'\"'),function(x){x[[14]]})
})
for(i in 1:length(x)){
  write.csv(cbind(x[[i]]),paste0(f[i],',output'),row.names=F)
}
