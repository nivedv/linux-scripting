# Module 1 - Hands-On Lab

## Linux Environment & Command Fundamentals

## By completing this lab, you will demonstrate proficiency in:

- Shell identification and management
- Environment variable manipulation
- Creating and managing aliases
- Command location and identification
- System and user identity verification
- Navigation and directory management
- History management and navigation

---

## **Lab Environment**

- **System:** Ubuntu 24.04 LTS or similar
- **Access:** SSH terminal session
- **Prerequisites:** Completed Module 1 demonstrations
- **Deliverable:** History output file (see submission section at the end optional)

---

## **Lab Instructions**

- Complete all exercises in order
- Document your commands as you work (history will capture them)
- Some exercises have verification steps - ensure they pass
- If you get stuck, review the demo materials
- **DO NOT copy-paste** - type commands to build muscle memory
- Save your terminal output when requested

---

## **⚠️ IMPORTANT: Lab Submission Requirement**

**At the end of this lab, you MUST:**

1. Save your command history to a file:

   ```bash
   history > ~/module1_lab_history_<your_name>.txt
   ```

2. Review the file to ensure it contains all your lab commands:

   ```bash
   less ~/module1_lab_history_<your_name>.txt
   ```

3. Submit this file to your trainer as proof of completion

---

# **PART 1: SHELL IDENTIFICATION & MANAGEMENT (5-7 minutes)**

## **Exercise 1.1: Identify Your Environment**

**Task 1.1.1:** Display your default login shell

```
[Your command here]
Expected output: /bin/bash or similar
```

**Task 1.1.2:** Display your current running shell process

```
[Your command here]
Expected to show: bash or your current shell
```

**Task 1.1.3:** List all available shells on the system

```
[Your command here]
Expected to show: /bin/bash, /bin/sh, etc.
```

**Task 1.1.4:** Check if zsh is installed

```
[Your command here]
If not installed, install it: sudo apt install zsh -y
```

---

## **Exercise 1.2: Switch Shells and Understand the Difference**

**Task 1.2.1:** Switch to the sh shell

```
[Your command here]
```

**Task 1.2.2:** While in sh, verify what shell is running

```
[Your command here]
```

**Task 1.2.3:** Check if your default shell variable changed

```
[Your command here]
Expected: Should still show original shell like /bin/bash
```

**Task 1.2.4:** Exit sh and return to bash

```
[Your command here]
```

**Task 1.2.5:** Confirm you're back in bash

```
[Your command here]
```

**✓ Verification:** Run `echo $0` and confirm you see "bash" or "-bash"

---

# **PART 2: ENVIRONMENT VARIABLES (8-10 minutes)**

## **Exercise 2.1: View and Understand Environment Variables**

**Task 2.1.1:** Display all exported environment variables

```
[Your command here]
```

**Task 2.1.2:** Count how many environment variables are exported

```
[Your command here]
Hint: Use a pipe with wc -l
```

**Task 2.1.3:** Display your current PATH variable

```
[Your command here]
```

**Task 2.1.4:** Display your HOME directory path using printenv

```
[Your command here]
```

**Task 2.1.5:** Try to display a non-existent variable with printenv and check the exit code

```
[Your command here to try printing NONEXISTENT_VAR]
[Your command here to check exit code]
Expected exit code: 1
```

---

## **Exercise 2.2: Create and Manage Variables**

**Task 2.2.1:** Create a local variable called PROJECT with value "BankingAutomation"

```
[Your command here]
```

**Task 2.2.2:** Display the variable

```
[Your command here]
```

**Task 2.2.3:** Try to find it in the environment variables list

```
[Your command here]
Hint: Use env | grep PROJECT
Expected: Nothing found (not exported yet)
```

**Task 2.2.4:** Export the PROJECT variable

```
[Your command here]
```

**Task 2.2.5:** Verify it now appears in env

```
[Your command here]
```

**Task 2.2.6:** Create and export a variable DB_SERVER with value "prod-db-01.bofa.local" in a single command

```
[Your command here]
```

**Task 2.2.7:** Create and export a variable APP_PORT with value 8080

```
[Your command here]
```

**Task 2.2.8:** Display all three variables you created using printenv

```
[Your command here to display PROJECT]
[Your command here to display DB_SERVER]
[Your command here to display APP_PORT]
```

---

## **Exercise 2.3: Modify PATH and Cleanup**

**Task 2.3.1:** Display your current PATH

```
[Your command here]
```

**Task 2.3.2:** Add /opt/custom_scripts to the end of your PATH

```
[Your command here]
Hint: export PATH=$PATH:/opt/custom_scripts
```

