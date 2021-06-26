import requests
from bs4 import BeautifulSoup
import jieba
from snownlp import SnowNLP
import thulac
import pynlpir

headers = {"User-Agent": "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) "
                         "Chrome/39.0.2171.95 Safari/537.36"}
response = requests.get('http://www.xinhuanet.com/politics/leaders/2019-09/21/c_1125023359.htm', headers=headers)
response.encoding = 'utf-8'
soup = BeautifulSoup(response.text, 'lxml')
article = soup.find(attrs={'class': 'main-aticle'})
article = article.find_all('p')
with open('in.txt', 'w') as f:
    for row in article[2:]:
        f.write(row.text)
        f.write('\n')

# jieba
txt = open('in.txt', 'r').read()
txt = jieba.lcut(txt)
txt = '|'.join(txt)
f = open('jieba_out.txt', 'w')
f.write(txt)
f.close()

# SnowNLP
txt = open('in.txt', 'r').read()
txt = SnowNLP(txt).words
txt = '|'.join(txt)
f = open('SnowNLP_out.txt', 'w')
f.write(txt)
f.close()

# thulac
txt = open('in.txt', 'r').read()
res = thulac.thulac(seg_only=True).cut(txt)
txt = []
for each in res:
    txt.append(each[0])
txt = '|'.join(txt)
f = open('thulac_out.txt', 'w')
f.write(txt)
f.close()

# pynlpir
pynlpir.open()
txt = open('in.txt', 'r').read()
txt = pynlpir.segment(txt, pos_tagging=False)
txt = '|'.join(txt)
f = open('pynlpir_out.txt', 'w')
f.write(txt)
f.close()

