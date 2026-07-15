# Module 4 - Topic 3: Command-line Arguments and User Input
## Hands-On Lab (5 minutes)

**Objective:** Master command-line arguments and interactive user input

---

## **Lab 4.3: Argument Parsing and Processing (5 minutes)**

### **Setup**
```bash
# Navigate to Module 4 workspace (created in Topic 1)
cd ~/module4_lab

# If you skipped earlier topics, create folder and copy files:
# mkdir -p ~/module4_lab
# cp ~/module2_lab/*.log ~/module2_lab/*.csv ~/module2_lab/*.txt ~/module4_lab/

# Verify data files are present
ls -lh *.log *.csv *.txt
```

**Note:** You need access.log, transactions.csv and other Module 2 files for these exercises

---

### **Exercise 1: Simple Argument Script (1 minute)**

**Task:** Create a script that displays file information based on argument

**Create script:**
```bash
nano file_info.sh
```

**Type this:**
```bash
#!/bin/bash

# Check if filename provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    echo "Example: $0 access.log"
    exit 1
fi

FILENAME=$1

# Check if file exists
if [ ! -f "$FILENAME" ]; then
    echo "Error: $FILENAME not found"
    exit 1
fi

# Display file information
echo "=== File Information ==="
echo "File: $FILENAME"
echo "Size: $(du -h "$FILENAME" | cut -f1)"
echo "Lines: $(wc -l < "$FILENAME")"
echo "Words: $(wc -w < "$FILENAME")"
echo "Last modified: $(stat -c %y "$FILENAME" 2>/dev/null || stat -f %Sm "$FILENAME")"
echo ""
echo "First 3 lines:"
head -3 "$FILENAME"
```

**Test it:**
```bash
chmod +x file_info.sh
./file_info.sh                    # No argument - shows usage
./file_info.sh access.log         # With argument
./file_info.sh transactions.csv   # Different file
```

---

### **Exercise 2: Multiple Arguments (1 minute)**

**Task:** Create a script that processes multiple filenames

**Create script:**
```bash
nano multi_file_check.sh
```

**Type this:**
```bash
#!/bin/bash

# Check if arguments provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file1> [file2] [file3] ..."
    echo "Example: $0 access.log transactions.csv"
    exit 1
fi

echo "=== File Status Check ==="
echo "Checking $# files..."
echo ""

# Process each argument
for file in "$@"; do
    if [ -f "$file" ]; then
        SIZE=$(du -h "$file" | cut -f1)
        LINES=$(wc -l < "$file")
        echo "✓ $file - $SIZE, $LINES lines"
    else
        echo "✗ $file - NOT FOUND"
    fi
done

echo ""
echo "Total files checked: $#"
```

**Test it:**
```bash
chmod +x multi_file_check.sh
./multi_file_check.sh access.log transactions.csv employees.txt nonexistent.txt
```

---

### **Exercise 3: Interactive Input (1 minute)**

**Task:** Create an interactive log analyzer

**Create script:**
```bash
nano interactive_log.sh
```

**Type this:**
```bash
#!/bin/bash

echo "=== Interactive Log Analyzer ==="
echo ""

# Get log file
read -p "Enter log filename [access.log]: " LOGFILE
LOGFILE=${LOGFILE:-access.log}

# Validate file
if [ ! -f "$LOGFILE" ]; then
    echo "Error: $LOGFILE not found"
    exit 1
fi

# Get search term
read -p "Enter search term: " SEARCH

# Validate search term
if [ -z "$SEARCH" ]; then
    echo "Error: Search term cannot be empty"
    exit 1
fi

# Ask for case sensitivity
read -p "Case-sensitive search? (y/n) [n]: " CASE_SENSITIVE
CASE_SENSITIVE=${CASE_SENSITIVE:-n}

# Perform search
echo ""
echo "Searching for '$SEARCH' in $LOGFILE..."
echo ""

if [ "$CASE_SENSITIVE" = "y" ]; then
    RESULTS=$(grep "$SEARCH" "$LOGFILE")
    COUNT=$(echo "$RESULTS" | grep -c .)
else
    RESULTS=$(grep -i "$SEARCH" "$LOGFILE")
    COUNT=$(echo "$RESULTS" | grep -c .)
fi

echo "Found $COUNT matches:"
echo "$RESULTS"
```

**Test it:**
```bash
chmod +x interactive_log.sh
./interactive_log.sh
```

**Enter when prompted:**
- Filename: `access.log` (or just press Enter)
- Search: `200`
- Case-sensitive: `n`

---

### **Exercise 4: Hybrid Script (2 minutes)**

**Task:** Create a script that works with arguments OR interactively

**Create script:**
```bash
nano flexible_search.sh
```

