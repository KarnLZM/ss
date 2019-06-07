# DigitalOcean搭建V2Ray并且配置多用户

### 领取学生优惠并购买DigitalOcean服务器
1. 若是学生，可以使用edu邮箱注册一个github账号，登陆后前往https://education.github.com/pack
找到DigitalOcean优惠并点击requestyour offer code to get access申请50刀DigitalOcean优惠码。若不是学生，直接到第2步。

2. 通过我分享的邀请链接：https://m.do.co/c/aca03a5dab85 注册DigitalOcean账号，可以额外获得10刀的优惠码。若执行了第1步，注册成功后登陆DigitalOcean，左边侧边栏点击Billing，拉到页面最下方找到PromoCode，输入申请到的50刀DigitalOcean优惠码，即可收到50刀账户余额。需注意的是，注册时会让你绑定支付方式，若没有信用卡，可以先去Paypal官网https://www.paypal.com/c2/signup/singlePageAccount 注册一个账号并在Paypal里绑定借记卡，绑定时先充值5刀到DigitalOcean账户里，日后在DigitalOcean里用该Paypal账号付款即可。

3. 登录DigitalOcean后，点击右上方的Create，再点击Droplets新建一个VPS。系统选CentOS 64。价位选择的最低档5刀一个月（plan默认是40刀/月，需点击←箭头按钮即可看到5刀/月的配置）, 这配置绝对足够用。机房推荐选San Francisco，强烈建议在创建服务器时点击添加SSH Key（New SSH Key），这样无需密码便可登录，更加安全高效，若不知如何生成SSH Key，请看这篇文章：https://www.jianshu.com/p/31cbbbc5f9fa。 接下来点击create即可。稍等几秒，系统便会装好。

4. 接下来打开终端（windows打开powershell或cmd），用以下命令连接服务器：
```
ssh root@你的服务器ip
```

接下来正式开始搭梯子！

### 安装V2Ray
```
sudo yum -y install wget
wget https://install.direct/go.sh
sudo yum -y install zip unzip 
sudo bash go.sh

echo "alias restartv2ray='systemctl restart v2ray'" >> ~/.bash_profile
echo "alias stopv2ray='systemctl stop v2ray'" >> ~/.bash_profile
echo "alias startv2ray='systemctl start v2ray'" >> ~/.bash_profile
source ~/.bash_profile
```

### 安装BBRPlus
```
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
```
先输入2，安装 BBRplus版内核，安装完之后会提示重启系统，重启之后再运行脚本，输入7，使用BBRplus版加速，一键安装，很方便，
该脚本可以多次运行，当看到提示：当前状态：已安装 BBRplus加速内核，BBRplus启动成功，表示加速成功。

### 修改配置
```
rm -rf /etc/v2ray/config.json
vi /etc/v2ray/config.json
```
按```i```开始编辑，输入以下内容后，按```esc```键退出编辑模式，再保存并退出```(:wq)```
```
{
  "inbounds": [{
    "port": 29120,
    "protocol": "vmess",
    "settings": {
      "clients": [{
          "id": "282f3803-f9fc-4f47-bf39-4a029af9ef5e",
          "level": 1,
          "alterId": 64
        },
        {
          "id": "4a015114-f8a8-4c5e-8b3a-b87ba50a6112",
          "level": 1,
          "alterId": 64
        },
        {
          "id": "6fad80a7-6237-4f00-9bad-837211e05e0d",
          "level": 1,
          "alterId": 64
        },
        {
          "id": "2717a3b6-d27a-41a7-8caa-bfd37affcbaa",
          "level": 1,
          "alterId": 64
        },
        {
          "id": "ad4476e3-f880-4ace-a4ad-b9d4e51bb0aa",
          "level": 1,
          "alterId": 64
        },
        {
          "id": "0a70d166-a0cd-4492-b177-b027d58be327",
          "level": 1,
          "alterId": 64
        },
        {
          "id": "02eee8af-244d-4aeb-b3b8-727b27d178be",
          "level": 1,
          "alterId": 64
        },
        {
          "id": "63363856-cb28-4682-8141-8de4b2e61132",
          "level": 1,
          "alterId": 64
        },
        {
          "id": "89f5c207-b921-43ea-bdbf-d227b33e9e4a",
          "level": 1,
          "alterId": 64
        },
        {
          "id": "55e3bfc3-bc6c-49a9-93ea-d47e1b3c90c3",
          "level": 1,
          "alterId": 64
        },
        {
          "id": "0bb972e6-2690-40b6-a9cd-3b191b342793",
          "level": 1,
          "alterId": 64
        }
      ]
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }, {
    "protocol": "blackhole",
    "settings": {},
    "tag": "blocked"
  }],
  "routing": {
    "rules": [{
      "type": "field",
      "ip": ["geoip:private"],
      "outboundTag": "blocked"
    }]
  }
}
```
上述配置中clients表示用户配置，我配置了十几个用户，客户端配置要和该配置一一对应。

### 优化内核
```
vi /etc/sysctl.conf
```

### 添加以下内容
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
```

### 使参数生效
```
sudo sysctl -p
```

### 启动V2Ray
```
startv2ray
```

### 配置客户端
各平台客户端下载及配置可以参考https://ssr.tools/314
客户端配置中地址（服务器）填你的服务器ip, id（密码）填上面配置的clients的其中一个id，alterId填64，加密方式建议选auto.

### Note
V2Ray有时会不稳定，发生断连，但是很安全，不会被墙掉。Shadowsocks虽然稳定，但是会被墙掉=-=
