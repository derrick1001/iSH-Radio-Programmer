#!/usr/bin/python3.8

from netmiko import ConnectHandler
from time import sleep
from rich.progress import track
import colorama

# Auto reset color back to white after color call
colorama.init(autoreset=True)

# Colors we use
c_BLUE = f"{colorama.Style.BRIGHT}{colorama.Fore.BLUE}"
c_GREEN = f"{colorama.Style.BRIGHT}{colorama.Fore.GREEN}"
c_MAGENTA = f"{colorama.Style.BRIGHT}{colorama.Fore.MAGENTA}"
c_CYAN = f"{colorama.Style.BRIGHT}{colorama.Fore.CYAN}"
c_RED = f"{colorama.Style.BRIGHT}{colorama.Fore.RED}"

ip = input(f'{c_BLUE}IP-address: ')
user = input(f'{c_BLUE}User: ')
password = input(f'{c_BLUE}Password: ')
radio_type = input(f'{c_BLUE}HI or LO: ').upper()
product = input(f'{c_BLUE}820/850: ')

if product == '820':
    product = '820S'
elif product == '850':
    product = '850C'

band = input(f'{c_BLUE}Freq: ')


def connect_to_radio(ip_add='192.168.1.1', user='admin', password='admin'):
    device = {'device_type': 'generic',
              'host': ip_add,
              'username': user,
              'password': password,
              'fast_cli': False
              }
    conn = ConnectHandler(**device)
    return conn


con = connect_to_radio(ip, user, password)


def countdown(second):
    for n in track(range(second), description=f'{c_GREEN}Rebooting...'):
        sleep(1)


def refresh(cmd):
    while True:
        output = con.send_command(cmd)
        print(output)
        if 'all components exist' in output:
            print(f'{c_CYAN}Software is up to date.', end='\r')
            break
        elif 'Nothing to Update' in output:
            print(f'{c_CYAN}Already up to date', end='\r')
            break
        elif '100' in output:
            break
        elif 'download in progress' in output:
            parse_string = output.split()
            print(
                f"{c_CYAN}{parse_string[8].capitalize()} {c_CYAN}{parse_string[9].capitalize()} {c_MAGENTA}{parse_string[10].capitalize()}", end='\r')
            sleep(10)
        elif 'install started' or 'installation in progress' in output:
            parse_string = output.split()
            print(
                f"{c_CYAN}{parse_string[8].capitalize()} {c_CYAN}{parse_string[9].capitalize()} {c_MAGENTA}{parse_string[10].capitalize()}", end='\r')
            sleep(10)
        else:
            continue


def software_dl():
    dl_software = 'platform software download version protocol ftp'
    if product == '820S':
        set_software_param = f'platform software download channel server set server-ip 192.168.1.30 directory /home/derrick/Documents/{product}-Builds/{product}-12-0/ username derrick password Guitarpro2'
    elif product == '850C':
        set_software_param = f'platform software download channel server set server-ip 192.168.1.30 directory /home/derrick/Documents/{product}-Builds/{product}-12-3/ username derrick password Guitarpro2'
    status = 'platform software download status show'

    con.send_command(set_software_param)
    con.send_command(dl_software,
                     expect_string='Software Version to Download')
    con.send_command('yes\n',
                     expect_string='root>',
                     delay_factor=2
                     )
    print(f'{c_GREEN}Downloading software..')
    sleep(2)
    refresh(status)
    sleep(3)
    print(f'{c_GREEN}Software successfully downloaded.')
    sleep(2)
    print(f'{c_GREEN}Upgrading firmware..')
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
    sleep(3)
    print(f'{c_GREEN}Installation complete.')
    sleep(2)
    countdown(260)
    import_func(band, radio_type)


def import_func(band, radio_type):
    if product == '820S':
        set_template_params = f'platform configuration channel server set ip-address 192.168.1.30 directory /home/derrick/Documents/{product}-Builds/ filename {product}-12-0-{band}-{radio_type}-template.zip username derrick password Guitarpro2'
    elif product == '850C':
        set_template_params = f'platform configuration channel server set ip-address 192.168.1.30 directory /home/derrick/Documents/{product}-Builds/ filename {product}-12-3-{band}-{radio_type}-template.zip username derrick password Guitarpro2'
    import_template = 'platform configuration configuration-file import restore-point-1'
    restore_template = 'platform configuration configuration-file restore restore-point-1'
    con = connect_to_radio(ip, user, password)

    con.send_command(set_template_params)
    con.send_command(import_template,
                     expect_string='WARNING: This will replace the existing configuration file.',)
    con.send_command('yes\n',
                     expect_string='root>',)
    print(f'{c_GREEN}Importing template..')
    sleep(2)
    while True:
        output = con.send_command('platform configuration channel show status')
        if 'succeeded' in output:
            print(f'{c_GREEN}File transfer complete..')
            break
        elif 'failure' in output:
            print(f'{c_RED}Something went wrong..')
            break
        else:
            print(f'{c_CYAN}Validating..', end='\r')
    sleep(2)
    print(f'{c_GREEN}Restoring configuration..')
    sleep(2)
    con.send_command(restore_template,
                     expect_string='WARNING: This will replace the working configuration. System will reboot.')
    if product == '850C':
        output = con.send_command('yes\n',
                                  expect_string='root>')
        print(f'{c_GREEN}Done..')
        sleep(1)
        countdown(170)
    else:
        output = con.send_command('yes\n',
                                  expect_string='The system is going down for reboot NOW!')
        if 'NOW!' in output:
            print(f'{c_GREEN}Done..')
        else:
            print(f'{c_RED}Something went wrong')
        sleep(1)
        countdown(250)
    if radio_type == 'LO':
        set_lo_ip()
    else:
        print(f'{c_GREEN}Radio configured!!')
        sleep(1)


def set_lo_ip():
    set_ip = 'platform management ip set ipv4-address 192.168.1.2 subnet 255.255.255.0 gateway 192.168.1.1'
    con = connect_to_radio(ip, user, password)
    print(f'{c_CYAN}Changing IP..', end='\r')
    con.send_command(set_ip, expect_string="")
    con.disconnect()
    sleep(2)
    print(f'{c_GREEN}Radio configured!!')


def gather_info():

    print(f'{c_GREEN}Gathering info..')
    sleep(1)
    print(f'{c_CYAN}Checking firmware..', end='\r')
    sleep(2)
    output = con.send_command('platform software show versions')
    if product == '850C' and '12.3' in output:
        print(f'{c_GREEN}Firmware up to date..')
        sleep(2)
        import_func(band, radio_type)
    elif product == '820S' and '12.0' in output:
        print(f'{c_GREEN}Firmware up to date..')
        sleep(2)
        import_func(band, radio_type)
    else:
        software_dl()


# gather_info()
set_lo_ip()
