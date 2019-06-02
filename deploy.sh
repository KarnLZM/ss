yum install git python-setuptools net-tools -y
easy_install pip
pip install git+https://github.com/shadowsocks/shadowsocks.git@master
yum install epel-release -y
yum install libsodium -y
echo "alias startss='ssserver -c ~/ss.json -d start'" >> ~/.bash_profile
echo "alias stopss='ssserver -c ~/ss.json -d stop'" >> ~/.bash_profile
source ~/.bash_profile
curl https://raw.githubusercontent.com/KarnLZM/ss/master/ss.json?token=Ami0xusZxm9zs3VlJ7KYLvy2GdOxDPVOks5bOHdfwA%3D%3D --output ~/ss.json

uname -r

# 如果当前内核版本低于 4.10，可使用 ELRepo 源更新：
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
sudo yum --enablerepo=elrepo-kernel install kernel-ml -y

rpm -qa | grep kernel
# 在输出中看到 kernel-ml-4.11.0-1.el7.elrepo.x86_64 类似的内容，表示安装成功

sudo egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'

sudo grub2-set-default 1
reboot

uname -r

echo 'net.core.default_qdisc=fq' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control=bbr' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

sudo sysctl net.ipv4.tcp_available_congestion_control
sudo sysctl -n net.ipv4.tcp_congestion_control
lsmod | grep bbr

sudo dd if=/dev/zero of=500mb.zip bs=1024k count=500

# 访问 http://[your-server-IP]/500mb.zip 来测试一下下载速度吧
