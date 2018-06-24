yum install git python-setuptools net-tools -y
easy_install pip
pip install git+https://github.com/shadowsocks/shadowsocks.git@master
yum install epel-release -y
yum install libsodium -y
echo "alias startss='ssserver -c ~/ss.json -d start'" >> ~/.bash_profile
echo "alias stopss='ssserver -c ~/ss.json -d stop'" >> ~/.bash_profile
source ~/.bash_profile
curl https://raw.githubusercontent.com/KarnLZM/ss/master/ss.json?token=Ami0xusZxm9zs3VlJ7KYLvy2GdOxDPVOks5bOHdfwA%3D%3D --output ~/ss.json