**Task 2.3.3:** Verify the new directory is in PATH

```
[Your command here]
```

**Task 2.3.4:** Remove the DB_SERVER variable using unset

```
[Your command here]
```

**Task 2.3.5:** Verify DB_SERVER no longer exists

```
[Your command here]
Expected: No output or exit code 1
```

**Task 2.3.6:** Remove both PROJECT and APP_PORT variables in a single command

```
[Your command here]
```

**✓ Verification:** Run `printenv | grep -E "PROJECT|APP_PORT|DB_SERVER"` and confirm no output

---

# **PART 3: ALIASES (6-8 minutes)**

## **Exercise 3.1: View and Create Aliases**

**Task 3.1.1:** Display all current aliases

```
[Your command here]
```

**Task 3.1.2:** Create an alias 'll' that shows detailed file listing with human-readable sizes

```
[Your command here]
Hint: ls -lah
```

**Task 3.1.3:** Test your ll alias

```
[Your command here]
```

**Task 3.1.4:** Create an alias 'ports' that lists all listening ports

```
[Your command here]
Hint: netstat -tuln | grep LISTEN or ss -tuln | grep LISTEN
```

**Task 3.1.5:** Create a safety alias for rm that asks for confirmation

```
[Your command here]
Hint: rm -i
```

**Task 3.1.6:** Create an alias 'h' for viewing the last 20 history entries

```
[Your command here]
```

---

## **Exercise 3.2: Multi-Command Aliases**

**Task 3.2.1:** Create an alias 'sysinfo' that displays:

- System information (uname -a)
- Current user (whoami)
- Current directory (pwd)

```
[Your command here]
Hint: Use && to chain commands
```

**Task 3.2.2:** Test your sysinfo alias

```
[Your command here]
```

**Task 3.2.3:** Create an alias 'myinfo' that shows your username and all groups

```
[Your command here]
Hint: Use whoami and id commands
```

---

## **Exercise 3.3: Manage Aliases**

**Task 3.3.1:** Remove the 'h' alias you created

```
[Your command here]
```

**Task 3.3.2:** Verify 'h' no longer works as an alias

```
[Your command here]
Expected: command not found
```

**Task 3.3.3:** Bypass the 'll' alias and run the original ls command

```
[Your command here]
Hint: Use backslash before the command
```

**✓ Verification:** Run `alias` and confirm you see ll, ports, rm, sysinfo, and myinfo (but not h)

---

# **PART 4: COMMAND IDENTIFICATION (5-7 minutes)**

## **Exercise 4.1: Locate Commands**

**Task 4.1.1:** Find the location of the bash executable using which

```
[Your command here]
```

**Task 4.1.2:** Find comprehensive information about bash using whereis

```
[Your command here]
Expected: Shows binary, manual pages, etc.
```

**Task 4.1.3:** Find only the binary location of grep using whereis

```
[Your command here]
Hint: Use the -b flag
```

**Task 4.1.4:** Find the manual page location for ls using whereis

```
[Your command here]
Hint: Use the -m flag
```

---

## **Exercise 4.2: Identify Command Types**

**Task 4.2.1:** Determine what type of command 'cd' is

```
[Your command here]
Expected: shell builtin
```

**Task 4.2.2:** Determine what type of command 'll' is

```
[Your command here]
Expected: alias
```

**Task 4.2.3:** Determine what type of command 'echo' is and show all implementations

```
[Your command here]
Hint: Use the -a flag
Expected: Should show both builtin and /usr/bin/echo
```

**Task 4.2.4:** Check what type 'ls' is

```
[Your command here]
```

**Task 4.2.5:** Find all versions of python in your PATH

```
[Your command here]
Hint: which -a python3
```

**✓ Verification:** Create a simple alias `alias test='echo testing'`, then run `type test` to confirm it shows as an alias

---

# **PART 5: SYSTEM & USER IDENTITY (5-7 minutes)**

## **Exercise 5.1: System Information**

**Task 5.1.1:** Display the kernel name only

```
[Your command here]
Hint: uname -s
```

**Task 5.1.2:** Display complete system information

```
[Your command here]
```

**Task 5.1.3:** Display only the kernel version

```
[Your command here]
Hint: uname -r
```

**Task 5.1.4:** Display the machine hardware architecture

```
[Your command here]
Hint: uname -m
```

**Task 5.1.5:** Display your system's hostname

```
[Your command here]
```

**Task 5.1.6:** Display the fully qualified domain name (FQDN)

```
[Your command here]
Hint: hostname -f
```

**Task 5.1.7:** Display all IP addresses assigned to this machine

