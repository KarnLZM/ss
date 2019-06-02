# CentOS 7 配置Shadowsocks多用户服务器并开启BBR网络优化算法

### 安装Shadowsocks及其依赖
```
yum install git python-setuptools net-tools -y
easy_install pip
pip install git+https://github.com/shadowsocks/shadowsocks.git@master
yum install epel-release -y
yum install libsodium -y
echo "alias startss='ssserver -c ~/ss.json -d start'" >> ~/.bash_profile
echo "alias stopss='ssserver -c ~/ss.json -d stop'" >> ~/.bash_profile
echo "alias restartpss='ssserver -c ~/ss.json -d restart'" >> ~/.bash_profile
source ~/.bash_profile
```

### 添加配置文件
新建ss配置文件
```
vi ss.json
```

输入以下内容
```
{
    "server": "0.0.0.0",
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "timeout": 300,
    "method": "chacha20-ietf-poly1305",
    "fast_open": false,
    "port_password": {
        "60000": "8#U0*)gtdc",
        "60001": "brX!,*f<UB",
        "60002": "nE,!v#6%8H",
        "60003": "!=3xC8LGrz",
        "60004": "%c^QLl!>f$",
        "60005": "WarVmy&ij+",
        "60006": "h>9hN&H+bD",
        "60007": "jsqm1g#gg0",
        "60008": "%JR_Z1zldi",
        "60009": "oPTq(Omg9e"
    }
}
```

保存并退出
```
:wq
```

### 更新系统
```
yum update -y
```

### 如果当前内核版本低于 4.10，可使用 ELRepo 源更新：
```
uname -r
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
sudo yum --enablerepo=elrepo-kernel install kernel-ml -y
rpm -qa | grep kernel
```

在输出中看到 kernel-ml-4.11.0-1.el7.elrepo.x86_64类似的内容(>=4.11版本)，表示安装成功

### 查看内核版本对应的位置并设置其为默认内核，再重启
```
sudo egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
sudo grub2-set-default 1
reboot
```

### 重启后查看内核版本
```
uname -r
```

### 添加优化内核以及启用bbr参数
```
vi /etc/sysctl.conf
```

### 输入以下内容
```
fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.rmem_default = 65536
net.core.wmem_default = 65536
net.core.netdev_max_backlog = 4096
net.core.somaxconn = 4096

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fast_open=3
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1

net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
```
### 使配置生效并查看bbr是否开启成功
```
sudo sysctl -p
sudo sysctl net.ipv4.tcp_available_congestion_control
sudo sysctl -n net.ipv4.tcp_congestion_control
lsmod | grep bbr
```

### 启动shadowsocks
```
startss
```
