# Module 2: Advanced File Handling & Text Processing

## Hands-On Lab Exercise

**Duration:** 35-45 minutes  
**Difficulty Level:** Intermediate  
**Prerequisites:** Module 1 completed, basic Linux command knowledge  
**Target Audience:** Bank of America IT Professionals

---

## **Lab Objectives**

By the end of this lab, you will be able to:

- Transform and analyze CSV data using awk
- Monitor and filter log files in real-time
- Use advanced grep patterns for text searching
- Perform multi-file operations (join, paste, diff, comm)
- Build complex command pipelines
- Generate reports from raw data

---

## **Lab Setup Instructions**

### **Step 1: Prepare Your Environment**

```bash
# Navigate to your home directory
cd ~

# Extract the demo files (if not already done)
unzip module2_demo_files.zip

# Navigate to the demo directory
cd module2_demo_files

# Run the setup script
bash setup_demo.sh

# Verify all files are present
ls -lh
```

**Expected Files:**

- transactions.csv
- access.log
- employees.txt
- departments.txt
- large_numbers.txt
- fruits1.txt
- fruits2.txt
- README.txt

### **Step 2: Create Your Lab Working Directory**

```bash
# Create a directory for your lab work
mkdir -p ~/module2_lab
cd ~/module2_lab

# Copy all demo files here
cp ~/module2_demo_files/* .

# Verify files copied
ls -lh
```

---

## **PART 1: CSV Data Transformation with awk (8-10 minutes)**

### **Lab 1.1: Basic Data Extraction (2 minutes)**

**Task:** Extract and display only the AccountID and Amount from all completed transactions.

**Your Command:**

```bash
# Write your command here:




```

**Hints:**

- Use `-F','` to set comma as field separator
- Field 1 is AccountID, Field 4 is Amount, Field 5 is Status
- Use `NR>1` to skip the header row
- Condition: `$5=="Completed"`

**Expected Output Sample:**

```
ACC001 5000.00
ACC002 1500.50
...
```

**Verification:** You should see 8 completed transactions.

---

### **Lab 1.2: Calculate Transaction Statistics (2 minutes)**

**Task:** Calculate and display:

- Total amount of all completed transactions
- Number of completed transactions
- Average transaction amount

**Your Command:**

```bash
# Write your command here:




```

**Hints:**

- Use a variable to accumulate: `total += $4`
- Use a counter: `count++`
- Use the `END` block to print results
- Average = total/count

**Expected Output Format:**

```
Total Amount: $XXXXX
Transaction Count: X
Average: $XXXX.XX
```

---

### **Lab 1.3: Generate Branch-wise Report (3 minutes)**

**Task:** Create a report showing total transaction amounts for each branch, but ONLY for completed transactions. Format the output professionally.

**Your Command:**

```bash
# Write your command here:




```

**Hints:**

- Use associative arrays: `branch[$6] += $4`
- Loop through array in END block: `for (b in branch)`
- Use printf for formatting: `printf "%-15s $%10.2f\n", branch_name, amount`
- Add a header using BEGIN block

**Expected Output Format:**

```
=== BRANCH TRANSACTION SUMMARY ===
NYC             $   7700.00
LA              $   4500.50
Chicago         $   5000.00
...
```

---

### **Lab 1.4: Advanced Filtering (3 minutes)**

