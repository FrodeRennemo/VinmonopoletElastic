# VinmonopoletElastic
Index product data from Vinmonopolet to Elasticsearch

# Elasticsearch/Kibana Vinmonopolet demo
This project contains scripts and tools for Vinmonopolet demo.

## Prerequisites
#### Java 8 installed
- Download jdk from http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
- Set JAVA_HOME environment variable and point to the installation path of the jdk for all users

#### Download and unzip latest version of Elasticsearch and Kibana and Logstash
- Elasticsearch https://www.elastic.co/downloads/elasticsearch
- Kibana https://www.elastic.co/downloads/kibana
- Logstash https://www.elastic.co/downloads/logstash

Unzip to your preferered directory. (for instance "c:\elastic")

#### Run Elasticsearch and Kibana
From the unzipped directories, run the following commands. (alternatively double click on elasticsearch.bat/kibana.bat)
- /elasticsearch-5.3.1/bin/elasticsearch
- /kibana-5.3.1/bin/kibana

Go to http://localhost:9200 and http://localhost:5601 in your browser to ensure you get a response.

## Index data from Vinmonopolet
Open cmd, bash, powershell or similar and change directory to the checked out source.
Now, run logstash to feed data into elastic . (Adjust path to logstash to where you unzipped it)
-  C:\elastic\logstash-5.3.1\bin\logstash.bat -f .\vinMonopoletCsvFileLogstash.conf.txt

Verify that you have data by opening http://localhost:9200/vinmonopolet/_search 
(Should be 16000-ish total documents)
