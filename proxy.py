import random
from pythonping import ping
from sshtunnel import SSHTunnelForwarder
import pymysql

# Inser public IP addresses of slave and master
slave_ip_addresses = ["23.22.106.34", "34.228.41.30", "23.22.190.172"]
master_ip_address = "54.172.100.33"


def get_slave_from_ip(ip_address: str) -> int:
    """
    get the number of the slave node from the ip address
    :param ip_address:      the ip address
    :return:                the node number
    """
    return slave_ip_addresses.index(ip_address) + 1


def get_fastest_ping_ip() -> str:
    """
    get_fastest_ping_ip uses a subprocess to ping each slave ip address only once and returns the ip address of the fastest responding node
    :return:    a string of the ip address of the fastest node
    """
    fastest_ping_ip = ""
    fastest_ping_time = 9999
    for ip_address, i in enumerate(slave_ip_addresses):
        ping_time = ping(target=ip_address, count=1, timeout=2).rtt_avg_ms
        print("Ping time of slave", i + 1, ":", ping_time, "ms")
        if ping_time < fastest_ping_time:
            fastest_ping_time = ping_time
            fastest_ping_ip = ip_address

    return fastest_ping_ip


def get_random_ip() -> str:
    """
    Returns a random ip address from the list of slave ip addresses
    :return:    A random ip address
    """
    return random.choice(slave_ip_addresses)


def direct_hit():
    """
    Forwards request to master node
    """
    print("Forwarding to master node with ip address:", master_ip_address)
    forward_request_to_node(master_ip_address)

def random_hit():
    """
    Forwards request to a random slave node
    """
    random_ip = get_random_ip()
    print("Forwarding to random slave", get_slave_from_ip(random_ip), "with ip address:", random_ip)
    forward_request_to_node(random_ip)

def fastest_ping_hit():
    """
    Forwards request to the slave node with the fastest response time
    """
    fastest_ping_ip = get_fastest_ping_ip()
    print("Forwarding to fastest slave", get_slave_from_ip(fastest_ping_ip), "with ip address:", fastest_ping_ip)
    forward_request_to_node(fastest_ping_ip)

def forward_request_to_node(node_ip: str):
    """
    Forwards request to the node specified and prints the result of the operation
    :param node_ip:     The IP address of the node to forward to
    """
    with SSHTunnelForwarder(node_ip, ssh_username="ubuntu", ssh_pkey="vockey.pem", remote_bind_address=(master_ip_address, 3306)):
        client = pymysql.connect(host=master_ip_address, user="user", password="password", db="sakila", port=3306, autocommit=True)
        print(client)
        cursor = client.cursor()
        cursor.execute("SELECT * FROM store;")
        print(cursor.fetchall())
        client.close()



# Allow user to choose between direct, random or custom
user_choice="-1"
while user_choice not in ["direct", "random", "custom"]:
    user_choice = input("Write DIRECT, RANDOM or CUSTOM for the node to use:\n").lower()

if(user_choice == "direct"):
    direct_hit()
elif user_choice == "random":
    random_hit()
else:
    fastest_ping_hit()