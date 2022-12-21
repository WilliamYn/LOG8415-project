import subprocess
import random

slave_ip_addresses = ["172.31.17.2", "172.31.17.3", "172.31.17.4"]
master_ip_address = "172.31.17.1"

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


def direct_hit():
    print("Forwarding to master node with ip address:", master_ip_address)

def random_hit():
    random_ip = get_random_ip()
    print("Forwarding to random slave", get_slave_from_ip(random_ip), "with ip address:", random_ip)

def fastest_ping_hit():
    fastest_ping_ip = get_fastest_ping_ip()
    print("Forwarding to fastest slave", get_slave_from_ip(fastest_ping_ip), "with ip address:", fastest_ping_ip)



user_choice="-1"
while user_choice not in ["direct", "random", "custom"]:
    user_choice = input("Write DIRECT, RANDOM or CUSTOM for the node to use:\n").lower()

if(user_choice == "direct"):
    direct_hit()
elif user_choice == "random":
    random_hit()
else:
    fastest_ping_hit()
