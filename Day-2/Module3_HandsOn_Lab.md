# Module 3: Regular Expressions - Deep Dive
## Hands-On Lab - Practice Exercises

**Module:** Regular Expressions - Deep Dive  
**Duration:** 30-35 minutes  
**Total Exercises:** 16 required + 4 bonus challenges  
**Lab Files:** module3_demo_files (same as trainer demos)

---

## **Lab Objectives**

By the end of this lab, you will be able to:
- ✅ Extract structured data (emails, IPs) using regex patterns
- ✅ Parse and analyze system logs with complex patterns
- ✅ Validate data formats (emails, hostnames, IP addresses)
- ✅ Use grep with various flags (-E, -P, -o, -v, -i, -n, -c)
- ✅ Apply regex to real-world security and automation scenarios
- ✅ Build complex patterns incrementally
- ✅ Combine regex with pipes for data analysis

---

## **Lab Setup Instructions**

### **Step 1: Navigate to Your Lab Directory**

```bash
cd ~
```

### **Step 2: Extract the Demo Files (if not already done)**

```bash
# If you have the zip file:
unzip module3_demo_files.zip

# Navigate to the demo files directory:
cd module3_demo_files

# OR if files are already extracted:
cd module3_demo_files
```

### **Step 3: Verify All Files Are Present**

```bash
ls -lh
```

**Expected files:**
- system.log
- access.log
- email_list.txt
- servers.txt
- config.conf
- passwd.txt
- firewall_rules.txt
- setup_demo.sh
- README.txt

### **Step 4: Run the Setup Script (Recommended)**

```bash
bash setup_demo.sh
```

This will verify your environment and create a helpful cheat sheet.

### **Step 5: Create Your Lab Working Directory**

```bash
# Create a directory for your lab work
mkdir -p ~/module3_lab
cd ~/module3_lab

# Copy all demo files here
cp ~/module3_demo_files/*.log ~/module3_demo_files/*.txt ~/module3_demo_files/*.conf .

# Verify files copied
ls -lh
```

**You are now ready to begin!**

---

## **PART 1: Email Extraction and Validation (6-8 minutes)**

### **Lab 1.1: Extract All Emails from Configuration File**

**Task:** Extract all email addresses from the `config.conf` file.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Use `grep -oE` for extended regex and output only matching parts
- Email pattern: `[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}`
- Work with file: `config.conf`

**Expected Output:** List of email addresses like:
```
admin@company.com
backup@company.com
alerts@monitoring.company.com
...
```

**Verification:** Count how many emails you found:
```bash
# Your command | wc -l
```
Expected count: Should find 7-8 email addresses

---

### **Lab 1.2: Extract Unique Email Domains**

**Task:** Extract just the domain part (after @) from all emails in `config.conf`, and show unique domains.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- First extract emails, then use `cut -d'@' -f2` or `sed` to get domain part
- Use `sort -u` to get unique domains
- Pattern to extract what comes after @: `grep -oP '@\K[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'`

**Expected Output:**
```
company.com
monitoring.company.com
```

---

### **Lab 1.3: Validate Email Addresses**

**Task:** From `email_list.txt`, find all VALID email addresses.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Use anchors: `^` (start) and `$` (end) to match the entire line
- Pattern: `^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`
- Use `grep -E`

**Expected Output:** List of valid emails (should be around 10)

**Verification:** How many valid emails are there?
```bash
# Your command | wc -l
```

---

### **Lab 1.4: Find INVALID Email Addresses**

**Task:** From `email_list.txt`, find all INVALID email addresses for cleanup.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Use `grep -vE` to INVERT the match (show non-matching lines)
- Same pattern as Lab 1.3, but with `-v` flag
- These are emails that need to be fixed or removed

**Expected Output:** List of malformed emails like:
```
invalid@email
support@company
user@.com
...
```

**Question:** Why are these invalid? Note at least 3 different types of problems.

---

## **PART 2: IP Address Extraction and Analysis (6-8 minutes)**

### **Lab 2.1: Extract All IP Addresses from System Log**

**Task:** Extract all IP addresses from `system.log`.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- IP pattern: `\b([0-9]{1,3}\.){3}[0-9]{1,3}\b`
- Use `grep -oE` to extract only the IPs
- `\b` is word boundary - ensures complete IP match

