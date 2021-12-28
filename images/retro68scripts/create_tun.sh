#tunctl -t tun9 # does not work
sudo openvpn --mktun --dev tun9
ifconfig tun9 192.168.0.244 up      
route add -host 192.168.0.245 dev tun9
bash -c 'echo 1 > /proc/sys/net/ipv4/conf/tun9/proxy_arp'
arp -Ds 192.168.1.52 enp0s3 pub

