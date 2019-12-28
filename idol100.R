
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
  x.m <- cbind(
    paste0('\"',names(x),'\"'),
    paste0('\"',as.vector(x),'\"')
  )
  paste(apply(x.m,1,function(x){paste(x,collapse=':')}),collapse=',')
}
chrome <- remoteDriver(remoteServerAddr = "localhost" 
                       , port = 4444L
                       , browserName = "chrome")
chrome$open()

setwd('/Users/wenrurumon/Desktop/kameng/idolinfo')
id <- unique(openxlsx::read.xlsx("榜单ID.xlsx")[,2])

idolinfo <- function(idi,ifbk=T,bkurl=NULL,ifxy=T,xyurl=NULL,iftb=T,tburl=NULL){
  #setup
  # idi <- id[52]
  # ifbk <- ifxy <- iftb <- T
  # bkurl <- xyurl <- tburl <- NULL
  #get baiduinfo
  if(ifbk){
    if(is.null(bkurl)){
      chrome$navigate('http://baike.baidu.com')
      input <- chrome$findElement('name',"word")
      input$sendKeysToElement(list(idi,key='enter'))
    }else{
      chrome$navigate(bkurl)
    }
    lemmasummary <- chrome$findElement('class','lemma-summary') %>% geteletext
    lemmasummary <- c('summary',lemmasummary[[1]]%>%rmspace)
    basinfo <- do.call(c,chrome$findElements('class','basicInfo-item'))
    basinfo <- sapply(basinfo,function(x){x$getElementText()[[1]]%>%rmspace})
    basinfo <- t(matrix(basinfo,nrow=2))
    basinfo <- basinfo[rowSums(nchar(basinfo))>0,,drop=F]
    basinfo <- as.vector(t(basinfo))
  } else {
    lemmasummary <- c('summary',NA)
    basinfo <- c('basinfo',NA)
  }
  #getxunyee
  if(ifxy){
    if(is.null(xyurl)){
      chrome$navigate('https://www.xunyee.cn/')
      input <- chrome$findElement('id','indexSearchInput')
      input$sendKeysToElement(list(idi,key='enter'))
      x <- chrome$findElement('class','smallsite_list_box_img')
      x <- x$getElementAttribute('href')[[1]]
      chrome$navigate(x)
    }else{
      chrome$navigate(xyurl)
    }
    headimg <- chrome$findElement('id','smallsite_header_headimg_img')
    headimg <- c('headimg_xunyi',headimg$getElementAttribute('src')[[1]])
    bkimg <- chrome$findElement('id','smallsite_header_bg')
    bkimg <- bkimg$getElementAttribute('style')[[1]]
    bkimg <- c('bkimg_xunyi',strsplit(bkimg,'\"')[[1]][[2]])
  } else {
    headimg <- NA
    bkimg <- NA
  }
  #baidutieba
  if(iftb){
    if(is.null(tburl)){
      chrome$navigate('http://tieba.baidu.com/')
      input <- chrome$findElement('name','kw1')
      input$sendKeysToElement(list(idi,key='enter'))
    }else{
      chrome$navigate(tburl)
    }
    headimg2 <- chrome$findElement('id','forum-card-head')
    headimg2 <- c('headimg_baike',headimg2$getElementAttribute('src')[[1]])
    bkimg2 <- chrome$findElement('id','forum-card-banner')
    bkimg2 <- bkimg2$getElementAttribute('src')[[1]]
    bkimg2 <- c('bkimg_baike',bkimg2)
  } else {
    headimg2 <- NA
    bkimg2 <- NA
  }
  #resulting
  rlt <- t(matrix(c(lemmasummary,basinfo,headimg,bkimg,headimg2,bkimg2),nrow=2))
  rlt2 <- as.list(rlt[,2])
  names(rlt2) <- rlt[,1]
  rlt2$sex <- sign(nchar(gsub('男','',lemmasummary[[2]]))-nchar(gsub('女','',lemmasummary[[2]])))
  rlt2
}

#############################################
#############################################

rlt <- list()
for(i in 50:length(id)){
  idi <- id[i]
  print(paste(i,idi,Sys.time()))
  rlt[[i]] <- try(idolinfo(idi))
}
which(!sapply(rlt,is.list))
# save(rlt,file='idol103.rda')
rlt[[50]] <- idolinfo(idi,xyurl='https://www.xunyee.cn/person-1118.html')
rlt[[57]] <- idolinfo(id[57],ifxy=FALSE)
rlt[[86]] <- idolinfo(id[86],bkurl='https://baike.baidu.com/item/%E8%B5%B5%E8%AE%A9/23412526')
rlt[[97]] <- idolinfo(id[97],bkurl='https://baike.baidu.com/item/%E9%83%91%E4%BA%91%E9%BE%99/23143708',ifxy=F)
# save(rlt,file='idol103.rda')
# load('idol103.rda')
for(i in 1:length(rlt)){
  for(j in 1:(length(rlt[[i]]))){
    rlt[[i]][[j]] <- gsub('\"','',rlt[[i]][[j]])
  }
}
rlt <- paste0('{',sapply(rlt,getjson),'}')
write(paste0('[',paste(rlt,collapse=','),']'),'idol100.json')

#############################################
#############################################

setwd('/Users/wenrurumon/Desktop/kameng/idolinfo')
idmap <- paste(read.table('idol9000.txt',header=T)[,1])
getimg <- function(urli){
  chrome$navigate(urli)
  idi <- (chrome$findElement('id','smallsite_header_starname')%>%geteletext)[[1]]
  headimg <- chrome$findElement('id','smallsite_header_headimg_img')
  headimg <- headimg$getElementAttribute('src')[[1]]
  bkimg <- chrome$findElement('id','smallsite_header_bg')
  bkimg <- bkimg$getElementAttribute('style')[[1]]
  bkimg <- strsplit(bkimg,'\"')[[1]][[2]]
  chrome$navigate('http://tieba.baidu.com/')
  input <- chrome$findElement('name','kw1')
  input$sendKeysToElement(list(idi,key='enter'))
  headimg2 <- chrome$findElement('id','forum-card-head')
  headimg2 <- headimg2$getElementAttribute('src')[[1]]
  bkimg2 <- chrome$findElement('id','forum-card-banner')
  bkimg2 <- bkimg2$getElementAttribute('src')[[1]]
  c(idi,headimg,bkimg,headimg2,bkimg2)
}
rlt <- list()
for(i in 1:length(idmap)){
  print(paste(i,Sys.time()))
  rlt[[i]] <- try(getimg(idmap[[i]]))
}
