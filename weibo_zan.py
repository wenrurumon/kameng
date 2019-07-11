#python notebook

import os
import sys
reload(sys)
sys.setdefaultencoding( "utf-8" )

from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.wait import WebDriverWait
import selenium.webdriver.support.ui as ui
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
import datetime

def printdom(doms):
  for i in doms:
    print(i.text)
    print("##############################")

def returndom(doms):
  rlt = []
  for i in doms:
    print(i.text)
    rlt.append(i.text)
  return(rlt)

def rolldown(l,t=3):
  js="var q=document.documentElement.scrollTop=%d"%(l)
  b.execute_script(js)
  time.sleep(t)

b = webdriver.Chrome()
b.get('https://m.weibo.cn/detail/4369599526796493#attitude')

for i in range(0,100):
  print(i)
  rolldown(1000000000000000,3)

doms = b.find_elements_by_css_selector('.m-text-cut')
temp = returndom(doms)

f = open("tongmengshi_likelist.txt", "w")
for i in rlt: 
  f.write(i+"\n")

f.close()
 
