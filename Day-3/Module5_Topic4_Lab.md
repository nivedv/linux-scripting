# Module 5 - Topic 4: Loops (for, while, until) and Loop Control
## Hands-On Lab (4 minutes)

**Objective:** Master FOR, WHILE loops and loop control

---

## **Lab 5.4: Loop Processing Scripts (4 minutes)**

### **Setup**
```bash
cd ~/module5_lab
```

---

### **Exercise 1: File Batch Processor (1.5 minutes)**

**Task:** Process multiple files with FOR loop

**Create script:**
```bash
nano batch_processor.sh
```

**Type this:**
```bash
#!/bin/bash

echo "=== Batch File Processor ==="
echo ""

TOTAL_FILES=0
TOTAL_LINES=0
TOTAL_SIZE=0

for file in *.log *.csv *.txt; do
    # Skip if glob didn't match
    if [ ! -f "$file" ]; then
        continue
    fi
    
    LINES=$(wc -l < "$file")
    SIZE=$(du -k "$file" | cut -f1)
    
    echo "File: $file"
    echo "  Lines: $LINES"
    echo "  Size: ${SIZE}KB"
    
    ((TOTAL_FILES++))
    ((TOTAL_LINES += LINES))
    ((TOTAL_SIZE += SIZE))
    echo ""
done

echo "================================"
echo "Summary:"
echo "  Total files: $TOTAL_FILES"
echo "  Total lines: $TOTAL_LINES"
echo "  Total size: ${TOTAL_SIZE}KB"
```

**Test:**
```bash
chmod +x batch_processor.sh
./batch_processor.sh
```

---

### **Exercise 2: Service Monitor (1.5 minutes)**

**Task:** Monitor services with WHILE loop

**Create script:**
```bash
nano service_monitor.sh
```

**Type this:**
```bash
#!/bin/bash

SERVICES=("ssh" "cron")
INTERVAL=5
MAX_CHECKS=3

echo "=== Service Monitor ==="
echo "Monitoring: ${SERVICES[@]}"
echo "Check interval: ${INTERVAL}s"
echo "Max checks: $MAX_CHECKS"
echo ""

CHECK=1
while [ $CHECK -le $MAX_CHECKS ]; do
    echo "--- Check $CHECK at $(date +%H:%M:%S) ---"
    
    for service in "${SERVICES[@]}"; do
        if systemctl is-active $service >/dev/null 2>&1; then
            echo "✓ $service is running"
        else
            echo "✗ $service is stopped"
        fi
    done
    
    ((CHECK++))
    
    if [ $CHECK -le $MAX_CHECKS ]; then
        echo ""
        echo "Waiting ${INTERVAL}s..."
        sleep $INTERVAL
        echo ""
    fi
done

echo ""
echo "Monitoring complete"
```

**Test:**
```bash
chmod +x service_monitor.sh
./service_monitor.sh
```

---

### **Exercise 3: Number Range Processor (1 minute)**

**Task:** Process number ranges with different loop styles

**Create script:**
```bash
nano number_processor.sh
```

**Type this:**
```bash
#!/bin/bash

echo "=== FOR loop with range ==="
for num in {1..5}; do
    echo "Number: $num"
done

echo ""
echo "=== C-style FOR loop ==="
for ((i=1; i<=5; i++)); do
    SQUARE=$((i * i))
    echo "$i squared = $SQUARE"
done

echo ""
echo "=== WHILE loop countdown ==="
COUNT=5
while [ $COUNT -gt 0 ]; do
    echo "Countdown: $COUNT"
    ((COUNT--))
    sleep 1
done
echo "Done!"

echo ""
echo "=== UNTIL loop (opposite of WHILE) ==="
COUNT=0
until [ $COUNT -eq 5 ]; do
    echo "Count: $COUNT"
    ((COUNT++))
done
```

**Test:**
```bash
chmod +x number_processor.sh
./number_processor.sh
```

---

### **Exercise 4: Log Error Finder (Bonus)**

**Task:** Search logs with loop control

**Create script:**
```bash
nano error_finder.sh
```

**Type this:**
```bash
#!/bin/bash

LOGFILE="access.log"
MAX_ERRORS=5
FOUND=0

echo "=== Error Finder ==="
echo "Searching $LOGFILE for errors (max: $MAX_ERRORS)"
echo ""

while read line; do
    # Check if line contains error
    if [[ $line =~ (404|500) ]]; then
        echo "Error found: $line"
        ((FOUND++))
        
        # Break if max reached
        if [ $FOUND -ge $MAX_ERRORS ]; then
            echo ""
            echo "Reached maximum ($MAX_ERRORS errors)"
            break
        fi
    fi
done < "$LOGFILE"

echo ""
echo "Total errors found: $FOUND"
```

**Test:**
```bash
chmod +x error_finder.sh
./error_finder.sh
```

---

## **Verification Checklist**

- [ ] batch_processor.sh loops through files
- [ ] service_monitor.sh uses WHILE loop
- [ ] number_processor.sh shows all loop types
- [ ] error_finder.sh uses break control
- [ ] Understand FOR, WHILE, UNTIL loops
- [ ] Can use break and continue
- [ ] Can use ((i++)) for incrementing

---

## **Quick Reference**

### **FOR Loop**
```bash
# List items
for item in item1 item2 item3; do
    commands
done

# Files
for file in *.txt; do
    commands
done

# Range
for num in {1..10}; do
    commands
done

# C-style
for ((i=1; i<=10; i++)); do
    commands
done
```

### **WHILE Loop**
```bash
while [ condition ]; do
    commands
done

# Counter
COUNT=0
while [ $COUNT -lt 5 ]; do
    echo $COUNT
    ((COUNT++))
done

# Read file
while read line; do
    echo $line
done < file.txt
```

### **UNTIL Loop**
```bash
until [ condition ]; do
    commands
done
```

### **Loop Control**
```bash
# Skip to next iteration
for item in list; do
    [ condition ] && continue
    process $item
done

# Exit loop
for item in list; do
    [ condition ] && break
    process $item
done
```

### **Infinite Loop**
```bash
while true; do
    commands
    [ condition ] && break
done
```

---

## **Submission**

```bash
history | tail -25 > topic4_history.txt
ls -l batch_processor.sh service_monitor.sh number_processor.sh error_finder.sh
```