**Task:** Find all withdrawal transactions where the amount is greater than $500, and display AccountID, Date, and Amount. Sort the output by amount (you'll need to pipe to sort).

**Your Command:**

```bash
# Write your command here:




```

**Hints:**

- Filter by Type: `$3=="Withdrawal"`
- Filter by Amount: `$4>500`
- Pipe to sort: `| sort -t' ' -k3 -n` (sort by 3rd field numerically)

**Expected Output:**

```
ACC002 2024-01-15 1500.50
```

---

### **📝 Lab 1 Checkpoint:**

- [ ] Completed Lab 1.1 - Basic extraction
- [ ] Completed Lab 1.2 - Statistics calculation
- [ ] Completed Lab 1.3 - Branch report
- [ ] Completed Lab 1.4 - Advanced filtering

---

## **PART 2: Real-time Log Monitoring (8-10 minutes)**

### **Lab 2.1: Basic Log Analysis (2 minutes)**

**Task:** Use tail to display the last 3 entries from access.log, then use head to display the first 3 entries.

**Your Commands:**

```bash
# Last 3 entries:


# First 3 entries:


```

**Verification:** Compare the timestamps to ensure you got the earliest and latest entries.

---

### **Lab 2.2: Filter Error Logs (2 minutes)**

**Task:** Find all log entries with HTTP status code 500 (server errors) and display them with line numbers.

**Your Command:**

```bash
# Write your command here:



```

**Hints:**

- Use grep with -n flag for line numbers
- Pattern to search: "500"

**Expected Output:** Should show 2 error entries with their line numbers.

---

### **Lab 2.3: Real-time Monitoring Simulation (3 minutes)**

**Task:** Set up real-time monitoring of access.log that:

1. Follows the log file in real-time
2. Only shows lines containing errors (status codes 500 or 404)
3. Highlights the error codes in color

**Your Command:**

```bash
# Write your command here:



```

**Steps to Test:**

1. Open a second terminal window
2. Run the monitoring command in the first terminal
3. In the second terminal, add new log entries:
   ```bash
   echo "2024-11-27 10:00:00 192.168.1.200 GET /api/test 500 2.5s" >> access.log
   echo "2024-11-27 10:00:01 192.168.1.201 GET /api/data 200 0.1s" >> access.log
   echo "2024-11-27 10:00:02 192.168.1.202 GET /api/missing 404 0.05s" >> access.log
   ```
4. Watch the first terminal - only error entries should appear
5. Press Ctrl+C to stop monitoring

**Hints:**

- Use `tail -f` for real-time following
- Pipe to `grep -E` for multiple patterns
- Use `--color=auto` for highlighting

---

### **Lab 2.4: Performance Analysis (3 minutes)**

**Task:** Find all log entries where the response time is greater than 1 second. Display the IP address, endpoint, and response time.

**Your Command:**

```bash
# Write your command here:



```

**Hints:**

- Use awk to filter by last field: `$NF > 1.0`
- NF means "Number of Fields" (last field)
- Print fields: IP ($3), Endpoint ($5), Time ($NF)

**Expected Output:**

```
192.168.1.104 /api/accounts 2.345s
192.168.1.107 /api/deposit 1.234s
```

---

### **📝 Lab 2 Checkpoint:**

- [ ] Completed Lab 2.1 - Basic log viewing
- [ ] Completed Lab 2.2 - Error filtering
- [ ] Completed Lab 2.3 - Real-time monitoring
- [ ] Completed Lab 2.4 - Performance analysis

---

## **PART 3: Advanced grep Patterns (6-8 minutes)**

### **Lab 3.1: Case-Insensitive Search (1 minute)**

**Task:** Search for the word "deposit" in transactions.csv (case-insensitive) and count how many lines match.

**Your Commands:**

```bash
# Search and display:


# Count matches:


```

**Hints:**

- Use `-i` for case-insensitive
- Use `-c` to count matches

**Expected Count:** 4

---

### **Lab 3.2: Inverted Matching (1 minute)**

**Task:** Display all transactions that are NOT completed (exclude all "Completed" status).

**Your Command:**

```bash
# Write your command here:



```

**Hints:**

- Use `-v` to invert match
- Skip the header line if needed

**Expected Output:** Should show 2 transactions (1 Pending, 1 Failed)

---

### **Lab 3.3: Pattern Matching with Context (2 minutes)**

**Task:** Find the "Failed" transaction and display 2 lines before and 2 lines after it.

**Your Command:**

```bash
# Write your command here:



```

**Hints:**

- Use `-B 2` for 2 lines before
- Use `-A 2` for 2 lines after
- You can combine: `-B 2 -A 2` or use `-C 2` for context

**Verification:** You should see 5 total lines (2 before + match + 2 after).

---

### **Lab 3.4: Multiple Pattern Search (2 minutes)**

**Task:** Find all transactions that are either "Deposit" OR "Withdrawal" type, and display them with line numbers.

**Your Command:**

```bash
# Write your command here:



```

**Hints:**

- Use `-E` for extended regex
- Use `|` (pipe) for OR: "pattern1|pattern2"
- Use `-n` for line numbers

**Expected Output:** Should show 8 lines with line numbers.

---

### **Lab 3.5: Extract IP Addresses (2 minutes)**

**Task:** Extract all unique IP addresses from access.log.

**Your Command:**

```bash
# Write your command here:



```

**Hints:**

- Use grep to extract IPs: `grep -o` with pattern
- IP pattern: `[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}`
- Pipe to `sort | uniq` to get unique IPs

**Alternative:** Use awk: `awk '{print $3}' access.log | sort | uniq`

**Expected Output:** 7 unique IP addresses

---

### **📝 Lab 3 Checkpoint:**

- [ ] Completed Lab 3.1 - Case-insensitive search
- [ ] Completed Lab 3.2 - Inverted matching
- [ ] Completed Lab 3.3 - Context display
- [ ] Completed Lab 3.4 - Multiple patterns
- [ ] Completed Lab 3.5 - IP extraction

---

## **PART 4: Multi-File Operations (8-10 minutes)**

### **Lab 4.1: Join Employee and Department Data (2 minutes)**

**Task:** Combine employees.txt and departments.txt to show each employee with their department. Sort the files first if needed.

**Your Commands:**

```bash
# Sort files (if needed):



# Join files:



```

**Hints:**

- Files must be sorted by the join field (first field)
- Use `join file1 file2`

**Expected Output:**

```
E001 John Smith Technology
E002 Sarah Johnson Finance
E003 Mike Davis Operations
E004 Emily Brown HR
E005 David Wilson Technology
```

---

### **Lab 4.2: Side-by-Side Comparison (1 minute)**

**Task:** Display employees.txt and departments.txt side by side using paste.

**Your Command:**

```bash
# Write your command here:



```

**Expected Output:**

```
E001 John Smith        E001 Technology
E002 Sarah Johnson     E002 Finance
...
```

---

### **Lab 4.3: Find Differences (2 minutes)**

**Task:** Create a modified version of fruits1.txt and use diff to find the differences.

**Your Commands:**

```bash
# Create modified file:
cp fruits1.txt fruits1_modified.txt
echo "Grape" >> fruits1_modified.txt
sed -i 's/Apple/Apricot/' fruits1_modified.txt

# Find differences:



# Side-by-side diff:



```

**Hints:**

- Use `diff file1 file2` for standard diff
- Use `diff -y file1 file2` for side-by-side view

---

### **Lab 4.4: Set Operations with comm (3 minutes)**

**Task:** Using fruits1.txt and fruits2.txt, find:

1. Lines only in fruits1.txt
2. Lines only in fruits2.txt
3. Lines in both files

**Your Commands:**

```bash
# Lines only in fruits1.txt:


# Lines only in fruits2.txt:


# Lines in both files (common):


```

**Hints:**

- Files must be sorted for comm
- `comm -23 file1 file2` = only in file1
- `comm -13 file1 file2` = only in file2
- `comm -12 file1 file2` = in both files

**Expected Results:**

- Only in fruits1: Apple, Date
- Only in fruits2: Elderberry, Fig
- In both: Banana, Cherry

---

### **Lab 4.5: Multi-File grep (2 minutes)**

**Task:** Search for the word "Completed" across all CSV files in the directory. (First create additional CSV files for testing)

**Your Commands:**

```bash
# Create test files:
cp transactions.csv transactions_backup.csv
cp transactions.csv transactions_archive.csv

# Search across all CSV files:



```

**Hints:**

- Use wildcard: `grep "pattern" *.csv`
- grep will show filename before each match

**Expected Output:** Should show matches from all three CSV files with filenames.

---

### **📝 Lab 4 Checkpoint:**

- [ ] Completed Lab 4.1 - Join operation
- [ ] Completed Lab 4.2 - Paste side-by-side
- [ ] Completed Lab 4.3 - Diff comparison
- [ ] Completed Lab 4.4 - Comm set operations
- [ ] Completed Lab 4.5 - Multi-file grep

---

## **PART 5: Advanced Challenge Exercises (5-8 minutes)**

### **Challenge 1: Combined Operations (3 minutes)**

**Task:** Create a report that shows:

- Total transaction amount by branch
- Only for completed transactions
- Sorted by amount (highest first)
- Formatted as a table with headers

**Your Command:**

```bash
# Write your command here:




```

**Hints:**

- Use awk to sum by branch
- Pipe to sort: `sort -k2 -n -r` (sort by column 2, numeric, reverse)
- Use printf for table formatting

**Expected Output Format:**

```
=== BRANCH PERFORMANCE REPORT ===
Branch          Total Amount
-----------------------------------
NYC             $   7700.00
LA              $   4500.50
Chicago         $   5000.00
...
```

---

### **Challenge 2: Log Analysis Pipeline (3 minutes)**

**Task:** Create a one-liner that:

1. Reads access.log
2. Filters for successful requests (status 200)
3. Extracts the endpoint (column 5)
4. Shows the count of each unique endpoint
5. Sorts by count (most frequent first)

**Your Command:**

```bash
# Write your command here:




```

**Hints:**

- Use grep to filter: `grep " 200 "`
- Use awk to extract endpoint: `awk '{print $5}'`
- Use sort and uniq: `sort | uniq -c`
- Sort by count: `sort -rn`

**Expected Output:**

```
   3 /api/accounts
   2 /api/balance
   1 /api/history
```

---

### **Challenge 3: Data Validation (2 minutes)**

**Task:** Find all transactions where:

- The amount is between $1000 and $5000 (inclusive)
- Status is either "Completed" or "Pending"
- Transaction type is "Deposit"

Display: AccountID, Date, Amount, Status

**Your Command:**

```bash
# Write your command here:




```

**Hints:**

- Multiple conditions in awk: `condition1 && condition2 && condition3`
- Amount range: `$4>=1000 && $4<=5000`
- OR condition: `($5=="Completed" || $5=="Pending")`

---

### **📝 Challenge Checkpoint:**

- [ ] Completed Challenge 1 - Branch report
- [ ] Completed Challenge 2 - Log pipeline
- [ ] Completed Challenge 3 - Data validation

---

## **PART 6: Bonus Exercises (Optional - Extra Practice)**

### **Bonus 1: Create a Transaction Summary Script**

**Task:** Write a one-liner that creates a complete transaction summary showing:

- Total deposits vs total withdrawals
- Count of each transaction type
- Overall total of all transactions

**Your Command:**

```bash
# Write your command here:




```

---

### **Bonus 2: Real-Time Error Monitor**

**Task:** Create a command that monitors access.log in real-time and:

- Shows only errors (4xx and 5xx status codes)
- Displays timestamp, IP, and endpoint
- Highlights the status code in red

**Your Command:**

```bash
# Write your command here:




```

---

### **Bonus 3: Employee Department Report**

**Task:** Create a report showing:

- How many employees are in each department
- List of employees per department

**Your Command:**

```bash
# Write your command here:




```

**Hint:** Use join first, then awk to process

---

## **LAB COMPLETION REQUIREMENTS**

### **Step 1: Create Your Lab Summary**

Create a file named `lab_summary.txt` with the following information:

```bash
cat > ~/module2_lab/lab_summary.txt << 'EOF'
=================================================================
MODULE 2: ADVANCED FILE HANDLING & TEXT PROCESSING
Lab Completion Summary
=================================================================

Name: [Your Name]
Date: [Today's Date]
Module: 2 - Advanced File Handling & Text Processing

=================================================================
COMPLETION STATUS:
=================================================================

Part 1: CSV Data Transformation with awk
[ ] Lab 1.1 - Basic data extraction
[ ] Lab 1.2 - Calculate statistics
[ ] Lab 1.3 - Branch-wise report
[ ] Lab 1.4 - Advanced filtering

Part 2: Real-time Log Monitoring
[ ] Lab 2.1 - Basic log analysis
[ ] Lab 2.2 - Filter error logs
[ ] Lab 2.3 - Real-time monitoring
[ ] Lab 2.4 - Performance analysis

Part 3: Advanced grep Patterns
[ ] Lab 3.1 - Case-insensitive search
[ ] Lab 3.2 - Inverted matching
[ ] Lab 3.3 - Pattern with context
[ ] Lab 3.4 - Multiple patterns
[ ] Lab 3.5 - IP extraction

Part 4: Multi-File Operations
[ ] Lab 4.1 - Join operation
[ ] Lab 4.2 - Paste side-by-side
[ ] Lab 4.3 - Diff comparison
[ ] Lab 4.4 - Comm set operations
[ ] Lab 4.5 - Multi-file grep

Part 5: Advanced Challenges
[ ] Challenge 1 - Branch report
[ ] Challenge 2 - Log pipeline
[ ] Challenge 3 - Data validation

Bonus Exercises (Optional):
[ ] Bonus 1 - Transaction summary
[ ] Bonus 2 - Error monitor
[ ] Bonus 3 - Department report

=================================================================
TIME TAKEN:
=================================================================

Start Time: __________
End Time: __________
Total Duration: __________ minutes

=================================================================
NOTES / QUESTIONS:
=================================================================

[Write any questions or observations here]




=================================================================
SELF-ASSESSMENT:
=================================================================

Rate your understanding (1-5, where 5 is excellent):

awk command: ___/5
tail and log monitoring: ___/5
grep patterns: ___/5
Multi-file operations: ___/5
Overall confidence: ___/5

=================================================================
EOF

# Edit the file to fill in your information
nano lab_summary.txt  # or use vi/vim
```

---

### **Step 2: Save Your Command History** ⚠️ **REQUIRED**

**CRITICAL:** You MUST save your command history to a file and submit it along with your lab summary.

```bash
# Save your complete command history
history > ~/module2_lab/lab_history_$(whoami)_$(date +%Y%m%d_%H%M%S).txt

# Verify the file was created
ls -lh ~/module2_lab/lab_history_*.txt

# View the last 20 commands to verify
tail -20 ~/module2_lab/lab_history_*.txt
```

**What This Does:**

- Saves ALL commands you typed during this lab
- Includes timestamp in filename for tracking
- Allows trainer to verify your work
- Helps you review what you learned

---

### **Step 3: Create Final Submission Package**

```bash
# Navigate to your lab directory
cd ~/module2_lab

# Create a submission directory
mkdir -p ~/module2_submission

# Copy required files to submission directory
cp lab_summary.txt ~/module2_submission/
cp lab_history_*.txt ~/module2_submission/

# Create any output files you generated during labs
# (optional - include if you created reports, analysis files, etc.)

# Create a zip file of your submission
cd ~
zip -r module2_submission_$(whoami)_$(date +%Y%m%d).zip module2_submission/

# Verify your submission package
ls -lh module2_submission_*.zip
unzip -l module2_submission_*.zip
```

**Your submission should contain:**

1. `lab_summary.txt` - Your completed summary with checkboxes
2. `lab_history_[username]_[timestamp].txt` - Your command history
3. Any additional output files you created

---

## **SUBMISSION INSTRUCTIONS**

### **What to Submit:**

1. **lab_summary.txt** - Completed with:
   - All checkboxes marked
   - Time taken noted
   - Self-assessment filled
   - Any questions/notes

2. **lab*history*[username]\_[timestamp].txt** - Your command history file

3. **Zip package** - `module2_submission_[username]_[date].zip`

### **How to Submit:**

```bash
# Your submission file is ready at:
ls -lh ~/module2_submission_*.zip

# Email or upload this file to your trainer
# File location: ~/module2_submission_[username]_[date].zip
```

**Submission Deadline:** [To be announced by trainer]

---

## **TROUBLESHOOTING GUIDE**

### **Problem: awk gives unexpected results**

**Solution:**

- Check field separator: Use `-F','` for CSV files
- Verify field numbers: `awk -F',' '{print NF}' file.csv | head -1`
- Print all fields to debug: `awk -F',' '{print $0}' file.csv`

### **Problem: grep returns nothing**

**Solution:**

- Check pattern case: Use `-i` for case-insensitive
- Verify file contains pattern: `cat file | less` and search manually
- Check for special characters: Use single quotes around pattern

### **Problem: join returns "not sorted" error**

**Solution:**

- Sort both files first: `sort file1 > file1_sorted`
- Or use process substitution: `join <(sort file1) <(sort file2)`

### **Problem: tail -f shows nothing new**

**Solution:**

- This is normal! It's waiting for new lines
- Test by adding data in another terminal: `echo "test" >> file.log`
- Press Ctrl+C to exit

### **Problem: Command not found**

**Solution:**

- Verify command exists: `which command_name`
- Check if installed: `command -v command_name`
- Install if needed: `sudo apt-get install package-name`

### **Problem: Permission denied**

**Solution:**

- Check file permissions: `ls -l file`
- Make executable if needed: `chmod +x file`
- Use sudo only if absolutely necessary

---

## **TIPS FOR SUCCESS**

### **Time Management:**

- Part 1 (awk): 8-10 minutes
- Part 2 (logs): 8-10 minutes
- Part 3 (grep): 6-8 minutes
- Part 4 (multi-file): 8-10 minutes
- Part 5 (challenges): 5-8 minutes
- **Total:** 35-45 minutes

### **Best Practices:**

1. **Read instructions carefully** before typing commands
2. **Test simple versions first**, then add complexity
3. **Use command history** (↑ arrow) to recall and modify commands
4. **Verify output** after each command
5. **Ask questions** if stuck for more than 5 minutes
6. **Save your work frequently**

### **Learning Strategies:**

- **Understand, don't memorize** - Focus on the pattern, not exact syntax
- **Experiment** - Try variations to see what happens
- **Use man pages** - `man awk`, `man grep` for reference
- **Build incrementally** - Start simple, add features step by step
- **Learn from errors** - Error messages tell you what's wrong

---

## **ADDITIONAL RESOURCES**

### **Command Reference:**

**awk Quick Reference:**

```bash
awk -F'delimiter' 'condition {action}' file
awk 'NR>1 {print $1, $2}' file          # Skip header, print fields
awk '{sum += $1} END {print sum}' file  # Sum a column
```

**grep Quick Reference:**

```bash
grep pattern file                # Basic search
grep -i pattern file             # Case-insensitive
grep -v pattern file             # Invert (exclude)
grep -n pattern file             # Show line numbers
grep -E "pat1|pat2" file         # Multiple patterns
grep -A 2 -B 2 pattern file      # Context (2 lines before/after)
```

**tail Quick Reference:**

```bash
tail -10 file                    # Last 10 lines
tail -f file                     # Follow in real-time
tail -f file | grep pattern      # Filter while following
```

**join/paste/diff/comm Quick Reference:**

```bash
join file1 file2                 # Join on first field
paste file1 file2                # Side-by-side
diff file1 file2                 # Show differences
comm file1 file2                 # Compare sorted files
```

### **Online Resources:**

- GNU awk manual: https://www.gnu.org/software/gawk/manual/
- Grep tutorial: https://www.gnu.org/software/grep/manual/
- Text processing guide: https://tldp.org/LDP/abs/html/textproc.html

---

## **EVALUATION CRITERIA**

Your lab will be evaluated based on:

1. **Completion** (40%)
   - How many exercises completed
   - All required parts finished

2. **Correctness** (30%)
   - Commands produce expected output
   - Proper syntax and options used

3. **Efficiency** (15%)
   - Using appropriate commands
   - Clean, readable command structure

4. **Documentation** (15%)
   - History file submitted
   - Summary completed
   - Clear notes/questions

**Passing Score:** 70% or higher

---

## **LAB COMPLETION CHECKLIST**

Before submitting, verify:

- [ ] All lab exercises attempted
- [ ] Command history saved: `history > lab_history_*.txt`
- [ ] Lab summary completed with checkboxes
- [ ] Time taken recorded
- [ ] Self-assessment filled out
- [ ] Questions/notes documented
- [ ] Submission zip file created
- [ ] Verified zip contents: `unzip -l filename.zip`
- [ ] File size reasonable (< 5 MB)
- [ ] Filename includes username and date

---

## **QUESTIONS OR ISSUES?**

If you encounter problems or have questions:

1. **Check the troubleshooting guide** above
2. **Review the demo guide** for examples
3. **Check man pages**: `man command_name`
4. **Ask your trainer** - Don't struggle for more than 10 minutes!

---

## **POST-LAB REFLECTION**

After completing the lab, consider:

1. Which commands did you find most useful?
2. Which concepts need more practice?
3. How would you use these commands in your daily work?
4. What real-world scenarios could benefit from these tools?

**Write your reflections in the lab_summary.txt file!**

---

**Good luck! Remember: The goal is learning, not perfection. Mistakes are part of the process!**

---

**Document Version:** 1.0  
**Last Updated:** November 2024  
**Module:** 2 - Advanced File Handling & Text Processing  
**Estimated Completion Time:** 35-45 minutes

---

_This hands-on lab provides practical exercises to reinforce all concepts covered in Module 2, with clear instructions, hints, and verification steps to ensure successful learning outcomes._
