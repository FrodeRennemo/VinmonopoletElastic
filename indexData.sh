#!/bin/bash
generate_post_data()
{
	cat <<EOF
	{"Datotid":\"$Datotid\","Varenummer":\"$Varenummer\","Varenavn":\"$Varenavn\","Volum":\"$Volum\","Pris":\"$Pris\","Literpris":\"$Literpris\","Varetype":\"$Varetype\","Produktutvalg":\"$Produktutvalg\","Butikkategori":\"$Butikkategori\","Fylde":\"$Fylde\","Friskhet":\"$Friskhet\","Garvestoffer":\"$Garvestoffer\","Bitterhet":\"$Bitterhet\","Sodme":\"$Sodme\","Farge":\"$Farge\","Lukt":\"$Lukt\","Smak":\"$Smak\","Passertil01":\"$Passertil01\","Passertil02":\"$Passertil02\","Passertil03":\"$Passertil03\","Land":\"$Land\","Distrikt":\"$Distrikt\","Underdistrikt":\"$Underdistrikt\","Argang":\"$Argang\","Rastoff":\"$Rastoff\","Metode":\"$Metode\","Alkohol":\"$Alkohol\","Sukker":\"$Sukker\",
"Syre":\"$Syre\","Lagringsgrad":\"$Lagringsgrad\","Produsent":\"$Produsent\","Grossist":\"$Grossist\","Distributor":\"$Distributor\","Emballasjetype":\"$Emballasjetype\","Korktype":\"$Korktype\","Vareurl":\"$Vareurl\"}
EOF
}

"$(mkdir download)"                                                                                                                                                                                  
curl='/usr/bin/curl'
http="https://www.vinmonopolet.no/medias/sys_master/products/products/hbc/hb0/8834253127710/produkter.csv"
curlargs="-f -s -S -k"

dot="$(cd "$(dirname "$0")"; pwd)"
path="$dot/download"

resp="$($curl $curlargs $http > $path/products.csv)"

#Set correct encoding
iconv -f ISO-8859-1 -t UTF-8 $path/products.csv > $path/iconproducts.csv

#Set mapping
mapping="$(cat mapping_fielddata.json)"
"$($curl -XPUT 'localhost:9200/_template/vinmonopolettpl?pretty' -H 'Content-Type: application/json' -d "$mapping")"

OLDIFS=$IFS
IFS=";"
declare -a fields=(Alkohol Pris Volum Bitterhet Literpris Sukker Syre)

#Datotid Varenummer Varenavn	Volum	Pris	Literpris	Varetype	Produktutvalg	Butikkategori	Fylde	Friskhet	Garvestoffer	Bitterhet	Sodme	Farge	Lukt	Smak	Passertil01	Passertil02	Passertil03	Land	Distrikt	Underdistrikt	Argang	Rastoff	Metode	Alkohol	Sukker Syre	Lagringsgrad Produsent Grossist	Distributor	Emballasjetype Korktype	Vareurl

while read Datotid Varenummer Varenavn	Volum	Pris	Literpris	Varetype	Produktutvalg	Butikkategori	Fylde	Friskhet	Garvestoffer	Bitterhet	Sodme	Farge	Lukt	Smak	Passertil01	Passertil02	Passertil03	Land	Distrikt	Underdistrikt	Argang	Rastoff	Metode	Alkohol	Sukker Syre	Lagringsgrad Produsent Grossist	Distributor	Emballasjetype Korktype	Vareurl
 do
 #replace "," with "."
		curl -XPOST "localhost:9200/vinmonopolet/vinmonopolet?pretty" -H "Content-Type: application/json" -d "$(generate_post_data)"


		
done < $path/products.csv
IFS=$OLDIFS
