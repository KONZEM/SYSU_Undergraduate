import requests
from bs4 import BeautifulSoup as bf
import re
import os
import copy

URL = 'http://feed.mix.sina.com.cn/api/roll/get?pageid=372&lid=2431&k=&num=50&page='    # api接口
HEADERS = {"User-Agent": "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) "  # 伪装成浏览器
                         "Chrome/39.0.2171.95 Safari/537.36"}
URL_RECORD = 'record.txt'   # 记录爬过的网址，避免重复
RECORD_NUM = 0


def get_url(i):
    # 向api发请求
    url = URL + str(i)
    response = requests.get(url, headers=HEADERS)
    response = response.text

    # 去转义字符
    response = response.replace('\\', '')

    # 正则提取url
    urls_1 = re.findall('https://tech\.sina\.com\.cn/.+?html', response)
    urls_2 = re.findall('http://tech\.sina\.com\.cn/.+?html', response)
    urls = urls_1 + urls_2

    # 去重
    urls = list(set(urls))
    copy_urls = copy.deepcopy(urls)
    for each in copy_urls:
        # 检查日期  在2019的新闻
        date = re.search('\d{4}-\d{2}-\d{2}', each)
        if int(date[0][0:4]) < 2019:
            urls.remove(each)

    # 避免与之前的重复
    if os.path.exists(URL_RECORD):
        # print('in')
        for line in open(URL_RECORD, 'r'):
            if line.strip('\n') in urls:
                urls.remove(line.strip('\n'))
    for each in urls:
        print(each)
    print(len(urls))

    # 记录爬过的网页
    f = open(URL_RECORD, 'a')
    for url in urls:
        f.write(url)
        f.write('\n')
    f.close()

    return urls


def run(urls):
    global RECORD_NUM
    for url in urls:
        # 返回网页代码
        response = requests.get(url, headers=HEADERS)

        # 指定编码
        response.encoding = 'utf-8'
        soup = bf(response.text, 'lxml')

        # 找到包含标题的标签
        title = soup.find(attrs={'class': 'main-title'})
        if title is None:
            title = soup.find('h1')
        if title is None:
            break

        # 找到包含正文的标签
        contents = soup.find(attrs={'class': 'article'})
        if contents is None:
            contents = soup.find(attrs={'class': 'blkContainerSblkCon BSHARE_POP'})
            # BSHARE_POP blkContainerSblkCon clearfix blkContainerSblkCon_14
        if contents is None:
            break
        contents = contents.find_all('p')
        RECORD_NUM += 1

        # 写入文件
        f = open('data/'+str(RECORD_NUM)+'.txt', 'w', encoding='utf-8')
        f.write(title.text.strip())
        for content in contents:
            f.write('\n')
            f.write(content.text.strip())
        f.close()


if __name__ == '__main__':
    os.makedirs('data')
    for i in range(1, 1000):
        urls = get_url(i)
        run(urls)
