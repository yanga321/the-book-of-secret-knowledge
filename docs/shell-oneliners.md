# Shell One-liners

Useful command-line one-liners for system administration, networking, and security.

---

## Terminal

### Reload shell without exit
```bash
exec $SHELL -l
```

### Close shell keeping subprocesses running
```bash
disown -a && exit
```

### Exit without saving shell history
```bash
kill -9 $$
# or
unset HISTFILE && exit
```

### List most used commands
```bash
history | \
awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | \
grep -v "./" | \
column -c3 -s " " -t | \
sort -nr | nl | head -n 20
```

### Quickly backup a file
```bash
cp filename{,.orig}
```

### Empty a file (truncate to 0 size)
```bash
>filename
```

### Create directory and cd into it
```bash
mkd() { mkdir -p "$@" && cd "$@"; }
```

## File System

### Find files by name
```bash
find /path -name "filename"
```

### Find files modified in last 7 days
```bash
find /path -mtime -7
```

### Find and delete empty directories
```bash
find /path -type d -empty -delete
```

### Find large files
```bash
find / -type f -size +100M
```

### Count files in directory
```bash
find . -type f | wc -l
```

### Disk usage sorted by size
```bash
du -sh * | sort -rh | head -20
```

## Process Management

### List all processes
```bash
ps auxf
```

### Find process by name
```bash
pgrep -fl processname
```

### Kill process by name
```bash
pkill -9 processname
```

### List open files by process
```bash
lsof -p PID
```

### Show processes using a file
```bash
fuser -v /path/to/file
```

## Networking

### Show all listening ports
```bash
netstat -tulpn
# or
ss -tulpn
```

### Check if port is open
```bash
nc -zv host port
```

### Download file
```bash
curl -O http://example.com/file
wget http://example.com/file
```

### Get public IP
```bash
curl ifconfig.me
curl icanhazip.com
```

### DNS lookup
```bash
dig domain.com
host domain.com
nslookup domain.com
```

## SSH

### Copy SSH key to remote server
```bash
ssh-copy-id user@host
```

### SSH tunnel (local port forwarding)
```bash
ssh -L local_port:remote_host:remote_port user@ssh_server
```

### SSH tunnel (remote port forwarding)
```bash
ssh -R remote_port:local_host:local_port user@ssh_server
```

### Run command on remote server
```bash
ssh user@host 'command'
```

### Copy file to remote server
```bash
scp file.txt user@host:/path/
```

## Text Processing

### Count lines in file
```bash
wc -l filename
```

### Search for pattern in files
```bash
grep -r "pattern" /path
```

### Replace text in file
```bash
sed -i 's/old/new/g' filename
```

### Extract column from output
```bash
awk '{print $1}' filename
```

### Sort and remove duplicates
```bash
sort filename | uniq
```

## OpenSSL

### Generate self-signed certificate
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem
```

### Check certificate expiration
```bash
openssl x509 -enddate -noout -in cert.pem
```

### Test SSL connection
```bash
openssl s_client -connect host:443
```

### Generate random password
```bash
openssl rand -base64 32
```

## System Information

### Show system info
```bash
uname -a
```

### Show memory usage
```bash
free -h
```

### Show disk usage
```bash
df -h
```

### Show CPU info
```bash
lscpu
cat /proc/cpuinfo
```

### Show logged in users
```bash
who
w
```

## tcpdump

### Capture packets on interface
```bash
tcpdump -i eth0
```

### Capture and save to file
```bash
tcpdump -i eth0 -w capture.pcap
```

### Filter by host
```bash
tcpdump host 192.168.1.1
```

### Filter by port
```bash
tcpdump port 80
```

## nmap

### Scan single host
```bash
nmap 192.168.1.1
```

### Scan all ports
```bash
nmap -p- host
```

### Service version detection
```bash
nmap -sV host
```

### OS detection
```bash
nmap -O host
```

### Stealth scan
```bash
nmap -sS host
```

## Git

### Undo last commit (keep changes)
```bash
git reset --soft HEAD~1
```

### Show changes in commit
```bash
git show commit_hash
```

### Search commit history
```bash
git log --grep="search term"
```

### Show file at specific commit
```bash
git show commit_hash:filename
```

### Clean untracked files
```bash
git clean -fd
```
