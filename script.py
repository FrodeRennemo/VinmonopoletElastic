import csv
import urllib2
import logging
import json
import os
import sys
import httplib


# fix Norwegian number formatting -> standard (sorry about that)
def fixNumber(str):
    if str.find(",") > -1:
        str = str.replace(',', '.')
    return str


def UnicodeDictReader(path,**kwargs):
    with open(path + '/download/iconproducts.csv','r') as fout:
        csv_reader = csv.DictReader(fout, **kwargs)
        for row in csv_reader:
            try:
                yield dict([(key, value)
                            for key, value in row.iteritems()])
            except Exception as e:
                pass

es_index = "vinmonopolet"
doctype = "produkt"


def main():
    logging.basicConfig(level=logging.WARN, format='%(asctime)s %(message)s')
    #Check if index exist?
    indexJson = json.JSONEncoder().encode({"settings" : {"index" : {"number_of_shards" : 5, "number_of_replicas" : 1 }}})
    indexConn = httplib.HTTPConnection("localhost:9200")
    indexConn.request("PUT","/vinmonopolet",indexJson,headers={'Content-Type':'application/json'})
    
    dirfile = os.path.dirname(os.path.realpath(__file__))
    json_mapping = json.loads(open(dirfile + "/mapping_fielddata.json", "r").read())

    templateJson = json.JSONEncoder().encode(json_mapping)
    templateConn = httplib.HTTPConnection("localhost:9200")
    templateConn.request("PUT","/_template/vinmonopolettpl",templateJson,headers={'Content-Type':'application/json'})

    cr = UnicodeDictReader(dirfile,delimiter=';')


    fields = ["Alkohol","Pris", "Volum", "Bitterhet","Literpris","Sukker", "Syre"]
    docConn = httplib.HTTPConnection("localhost:9200")

    for row in cr:
        if len(row) > 2:
            for field in fields:
                if row[field]=="Ukjent":
                    row[field] = ""
                else:
                    try:
                        row[field] = float(fixNumber(row[field]))
                    except Exception as exp:
                        print("Could not convert field")

            print row['Varenavn']
            docJson = json.JSONEncoder().encode(row)
            try:
                docConn.request("POST","/vinmonopolet/produkt",docJson,headers={'Content-Type':'application/json'})
            except Exception as ex:
                docConn = httplib.HTTPConnection("localhost:9200")
                docConn.request("POST","/vinmonopolet/produkt",docJson,headers={'Content-Type':'application/json'})

if __name__ == '__main__':
    main()
