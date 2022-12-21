import subprocess
import random

slave_ip_addresses = ["172.31.17.2", "172.31.17.3", "172.31.17.4"]

def get_slave_from_ip(ip_address: str) -> int:
    return slave_ip_addresses.index(ip_address) + 1


def get_fastest_ping_ip() -> str:
    """
    get_fastest_ping_ip uses a subprocess to ping each slave ip address only once and returns the ip address of the fastest responding node
    :return:    a string of the ip address of the fastest node
    """
    fastest_ping_ip = ""
    fastest_ping_time = 9999
    for ip_address in slave_ip_addresses:
        # ping ip address once
        ping_output = subprocess.run(["ping", "-c", "1", ip_address], capture_output=True)
        output_list = ping_output.stdout.split()
        for binary_element in output_list:
            # stringify the element of the output list
            string_element = binary_element.decode("utf-8")
            # extract the time
            if "time=" in string_element :
                ping_time = float(string_element.strip("time="))
                # get fastest time
                if ping_time < fastest_ping_time:
                    fastest_ping_time = ping_time
                    fastest_ping_ip = ip_address
    return fastest_ping_ip


def get_random_ip():
    """
    returns a random ip address from the list of slave ip addresses
    :return:    str ip address
    """
    return random.choice(slave_ip_addresses)

fastest_ping_ip = get_fastest_ping_ip()
print("Fastest worker is worker", get_slave_from_ip(fastest_ping_ip), "with ip address:", fastest_ping_ip)

random_ip = get_random_ip()
print("Random worker  is worker", get_slave_from_ip(random_ip), "with ip address:", random_ip)