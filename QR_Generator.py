import qrcode
import sys
import json
import base64

print(sys.argv[1])
with open(sys.argv[1]) as fp:
    document = json.load(fp)
    method = document['method']
    hostname = document['server']
    for port, password in document['port_password'].items():
        url = '{}:{}@{}:{}'.format(method, password, hostname, port)
        burl = b'ss://' + base64.b64encode(url.encode())
        img = qrcode.make(burl)
        img.save('QR/{}.png'.format(port))
