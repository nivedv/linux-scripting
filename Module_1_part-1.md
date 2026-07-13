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
