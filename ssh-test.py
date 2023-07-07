#!/usr/bin/python3.8

from netmiko import ConnectHandler
from subprocess import run
from time import sleep

ip = input('IP-address: ')
user = input('User: ')
password = input('Password: ')


def connect_to_radio(ip, user, password):
    device = {'device_type': 'generic',
              'host': ip,
              'username': user,
              'password': password,
              'fast_cli': False
              }
    conn = ConnectHandler(**device)
    return conn


con = connect_to_radio(ip='192.168.1.1', user='admin', password='admin')


def refresh(cmd):
    while True:
        output = con.send_command(cmd)
        if '100' in output:
            print(output)
            sleep(2)
            break
        else:
            print(output)
            sleep(10)


def software_dl():
    dl_software = 'platform software download version protocol ftp'
    set_software_param = 'platform software download channel server set server-ip 192.168.1.30 directory sd1/820S-Builds/820S-11-9/ username RSI-Admin password can0py_BAM'
    status = 'platform software download status show'

    con.send_command(set_software_param)
    con.send_command(dl_software,
                     expect_string='Software Version to Download')
    con.send_command('yes\n',
                     expect_string='root>',
                     delay_factor=2
                     )
    refresh(status)
    print('Software successfully uploaded.')
    sleep(2)
    print('Upgrading firmware now..')
    install_func()


def install_func():
    install_software = 'platform software install version'
    status = 'platform software install status show'
    con.send_command(install_software,
                     expect_string=r'Software version to be installed:')
    con.send_command('yes\n',
                     expect_string='root>',
                     delay_factor=2
                     )
    refresh(status)
    print('Installation complete.')
    sleep(2)
    print('Rebooting...')
    sleep(180)


def import_func(radio_type):
    set_template_params = f'platform configuration channel server set ip-address 192.168.1.30 directory sd1/820S-Builds/ filename 820S-12-0-{radio_type}-template.zip username RSI-Admin password can0py_BAM'
    import_template = 'platform configuration configuration-file import restore-point-1'
    restore_template = 'platform configuration configuration-file restore restore-point-1'

    con.send_command(set_template_params)
    con.send_command(import_template,
                     expect_string='WARNING: This will replace the existing configuration file.',)
    con.send_command('yes\n',
                     expect_string='root>',)
    while True:
        output = con.send_command('platform configuration channel show status')
        if 'succeeded' in output:
            print('File transfer complete..')
            break
        elif 'failure' in output:
            print('Something went wrong..')
            break
        else:
            print(output)


software_dl()
# import_func(input('HI or LO: ').upper())
