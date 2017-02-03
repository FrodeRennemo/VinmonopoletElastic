mkdir download
curl -0 https://www.vinmonopolet.no/medias/sys_master/products/products/hbc/hb0/8834253127710/produkter.csv > downloads/products.csv
iconv -f ISO-8859-1 -t UTF-8 download/products.csv > download/iconproducts.csv