```
[Your command here]
Hint: hostname -I
```

---

## **Exercise 5.2: User Identity**

**Task 5.2.1:** Display your current username

```
[Your command here]
```

**Task 5.2.2:** Display your complete user and group information

```
[Your command here]
```

**Task 5.2.3:** Display only your user ID number

```
[Your command here]
Hint: id -u
```

**Task 5.2.4:** Display only your primary group ID

```
[Your command here]
Hint: id -g
```

**Task 5.2.5:** Display all group IDs you belong to

```
[Your command here]
Hint: id -G
```

**Task 5.2.6:** Display all group names (not IDs) you belong to

```
[Your command here]
Hint: id -Gn
```

**Task 5.2.7:** Check the user information for 'root'

```
[Your command here]
```

**✓ Verification:** Run the following command and ensure it completes without error:

```bash
echo "System: $(uname -s), User: $(whoami), UID: $(id -u), Hostname: $(hostname)"
```

---

# **PART 6: NAVIGATION & FILE LISTING (6-8 minutes)**

## **Exercise 6.1: Directory Navigation**

**Task 6.1.1:** Display your current working directory

```
[Your command here]
```

**Task 6.1.2:** Change to the /var/log directory

```
[Your command here]
```

**Task 6.1.3:** Confirm you're in /var/log

```
[Your command here]
```

**Task 6.1.4:** Change to the /etc directory

```
[Your command here]
```

**Task 6.1.5:** Jump back to /var/log using the shortcut

```
[Your command here]
Hint: cd -
```

**Task 6.1.6:** Jump back to /etc again using the same shortcut

```
[Your command here]
```

**Task 6.1.7:** Go to your home directory using the shortest command possible

```
[Your command here]
```

**Task 6.1.8:** Go up one directory level from your current location

```
[Your command here]
```

**Task 6.1.9:** Go up two directory levels from your current location

```
[Your command here]
Hint: Use ../..
```

**Task 6.1.10:** Return to your home directory using the ~ symbol

```
[Your command here]
```

---

## **Exercise 6.2: File Listing Mastery**

**Task 6.2.1:** List all files in your home directory (including hidden files) in long format with human-readable sizes

```
[Your command here]
```

**Task 6.2.2:** Navigate to /var/log and list files sorted by modification time (newest first)

```
[Your command here to navigate]
[Your command here to list]
```

**Task 6.2.3:** List files in /var/log sorted by size (largest first)

```
[Your command here]
```

**Task 6.2.4:** List only directories in your current location

```
[Your command here]
Hint: ls -ld */
```

**Task 6.2.5:** List files sorted by size in reverse order (smallest first)

```
[Your command here]
Hint: Combine -S with -r
```

**Task 6.2.6:** List files in /etc showing inode numbers

```
[Your command here]
Hint: Use -i flag
```

**Task 6.2.7:** Go to /tmp and create a test file, then list to verify

```
[Your command here to navigate]
[Your command here to create file]
Hint: touch testfile_<yourname>.txt
[Your command here to list]
```

**✓ Verification:** From any directory, run `ls -lah ~` to list your home directory without changing to it

---

# **PART 7: HISTORY MANAGEMENT (5-7 minutes)**

## **Exercise 7.1: View and Search History**

**Task 7.1.1:** Display the last 20 commands from your history

```
[Your command here]
```

**Task 7.1.2:** Count the total number of commands in your history

```
[Your command here]
Hint: Use wc -l
```

**Task 7.1.3:** Search your history for all commands containing "ls"

```
[Your command here]
Hint: history | grep ls
```

**Task 7.1.4:** Search your history for all commands containing "cd"

```
[Your command here]
```

**Task 7.1.5:** Display your HISTSIZE variable

```
[Your command here]
```

---

## **Exercise 7.2: Execute from History**

**Task 7.2.1:** Run the previous command again using !!

```
[Your command here - just type a simple echo first]
[Your command here - now use !!]
```

**Task 7.2.2:** List a file (any file), then use !$ to view its contents with cat

```
[Your command here to list]
Example: ls /etc/hostname
[Your command here to cat using !$]
```

**Task 7.2.3:** Find a command in your history that starts with "echo" and note its number

```
[Your command here]
```

**Task 7.2.4:** Execute that command by its history number

```
[Your command here]
Example: !125
```

**Task 7.2.5:** Use Ctrl+R to search for a previous "pwd" command

```
Press Ctrl+R, then type 'pwd'
Press Enter to execute
Document: I successfully used Ctrl+R: YES / NO
```

**Task 7.2.6:** Run the most recent command that started with "ls"

