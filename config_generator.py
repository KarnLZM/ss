import json
import string
import random


def password_generator(
        size=8,
        chars=string.ascii_letters + string.digits + '!@#$%^&*()<>,.;:=-+_'):
    """
    Returns a string of random characters, useful in generating temporary
    passwords for automated password resets.

    size: default=8; override to provide smaller/larger passwords
    chars: default=A-Za-z0-9; override to provide more/less diversity

    Credit: Ignacio Vasquez-Abrams
    Source: http://stackoverflow.com/a/2257449
    """
    return ''.join(random.choice(chars) for i in range(size))


config = {}
config['server'] = 'codingdiary.cn'
config['local_address'] = '127.0.0.1'
config['local_port'] = 1080
config['timeout'] = 300
config['method'] = 'chacha20-ietf-poly1305'
config['fast_open'] = False
config['port_password'] = {}

for port in range(40000, 40100):
    config['port_password'][port] = password_generator(10)

with open('ss.json', 'w') as f:
    json.dump(config, f, indent=4)