**Expected Output:** List of IP addresses
```
192.168.1.100
203.0.113.45
10.0.1.50
...
```

**Verification:** Count total IP occurrences:
```bash
# Your command | wc -l
```

---

### **Lab 2.2: Find Unique IP Addresses with Count**

**Task:** Find all unique IP addresses in `system.log` and show how many times each appears, sorted by frequency.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Extract IPs (from Lab 2.1)
- Pipe to `sort` to group them
- Pipe to `uniq -c` to count each
- Pipe to `sort -rn` to sort by count (reverse numeric)

**Expected Output:**
```
      6 203.0.113.45
      3 192.168.1.101
      2 10.0.1.50
      1 172.16.0.99
...
```

**Question:** Which IP appears most frequently? This could indicate an attack!

---

### **Lab 2.3: Extract IPs from Specific Log Type**

**Task:** Extract IP addresses ONLY from failed SSH login attempts.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- First grep for 'Failed password'
- Then pipe to grep for IP addresses
- Two-stage extraction: `grep 'pattern1' | grep -oE 'pattern2'`

**Expected Output:** IP addresses from failed login lines only

---

### **Lab 2.4: Identify Attack Source**

**Task:** Find IP addresses that have 3 or more failed login attempts.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Extract IPs from failed logins (Lab 2.3)
- Sort and count unique IPs
- Use `awk '$1 >= 3 {print $2, "("$1" attempts)"}'` to filter

**Expected Output:**
```
203.0.113.45 (6 attempts)
```

**Action:** This IP should be blocked! In production, you'd add it to firewall.

---

## **PART 3: Log Parsing and Pattern Matching (6-8 minutes)**

### **Lab 3.1: Find All Failed SSH Login Attempts**

**Task:** Find all lines in `system.log` that contain failed SSH login attempts.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Search for pattern: `Failed password`
- Use basic grep
- Add `-c` to count, or pipe to `wc -l`

**Expected Output:** Lines with failed password attempts

**Verification:** How many failed attempts total?

---

### **Lab 3.2: Extract Usernames from Failed Logins**

**Task:** Extract ONLY the usernames from failed SSH login attempts.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Use `grep -oP` for Perl regex
- Pattern: `Failed password for \K\w+`
- `\K` means "discard everything matched before this point"
- Alternative: `grep 'Failed password' | sed -E 's/.*Failed password for (\w+).*/\1/'`

**Expected Output:** List of usernames:
```
root
admin
oracle
admin
root
postgres
...
```

**Question:** Which username is targeted most? Use `sort | uniq -c | sort -rn`

---

### **Lab 3.3: Find HTTP Error Responses**

**Task:** Find all HTTP responses with 4xx or 5xx status codes in `access.log`.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Pattern to match 4xx: `4[0-9]{2}`
- Pattern to match 5xx: `5[0-9]{2}`
- Combine with OR: `(4[0-9]{2}|5[0-9]{2})`
- Full pattern: `' (4[0-9]{2}|5[0-9]{2}) '` (with spaces)

**Expected Output:** Log lines with errors

---

### **Lab 3.4: Count Each Error Type**

**Task:** Count how many times each HTTP error code appears in `access.log`.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Extract just the status codes: `grep -oE ' [45][0-9]{2} '`
- Sort and count: `sort | uniq -c | sort -rn`

**Expected Output:**
```
      4 404
      3 403
      2 401
      1 500
      1 400
```

**Analysis:** Which error is most common?

---

### **Lab 3.5: Detect Attack Patterns in URLs**

**Task:** Find requests that contain suspicious patterns (directory traversal, admin access, shell uploads).

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Look for patterns: `\.\.\/` (directory traversal), `admin`, `shell`, `wp-admin`
- Use grep -E with OR: `(\.\./|admin|shell|wp-admin)`
- File: `access.log`

**Expected Output:** Lines with suspicious URLs

**Question:** How many attack attempts were detected?

---

## **PART 4: Data Validation (5-7 minutes)**

### **Lab 4.1: Validate Server Hostnames**

**Task:** From `servers.txt`, find servers with VALID hostnames according to this rule:
- Must start with a letter
- Can contain letters, numbers, and hyphens
- Must be 5-20 characters total

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Pattern: `^[a-zA-Z][a-zA-Z0-9-]{4,19} `
- Use `grep -E`
- The space after {4,19} ensures we're matching the hostname field

