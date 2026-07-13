# Module 1 - Hands-On Lab-Part-2

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
