import csv
import urllib2
import elasticsearch
import logging
import json
import os
import sys


#fix Norwegian number formatting -> standard (sorry about that)
def fixNumber(str):
    if str.find(",") > -1:
            str = str.replace(',', '.')
    return str


def UnicodeDictReader(utf8_data, **kwargs):
    csv_reader = csv.DictReader(utf8_data, **kwargs)
    for row in csv_reader:
        yield dict([(key, unicode(value, 'cp1252'))
                    for key, value in row.iteritems()])

es = elasticsearch.Elasticsearch('http://localhost:9200/')
es_index = "vinmonopolet"
doctype = "produkt"


def main():
    logging.basicConfig(level=logging.WARN, format='%(asctime)s %(message)s')
    if es.indices.exists(index=es_index):
        es.indices.delete(es_index)
    es.indices.create(es_index)
    dirfile = os.path.dirname(os.path.realpath(__file__))
    json_mapping = json.loads(open(dirfile + "/mapping.json", "r").read())
    es.indices.put_template(name="vinmonopolettemplate", body=json_mapping)
    url = 'https://www.vinmonopolet.no/medias/sys_master/products/products/hbc/hb0/8834253127710/produkter.csv'
    try:
        response = urllib2.urlopen(url)
    except urllib2.HTTPError, err:
        if err.code != 200:
            print "There was an error downloading ", err.code
            sys.exit()
    except urllib2.URLError, err:
            print "Some other error happened:", err.reason
            sys.exit()

    cr = UnicodeDictReader(response, delimiter=';')
    for row in cr:
        if len(row) > 2:
            if(row['Volum']):
                row['Volum'] = float(fixNumber(row['Volum']))
            if(row['Pris']):
                row['Pris'] = float(fixNumber(row['Pris']))
            if(row['Literpris']):
                row['Literpris'] = float(fixNumber(row['Literpris']))
            if(row['Alkohol']):
                row['Alkohol'] = float(fixNumber(row['Alkohol']))
            if(row['Argang']):
                row['Argang'] = int(row['Argang'])
            if(row['Bitterhet']):
                row['Bitterhet'] = int(row['Bitterhet'])
            if(row['Friskhet']):
                row['Friskhet'] = int(row['Friskhet'])
            if(row['Fylde']):
                row['Fylde'] = int(row['Fylde'])
            if(row['Garvestoffer']):
                row['Garvestoffer'] = int(row['Garvestoffer'])
            if(row['Sodme']):
                row['Sodme'] = int(row['Sodme'])
            if(row['Varenummer']):
                row['Varenummer'] = int(row['Varenummer'])
            print row['Varenavn']
            es.index(index=es_index,
                     doc_type=doctype,
                     id=row['Varenummer'],
                     body=row)

if __name__ == '__main__':
    main()