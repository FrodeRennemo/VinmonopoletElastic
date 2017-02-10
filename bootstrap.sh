sudo apt-get update
sudo apt-get install wget openjdk-8-jdk -y

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https

# Install python tools
#udo apt-get install build-essential autoconf flex bison libtool python-dev -y
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list

# Commands taken from
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup-repositories.html
sudo apt-get update && sudo apt-get install elasticsearch
sudo apt-get update && sudo apt-get install kibana

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl enable kibana.service
sudo apt-get install python python-pip
cd /vagrant
pip install