**Expected Output:** Lines with valid hostnames

---

### **Lab 4.2: Find Invalid Hostnames**

**Task:** Find servers that VIOLATE the naming convention.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Same pattern as Lab 4.1, but use `grep -vE` to invert
- `-v` shows lines that DON'T match

**Expected Output:** Servers with non-compliant names (if any)

---

### **Lab 4.3: Extract Users with Bash Shell**

**Task:** From `passwd.txt`, find all users who have `/bin/bash` as their shell.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Pattern to match end of line: `/bin/bash$`
- `$` anchors to end of line
- Use basic grep or `grep -E`

**Expected Output:** Users with bash shell

**Follow-up:** Extract just the usernames (first field):
```bash
# Your command | cut -d':' -f1
```

---

### **Lab 4.4: Validate Account Usernames**

**Task:** Find users whose usernames follow this policy:
- Lowercase letters only
- Can include numbers, dots, underscores
- 3-32 characters long

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Pattern: `^[a-z0-9._]{3,32}:`
- The `:` after the username field helps anchor the pattern
- Look for violations with `grep -vE`

**Expected Output:** Valid or invalid usernames depending on approach

---

## **PART 5: Advanced Pattern Matching (5-7 minutes)**

### **Lab 5.1: Extract All File Paths from Configuration**

**Task:** Extract all absolute file paths (starting with /) from `config.conf`.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Pattern: `/[a-zA-Z0-9/_.-]+`
- Starts with `/`
- Followed by letters, numbers, slashes, dots, hyphens
- Use `grep -oE`

**Expected Output:** List of file paths like:
```
/var/log/webapp/application.log
/var/log/webapp/access.log
/var/log/webapp/error.log
```

---

### **Lab 5.2: Find SSH Accept Rules**

**Task:** From `firewall_rules.txt`, find all ACCEPT rules for SSH (port 22).

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Look for lines starting with ACCEPT: `^ACCEPT`
- That also contain port 22: `dpt:22`
- Combine: `grep -E '^ACCEPT.*dpt:22'`

**Expected Output:** SSH allow rules

**Question:** Which networks are allowed SSH access?

---

### **Lab 5.3: Extract Blocked IP Addresses**

**Task:** From `firewall_rules.txt`, extract IP addresses or ranges that are being blocked (DROP rules).

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- First grep for DROP rules: `grep '^DROP'`
- Then extract IPs: `grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}[^ ]*'`
- The `[^ ]*` catches CIDR notation like /24

**Expected Output:** Blocked IPs/ranges like:
```
203.0.113.45
198.51.100.0/24
```

---

### **Lab 5.4: Create Security Summary Report**

**Task:** Create a one-line report showing key security metrics from `system.log`.

**Your Command:**
```bash
# Count failed logins
FAILED=$(grep -c 'Failed password' system.log)

# Count unique attacking IPs
ATTACKERS=$(grep 'Failed password' system.log | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | sort -u | wc -l)

# Display report
echo "Security Summary: $FAILED failed logins from $ATTACKERS unique IPs"
```

**Expected Output:**
```
Security Summary: 10 failed logins from 3 unique IPs
```

**Challenge:** Enhance this to also include web attack attempts from `access.log`!

---

## **BONUS CHALLENGES (Optional - 5-10 minutes)**

### **Bonus 1: Extract Phone Numbers**

**Task:** If there are phone numbers in `config.conf` (format XXX-XXX-XXXX), extract them.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Pattern: `\d{3}-\d{3}-\d{4}` (with grep -P)
- Or: `[0-9]{3}-[0-9]{3}-[0-9]{4}` (with grep -E)

---

### **Bonus 2: Generate Auto-Block Commands**

**Task:** Generate iptables commands to automatically block IPs with 3+ failed login attempts.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- Extract IPs from failed logins
- Count occurrences
- Filter for >= 3 attempts
- Generate command: `awk '$1 >= 3 {print "iptables -A INPUT -s "$2" -j DROP"}'`

**Expected Output:**
```
iptables -A INPUT -s 203.0.113.45 -j DROP
```

---

### **Bonus 3: Extract User Agents from Access Log**

**Task:** Extract all unique user agents from `access.log`.

**Your Command:**
```bash
# Write your command here:


```

