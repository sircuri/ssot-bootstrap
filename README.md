# ssot-bootstrap

# Temporary disable IPv6?
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1 && \
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1 && \
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1

# Permanent disabled IPv6?
sudo nano /etc/default/grub
FROM:
GRUB_CMDLINE_LINUX_DEFAULT=""
TO:
GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1"

sudo update-grub

# Disable ipv randomizer
netsh interface ipv6 set global randomizeidentifiers=disable

# Start script

wget --inet4-only -O bootstrap.sh https://raw.githubusercontent.com/sircuri/ssot-bootstrap/main/bootstrap.sh && bash bootstrap.sh

# Clean docker comtainers

docker volume rm -f $(docker volume ls -f "dangling=true")
