#!/bin/bash
# ============================================
# Module 14: ACL Demo Environment Setup
# Creates users, groups, and test structures
# in /home/rps directory
# 
# NOTE: Permissions are NOT set here
# They will be demonstrated live in the demo
# ============================================

echo "=========================================="
echo "Setting up ACL Demo Environment"
echo "Home directory: /home/rps"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
   echo "Please run with sudo: sudo bash setup_module14_acl_demo.sh"
   exit 1
fi

# ============================================
# STEP 0: Create/Verify rps user
# ============================================
echo "[0/5] Checking rps user..."

if id "rps" &>/dev/null; then
    echo "  ✅ User 'rps' already exists"
else
    echo "  Creating user 'rps'..."
    sudo useradd -m -s /bin/bash rps
    echo "  ✅ User 'rps' created"
fi

RPS_HOME=$(eval echo ~rps)
echo "  Home directory: $RPS_HOME"
echo ""

# ============================================
# STEP 1: Create Test Users
# ============================================
echo "[1/5] Creating test users..."

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
echo "[2/5] Creating test groups..."

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
echo "[3/5] Adding users to groups..."

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

# Add all test users to rps group for cross-access
sudo usermod -a -G rps loanOfficer1
sudo usermod -a -G rps loanOfficer2
sudo usermod -a -G rps riskManager1
sudo usermod -a -G rps riskManager2
sudo usermod -a -G rps financeUser1
sudo usermod -a -G rps legalUser1
sudo usermod -a -G rps auditor1

echo "  ✅ Users added to groups"
echo "  ✅ All test users added to 'rps' group for access"
echo ""

# ============================================
# STEP 4: Create Directory and File Structure
# ============================================
echo "[4/5] Creating demo directory structure..."

# Create directories in rps home
# NOTE: Using default permissions (not customizing)
sudo mkdir -p "$RPS_HOME/loan_applications"
sudo mkdir -p "$RPS_HOME/loan_processing"
sudo mkdir -p "$RPS_HOME/merger_analysis"
sudo mkdir -p "$RPS_HOME/finance_reports"

# Ensure rps owns all directories
sudo chown -R rps:rps "$RPS_HOME/loan_applications"
sudo chown -R rps:rps "$RPS_HOME/loan_processing"
sudo chown -R rps:rps "$RPS_HOME/merger_analysis"
sudo chown -R rps:rps "$RPS_HOME/finance_reports"

# Create sample files (NO permission changes yet - will do in demo!)
sudo touch "$RPS_HOME/loan_applications/loan_12345.txt"
sudo touch "$RPS_HOME/loan_applications/loan_12346.txt"
sudo touch "$RPS_HOME/loan_applications/loan_12347.txt"

sudo touch "$RPS_HOME/merger_analysis/analysis_report.txt"

sudo touch "$RPS_HOME/finance_reports/financial_report.txt"
sudo touch "$RPS_HOME/finance_reports/audit_trail.log"

# Set ownership of files to rps
sudo chown rps:rps "$RPS_HOME/loan_applications/"*.txt
sudo chown rps:rps "$RPS_HOME/merger_analysis/"*.txt
sudo chown rps:rps "$RPS_HOME/finance_reports/"*

echo "  ✅ Directories created in $RPS_HOME:"
echo "     - loan_applications/"
echo "     - loan_processing/"
echo "     - merger_analysis/"
echo "     - finance_reports/"
echo ""
echo "  ✅ Sample files created (default permissions)"
echo ""

# ============================================
# STEP 5: Create Test Access Script
# ============================================
echo "[5/5] Creating convenience scripts..."

# Create a test access script
cat > "$RPS_HOME/test_acl_access.sh" << 'EOF'
#!/bin/bash
# Test script to verify ACL access

TEST_FILE="/home/rps/loan_applications/loan_12345.txt"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║       Testing ACL Access Permissions                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "Current user: $(whoami)"
echo "User groups: $(groups)"
echo ""

echo "Attempting to read: $TEST_FILE"
if cat "$TEST_FILE" 2>/dev/null; then
    echo "✅ READ: Success"
else
    echo "❌ READ: Permission denied"
fi

echo ""
echo "File permissions:"
ls -l "$TEST_FILE"

echo ""
echo "File ACL:"
getfacl "$TEST_FILE"
EOF

chmod +x "$RPS_HOME/test_acl_access.sh"
sudo chown rps:rps "$RPS_HOME/test_acl_access.sh"

echo "  ✅ Test access script created:"
echo "     - /home/rps/test_acl_access.sh"
echo ""

# ============================================
# VERIFY SETUP
# ============================================
echo "Verifying setup..."
echo ""

echo "=== Users Created ==="
cut -d: -f1 /etc/passwd | grep -E "^(loanOfficer|riskManager|financeUser|legalUser|auditor)" | sort

echo ""
echo "=== Groups Created ==="
cut -d: -f1 /etc/group | grep -E "_(dept|team)|^rps$" | sort

echo ""
echo "=== Directory Structure ==="
ls -ld "$RPS_HOME"/loan_* "$RPS_HOME"/merger_* "$RPS_HOME"/finance_* 2>/dev/null

echo ""
echo "=== Sample Files (with DEFAULT permissions) ==="
ls -l "$RPS_HOME/loan_applications/loan_12345.txt"
echo ""
echo "NOTE: Permissions are at DEFAULT. You will change them in the live demo!"

echo ""
echo "=== Current ACL (should be empty) ==="
getfacl "$RPS_HOME/loan_applications/loan_12345.txt" 2>/dev/null | grep -E "^(user|group|mask|other):"

echo ""
echo "=========================================="
echo "✅ Setup Complete!"
echo "=========================================="
echo ""
echo "Demo Location: /home/rps/"
echo ""
echo "IMPORTANT: Files have DEFAULT permissions"
echo "You will demonstrate chmod and ACL changes live!"
echo ""
echo "Ready to Demo:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Test access script:"
echo "  bash /home/rps/test_acl_access.sh"
echo ""
echo "View current permissions:"
echo "  ls -l /home/rps/loan_applications/"
echo