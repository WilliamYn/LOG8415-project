import random
from pythonping import ping
from sshtunnel import SSHTunnelForwarder
import pymysql

# todo public ip addresses
# slave_ip_addresses = ["172.31.17.2", "172.31.17.3", "172.31.17.4"]
slave_ip_addresses = ["23.22.106.34", "34.228.41.30", "23.22.190.172"]
# master_ip_address = "172.31.17.1"
master_ip_address = "54.172.100.33" # TODO change public ip of master

def get_slave_from_ip(ip_address: str) -> int:
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


def get_random_ip():
    """
    returns a random ip address from the list of slave ip addresses
    :return:    str ip address
    """
    return random.choice(slave_ip_addresses)


def direct_hit():
    print("Forwarding to master node with ip address:", master_ip_address)
    forward_request_to_node(master_ip_address)

def random_hit():
    random_ip = get_random_ip()
    print("Forwarding to random slave", get_slave_from_ip(random_ip), "with ip address:", random_ip)
    forward_request_to_node(random_ip)

def fastest_ping_hit():
    fastest_ping_ip = get_fastest_ping_ip()
    print("Forwarding to fastest slave", get_slave_from_ip(fastest_ping_ip), "with ip address:", fastest_ping_ip)
    forward_request_to_node(fastest_ping_ip)

def forward_request_to_node(node_ip: str):
    with SSHTunnelForwarder(node_ip, ssh_username="ubuntu", ssh_pkey="vockey.pem", remote_bind_address=(master_ip_address, 3306)):
        client = pymysql.connect(host=master_ip_address, user="user", password="password", db="sakila", port=3306, autocommit=True)
        print(client)
        cursor = client.cursor()
        cursor.execute("SELECT * FROM store;")
        print(cursor.fetchall())
        client.close()

user_choice="-1"
while user_choice not in ["direct", "random", "custom"]:
    user_choice = input("Write DIRECT, RANDOM or CUSTOM for the node to use:\n").lower()

if(user_choice == "direct"):
    direct_hit()
elif user_choice == "random":
    random_hit()
else:
    fastest_ping_hit()


"""
 # TODO: change public ip address to the one in proxy
rapport: https://support.infrasightlabs.com/troubleshooting/host-is-not-allowed-to-connect-to-this-mysql-server/#:~:text=This%20error%20occurs%20due%20to,not%20other%20IP%20address%20ranges.
"""