# Module 4 - Topic 2: Variables, Arrays, and Special Parameters
## Hands-On Lab (5 minutes)

**Objective:** Use variables, arrays, and special parameters in scripts

---

## **Lab 4.2: Working with Variables (5 minutes)**

### **Setup**
```bash
# Navigate to Module 4 workspace (created in Topic 1)
cd ~/module4_lab

# If you skipped Topic 1, create folder and copy files:
# mkdir -p ~/module4_lab
# cp ~/module2_lab/*.log ~/module2_lab/*.csv ~/module2_lab/*.txt ~/module4_lab/

# Verify data files are present
ls -lh *.log *.csv *.txt
```

**Note:** You should have access.log, transactions.csv, employees.txt and other files from Module 2

---

### **Exercise 1: Simple Variables (2 minutes)**

**Task:** Create a script that generates a backup filename with timestamp

**Create script:**
```bash
nano backup_generator.sh
```

**Type this:**
```bash
#!/bin/bash

# Define variables
BACKUP_DIR="/backup"
DATE=$(date +%Y%m%d_%H%M%S)
SOURCE_FILE="transactions.csv"
BACKUP_NAME="${SOURCE_FILE%.csv}_$DATE.csv"

# Display backup information
echo "Backup Generator"
echo "================"
echo "Source: $SOURCE_FILE"
echo "Backup directory: $BACKUP_DIR"
echo "Backup filename: $BACKUP_NAME"
echo "Full path: $BACKUP_DIR/$BACKUP_NAME"

# Check if source exists
if [ -f "$SOURCE_FILE" ]; then
    echo "✓ Source file exists"
    FILESIZE=$(du -h "$SOURCE_FILE" | cut -f1)
    echo "  Size: $FILESIZE"
else
    echo "✗ Source file not found"
fi
```

**Run it:**
```bash
chmod +x backup_generator.sh
./backup_generator.sh
```

**Expected Output:** Shows backup filename with timestamp

---

### **Exercise 2: Command Substitution (1 minute)**

**Task:** Create a script that captures and displays system metrics

**Create script:**
```bash
nano metrics.sh
```

**Type this:**
```bash
#!/bin/bash

# Capture system metrics in variables
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
LOAD=$(uptime | awk -F'load average:' '{print $2}')
MEMORY_USED=$(free -h | grep Mem | awk '{print $3}')
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}')
PROCESS_COUNT=$(ps aux | wc -l)

# Display metrics
echo "=== System Metrics for $HOSTNAME ==="
echo "Uptime: $UPTIME"
echo "Load average: $LOAD"
echo "Memory used: $MEMORY_USED"
echo "Disk usage (root): $DISK_USAGE"
echo "Running processes: $PROCESS_COUNT"
```

**Run it:**
```bash
chmod +x metrics.sh
./metrics.sh
```

---

### **Exercise 3: Arrays (1 minute)**

**Task:** Create a script that checks multiple files

**Create script:**
```bash
nano file_checker.sh
```

**Type this:**
```bash
#!/bin/bash

# Array of files to check
FILES=("access.log" "transactions.csv" "employees.txt" "departments.txt" "nonexistent.txt")

echo "File Status Check"
echo "================="

# Check each file
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        LINES=$(wc -l < "$file")
        echo "✓ $file ($LINES lines)"
    else
        echo "✗ $file (NOT FOUND)"
    fi
done

echo ""
echo "Total files checked: ${#FILES[@]}"
```

**Run it:**
```bash
chmod +x file_checker.sh
./file_checker.sh
```

**Expected Output:** Status of each file, with line counts

---

### **Exercise 4: Special Variables (1 minute)**

**Task:** Create a script that uses command-line arguments

**Create script:**
```bash
nano search_log.sh
```

