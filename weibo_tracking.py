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
    rlt.append(i.text)
  return rlt

##################################

b = webdriver.Chrome()
b.get('https://m.weibo.cn/p/2304132113270200_-_WEIBO_SECOND_PROFILE_WEIBO')
time.sleep(5)
#contents = b.find_elements_by_css_selector(".weibo-main")
#boxes = b.find_elements_by_css_selector('.m-ctrl-box')
for i in range(0,20):
  print(i)
  js="var q=document.documentElement.scrollTop=1000000000000"
  b.execute_script(js) 
  time.sleep(5)

doms = b.find_elements_by_css_selector('.card-main')

####################################