**Hints:**
- User agent is in quotes at the end of each line
- Pattern: `"[^"]*"[^"]*"[^"]*"\K[^"]*` (complex!)
- Or simpler: `awk -F'"' '{print $6}'` 
- Then `sort -u` for unique values

---

### **Bonus 4: Comprehensive Log Analysis Script**

**Task:** Create a script that analyzes all logs and produces a summary report.

**Your Script:**
```bash
#!/bin/bash
# Save as: analyze_logs.sh

echo "=== COMPREHENSIVE LOG ANALYSIS ==="
echo ""

echo "1. Failed Login Analysis:"
echo "   Total failed attempts: $(grep -c 'Failed password' system.log)"
echo "   Unique attackers: $(grep 'Failed password' system.log | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | sort -u | wc -l)"

echo ""
echo "2. Web Server Errors:"
echo "   4xx errors: $(grep -cE ' 4[0-9]{2} ' access.log)"
echo "   5xx errors: $(grep -cE ' 5[0-9]{2} ' access.log)"

echo ""
echo "3. Attack Detection:"
echo "   Suspicious URLs: $(grep -cE '(\.\./|admin|shell)' access.log)"

echo ""
echo "4. Top Attacking IPs:"
grep 'Failed password' system.log | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | sort | uniq -c | sort -rn | head -3

echo ""
echo "=== END OF REPORT ==="
```

**Run it:**
```bash
chmod +x analyze_logs.sh
./analyze_logs.sh
```

---

## **CRITICAL: Lab Submission Requirements**

### **1. Save Your Command History (REQUIRED)**

At the end of the lab, save your complete command history:

```bash
# Save history with timestamp
history > ~/module3_lab/lab_history_$(whoami)_$(date +%Y%m%d_%H%M%S).txt
```

This captures ALL commands you typed during the lab.

---

### **2. Create Lab Summary File (REQUIRED)**

Create a summary of your work:

```bash
cat > ~/module3_lab/lab_summary.txt << 'EOF'
=================================================================
MODULE 3 LAB SUMMARY
=================================================================

Student Name: [Your Name]
Date: $(date +%Y-%m-%d)
Start Time: [HH:MM]
End Time: [HH:MM]
Total Duration: [XX minutes]

=================================================================
COMPLETION CHECKLIST:
=================================================================

PART 1: Email Extraction and Validation
[ ] Lab 1.1: Extract emails from config
[ ] Lab 1.2: Extract email domains
[ ] Lab 1.3: Validate email addresses
[ ] Lab 1.4: Find invalid emails

PART 2: IP Address Extraction and Analysis
[ ] Lab 2.1: Extract all IP addresses
[ ] Lab 2.2: Find unique IPs with count
[ ] Lab 2.3: Extract IPs from failed logins
[ ] Lab 2.4: Identify attack sources

PART 3: Log Parsing and Pattern Matching
[ ] Lab 3.1: Find failed login attempts
[ ] Lab 3.2: Extract usernames
[ ] Lab 3.3: Find HTTP errors
[ ] Lab 3.4: Count error types
[ ] Lab 3.5: Detect attack patterns

PART 4: Data Validation
[ ] Lab 4.1: Validate hostnames
[ ] Lab 4.2: Find invalid hostnames
[ ] Lab 4.3: Extract bash shell users
[ ] Lab 4.4: Validate usernames

PART 5: Advanced Pattern Matching
[ ] Lab 5.1: Extract file paths
[ ] Lab 5.2: Find SSH accept rules
[ ] Lab 5.3: Extract blocked IPs
[ ] Lab 5.4: Create security summary

BONUS CHALLENGES (Optional):
[ ] Bonus 1: Extract phone numbers
[ ] Bonus 2: Generate auto-block commands
[ ] Bonus 3: Extract user agents
[ ] Bonus 4: Comprehensive analysis script

=================================================================
SELF-ASSESSMENT (Rate 1-5):
=================================================================

Email pattern matching:        [ /5]
IP address extraction:          [ /5]
Log parsing and filtering:      [ /5]
Data validation:                [ /5]
Combining regex with pipes:     [ /5]
Overall confidence with regex:  [ /5]

=================================================================
KEY FINDINGS:
=================================================================

1. IP with most failed login attempts: _________________
2. Most common HTTP error code: _________________
3. Number of attack patterns detected: _________________
4. Total valid emails in email_list.txt: _________________
5. Number of servers with valid hostnames: _________________

=================================================================
QUESTIONS / CHALLENGES FACED:
=================================================================

1. What was the most difficult exercise?


2. Which regex pattern was hardest to understand?


3. What concept needs more practice?


=================================================================
PATTERNS I LEARNED / WILL REUSE:
=================================================================

1. 

2. 

3. 

=================================================================
REAL-WORLD APPLICATION IDEAS:
=================================================================

How could you use regex in your daily work?




=================================================================
EOF
```