**Type this:**
```bash
#!/bin/bash

# Check if search term provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <search-term> [logfile]"
    echo "Example: $0 error access.log"
    exit 1
fi

# Get arguments
SEARCH_TERM=$1
LOGFILE=${2:-access.log}  # Default to access.log if not provided

echo "=== Log Search ==="
echo "Script: $0"
echo "Search term: $SEARCH_TERM"
echo "Log file: $LOGFILE"
echo "Total arguments: $#"
echo "All arguments: $@"
echo ""

# Search the log
if [ -f "$LOGFILE" ]; then
    MATCHES=$(grep -i "$SEARCH_TERM" "$LOGFILE" | wc -l)
    echo "Found $MATCHES matches for '$SEARCH_TERM' in $LOGFILE"
    echo ""
    echo "First 5 matches:"
    grep -i "$SEARCH_TERM" "$LOGFILE" | head -5
else
    echo "Error: $LOGFILE not found"
    exit 1
fi
```

**Run it different ways:**
```bash
chmod +x search_log.sh
./search_log.sh                    # No arguments - shows usage
./search_log.sh 500               # Search for 500 in access.log
./search_log.sh Completed transactions.csv   # Search in different file
```

---

### **Exercise 5: Exit Status Check (Bonus)**

**Task:** Create a script that checks command success

**Create script:**
```bash
nano command_check.sh
```

**Type this:**
```bash
#!/bin/bash

echo "Testing exit status..."
echo ""

# Test successful command
ls /tmp > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ ls /tmp succeeded (exit status: 0)"
else
    echo "✗ ls /tmp failed (exit status: $?)"
fi

# Test failing command
ls /nonexistent > /dev/null 2>&1
STATUS=$?
if [ $STATUS -eq 0 ]; then
    echo "✓ ls /nonexistent succeeded"
else
    echo "✗ ls /nonexistent failed (exit status: $STATUS)"
fi

# Check if file exists
FILE="access.log"
test -f $FILE
if [ $? -eq 0 ]; then
    echo "✓ File $FILE exists"
else
    echo "✗ File $FILE does not exist"
fi
```

**Run it:**
```bash
chmod +x command_check.sh
./command_check.sh
```

---

## **Verification Checklist**

- [ ] backup_generator.sh creates timestamped filename
- [ ] metrics.sh displays system information
- [ ] file_checker.sh checks array of files
- [ ] search_log.sh accepts and uses arguments
- [ ] Understand $1, $2, $#, $@, $?
- [ ] Can capture command output with $()

---

## **Quick Reference**

**Set variable:**
```bash
NAME="value"              # No spaces around =
PATH="/var/log"
COUNT=5
```

**Use variable:**
```bash
echo $NAME
echo ${NAME}              # Safer with braces
```

**Command substitution:**
```bash
RESULT=$(command)         # Preferred
RESULT=`command`          # Old style
```

**Arrays:**
```bash
ARRAY=("item1" "item2" "item3")
echo ${ARRAY[0]}          # First item
echo ${ARRAY[@]}          # All items
echo ${#ARRAY[@]}         # Count
```

**Special variables:**
```bash
$0          # Script name
$1, $2      # Arguments
$#          # Argument count
$@          # All arguments
$$          # Process ID
$?          # Exit status (0=success)
$USER       # Current user
$HOME       # Home directory
$PWD        # Current directory
```

---

## **Common Issues**

**Problem:** Variable not expanding
```bash
name=John
echo $name    # Works
echo name     # Just prints "name"
```

**Problem:** Spaces in assignment
```bash
VAR = value   # WRONG - spaces
VAR=value     # CORRECT
```

**Problem:** Using variable in string
```bash
echo "$NAME_file"     # Wrong - looks for NAME_file variable
echo "${NAME}_file"   # Correct - uses braces
```

---

## **Submission**

Save command history:
```bash
history | tail -30 > topic2_history.txt
```

List your scripts:
```bash
ls -l backup_generator.sh metrics.sh file_checker.sh search_log.sh
```
