# Shell Functions

Reusable shell functions for common tasks.

---

## File Operations

### Create directory and cd into it
```bash
mkcd() {
  mkdir -p "$1" && cd "$1"
}
```

### Extract any archive
```bash
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.tar.xz)    tar xJf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
```

### Backup file with timestamp
```bash
backup() {
  cp "$1" "$1.$(date +%Y%m%d%H%M%S).bak"
}
```

### Find files by content
```bash
ftext() {
  grep -rnw . -e "$1"
}
```

## Networking

### Get public IP
```bash
myip() {
  curl -s ifconfig.me
}
```

### Check if port is open
```bash
portcheck() {
  nc -zv "$1" "$2" 2>&1
}
```

### Quick HTTP server
```bash
serve() {
  local port="${1:-8000}"
  python3 -m http.server "$port"
}
```

### Get SSL certificate info
```bash
sslinfo() {
  echo | openssl s_client -connect "$1:443" 2>/dev/null | openssl x509 -noout -text
}
```

## System

### Show top processes by memory
```bash
topmem() {
  ps aux --sort=-%mem | head -n "${1:-10}"
}
```

### Show top processes by CPU
```bash
topcpu() {
  ps aux --sort=-%cpu | head -n "${1:-10}"
}
```

### Show disk usage sorted
```bash
dusort() {
  du -sh "${1:-.}"/* 2>/dev/null | sort -rh | head -20
}
```

### Kill process by name
```bash
killbyname() {
  pkill -9 -f "$1"
}
```

## Git

### Git status short
```bash
gs() {
  git status -sb
}
```

### Git log pretty
```bash
gl() {
  git log --oneline --graph --decorate -n "${1:-20}"
}
```

### Git add, commit, push
```bash
gacp() {
  git add -A && git commit -m "$1" && git push
}
```

### Git branch cleanup
```bash
gbclean() {
  git branch --merged | grep -v '\*\|main\|master' | xargs -n 1 git branch -d
}
```

## Development

### Create Python virtual environment
```bash
mkvenv() {
  python3 -m venv "${1:-.venv}" && source "${1:-.venv}/bin/activate"
}
```

### JSON pretty print
```bash
jsonpp() {
  cat "$1" | python3 -m json.tool
}
```

### Generate random password
```bash
genpass() {
  openssl rand -base64 "${1:-32}" | tr -d '\n'
  echo
}
```

### Quick calculator
```bash
calc() {
  echo "scale=2; $*" | bc
}
```

## Docker

### Stop all containers
```bash
dstopall() {
  docker stop $(docker ps -aq)
}
```

### Remove all containers
```bash
drmall() {
  docker rm $(docker ps -aq)
}
```

### Remove all images
```bash
drmiall() {
  docker rmi $(docker images -q)
}
```

### Docker cleanup
```bash
dclean() {
  docker system prune -af --volumes
}
```

### Docker shell into container
```bash
dexec() {
  docker exec -it "$1" /bin/bash || docker exec -it "$1" /bin/sh
}
```

## Miscellaneous

### Timer
```bash
timer() {
  local seconds="$1"
  while [ "$seconds" -gt 0 ]; do
    echo -ne "$seconds\033[0K\r"
    sleep 1
    : $((seconds--))
  done
  echo "Time's up!"
}
```

### Weather
```bash
weather() {
  curl -s "wttr.in/${1:-}"
}
```

### Cheat sheet
```bash
cheat() {
  curl -s "cheat.sh/$1"
}
```

### QR code generator
```bash
qrcode() {
  echo "$1" | curl -F-=\<- qrenco.de
}
```

## Add to Your Shell

Add these functions to your `~/.bashrc` or `~/.zshrc`:

```bash
# Source custom functions
if [ -f ~/.bash_functions ]; then
  . ~/.bash_functions
fi
```
