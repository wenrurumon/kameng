

setwd('/Users/wenrurumon/Desktop/kameng/idolinfo')
id <- unique(openxlsx::read.xlsx("榜单ID.xlsx")[,2])
id[50] <- '杨颖'
id <- c(id,'炎亚纶')

rlt <- list()
for(i in 1:length(id)){
  print(paste(i,id[i],Sys.time()))
  rlt[[i]] <- try(getid(id[i]))
}






############################
# Setup
############################

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