**Edit the file to fill in your answers:**
```bash
nano ~/module3_lab/lab_summary.txt
# or
vi ~/module3_lab/lab_summary.txt
```

---

### **3. Create Submission Package (REQUIRED)**

```bash
# Navigate to lab directory
cd ~/module3_lab

# Create submission directory
mkdir -p ~/module3_submission

# Copy required files
cp lab_summary.txt ~/module3_submission/
cp lab_history_*.txt ~/module3_submission/

# Optional: Copy any scripts you created
cp *.sh ~/module3_submission/ 2>/dev/null

# Create zip file
cd ~
zip -r module3_submission_$(whoami)_$(date +%Y%m%d).zip module3_submission/

# Verify zip contents
unzip -l module3_submission_$(whoami)_$(date +%Y%m%d).zip

echo ""
echo "Submission package created: module3_submission_$(whoami)_$(date +%Y%m%d).zip"
echo "Location: ~/module3_submission_$(whoami)_$(date +%Y%m%d).zip"
```

**Your submission MUST contain:**
1. ✅ lab_summary.txt (completed)
2. ✅ lab_history_[username]_[timestamp].txt
3. ✅ Any scripts you created (if applicable)

---

## **Lab Completion Checklist**

Before submitting, verify:

- [ ] All 16 required exercises attempted
- [ ] Command history saved: `lab_history_*.txt` exists
- [ ] Lab summary completed with checkboxes marked
- [ ] Self-assessment ratings filled in
- [ ] Key findings documented
- [ ] Questions/reflections written
- [ ] Submission zip file created
- [ ] Zip file verified (unzip -l to check contents)
- [ ] File size reasonable (should be < 1 MB)
- [ ] Filename includes username and date

---

## **Troubleshooting Guide**

### **Problem: Pattern doesn't match anything**

**Solutions:**
1. Start simple - test with basic text first
2. Check regex flavor - use `-E` for extended, `-P` for Perl
3. Escape special characters: `. $ * + ? ( ) [ ] { } ^ \ |`
4. Test incrementally - build pattern piece by piece

**Example:**
```bash
# If this doesn't work:
grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' file

# Try simpler version first:
grep '[0-9]' file  # Does this find digits?
grep '[0-9]\.' file  # Does this find digit followed by dot?
# Build up from there
```

---

### **Problem: Pattern matches too much**

**Solutions:**
1. Add anchors: `^` for start of line, `$` for end of line
2. Use word boundaries: `\b`
3. Be more specific with character classes
4. Use non-greedy quantifiers: `.*?` instead of `.*`

**Example:**
```bash
# This matches anywhere in line:
grep 'admin' file

# This matches only at start:
grep '^admin' file

# This matches complete word only:
grep '\badmin\b' file
```

---

### **Problem: Can't extract just the match**

**Solutions:**
1. Use `grep -o` to show only matching part
2. Use capture groups with sed: `sed -E 's/.*pattern(capture).*/\1/'`
3. Use `\K` with grep -P to discard everything before

**Example:**
```bash
# Extract just the IP:
grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' file

# Extract username after "user=":
grep -oP 'user=\K\w+' file
```

---

### **Problem: grep returns no results but data is there**

**Solutions:**
1. Check file encoding: `file filename`
2. Look for hidden characters: `cat -A filename`
3. Verify case sensitivity - add `-i` for case-insensitive
4. Test pattern on simple input: `echo "test" | grep 'pattern'`

---

### **Problem: Need to match literal special character**

**Solutions:**
1. Escape with backslash: `\. \$ \* \+ \? \( \) \[ \] \{ \} \^ \\`
2. Use fgrep for literal strings (no regex): `fgrep 'literal text' file`

**Example:**
```bash
# Match literal dollar sign:
grep '\$' file

# Match literal dot:
grep '\.' file

# Match literal parentheses:
grep '\(' file
```

---

## **Regex Quick Reference**

