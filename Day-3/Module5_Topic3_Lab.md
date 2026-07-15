# Module 5 - Topic 3: Case Statements for Menu-Driven Scripts
## Hands-On Lab (4 minutes)

**Objective:** Build menu-driven scripts with case statements

---

## **Lab 5.3: Menu-Driven System Tool (4 minutes)**

### **Setup**
```bash
cd ~/module5_lab
```

---

### **Exercise 1: Log Viewer Menu (2 minutes)**

**Task:** Create menu to view different log types

**Create script:**
```bash
nano log_viewer.sh
```

**Type this:**
```bash
#!/bin/bash

echo "==================================="
echo "        Log Viewer Menu"
echo "==================================="
echo "1. View access.log (last 10 lines)"
echo "2. Search access.log for errors"
echo "3. Count lines in access.log"
echo "4. Show access.log file size"
echo "5. Exit"
echo "==================================="

read -p "Enter choice [1-5]: " CHOICE

LOGFILE="access.log"

case $CHOICE in
    1)
        echo ""
        echo "=== Last 10 lines of $LOGFILE ==="
        tail -10 "$LOGFILE"
        ;;
    2)
        echo ""
        echo "=== Errors in $LOGFILE ==="
        grep -E " (404|500) " "$LOGFILE" | tail -20
        ;;
    3)
        LINES=$(wc -l < "$LOGFILE")
        echo ""
        echo "Total lines: $LINES"
        ;;
    4)
        SIZE=$(du -h "$LOGFILE" | cut -f1)
        echo ""
        echo "File size: $SIZE"
        ;;
    5)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo ""
        echo "✗ Invalid choice. Please select 1-5."
        exit 1
        ;;
esac
```

**Test:**
```bash
chmod +x log_viewer.sh
./log_viewer.sh
```

**Try choices:** 1, 2, 4, 9

---

### **Exercise 2: Service Manager (2 minutes)**

**Task:** Create service management menu

**Create script:**
```bash
nano service_manager.sh
```

**Type this:**
```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    read -p "Enter service name: " SERVICE
else
    SERVICE=$1
fi

echo ""
echo "==================================="
echo "  Service Manager: $SERVICE"
echo "==================================="
echo "1. Check status"
echo "2. Check if enabled"
echo "3. Show recent logs"
echo "4. Exit"
echo "==================================="

read -p "Enter choice [1-4]: " CHOICE

case $CHOICE in
    1)
        echo ""
        systemctl is-active $SERVICE >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "✓ $SERVICE is RUNNING"
        else
            echo "✗ $SERVICE is STOPPED"
        fi
        ;;
    2)
        echo ""
        systemctl is-enabled $SERVICE >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "✓ $SERVICE is ENABLED (starts on boot)"
        else
            echo "✗ $SERVICE is DISABLED (won't start on boot)"
        fi
        ;;
    3)
        echo ""
        echo "=== Recent logs for $SERVICE ==="
        sudo journalctl -u $SERVICE -n 10 --no-pager 2>/dev/null || echo "Cannot read logs"
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo ""
        echo "✗ Invalid choice"
        exit 1
        ;;
esac
```

**Test:**
```bash
chmod +x service_manager.sh
./service_manager.sh ssh
./service_manager.sh
```

---

### **Exercise 3: File Action Menu (Bonus)**

**Task:** Menu for file operations

**Create script:**
```bash
nano file_actions.sh
```

**Type this:**
```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

FILE=$1

if [ ! -f "$FILE" ]; then
    echo "Error: $FILE not found"
    exit 1
fi

while true; do
    echo ""
    echo "==================================="
    echo "  File Actions: $FILE"
    echo "==================================="
    echo "1. View content"
    echo "2. Count lines"
    echo "3. Show file info"
    echo "4. Search in file"
    echo "5. Exit"
    echo "==================================="
    
    read -p "Enter choice [1-5]: " CHOICE
    
    case $CHOICE in
        1)
            echo ""
            cat "$FILE"
            ;;
        2)
            LINES=$(wc -l < "$FILE")
            echo ""
            echo "Lines: $LINES"
            ;;
        3)
            echo ""
            ls -lh "$FILE"
            file "$FILE"
            ;;
        4)
            read -p "Enter search term: " TERM
            echo ""
            grep -i "$TERM" "$FILE" || echo "No matches found"
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo ""
            echo "✗ Invalid choice"
            ;;
    esac
    
    read -p "Press Enter to continue..."
done
```

**Test:**
```bash
chmod +x file_actions.sh
./file_actions.sh access.log
```

---

## **Verification Checklist**

- [ ] log_viewer.sh displays menu choices
- [ ] service_manager.sh handles service operations
- [ ] file_actions.sh loops menu until exit
- [ ] Understand case syntax and patterns
- [ ] Can use wildcard (*) for default
- [ ] Can use (|) for multiple patterns

---

## **Quick Reference**

### **Case Statement Syntax**
```bash
case $VAR in
    pattern1)
        commands
        ;;
    pattern2)
        commands
        ;;
    *)
        default commands
        ;;
esac
```

### **Pattern Examples**
```bash
case $CHOICE in
    1) action1 ;;           # Exact match
    [Yy]) yes_action ;;     # Character class
    y|yes) yes_action ;;    # Multiple patterns
    *.txt) text_action ;;   # Wildcard
    *) default ;;           # Catch-all
esac
```

### **Menu Loop Pattern**
```bash
while true; do
    # Display menu
    read -p "Choice: " CHOICE
    case $CHOICE in
        exit_option) break ;;
        *) handle_choice ;;
    esac
done
```

---

## **Submission**

```bash
history | tail -20 > topic3_history.txt
ls -l log_viewer.sh service_manager.sh file_actions.sh
```
