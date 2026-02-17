# Shell Tricks

Advanced shell techniques and lesser-known features.

---

## Bash Tricks

### Run previous command with sudo
```bash
sudo !!
```

### Repeat last argument
```bash
command $_
# or
command !$
```

### Repeat last command starting with...
```bash
!ssh    # runs last command starting with 'ssh'
```

### Quick substitution
```bash
^old^new    # run previous command replacing 'old' with 'new'
```

### Brace expansion
```bash
echo {1..10}           # 1 2 3 4 5 6 7 8 9 10
echo {a..z}            # a b c d ... z
echo file{1,2,3}.txt   # file1.txt file2.txt file3.txt
mkdir -p dir/{sub1,sub2,sub3}
```

### Command substitution
```bash
echo "Today is $(date)"
for file in $(ls *.txt); do echo $file; done
```

### Process substitution
```bash
diff <(ls dir1) <(ls dir2)
```

### Here strings
```bash
cat <<< "This is a here string"
```

## Job Control

### Run command in background
```bash
command &
```

### Bring job to foreground
```bash
fg %1
```

### Send job to background
```bash
bg %1
# or Ctrl+Z then bg
```

### List jobs
```bash
jobs
```

### Disown a process
```bash
disown %1
```

## Redirection

### Redirect stdout and stderr to file
```bash
command > file 2>&1
# or (bash 4+)
command &> file
```

### Redirect stderr only
```bash
command 2> errors.log
```

### Append to file
```bash
command >> file
```

### Discard output
```bash
command > /dev/null 2>&1
```

### Tee output to file and screen
```bash
command | tee output.log
```

## Arrays

### Define array
```bash
arr=("one" "two" "three")
```

### Access array elements
```bash
echo ${arr[0]}      # first element
echo ${arr[@]}      # all elements
echo ${#arr[@]}     # array length
```

### Loop through array
```bash
for item in "${arr[@]}"; do
  echo "$item"
done
```

## String Manipulation

### Get string length
```bash
str="hello"
echo ${#str}    # 5
```

### Substring extraction
```bash
str="hello world"
echo ${str:0:5}     # hello
echo ${str:6}       # world
```

### String replacement
```bash
str="hello world"
echo ${str/world/universe}    # hello universe
echo ${str//o/0}              # hell0 w0rld (all occurrences)
```

### Remove prefix/suffix
```bash
file="document.txt"
echo ${file%.txt}    # document (remove suffix)
echo ${file#doc}     # ument.txt (remove prefix)
```

## Parameter Expansion

### Default values
```bash
echo ${var:-default}    # use default if var is unset
echo ${var:=default}    # set var to default if unset
```

### Required values
```bash
echo ${var:?error message}    # exit if var is unset
```

## Useful Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+A` | Move to beginning of line |
| `Ctrl+E` | Move to end of line |
| `Ctrl+U` | Delete from cursor to beginning |
| `Ctrl+K` | Delete from cursor to end |
| `Ctrl+W` | Delete word before cursor |
| `Ctrl+R` | Search command history |
| `Ctrl+L` | Clear screen |
| `Ctrl+Z` | Suspend current process |
| `Ctrl+C` | Kill current process |
| `Ctrl+D` | Exit shell |

## Globbing

### Match any characters
```bash
ls *.txt        # any .txt file
ls file?.txt    # file1.txt, file2.txt, etc.
ls file[1-3].txt  # file1.txt, file2.txt, file3.txt
```

### Extended globbing (enable with `shopt -s extglob`)
```bash
ls !(*.txt)     # all except .txt files
ls +(ab|cd)     # one or more of ab or cd
ls ?(ab|cd)     # zero or one of ab or cd
```

## Conditional Execution

### AND operator
```bash
command1 && command2    # run command2 only if command1 succeeds
```

### OR operator
```bash
command1 || command2    # run command2 only if command1 fails
```

### Combine operators
```bash
command1 && command2 || command3
```
