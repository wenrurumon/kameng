import os
import requests

os.chdir('/home/admin/kameng')
f = open('wallpaper_url.txt','r')
urls = []
j = 0

def head(x,h=10):
        if len(x)<=h:
                h = len(x)
        for i in range(0,h):
                print(x[i])

def findid(findid):
        count = 0
        for i in urls:
                if i == findid:
                        rlt = count
                        break
                count = count+1
        return(rlt)

for i in f.readlines():
        urls.append(i.replace('\n',''))

#urls = urls[0:100]

isid = True
for i in urls[48246:len(urls)]:
        if i == '###############################':
                isid = (not isid)
                continue
        if isid:
                id = i
                print(id)
                j = 0
        else:
                j = j+1
                fname = "wallpaper/%s_%d.jpg"%(id,j)
                #print(fname)
                img = requests.get(i).content
                with open(fname,'wb') as f:
                        f.write(img)
findid = '叶童'
count = 0
for i in urls:
        if i == findid:
                print(count)
                break
        count = count+1


isid = True
ids = []
for i in urls:
        if i == '###############################':
                isid = (not isid)
                continue
        if isid:
                id = i
                ids.append(id)
                print(id)

