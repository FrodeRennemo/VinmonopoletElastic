
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
mkdir download
iwr -outfile "download/products.csv" "https://www.vinmonopolet.no/medias/sys_master/products/products/hbc/hb0/8834253127710/produkter.csv"
gc downloads/products.csv  | set-content -encoding utf-8  download/iconproducts.csv
