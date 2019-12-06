import os
import sys

from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.wait import WebDriverWait
import selenium.webdriver.support.ui as ui
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
import datetime
import pandas as pd
from pandas import ExcelFile
import numpy as np

###################################################
###################################################

def mf(x):
	a = '男' in x.split('\n')
	b = '女' in x.split('\n')
	return((a*10+b))

ids = 'test.xlsx'
ids = pd.read_excel(ids,sheetname='test')
ids = np.array(ids)[:,1]
b = webdriver.Chrome()

rlt = []
for i in ids[(1414+2647+5038)+len(rlt)-1:len(ids)]:
	print(i)
	i = '%s是男的女的' % (i)
	b.get('http://baidu.com')
	kw = b.find_element_by_css_selector('#kw')
	kw.clear()
	kw.send_keys(i)
	kw.send_keys(Keys.RETURN)
	time.sleep(2)
	t = b.find_elements_by_css_selector('#content_left')
	rlt.append([i,t[0].text])

rlt2 = []
for i in rlt:
	rlt2.append([i[0],mf(i[1])])

pd.DataFrame(np.array(rlt2)).to_csv('常晓阳.csv')

############

import os
import sys
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.wait import WebDriverWait
import selenium.webdriver.support.ui as ui
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
b = webdriver.Chrome()
b.get('https://m.weibo.cn/u/7187057341?is_all=1&is_all=1&jumpfrom=weibocom')

for i in range(0,100):
  print(i)
  js="var q=document.documentElement.scrollTop=100000000000000"
  b.execute_script(js) 
  time.sleep(1)

def printdom(doms):
  for i in doms:
    print(i.text)
    print("##############################")

def returndom(doms):
  rlt = []
  for i in doms:
    rlt.append(i.text)
  return rlt

doms = b.find_elements_by_css_selector('.card-main')
print(len(doms))
domi = returndom(doms)
fo = open('wodeaidouyulubot.txt', "w")
for k in domi:
        fo.write('%s\n########################\n' % (k))

fo.close()


###################################################
###################################################

rlt = []
url = 'https://weibo.cn/u/7212222634?page='
b = webdriver.Chrome()
for i in range(1,10):
	print(i)
	b.get('%s%d' % (url,i))
	rlt.append(b.find_elements_by_css_selector('.c'))
	time.sleep(1)


int f(const int x) {
   if (x <= 3) return(x);
   return (f(x - 1) + f(x - 3));
}

###################################################
###################################################

b = webdriver.Chrome()
b.get('https://www.duitang.com/album/?id=92791685#!albumpics')
for i in range(0,100):
  print(i)
  js="var q=document.documentElement.scrollTop=100000000000000"
  b.execute_script(js) 
  time.sleep(1)
#woo-holder > div.woo-swb.woo-cur > div:nth-child(2) > div:nth-child(112) > div > div.mbpho > a > u

d = b.find_element_by_css_selector('#woo-holder > div.woo-swb.woo-cur > div:nth-child(2)')


