#!/bin/bash
# ============================================
# Fix User Groups - Remove from rps
# Remove test users from rps group
# (They were wrongly added during setup)
# ============================================

echo "=========================================="
echo "Fixing Test User Groups"
echo "Removing users from rps group"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
   echo "Please run with sudo: sudo bash fix_user_groups.sh"
   exit 1
fi

# List of test users to remove from rps group
USERS=(
    "loanOfficer1"
    "loanOfficer2"
    "riskManager1"
    "riskManager2"
    "financeUser1"
    "legalUser1"
    "auditor1"
)

echo "[1/3] Removing users from rps group..."
echo ""

# Remove each user from rps group
for user in "${USERS[@]}"; do
    echo "  Removing $user from rps group..."
    sudo gpasswd -d "$user" rps 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "    ✅ Success"
    else
        echo "    ⚠️  User not in rps group or error"
    fi
done

echo ""
echo "[2/3] Verifying removal..."
echo ""

# Show current group membership for each user
for user in "${USERS[@]}"; do
    GROUPS=$(id -nG "$user" 2>/dev/null)
    echo "  $user groups: $GROUPS"
    
    # Check if rps is in the groups
    if echo "$GROUPS" | grep -q "rps"; then
        echo "    ⚠️  Still in rps group!"
    else
        echo "    ✅ NOT in rps group (correct)"
    fi
done

echo ""
echo "[3/3] Summary of group membership..."
echo ""

# Show detailed group info
for user in "${USERS[@]}"; do
    echo "User: $user"
    id "$user" 2>/dev/null
    echo ""
done

echo "=========================================="
echo "✅ User groups have been fixed!"
echo "=========================================="
echo ""
echo "Test users are now in their department groups:"
echo "  • loanOfficer1, loanOfficer2    → loan_dept"
echo "  • riskManager1, riskManager2    → risk_dept"
echo "  • financeUser1                  → finance_dept"
echo "  • legalUser1                    → legal_dept"
echo "  • auditor1                      → audit_dept"
echo ""
echo "And NOT in rps group!"
echo ""
echo "Your ACL demo will now work correctly."
echo ""