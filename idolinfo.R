
rm(list=ls())
library(tmcn)
library(RSelenium)
library(dplyr)
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
getjson <- function(x){
  x <- paste0('\"',x,'\"')
  x.m <- t(matrix(x,nrow=2))
  paste(apply(x.m,1,function(x){paste(x,collapse=':')}),collapse=',')
}
chrome <- remoteDriver(remoteServerAddr = "localhost" 
                       , port = 4444L
                       , browserName = "chrome")
chrome$open()

setwd('/Users/wenrurumon/Desktop/kameng/idolinfo')
id <- openxlsx::read.xlsx("榜单ID.xlsx")[,2]
idolinfo <- function(idi){
  #get baiduinfo
  chrome$navigate('http://baike.baidu.com')
  input <- chrome$findElement('name',"word")
  input$sendKeysToElement(list(idi,key='enter'))
  lemmasummary <- chrome$findElement('class','lemma-summary') %>% geteletext
  lemmasummary <- c('summary',lemmasummary[[1]]%>%rmspace)
  basinfo <- do.call(c,chrome$findElements('class','basicInfo-item'))
  basinfo <- sapply(basinfo,function(x){x$getElementText()[[1]]%>%rmspace})
  basinfo <- t(matrix(basinfo,nrow=2))
  basinfo <- basinfo[rowSums(nchar(basinfo))>0,]
  #getxunyee
  chrome$navigate('https://www.xunyee.cn/')
  input <- chrome$findElement('id','indexSearchInput')
  input$sendKeysToElement(list(idi,key='enter'))
  x <- chrome$findElement('class','smallsite_list_box_img')
  x <- x$getElementAttribute('href')[[1]]
  chrome$navigate(x)
  headimg <- chrome$findElement('id','smallsite_header_headimg_img')
  headimg <- c('headimg_xunyi',headimg$getElementAttribute('src')[[1]])
  bkimg <- chrome$findElement('id','smallsite_header_bg')
  bkimg <- bkimg$getElementAttribute('style')[[1]]
  bkimg <- c('bkimg_xunyi',strsplit(bkimg,'\"')[[1]][[2]])
  #baidutieba
  chrome$navigate('http://tieba.baidu.com/')
  input <- chrome$findElement('name','kw1')
  input$sendKeysToElement(list(idi,key='enter'))
  headimg <- chrome$findElement('id','forum-card-head')
  headimg <- c('headimg_baike',headimg$getElementAttribute('src')[[1]])
  bkimg <- chrome$findElement('id','forum-card-banner')
  bkimg <- bkimg$getElementAttribute('src')[[1]]
  bkimg <- c('bkimg_baike',bkimg)
  #resulting
  c(lemmasummary,basinfo,headimg,bkimg) %>% getjson
}

rlt <- list()
for(i in 1:length(id)){
  idi <- id[i]
  print(paste(i,idi,Sys.time()))
  rlt[[i]] <- try(idolinfo(idi))
}

              
