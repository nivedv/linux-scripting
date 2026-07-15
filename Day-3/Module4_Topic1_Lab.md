# Module 4 - Topic 1: Shebang and Script Execution Methods
## Hands-On Lab (5 minutes)

**Objective:** Create and execute your first bash scripts

---

## **Lab 4.1: Script Creation and Execution (5 minutes)**

### **Setup**
```bash
# Create Module 4 workspace
mkdir -p ~/module4_lab

# Copy data files from Module 2 folder
cp ~/module2_lab/*.log ~/module2_lab/*.csv ~/module2_lab/*.txt ~/module4_lab/

# Navigate to Module 4 directory
cd ~/module4_lab

# Verify files are present
ls -lh
```

**Expected files:** access.log, transactions.csv, employees.txt, departments.txt, fruits1.txt, fruits2.txt, large_numbers.txt

---

### **Exercise 1: Create Your First Script (2 minutes)**

**Task:** Create a script that displays system information

**Steps:**
```bash
# 1. Create the script file
nano my_first_script.sh
```

**Type this in nano:**
```bash
#!/bin/bash
# My First Script
echo "================================"
echo "System Information Report"
echo "================================"
echo "Hostname: $(hostname)"
echo "Current User: $(whoami)"
echo "Current Directory: $(pwd)"
echo "Date: $(date)"
echo "================================"
```

**Save:** Ctrl+X, Y, Enter

**2. Check the file:**
```bash
ls -l my_first_script.sh
```

**Question:** Can you execute it yet? Why or why not?

---

### **Exercise 2: Make Executable and Run (1 minute)**

**Task:** Make the script executable and run it using all three methods

**Commands:**
```bash
# Make it executable
chmod +x my_first_script.sh

# Verify permissions changed
ls -l my_first_script.sh

# Method 1: Run directly
./my_first_script.sh

# Method 2: Run with bash
bash my_first_script.sh

# Method 3: Source it
source my_first_script.sh
```

**Question:** Did all three methods produce the same output?

---

### **Exercise 3: Create a Log Checker Script (2 minutes)**

**Task:** Create a script that checks for errors in access.log

**Commands:**
```bash
nano log_checker.sh
```

**Type this:**
```bash
#!/bin/bash
echo "=== Log Error Check ==="
echo "File: access.log"
echo ""
echo "Error entries (status 500):"
grep " 500 " access.log | wc -l
echo ""
echo "Not Found entries (status 404):"
grep " 404 " access.log | wc -l
echo ""
echo "Last 5 error entries:"
grep -E " (404|500) " access.log | tail -5
```

**Save and run:**
```bash
chmod +x log_checker.sh
./log_checker.sh
```

**Expected Output:** Count of 500 errors, 404 errors, and last 5 error lines

---

### **Exercise 4: Create a File List Script (Optional Bonus)**

**Task:** Create a script that lists files with details

**Commands:**
```bash
nano file_report.sh
```

**Type this:**
```bash
#!/bin/bash
echo "Files in current directory:"
echo "=========================="
ls -lh
echo ""
echo "Total files: $(ls -1 | wc -l)"
echo "Total disk usage: $(du -sh . | cut -f1)"
```

**Make executable and run:**
```bash
chmod +x file_report.sh
./file_report.sh
```

---

## **Verification Checklist**

- [ ] Created my_first_script.sh with shebang
- [ ] Successfully changed permissions with chmod +x
- [ ] Ran script using ./script.sh
- [ ] Created log_checker.sh
- [ ] Script displays error counts correctly
- [ ] Understand the three execution methods

---

## **Quick Reference**

**Create script:**
```bash
nano scriptname.sh
# First line: #!/bin/bash
# Add commands
# Save: Ctrl+X, Y, Enter
```

**Make executable:**
```bash
chmod +x scriptname.sh
```

**Run script:**
```bash
./scriptname.sh          # Method 1 (most common)
bash scriptname.sh       # Method 2 (no chmod needed)
source scriptname.sh     # Method 3 (runs in current shell)
```

---

## **Common Issues**

**Problem:** Permission denied
**Solution:** Run `chmod +x scriptname.sh`

**Problem:** Command not found
**Solution:** Use `./scriptname.sh` not just `scriptname.sh`

**Problem:** Bad interpreter
**Solution:** Check shebang is `#!/bin/bash` (no spaces before #)

---

## **Submission**

Save your command history:
```bash
history | tail -20 > topic1_history.txt
```

Verify your scripts exist:
```bash
ls -l *.sh
```

**Expected files:**
- my_first_script.sh
- log_checker.sh
- file_report.sh (bonus)
