
rm(list=ls())
library(tmcn)
library(RSelenium)
library(dplyr)
library(rjson)
setwd('/Users/wenrurumon/Desktop/kameng/idolinfo')

geteletext <- function(...){
  x <- do.call(c,list(...))
  x <- sapply(x,function(x){
    x$getElementText()
  })
}
geteleattr <- function(...,attr,ifunlist=F){
  x <- do.call(c,list(...))
  x <- sapply(x,function(x){
    x$getElementAttribute(attr)
  })
  if(ifunlist){
    return(unlist(x))
  } else {
    return(x)
  }
}
rmspace <- function(x){
  x <- strsplit(x,' ')
  x <- sapply(x,function(x) paste(x,collapse=''))
  gsub("\\[.*?\\]|\n","",x)
}
# getjson <- function(x){
#   x.m <- cbind(
#     paste0('\"',names(x),'\"'),
#     paste0('\"',as.vector(x),'\"')
#   )
#   paste0('{',
#          paste(apply(x.m,1,function(x){paste(x,collapse=':')}),collapse=','),
#          '}')
# }
getjson <- function(x){
  x.m <- t(matrix(x,nrow=2))
  x.m <- cbind(
    paste0('\"',x.m[,1],'\"'),
    paste0('\"',x.m[,2],'\"')
  )
  paste0('{',
         paste(apply(x.m,1,function(x){paste(x,collapse=':')}),collapse=','),
         '}')
}
getbk <- function(idi,urli=NULL){
  if(is.null(urli)){
    chrome$navigate('http://baike.baidu.com')
    input <- chrome$findElement('name',"word")
    input$sendKeysToElement(list(idi,key='enter'))  
  } else {
    chrome$navigate(urli)
  }
  lemmasummary <- chrome$findElement('class','lemma-summary') %>% geteletext
  lemmasummary <- c('summary',lemmasummary[[1]]%>%rmspace)
  basinfo <- do.call(c,chrome$findElements('class','basicInfo-item'))
  basinfo <- sapply(basinfo,function(x){x$getElementText()[[1]]%>%rmspace})
  basinfo <- t(matrix(basinfo,nrow=2))
  basinfo <- basinfo[rowSums(nchar(basinfo))>0,,drop=F]
  basinfo <- as.vector(t(basinfo))
  basinfo <- c(basinfo,'性别',sign(nchar(gsub('男','',lemmasummary[[2]]))-nchar(gsub('女','',lemmasummary[[2]]))))
  c(lemmasummary,basinfo)
}
getbk2 <- function(idi,urli=NULL){
  rlt <- try(getbk(idi,urli))
  if(class(rlt)=='try-error'){
    return(NULL)
  } else {
    return(rlt)
  }
}
getxy <- function(idi,urli=NULL){
  if(is.null(urli)){
    chrome$navigate('https://www.xunyee.cn/')
    input <- chrome$findElement('id','indexSearchInput')
    input$sendKeysToElement(list(idi,key='enter'))
    x <- chrome$findElement('class','smallsite_list_box_img')
    x <- x$getElementAttribute('href')[[1]]
    chrome$navigate(x)
  }else{
    chrome$navigate(urli)
  }
  headimg <- chrome$findElement('id','smallsite_header_headimg_img')
  headimg <- c('headimg_xunyi',headimg$getElementAttribute('src')[[1]])
  bkimg <- chrome$findElement('id','smallsite_header_bg')
  bkimg <- bkimg$getElementAttribute('style')[[1]]
  bkimg <- c('bkimg_xunyi',strsplit(bkimg,'\"')[[1]][[2]])
  c(headimg,bkimg)
}
getxy2 <- function(idi,urli=NULL){
  rlt <- try(getxy(idi,urli))
  if(class(rlt)=='try-error'){
    return(NULL)
  } else {
    return(rlt)
  }
}
gettb <- function(idi,urli=NULL){
  if(is.null(urli)){
    chrome$navigate('http://tieba.baidu.com/')
    input <- chrome$findElement('name','kw1')
    input$sendKeysToElement(list(idi,key='enter'))
  }else{
    chrome$navigate(urli)
  }
  headimg2 <- chrome$findElement('id','forum-card-head')
  headimg2 <- c('headimg_baike',headimg2$getElementAttribute('src')[[1]])
  bkimg2 <- chrome$findElement('id','forum-card-banner')
  bkimg2 <- bkimg2$getElementAttribute('src')[[1]]
  bkimg2 <- c('bkimg_baike',bkimg2)
  c(headimg2,bkimg2)
}
gettb2 <- function(idi,urli=NULL){
  rlt <- try(gettb(idi,urli))
  if(class(rlt)=='try-error'){
    return(NULL)
  } else {
    return(rlt)
  }
}
getidolname <- function(urli){
  chrome$navigate(urli)
  ids <- chrome$findElements('class','rank_left_lib')
  rlt <- ids %>% geteletext
  unlist(rlt)
}
getinfo <- function(i,urlbk=NULL,urlxy=NULL,urltb=NULL){
  idi <- idolscore[i,2]
  scorei <- idolscore[i,3]
  print(paste(i,idi,Sys.time()))
  # urlbk <- urlxy <- urltb <- NULL
  x0 <- c('idi',idi,'scorei',scorei)
  x1 <- getbk2(idi,urlbk)
  x2 <- getxy2(idi,urlxy)
  x3 <- gettb2(idi,urltb)
  x4 <- c(length(x1),length(x2),length(x3))
  list(base=x0,baike=x1,xunyi=x2,tieba=x3,check=x4)
}
checkerror <- function(i){
  print(idolscore[i,])
  print(rlt.check[i,])
}
checkjson <- function(f){
  write(f,'test.json')
  fromJSON(file='test.json')
}

############################
# Setup
############################

chrome <- remoteDriver(remoteServerAddr = "localhost" 
                       , port = 4444L
                       , browserName = "chrome")
chrome$open()

#Get Idol List

urls <- paste0('https://www.xunyee.cn/rank-person-index-1-page-',1:120,'.html')
idolscore <- lapply(urls,getidolname)
idolscore <- t(sapply(strsplit(unlist(idolscore),'\n'),function(x){x[1:3]}))
idolscore[,2] <- gsub("\\(.*?\\)","",idolscore[,2])

#Get Result

rlt <- lapply(1:nrow(idolscore),getinfo)
rlt.check <- t(sapply(rlt,function(x){x$check}))
error.check <- which(sapply(apply(rlt.check,1,function(x){which(x==0)}),length)>0)
rlt[[36]] <- getinfo(36,urlbk='https://baike.baidu.com/item/%E8%A2%81%E6%98%8A/20237857')
rlt[[44]] <- getinfo(44,urlbk='https://baike.baidu.com/item/%E7%8E%8B%E5%AE%89%E5%AE%87/23640606?fr=aladdin')

rlt2 <- lapply(rlt,function(x){getjson(unlist(x[1:4]))})
