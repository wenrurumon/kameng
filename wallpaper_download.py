#python notebook

import os
import sys
reload(sys)
sys.setdefaultencoding( "utf-8" )

import requests
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.wait import WebDriverWait
import selenium.webdriver.support.ui as ui
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
import datetime

def dlimg(url,filename='test'):
    img = requests.get(url).content
    with open(filename,'wb') as f:
        f.write(img)

def getimg(id):
    url = 'https://image.baidu.com/search/index?tn=baiduimage&word=%s壁纸'%(id)
    b.get(url)
    dom = b.find_elements_by_css_selector('.img-hover')
    rlt = []
    for i in dom:
        temp = (i.get_attribute('data-imgurl'))
        if temp is not None:
            rlt.append(temp)
    return(rlt)

b = webdriver.Chrome()
b.get('https://github.com/wenrurumon/kameng/blob/master/starid.txt')
dom = b.find_element_by_css_selector('body > div.application-main > div > main > div.container-lg.new-discussion-timeline.experiment-repo-nav.p-responsive > div.repository-content > div.Box.mt-3.position-relative > div.Box-body.p-0.blob-wrapper.data.type-text > table > tbody')
ids = dom.text.splitlines()

count = 54
for id in ids[(count+1):len(ids)]:
    count = count + 1
    print('%d, %s'%(count,id))
    urls = getimg(id)
    for i in range(0,len(urls)):
        dlimg(urls[i],"/home/wenrurumon/Documents/note/wallpaper/%s_%d"%(id,i))

f = open('test.txt','w')

for id in ids:
    f.write(id)
    f.write('\n')
    f.write('###############################\n')
    temp = getimg(id)
    for i in temp:
        f.write(i)
        f.write('\n')
    f.write('###############################\n')


f.close()

##################################

import requests
url = 'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=36082272,1628839531&fm=26&gp=0.jpg'
img = requests.get(url).content
with open('test.jpg','wb') as f:
    f.write(img)



