
import subprocess

slave_ip_addresses = ["172.31.17.2", "172.31.17.3", "172.31.17.4"]
fastest_ping_ip = ""
fastest_ping_time = 9999

def get_fastest_ping_ip() -> str:
    for ip_address in slave_ip_addresses:
        output = subprocess.run(["ping", "-c", "1", ip_address], capture_output=True)
        ping_time = output.stdout.split()[-2].split("/")[1]
        if ping_time < fastest_ping_time:
            fastest_ping_time = ping_time
            fastest_ping_ip = ip_address
    return fastest_ping_ip


print(get_fastest_ping_ip)