```
[Your command here]
Hint: !ls
```

---

## **Exercise 7.3: History Configuration**

**Task 7.3.1:** Display the timestamp format of your history (if set)

```
[Your command here]
Hint: echo $HISTTIMEFORMAT
```

**Task 7.3.2:** Set history to display timestamps in format "YYYY-MM-DD HH:MM:SS"

```
[Your command here]
Hint: export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
```

**Task 7.3.3:** View your last 10 history entries with timestamps

```
[Your command here]
```

**✓ Verification:** Run `history 5` and confirm you see the last 5 commands with timestamps

---

# **BONUS CHALLENGES (Optional - Extra 5-10 minutes)**

## **Challenge 1: Create a System Report Script**

Write a one-liner that displays:

- Hostname
- Current user
- User ID
- Kernel version
- Current directory

```
[Your command here]
Hint: Use echo with command substitution $(command)
```

---

## **Challenge 2: Advanced Alias**

Create an alias called 'status' that:

1. Shows current directory
2. Shows current user
3. Lists the 5 most recently modified files in current directory

```
[Your command here]
```

Test it:

```
[Your command here]
```

---

## **Challenge 3: Variable Chain**

Create three environment variables that reference each other:

- BASE_DIR="/opt/banking"
- APP_DIR="$BASE_DIR/applications"
- LOG_DIR="$APP_DIR/logs"

Then display LOG_DIR to verify the full path is constructed correctly.

```
[Your commands here]
```

---

## **Challenge 4: History Detective**

Find and execute (in order):

1. Your 5th command from history
2. The last command you ran that contained "echo"
3. The previous command using !!
4. Create a new command using the last argument from the previous command

```
[Your commands here]
```

---

## **Challenge 5: Command Type Investigation**

For each of the following, determine if it's an alias, builtin, or executable:

- cd
- ls
- pwd
- echo
- grep

Create a one-liner that checks all of them.

```
[Your command here]
Hint: Use a for loop or multiple type commands
```

---

# **LAB COMPLETION CHECKLIST**

Before submitting, ensure you have completed:

- [ ] **Part 1:** Shell Identification (5 tasks)
- [ ] **Part 2:** Environment Variables (18 tasks)
- [ ] **Part 3:** Aliases (11 tasks)
- [ ] **Part 4:** Command Identification (11 tasks)
- [ ] **Part 5:** System & User Identity (14 tasks)
- [ ] **Part 6:** Navigation & File Listing (17 tasks)
- [ ] **Part 7:** History Management (13 tasks)
- [ ] **Bonus Challenges (Optional):** 0-5 challenges

**Total Required Tasks:** 89  
**Bonus Challenges:** 5

---

# **FINAL SUBMISSION INSTRUCTIONS**

## **Step 1: Save Your History**

Execute the following command to save your complete command history:

```bash
history > ~/module1_lab_history_$(whoami)_$(date +%Y%m%d_%H%M%S).txt
```

This creates a file with your username and timestamp, for example:
`module1_lab_history_ubuntu_20251126_143000.txt`

---

## **Step 2: Verify Your History File**

Check that the file was created and contains your commands:

```bash
ls -lh ~/module1_lab_history_*.txt
wc -l ~/module1_lab_history_*.txt
```

You should have at least 100+ commands in your history from this lab.

---

## **Step 3: Review Your History File**

Take a moment to review what you accomplished:

```bash
less ~/module1_lab_history_*.txt
```

Press 'q' to quit the viewer.

---

## **Step 4: Create a Summary Report**

Create a simple report of your lab completion:

```bash
cat << EOF > ~/module1_lab_summary_$(whoami).txt
============================================
MODULE 1 LAB COMPLETION REPORT
============================================
Participant: $(whoami)
System: $(uname -n)
Date: $(date)
Kernel: $(uname -r)
Architecture: $(uname -m)

Total Commands Executed: $(history | wc -l)

Lab Components Completed:
✓ Shell Identification & Management
✓ Environment Variable Operations
✓ Alias Creation & Management
✓ Command Location & Identification
✓ System & User Identity Verification
✓ Directory Navigation & File Listing
✓ History Management & Navigation

Bonus Challenges Attempted: [Fill in: 0-5]

History File: ~/module1_lab_history_$(whoami)_$(date +%Y%m%d_%H%M%S).txt

============================================
EOF

cat ~/module1_lab_summary_$(whoami).txt
```

---

## **Step 5: Submit Your Work**

Submit the following files to your trainer:

1. **History File:** `~/module1_lab_history_<username>_<timestamp>.txt`
2. **Summary Report:** `~/module1_lab_summary_<username>.txt`

