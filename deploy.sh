yum install git python-setuptools net-tools -y
easy_install pip
pip install git+https://github.com/shadowsocks/shadowsocks.git@master
yum install epel-release -y
yum install libsodium -y
echo "alias startss='ssserver -c ~/ss.json -d start'" >> ~/.bash_profile
echo "alias stopss='ssserver -c ~/ss.json -d stop'" >> ~/.bash_profile
source ~/.bash_profile
curl https://gist.githubusercontent.com/KaitoHH/b5761017633c9b4102b56ff41938dfeb/raw/087c6969ac02937ea2b29080a3b114a2f26d071d/ss.json --output ~/ss.json
