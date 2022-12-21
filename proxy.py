import subprocess

slave_ip_addresses = ["172.31.17.2", "172.31.17.3", "172.31.17.4"]

def get_fastest_ping_ip() -> str:
    fastest_ping_ip = ""
    fastest_ping_time = 9999
    for ip_address in slave_ip_addresses:
        ping_output = subprocess.run(["ping", "-c", "1", ip_address], capture_output=True)
        output_list = ping_output.stdout.split()
        for binary_element in output_list:
            string_element = binary_element.decode("utf-8")
            if "time=" in string_element :
                ping_time = float(string_element.strip("time="))
                if ping_time < fastest_ping_time:
                    fastest_ping_time = ping_time
                    fastest_ping_ip = ip_address
    return fastest_ping_ip

fastest_ping_ip = get_fastest_ping_ip()
print("Fastest worker is worker", slave_ip_addresses.index(fastest_ping_ip) + 1, "with ip address:", fastest_ping_ip)


"""

"""