**Submission Methods:**

- Email to trainer
- Upload to shared drive
- Or as instructed by your trainer

---

## **Step 6: Clean Up (Optional)**

If you created test files during the lab, you can clean them up:

```bash
rm -i /tmp/testfile_*.txt 2>/dev/null
echo "Lab environment cleaned up"
```

---

# **TROUBLESHOOTING**

## **Common Issues and Solutions:**

### **Issue 1: "Command not found" errors**

- **Solution:** Verify the command is installed: `which <command>`
- **Solution:** Check if you're in the right shell: `echo $0`

### **Issue 2: Permission denied errors**

- **Solution:** Check if you need sudo: `sudo <command>`
- **Solution:** Verify file permissions: `ls -l <file>`

### **Issue 3: Alias not working**

- **Solution:** Verify alias is set: `alias`
- **Solution:** Make sure you exported if needed
- **Solution:** Source your profile: `source ~/.bashrc`

### **Issue 4: Variable not showing up**

- **Solution:** Check if it's exported: `env | grep <VARNAME>`
- **Solution:** Verify spelling (variables are case-sensitive)

### **Issue 5: History not saving properly**

- **Solution:** Make sure you're using the correct syntax
- **Solution:** Check permissions on home directory: `ls -ld ~`
- **Solution:** Verify HISTSIZE: `echo $HISTSIZE`

### **Issue 6: Can't find your history file**

- **Solution:** Run: `ls -lh ~/module1_lab_history_*.txt`
- **Solution:** Check current directory: `pwd`
- **Solution:** Navigate to home: `cd ~`

---

# **SELF-ASSESSMENT QUESTIONS**

After completing the lab, answer these questions honestly:

1. **Can you quickly identify what shell you're running?** YES / NO

2. **Can you create and export environment variables?** YES / NO

3. **Can you create useful aliases to save time?** YES / NO

4. **Do you understand the difference between which, whereis, and type?** YES / NO

5. **Can you navigate the filesystem efficiently using shortcuts?** YES / NO

6. **Can you use Ctrl+R to search command history?** YES / NO

7. **Can you identify your user ID and group memberships?** YES / NO

8. **Can you find the location of any installed command?** YES / NO

9. **Do you feel comfortable with the Linux command line?** YES / NO

10. **Are you ready to move to Module 2?** YES / NO

**If you answered NO to more than 2 questions, consider reviewing the demo materials and practicing more before Module 2.**

---

# **ADDITIONAL PRACTICE (If Time Permits)**

## **Practice Scenario: System Administrator Tasks**

Imagine you're a new sysadmin who just logged into a production server. Complete these tasks:

1. Identify the system (hostname, OS, kernel version)
2. Check who you're logged in as and what groups you have
3. Navigate to /var/log and find the 3 largest log files
4. Create an alias to make log monitoring easier
5. Add /opt/custom/bin to your PATH
6. Document all your commands in history

Time yourself: Can you do this in under 5 minutes?

---

# **TRAINER NOTES**

**For Trainer Use Only:**

**Evaluation Criteria:**

- History file must contain at least 89 commands (one per required task)
- Commands should demonstrate understanding, not just copy-paste
- Bonus challenges show initiative and deeper understanding

**Common Mistakes to Watch For:**

- Not exporting variables (creating local instead of environment)
- Forgetting to verify tasks with provided verification steps
- Mixing up which, whereis, and type commands
- Not using sudo when required
- Incorrect alias syntax (missing quotes)

**Time Management:**

- Fast learners: 30-35 minutes + bonus challenges
- Average pace: 40-45 minutes
- Struggling participants: 50-60 minutes (acceptable)

**Follow-Up:**

- Review each participant's history file
- Identify common mistakes for group discussion
- Provide individual feedback on command efficiency
- Use errors as teaching moments for the group

---

## **CONGRATULATIONS!**

You've completed Module 1: Linux Environment & Command Fundamentals!

**You now have mastered:**
✅ Shell management and identification  
✅ Environment variables and PATH manipulation  
✅ Alias creation for efficiency  
✅ Command location and type identification  
✅ System and user identity verification  
✅ Advanced navigation techniques  
✅ Powerful history management

**Next Steps:**

- Review your history file to see your progress
- Practice daily to build muscle memory
- Create permanent aliases in your ~/.bashrc
- Prepare for Module 2: Advanced File Handling & Text Processing

**Keep Learning!** 🚀

---

**Document Version:** 1.0  
**Last Updated:** November 2025  
**Prepared For:** Bank of America Training Program  
**Contact Trainer:** [Trainer Email/Contact]
