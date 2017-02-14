# VinmonopoletElastic
Index product data from Vinmonopolet to Elasticsearch

# Elasticsearch/Kibana Vinmonopolet demo
This project contains scripts and tools for Vinmonopolet demo.

## Prerequisites
#### Java 8 installed
- Download jdk from http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
- Set JAVA_HOME environment variable and point to the installation path of the jdk for all users

#### Download latest version of Elasticsearch and Kibana
- Elasticsearch https://www.elastic.co/downloads/elasticsearch
- Kibana https://www.elastic.co/downloads/kibana

#### Run Elasticsearch and Kibana
- /elasticsearch-5.2.0/bin/elasticsearch
- /kibana-5.2.0/bin/kibana

Go to localhost:9200 and localhost:5601 in your browser to ensure you get a response.

## Index data from Vinmonopolet
#### Windows 
For Windows users, simply run import.ps1 (right click, Run with Powershell)

#### UNIX(OSX, Linux)
Assuming you have Python 2 installed and available in your shell, run `python script.py` in the terminal


