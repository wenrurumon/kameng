library(httr)
library(base64enc)
setwd("/Users/wenrurumon/Desktop/发票")
get.access.token <- function(){
  API.Key<-'Haco4p7cAGXug9mVdWpsAHDx'
  Secret.Key<-'GGnNkEetreBLoWYhR7qrPN2KYzZMufZj'
  host <- sprintf('https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=%s&client_secret=%s',API.Key,Secret.Key)
  
  r <- POST(host,
            add_headers('Content-Type'='application/json; charset=UTF-8'))
  stop_for_status(r)
  c <- content(r,'parsed')
  c$access_token
}
parse.receipt <- function(img, access.token) {
  b64 <- base64encode(img)
  b64url<-URLencode(b64,reserved = TRUE)
  bd <- sprintf('image=%s',b64url)
  host<-sprintf('https://aip.baidubce.com/rest/2.0/ocr/v1/vat_invoice?access_token=%s',access.token)
  r <- POST(host,
            body = bd,
            add_headers('Content-Type'='application/x-www-form-urlencoded'))
  
  receipt <- content(r,'parsed')
  invoiceCode <- receipt$words_result$InvoiceCode
  invoiceNumber <- receipt$words_result$InvoiceNum
  billingDate <- gsub('日','',gsub('年|月','-',receipt$words_result$InvoiceDate))
  totalAmount <- receipt$words_result$TotalAmount
  rlt <- list(receipt=receipt,
       key=list(
         invoiceCode=invoiceCode,
         invoiceNumber=invoiceNumber,
         billingDate=billingDate,
         totalAmount=totalAmount))
  print(rlt$key)
  rlt
}
get.receipt.info<-function(receipt) {
  invoiceCode <- receipt$key$InvoiceCode
  invoiceNumber <- receipt$key$InvoiceNum
  billingDate <- gsub('日','',gsub('年|月','-',receipt$key$InvoiceDate))
  totalAmount <- receipt$key$TotalAmount
  host<-'http://netocr.com/verapi/verInvoice.do'
  OCRKey<-'QWJJQKybffQ6wZgiaXFPT3'
  OCRSecret<-'2670c322a9384a7bbecc5b9dff7d38ee'
  bd <- sprintf('key=%s&secret=%s&typeId=3007&format=json&invoiceCode=%s&invoiceNumber=%s&billingDate=%s&totalAmount=%s',OCRKey,OCRSecret,invoiceCode,invoiceNumber,billingDate,totalAmount)
  r <- POST(host,
            body = bd,
            add_headers('Content-Type'='application/x-www-form-urlencoded'))
  c <- content(r,'parsed')
  c
}

####################################

access.token<-get.access.token()
receipt<-parse.receipt('28.png',access.token)#image recog
receipt
details <- get.receipt.info(receipt)#detail mining
x <- details[[2]][[1]]$invoiceLists[[1]][[1]]
x <- lapply(x,function(x){
  matrix(unlist(x),ncol=3,byrow=T)[,-2]
})
x
