# 从 https://appsource.microsoft.com/en-us/marketplace/apps?product=office%3Bteams&page=1 获取应用信息

import requests
import bs4
import math
import re
import json
import customTypes

# https://appsource.microsoft.com/view/appPricing/us?version=2017-04-24 这个获取所有app的单价设置

appPricingTable = ''
paidApp = []

def getAppPricing(appId: str):
    global appPricingTable
    if appPricingTable == '':
        appPricingTable = requests.get(
            'https://appsource.microsoft.com/view/appPricing/us?version=2017-04-24').json()
    return appPricingTable['startingPrices'][appId]

def processLink(href: str):
    appId = href.replace(
        'https://appsource.microsoft.com/en-us/product/office/', '').replace('?tab=Overview', '')
    response = requests.get(href).content
    soup = bs4.BeautifulSoup(response, "html.parser")
    title = soup.select_one("h1.titleHeader").text
    description = soup.select_one("h2[itemprop='description']").text
    reviewCount = -1 if soup.select_one(
        "div.ratingsCount>a") == None else int(re.sub("\D", "", soup.select_one(
            "div.ratingsCount>a").text))
    ratingValue = -1 if soup.select_one(
        "div.ratingsCount>span") == None else float(soup.select_one(
            "div.ratingsCount>span").text)

    price = getAppPricing(appId)
    offer = 'free' if type(price['pricingData']) != dict else 'paid'
    if offer == 'paid':
        global paidApp
        price['pricingData']['isQuantifiable'] = price['isQuantifiable']
        price['pricingData']['hasFreeTrial'] = price['hasFreeTrial']
        paidApp.append(price['pricingData'])

    publisher = soup.select_one(
        "div.metaDetails>div[itemprop='publisher']>span[itemprop='name']").text
    version = soup.select_one(
        "div.metaDetails>div[itemprop='version']>span").text
    modifiedDate = soup.select_one(
        "div.metaDetails>div[itemprop='dateModified']>span").text
    categories = [x["title"] for x in soup.select("a.detailsCategories")]

    return {
        "id": appId,
        "title": title,
        "description": description,
        "reviewCount": reviewCount,
        "ratingValue": ratingValue,
        "offer": offer,
        "publisher": publisher,
        "version": version,
        "modifiedDate": modifiedDate,
        "categories": categories
    }


def writeToJson(obj, fileName: str):
    with open(fileName, 'w') as file:
        json.dump(obj, file)


def main():
    result = []
    baseUrl = "https://appsource.microsoft.com/en-us/marketplace/apps?product=office%3Bteams&page={}"
    page = 1

    response = requests.get(baseUrl.format(page)).content
    soup = bs4.BeautifulSoup(response, "html.parser")

    # 解析页数
    totalPage = math.ceil(
        int(re.sub('\D', '', soup.select_one("div.headerName").text))/60)

    index = 1

    for x in soup.select("div.spza_tileWrapper > a"):
        app = processLink("https://appsource.microsoft.com"+x["href"])
        print(index, app['title'])
        result.append(app)
        index += 1

    while page < totalPage:
        response = requests.get(baseUrl.format(page+1)).content
        soup = bs4.BeautifulSoup(response, "html.parser")
        for x in soup.select("div.spza_tileWrapper > a"):
            app = processLink("https://appsource.microsoft.com"+x["href"])
            print(index, app['title'])
            result.append(app)
            index += 1
        page = page+1

    writeToJson(result, 'allapps.json')
    writeToJson(paidApp, 'paidapps-listprice.json')


if __name__ == '__main__':
    main()
