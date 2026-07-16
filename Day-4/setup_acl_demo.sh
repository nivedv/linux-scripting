#!/bin/bash
# ============================================
# ACL Demo Environment Setup
# Creates users, groups, and test structures
# ============================================

echo "=========================================="
echo "Setting up ACL Demo Environment"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
   echo "Please run with sudo: sudo bash setup_module14_acl_demo.sh"
   exit 1
fi

# ============================================
# STEP 1: Create Test Users
# ============================================
echo "[1/6] Creating test users..."

# User group: Loan Department
sudo useradd -m -s /bin/bash loanOfficer1 2>/dev/null || true
sudo useradd -m -s /bin/bash loanOfficer2 2>/dev/null || true

# User group: Risk Management
sudo useradd -m -s /bin/bash riskManager1 2>/dev/null || true
sudo useradd -m -s /bin/bash riskManager2 2>/dev/null || true

# User group: Finance
sudo useradd -m -s /bin/bash financeUser1 2>/dev/null || true

# User group: Legal/Compliance
sudo useradd -m -s /bin/bash legalUser1 2>/dev/null || true

# User group: Auditors
sudo useradd -m -s /bin/bash auditor1 2>/dev/null || true

echo "  ✅ Users created:"
echo "     - Loan Officers: loanOfficer1, loanOfficer2"
echo "     - Risk Managers: riskManager1, riskManager2"
echo "     - Finance: financeUser1"
echo "     - Legal: legalUser1"
echo "     - Auditors: auditor1"
echo ""

# ============================================
# STEP 2: Create Test Groups
# ============================================
echo "[2/6] Creating test groups..."

sudo groupadd loan_dept 2>/dev/null || true
sudo groupadd risk_dept 2>/dev/null || true
sudo groupadd finance_dept 2>/dev/null || true
sudo groupadd legal_dept 2>/dev/null || true
sudo groupadd audit_dept 2>/dev/null || true

echo "  ✅ Groups created:"
echo "     - loan_dept, risk_dept, finance_dept, legal_dept, audit_dept"
echo ""

# ============================================
# STEP 3: Add Users to Groups
# ============================================
echo "[3/6] Adding users to groups..."

# Loan Officers
sudo usermod -a -G loan_dept loanOfficer1
sudo usermod -a -G loan_dept loanOfficer2

# Risk Managers
sudo usermod -a -G risk_dept riskManager1
sudo usermod -a -G risk_dept riskManager2

# Finance Users
sudo usermod -a -G finance_dept financeUser1

# Legal Users
sudo usermod -a -G legal_dept legalUser1

# Auditors
sudo usermod -a -G audit_dept auditor1

echo "  ✅ Users added to groups"
echo ""

# ============================================
# STEP 4: Create Directory Structure
# ============================================
echo "[4/6] Creating demo directory structure..."

# Base directory
sudo mkdir -p /shared/loan_applications
sudo mkdir -p /shared/loan_processing
sudo mkdir -p /projects/merger_analysis
sudo mkdir -p /finance/reports/q3_2024

echo "  ✅ Directories created"
echo ""

# ============================================
# STEP 5: Set Up Initial Permissions
# ============================================
echo "[5/6] Setting up initial permissions..."

# Loan Applications Directory
# Owner: loanOfficer1, Group: loan_dept, Permission: 660
sudo chown loanOfficer1:loan_dept /shared/loan_applications
sudo chmod 660 /shared/loan_applications

# Create sample loan files
sudo touch /shared/loan_applications/loan_12345.txt
sudo touch /shared/loan_applications/loan_12346.txt
sudo touch /shared/loan_applications/loan_12347.txt

# Set file permissions to match
sudo chown loanOfficer1:loan_dept /shared/loan_applications/loan_*.txt
sudo chmod 660 /shared/loan_applications/loan_*.txt

# Loan Processing Directory (for SGID demo)
sudo mkdir -p /shared/loan_processing
sudo chown loanOfficer1:loan_dept /shared/loan_processing
sudo chmod 2770 /shared/loan_processing  # SGID bit set

# Projects Directory (for multi-team ACL demo)
sudo mkdir -p /projects/merger_analysis
sudo chown loanOfficer1:loan_dept /projects/merger_analysis
sudo chmod 770 /projects/merger_analysis

# Finance Reports
sudo mkdir -p /finance/reports/q3_2024
sudo chown financeUser1:finance_dept /finance/reports/q3_2024
sudo chmod 770 /finance/reports/q3_2024

# Create sample report files
sudo touch /finance/reports/q3_2024/financial_report.txt
sudo touch /finance/reports/q3_2024/audit_trail.log
sudo chown financeUser1:finance_dept /finance/reports/q3_2024/*.txt
sudo chown financeUser1:finance_dept /finance/reports/q3_2024/*.log
sudo chmod 640 /finance/reports/q3_2024/*.txt
sudo chmod 640 /finance/reports/q3_2024/*.log

echo "  ✅ Initial permissions set"
echo ""

# ============================================
# STEP 6: Verify Setup
# ============================================
echo "[6/6] Verifying setup..."
echo ""

echo "=== Users Created ==="
cut -d: -f1 /etc/passwd | grep -E "^(loanOfficer|riskManager|financeUser|legalUser|auditor)" | sort

echo ""
echo "=== Groups Created ==="
cut -d: -f1 /etc/group | grep -E "_(dept|team)" | sort

echo ""
echo "=== Directory Structure ==="
ls -ld /shared /projects /finance 2>/dev/null

echo ""
echo "=== Sample Files ==="
ls -l /shared/loan_applications/loan_*.txt 2>/dev/null | head -3

echo ""
echo "=========================================="
echo "✅ Setup Complete!"
echo "=========================================="
echo ""
echo "Ready for ACL demos!"
echo ""
echo "Test Access:"
echo "  sudo su - loanOfficer1"
echo "  cat /shared/loan_applications/loan_12345.txt"
echo ""
echo "Cleanup when done:"
echo "  sudo bash cleanup_module14_acl_demo.sh"
echo ""