**Type this:**
```bash
#!/bin/bash

echo "=== Flexible Search Script ==="
echo ""

# Get search term (argument or interactive)
if [ $# -ge 1 ]; then
    SEARCH=$1
    echo "Search term from argument: $SEARCH"
else
    read -p "Enter search term: " SEARCH
fi

# Validate search term
if [ -z "$SEARCH" ]; then
    echo "Error: Search term required"
    exit 1
fi

# Get filename (argument or interactive)
if [ $# -ge 2 ]; then
    LOGFILE=$2
    echo "Log file from argument: $LOGFILE"
else
    read -p "Enter log file [access.log]: " LOGFILE
    LOGFILE=${LOGFILE:-access.log}
fi

# Validate file
if [ ! -f "$LOGFILE" ]; then
    echo "Error: $LOGFILE not found"
    exit 1
fi

# Display search info
echo ""
echo "Searching for: '$SEARCH'"
echo "In file: $LOGFILE"
echo ""

# Perform search
MATCHES=$(grep -i "$SEARCH" "$LOGFILE" | wc -l)
echo "Found $MATCHES matches"
echo ""

# Ask if user wants to see results
if [ $MATCHES -gt 0 ]; then
    if [ $MATCHES -le 10 ]; then
        echo "Results:"
        grep -i "$SEARCH" "$LOGFILE"
    else
        read -p "Show all $MATCHES results? (y/n): " SHOW_ALL
        if [ "$SHOW_ALL" = "y" ]; then
            grep -i "$SEARCH" "$LOGFILE" | less
        else
            echo "First 10 results:"
            grep -i "$SEARCH" "$LOGFILE" | head -10
        fi
    fi
fi
```

**Test both ways:**
```bash
chmod +x flexible_search.sh
./flexible_search.sh 200 access.log     # With arguments
./flexible_search.sh                    # Interactive mode
```

---

### **Exercise 5: Validation Practice (Bonus)**

**Task:** Create a script with comprehensive input validation

**Create script:**
```bash
nano validate_input.sh
```

**Type this:**
```bash
#!/bin/bash

echo "=== Input Validation Demo ==="
echo ""

# Function to validate yes/no input
validate_yn() {
    if [ "$1" != "y" ] && [ "$1" != "n" ]; then
        return 1
    fi
    return 0
}

# Get and validate filename
while true; do
    read -p "Enter filename: " FILENAME
    
    if [ -z "$FILENAME" ]; then
        echo "Error: Filename cannot be empty. Try again."
        continue
    fi
    
    if [ ! -f "$FILENAME" ]; then
        echo "Error: File not found. Try again."
        continue
    fi
    
    break
done

echo "✓ Valid file: $FILENAME"

# Get and validate number
while true; do
    read -p "How many lines to display? (1-100): " NUM_LINES
    
    if ! [[ "$NUM_LINES" =~ ^[0-9]+$ ]]; then
        echo "Error: Must be a number. Try again."
        continue
    fi
    
    if [ "$NUM_LINES" -lt 1 ] || [ "$NUM_LINES" -gt 100 ]; then
        echo "Error: Must be between 1 and 100. Try again."
        continue
    fi
    
    break
done

echo "✓ Valid number: $NUM_LINES"

# Get and validate yes/no
while true; do
    read -p "Show with line numbers? (y/n): " SHOW_NUMBERS
    
    if validate_yn "$SHOW_NUMBERS"; then
        break
    fi
    
    echo "Error: Enter 'y' or 'n'. Try again."
done

echo "✓ Valid choice: $SHOW_NUMBERS"

# Display results
echo ""
echo "=== Results ==="

if [ "$SHOW_NUMBERS" = "y" ]; then
    head -n "$NUM_LINES" "$FILENAME" | nl
else
    head -n "$NUM_LINES" "$FILENAME"
fi
```

**Test it:**
```bash
chmod +x validate_input.sh
./validate_input.sh
```

---

## **Verification Checklist**

- [ ] file_info.sh accepts filename argument
- [ ] multi_file_check.sh processes multiple files
- [ ] interactive_log.sh asks user for input
- [ ] flexible_search.sh works both ways
- [ ] Understand $1, $2, $#, $@
- [ ] Can use read with prompts
- [ ] Can validate user input

---

## **Quick Reference**

**Check argument count:**
```bash
if [ $# -eq 0 ]; then
    echo "Usage: $0 <arg1> <arg2>"
    exit 1
fi
```

**Access arguments:**
```bash
FIRST=$1
SECOND=$2
ALL="$@"
COUNT=$#
```

**Default values:**
```bash
LOGFILE=${1:-access.log}    # Use $1 or default
PORT=${2:-8080}              # Use $2 or 8080
```

**Read user input:**
```bash
read -p "Prompt: " VAR       # With prompt
read -s PASSWORD             # Silent (password)
read -t 5 VAR                # 5 second timeout
read -n 1 KEY                # Single character
```

**Validate input:**
```bash
# Empty check
if [ -z "$VAR" ]; then
    echo "Empty"
fi

# File exists
if [ ! -f "$FILE" ]; then
    echo "Not found"
fi

# Number check
if [[ "$NUM" =~ ^[0-9]+$ ]]; then
    echo "Valid number"
fi
```

---

## **Common Patterns**

**Usage message:**
```bash
if [ $# -eq 0 ]; then
    echo "Usage: $0 <required> [optional]"
    exit 1
fi
```

**Argument with default:**
```bash
ARG=${1:-default_value}
```

**Loop through arguments:**
```bash
for arg in "$@"; do
    echo "Processing: $arg"
done
```

**Confirmation prompt:**
```bash
read -p "Continue? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    exit 0
fi
```

---

## **Submission**

Save command history:
```bash
history | tail -30 > topic3_history.txt
```

List your scripts:
```bash
ls -l file_info.sh multi_file_check.sh interactive_log.sh flexible_search.sh
```
