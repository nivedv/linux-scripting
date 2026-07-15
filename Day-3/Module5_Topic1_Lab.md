# Module 5 - Topic 1: Conditional Statements (if-then-else, elif)
## Hands-On Lab (4 minutes)

**Objective:** Master IF-ELIF-ELSE conditional logic

---

## **Lab 5.1: Multi-condition Decision Script (4 minutes)**

### **Setup**
```bash
# Create Module 5 workspace
mkdir -p ~/module5_lab

# Copy data files from Module 2
cp ~/module2_lab/*.log ~/module2_lab/*.csv ~/module2_lab/*.txt ~/module5_lab/

# Navigate to Module 5 directory
cd ~/module5_lab

# Verify files
ls -lh
```

---

### **Exercise 1: Service Status Checker (1 minute)**

**Task:** Create a script that checks service status and offers actions

**Create script:**
```bash
nano service_check.sh
```

**Type this:**
```bash
#!/bin/bash

# Check if service name provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <service-name>"
    exit 1
fi

SERVICE=$1

echo "=== Service Status Check ==="
echo "Service: $SERVICE"
echo ""

# Check if service is active
if systemctl is-active $SERVICE >/dev/null 2>&1; then
    echo "✓ $SERVICE is RUNNING"
    
    # Check if enabled for boot
    if systemctl is-enabled $SERVICE >/dev/null 2>&1; then
        echo "✓ Will start on boot"
    else
        echo "⚠ Will NOT start on boot"
        read -p "Enable for boot? (y/n): " ENABLE
        if [ "$ENABLE" = "y" ]; then
            echo "Run: sudo systemctl enable $SERVICE"
        fi
    fi
else
    echo "✗ $SERVICE is STOPPED"
    read -p "Start the service? (y/n): " START
    if [ "$START" = "y" ]; then
        echo "Run: sudo systemctl start $SERVICE"
    fi
fi
```

**Test it:**
```bash
chmod +x service_check.sh
./service_check.sh ssh
./service_check.sh nonexistent
```

---

### **Exercise 2: File Age Checker (1 minute)**

**Task:** Check file age and recommend cleanup

**Create script:**
```bash
nano file_age.sh
```

**Type this:**
```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

FILENAME=$1

echo "=== File Age Checker ==="

# Check if file exists
if [ ! -f "$FILENAME" ]; then
    echo "Error: $FILENAME not found"
    exit 1
fi

# Get file age in days
AGE=$(find "$FILENAME" -mtime +0 -printf '%Ay\n' 2>/dev/null | head -1)
if [ -z "$AGE" ]; then
    AGE=0
fi

SIZE=$(du -h "$FILENAME" | cut -f1)

echo "File: $FILENAME"
echo "Size: $SIZE"
echo "Age: $AGE days"
echo ""

# Make recommendation based on age
if [ $AGE -gt 365 ]; then
    echo "🗑 ARCHIVE: File is over 1 year old"
    echo "   Recommendation: Move to archive storage"
elif [ $AGE -gt 90 ]; then
    echo "📦 OLD: File is over 90 days old"
    echo "   Recommendation: Review and archive if not needed"
elif [ $AGE -gt 30 ]; then
    echo "ℹ AGING: File is over 30 days old"
    echo "   Recommendation: Monitor for archival"
else
    echo "✓ RECENT: File is current"
    echo "   Recommendation: Keep active"
fi
```

**Test it:**
```bash
chmod +x file_age.sh
./file_age.sh access.log
./file_age.sh transactions.csv
```

---

### **Exercise 3: User Input Validator (2 minutes)**

**Task:** Create a menu with input validation

**Create script:**
```bash
nano menu_validator.sh
```

**Type this:**
```bash
#!/bin/bash

echo "==================================="
echo "   System Administration Menu"
echo "==================================="
echo "1. Check disk space"
echo "2. Check memory usage"
echo "3. List running services"
echo "4. Show system uptime"
echo "5. Exit"
echo "==================================="

read -p "Enter your choice (1-5): " CHOICE

# Validate input is a number
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]]; then
    echo "Error: Invalid input. Must be a number."
    exit 1
fi

# Validate range
if [ $CHOICE -lt 1 ] || [ $CHOICE -gt 5 ]; then
    echo "Error: Choice must be between 1 and 5"
    exit 1
fi

echo ""

# Execute based on choice
if [ $CHOICE -eq 1 ]; then
    echo "=== Disk Space ==="
    df -h /
elif [ $CHOICE -eq 2 ]; then
    echo "=== Memory Usage ==="
    free -h
elif [ $CHOICE -eq 3 ]; then
    echo "=== Running Services ==="
    systemctl list-units --type=service --state=running | head -10
elif [ $CHOICE -eq 4 ]; then
    echo "=== System Uptime ==="
    uptime
elif [ $CHOICE -eq 5 ]; then
    echo "Goodbye!"
    exit 0
fi
```

**Test it:**
```bash
chmod +x menu_validator.sh
./menu_validator.sh
```

**Try different inputs:** 1, 3, abc, 10, 5

---

## **Verification Checklist**

- [ ] service_check.sh checks service status
- [ ] file_age.sh categorizes files by age
- [ ] menu_validator.sh validates user input
- [ ] Understand IF-ELIF-ELSE chains
- [ ] Can use test operators (-f, -d, -gt, -eq)
- [ ] Can combine conditions with && and ||

---

## **Quick Reference**

### **IF Statement Syntax**
```bash
if [ condition ]; then
    commands
elif [ condition ]; then
    commands
else
    commands
fi
```

### **File Test Operators**
```bash
[ -f file ]     # File exists and is regular file
[ -d dir ]      # Directory exists
[ -e path ]     # Path exists
[ -r file ]     # Readable
[ -w file ]     # Writable
[ -x file ]     # Executable
[ -s file ]     # Not empty
```

### **String Test Operators**
```bash
[ -z "$str" ]   # String is empty
[ -n "$str" ]   # String is not empty
[ "$a" = "$b" ] # Strings equal
[ "$a" != "$b" ]# Strings not equal
```

### **Numeric Test Operators**
```bash
[ $a -eq $b ]   # Equal
[ $a -ne $b ]   # Not equal
[ $a -gt $b ]   # Greater than
[ $a -lt $b ]   # Less than
[ $a -ge $b ]   # Greater or equal
[ $a -le $b ]   # Less or equal
```

### **Combining Conditions**
```bash
[ cond1 ] && [ cond2 ]  # AND
[ cond1 ] || [ cond2 ]  # OR
[ ! cond ]              # NOT
```

### **Command as Condition**
```bash
if command; then
    echo "Success"
fi

if systemctl is-active sshd; then
    echo "SSH running"
fi
```

---

## **Common Patterns**

### **Check and act**
```bash
if [ -f "$FILE" ]; then
    process_file "$FILE"
else
    echo "File not found"
fi
```

### **Validate before processing**
```bash
if [ $# -eq 0 ]; then
    echo "Usage: $0 <arg>"
    exit 1
fi
```

### **Multiple thresholds**
```bash
if [ $VALUE -gt 90 ]; then
    echo "Critical"
elif [ $VALUE -gt 80 ]; then
    echo "Warning"
else
    echo "OK"
fi
```

---

## **Submission**

```bash
history | tail -20 > topic1_history.txt
ls -l service_check.sh file_age.sh menu_validator.sh
```
