# Module 5 - Topic 2: Test Operators and Comparisons
## Hands-On Lab (3 minutes)

**Objective:** Master test operators for different data types

---

## **Lab 5.2: Test Operator Practice (3 minutes)**

### **Setup**
```bash
cd ~/module5_lab
```

---

### **Exercise 1: File Permission Checker (1 minute)**

**Task:** Check file permissions comprehensively

**Create script:**
```bash
nano permission_check.sh
```

**Type this:**
```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

FILE=$1

echo "=== Permission Checker ==="
echo "File: $FILE"
echo ""

if [ ! -e "$FILE" ]; then
    echo "✗ File does not exist"
    exit 1
fi

if [ -f "$FILE" ]; then
    echo "✓ Regular file"
elif [ -d "$FILE" ]; then
    echo "✓ Directory"
elif [ -L "$FILE" ]; then
    echo "✓ Symbolic link"
fi

echo ""
echo "Permissions:"
[ -r "$FILE" ] && echo "✓ Readable" || echo "✗ Not readable"
[ -w "$FILE" ] && echo "✓ Writable" || echo "✗ Not writable"
[ -x "$FILE" ] && echo "✓ Executable" || echo "✗ Not executable"

if [ -s "$FILE" ]; then
    SIZE=$(du -h "$FILE" | cut -f1)
    echo ""
    echo "✓ File is not empty ($SIZE)"
else
    echo ""
    echo "⚠ File is empty"
fi
```

**Test:**
```bash
chmod +x permission_check.sh
./permission_check.sh access.log
./permission_check.sh permission_check.sh
```

---

### **Exercise 2: Number Range Validator (1 minute)**

**Task:** Validate numeric input against ranges

**Create script:**
```bash
nano number_validator.sh
```

**Type this:**
```bash
#!/bin/bash

read -p "Enter a number (1-100): " NUM

# Check if it's a number
if ! [[ "$NUM" =~ ^[0-9]+$ ]]; then
    echo "✗ Error: Not a valid number"
    exit 1
fi

echo ""
echo "Number: $NUM"

# Range checks
if [ $NUM -lt 1 ]; then
    echo "✗ Too low (minimum: 1)"
elif [ $NUM -gt 100 ]; then
    echo "✗ Too high (maximum: 100)"
else
    echo "✓ Valid range"
    
    # Category
    if [ $NUM -le 25 ]; then
        echo "Category: LOW (1-25)"
    elif [ $NUM -le 50 ]; then
        echo "Category: MEDIUM (26-50)"
    elif [ $NUM -le 75 ]; then
        echo "Category: HIGH (51-75)"
    else
        echo "Category: CRITICAL (76-100)"
    fi
fi
```

**Test:**
```bash
chmod +x number_validator.sh
./number_validator.sh
```

**Try:** 50, 150, abc, 90

---

### **Exercise 3: String Pattern Matcher (1 minute)**

**Task:** Use pattern matching with double brackets

**Create script:**
```bash
nano pattern_matcher.sh
```

**Type this:**
```bash
#!/bin/bash

echo "=== Pattern Matcher ==="
echo ""

read -p "Enter text: " TEXT

if [ -z "$TEXT" ]; then
    echo "✗ Input is empty"
    exit 1
fi

echo ""
echo "Text: $TEXT"
echo "Length: ${#TEXT} characters"
echo ""

# Pattern checks
if [[ $TEXT =~ ^[0-9]+$ ]]; then
    echo "✓ Contains only digits"
elif [[ $TEXT =~ ^[a-zA-Z]+$ ]]; then
    echo "✓ Contains only letters"
elif [[ $TEXT =~ ^[a-zA-Z0-9]+$ ]]; then
    echo "✓ Contains letters and digits"
else
    echo "✓ Contains special characters"
fi

# Specific patterns
if [[ $TEXT =~ [A-Z] ]]; then
    echo "✓ Contains uppercase letters"
fi

if [[ $TEXT =~ [0-9] ]]; then
    echo "✓ Contains numbers"
fi

if [[ $TEXT =~ @ ]]; then
    echo "✓ Contains @ symbol (possible email)"
fi

if [[ $TEXT =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]]; then
    echo "✓ Matches phone format (XXX-XXX-XXXX)"
fi
```

**Test:**
```bash
chmod +x pattern_matcher.sh
./pattern_matcher.sh
```

**Try:** hello, Hello123, 555-123-4567, test@email.com

---

## **Verification Checklist**

- [ ] permission_check.sh tests file properties
- [ ] number_validator.sh validates numeric ranges
- [ ] pattern_matcher.sh uses regex patterns
- [ ] Understand -f, -d, -r, -w, -x, -s operators
- [ ] Understand -eq, -ne, -gt, -lt, -ge, -le
- [ ] Can use [[ ]] for pattern matching

---

## **Quick Reference**

### **File Tests**
```bash
[ -f file ]     # Regular file
[ -d dir ]      # Directory
[ -e path ]     # Exists
[ -r file ]     # Readable
[ -w file ]     # Writable
[ -x file ]     # Executable
[ -s file ]     # Not empty
[ -L link ]     # Symbolic link
```

### **String Tests**
```bash
[ -z "$str" ]   # Empty
[ -n "$str" ]   # Not empty
[ "$a" = "$b" ] # Equal
[ "$a" != "$b" ]# Not equal
[[ $str =~ pattern ]]  # Regex match
```

### **Numeric Tests**
```bash
[ $a -eq $b ]   # Equal
[ $a -ne $b ]   # Not equal
[ $a -gt $b ]   # Greater than
[ $a -lt $b ]   # Less than
[ $a -ge $b ]   # Greater or equal
[ $a -le $b ]   # Less or equal
```

---

## **Submission**

```bash
history | tail -20 > topic2_history.txt
ls -l permission_check.sh number_validator.sh pattern_matcher.sh
```