### **Metacharacters:**
- `.` = any character
- `^` = start of line
- `$` = end of line
- `*` = 0 or more (greedy)
- `+` = 1 or more (greedy)
- `?` = 0 or 1 OR make quantifier non-greedy
- `[]` = character class
- `[^]` = negated class
- `()` = capture group
- `|` = OR
- `\` = escape
- `\b` = word boundary

### **Common Patterns:**
```bash
Email:    [a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
IP:       \b([0-9]{1,3}\.){3}[0-9]{1,3}\b
Phone:    \d{3}-\d{3}-\d{4}
Date:     [0-9]{4}-[0-9]{2}-[0-9]{2}
```

### **Grep Flags:**
- `-E` = extended regex
- `-P` = Perl regex
- `-o` = only matching part
- `-v` = invert match
- `-i` = case insensitive
- `-n` = show line numbers
- `-c` = count matches

---

## **Tips for Success**

### **Time Management:**
- Part 1 (Email): 6-8 minutes
- Part 2 (IP): 6-8 minutes
- Part 3 (Logs): 6-8 minutes
- Part 4 (Validation): 5-7 minutes
- Part 5 (Advanced): 5-7 minutes
- **Total: 28-38 minutes**

### **Best Practices:**
1. **Read carefully** - Understand what's being asked
2. **Test simple first** - Start with basic pattern, add complexity
3. **Use command history** - Press ↑ to recall previous commands
4. **Verify output** - Check if results make sense
5. **Ask if stuck** - Don't spend > 5 minutes on one exercise
6. **Save frequently** - Save your commands as you go
7. **Learn from errors** - Mistakes are learning opportunities

### **Learning Strategies:**
1. **Understand, don't memorize** - Know WHY patterns work
2. **Experiment** - Try variations to see what changes
3. **Use man pages** - `man grep`, `man regex` for reference
4. **Build incrementally** - Pattern too complex? Break it down
5. **Learn from examples** - Study working patterns
6. **Practice regularly** - Regex is a skill that improves with use

---

## **After the Lab**

### **Additional Practice:**

1. **Practice on real logs** - Use your own system logs
2. **Create patterns library** - Save useful patterns
3. **Build automation scripts** - Use regex in bash scripts
4. **Try online testers** - regex101.com, regexr.com
5. **Read documentation** - GNU grep manual, regex guides

### **Next Steps:**

1. Review any exercises you struggled with
2. Study the patterns that worked well
3. Try the bonus challenges
4. Apply regex to your own data
5. Share useful patterns with colleagues

---

## **Evaluation Criteria**

Your lab will be evaluated on:

**Completion (40%)**
- How many exercises completed
- All required parts attempted
- Submission files present

**Correctness (30%)**
- Commands produce expected output
- Proper regex syntax
- Appropriate flags used

**Efficiency (15%)**
- Clean, readable commands
- Appropriate tool selection
- Good use of pipes

**Documentation (15%)**
- History file submitted
- Summary completed thoroughly
- Reflections show understanding

**Passing Score:** 70% or higher

---

## **Post-Lab Reflection Questions**

1. **Which regex patterns did you find most useful?**

2. **What concepts do you need to practice more?**

3. **How would you use regex in your daily work?**

4. **What was the biggest "aha!" moment?**

5. **Which exercise was most challenging and why?**

---

## **Resources for Further Learning**

### **Documentation:**
- `man grep` - grep manual
- `man regex` - POSIX regex manual
- `man sed` - sed manual
- `man awk` - awk manual

### **Online Resources:**
- regex101.com - Interactive regex tester with explanation
- regexr.com - Visual regex builder
- https://www.regular-expressions.info/ - Comprehensive tutorial
- https://www.gnu.org/software/grep/manual/ - Official grep manual

### **Practice Sites:**
- regexone.com - Interactive lessons
- regexcrossword.com - Regex puzzles
- hackerrank.com - Regex challenges

---

**Document Version:** 1.0  
**Last Updated:** November 2024  
**Module:** 3 - Regular Expressions Deep Dive  
**Duration:** 30-35 minutes  
**Total Exercises:** 16 required + 4 bonus

---

*This hands-on lab provides practical experience with regular expressions through real-world system administration scenarios. Focus on understanding patterns, not memorizing them. Build incrementally, test frequently, and learn from both successes and mistakes!*
