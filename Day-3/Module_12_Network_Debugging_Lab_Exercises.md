# Module 12: Network Debugging & Tuning - Hands-On Lab Exercises
## Practical Exercises for Isolated Lab Environments

**Duration:** 90 minutes  
**Environment:** Ubuntu 24.04 VM with SSH access  
**Prerequisites:** Modules 1-11 completed  
**Target Audience:** Bank of America IT professionals

---

## **Lab Environment Setup (15 minutes)**

### **Pre-Lab Checklist:**

Before starting any exercises, verify your lab environment:

```bash
# 1. Verify you have tcpdump installed
which tcpdump
# Expected: /usr/bin/tcpdump

# 2. Verify you have netcat installed
which nc
# Expected: /usr/bin/nc

# 3. Verify you have nmap installed
which nmap
# Expected: /usr/bin/nmap

# 4. Verify Python3 is available (for local web server)
python3 --version
# Expected: Python 3.10.x or higher

# 5. Check your network interfaces
ip link show
# Expected: lo, eth0, or similar

# 6. Verify sudo access
sudo id
# Expected: uid=0(root) - you're root
```

### **Setup Your Lab Services:**

```bash
# Terminal 1: Start a local HTTP server
cd /tmp
mkdir -p lab-demo
cd lab-demo

# Create sample HTML file
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Bank Demo</title></head>
<body>
  <h1>Bank of America - Demo Server</h1>
  <p>This is a test server for network debugging exercises.</p>
</body>
</html>
EOF

# Create a simple API endpoint
cat > api.json << 'EOF'
{
  "status": "online",
  "service": "Payment Processing",
  "version": "2.1.4",
  "transactions": 12345
}
EOF

# Start web server on port 8080
python3 -m http.server 8080 > /tmp/webserver.log 2>&1 &
echo "Web server started on port 8080 (PID: $!)"

# Verify it's running
sleep 1
curl -s http://localhost:8080 | head -5
```

**Expected output:**
```html
<!DOCTYPE html>
<html>
<head><title>Bank Demo</title></head>
<body>
```

---

## **LAB 1: Network Diagnostic Tools (netstat, ss, tcpdump)**
**Time Allocation: 20 minutes**

### **Exercise 1.1: Service Inventory with ss (5 min)**

**Scenario:** "We need to audit what services are running and listening for connections on our server"

```bash
# TASK 1: List all listening services
sudo ss -tlnp

# Expected output:
# State    Recv-Q Send-Q Local Address:Port Peer Address:Port Process
# LISTEN   0      128    *:22                *:*                 users:(("sshd",pid=1234))
# LISTEN   0      128    *:8080              *:*                 users:(("python3",pid=5678))

# QUESTION 1: What port is your SSH server listening on?
# Answer: ___________

# QUESTION 2: What port is your web server listening on?
# Answer: ___________
```

```bash
# TASK 2: Check current connections
sudo ss -tunap | head -20

# What do you see?
# - LISTEN = service waiting for connections
# - ESTAB = active connections
# - TIME-WAIT = connections closing

# QUESTION 3: Are there any ESTAB connections? Why/why not?
# Answer: ___________
```

```bash
# TASK 3: Filter to specific port
sudo ss -tunapl | grep :8080

# Expected output:
# tcp LISTEN 0 128 *:8080 *:* users:(("python3",pid=5678))

# QUESTION 4: What does "LISTEN" mean?
# Answer: The service is waiting for incoming connections
```

### **Exercise 1.2: Understanding Connection States (5 min)**

**Scenario:** "A developer says 'the database won't connect'. Let's check if it's a network issue or DB issue"

```bash
# Terminal 1: Look at your current connections
watch -n 1 'sudo ss -tunap | grep -E "LISTEN|ESTAB"'

# This updates every 1 second. Leave it running.

# Terminal 2: Generate traffic to create connections
curl http://localhost:8080
curl http://localhost:8080/api.json
curl http://localhost:8080

# Back to Terminal 1: Did you see new connections appear?
# Press Ctrl+C to stop watch

# QUESTION 5: When curl finishes, what happens to the connection state?
# Answer: ___________
```

```bash
# TASK 4: Check for stuck connections
sudo ss -tunap | grep CLOSE_WAIT

# If you see CLOSE_WAIT = application bug! (not closing connections properly)
# This indicates a resource leak

# QUESTION 6: Do you have any CLOSE_WAIT connections?
# Answer: ___________
```

### **Exercise 1.3: Tcpdump - Capture Traffic (10 min)**

**Scenario:** "Users report the website is slow. Let's capture packets to see if data is actually flowing"

```bash
# SETUP: Open 2 terminals side by side

# ===== TERMINAL 1: Start capture =====
sudo timeout 10 tcpdump -i any -n 'port 8080' -w /tmp/http_capture.pcap

# The command will wait for traffic. You have 10 seconds.
# If no traffic comes, it will show: "0 packets captured"

# ===== TERMINAL 2: Generate traffic (while Terminal 1 is capturing) =====
# Wait 1 second for tcpdump to start
sleep 1

# Make 5 requests
for i in {1..5}; do
  curl http://localhost:8080
  sleep 0.5
done

# ===== BACK TO TERMINAL 1: =====
# Should show: "5 packets captured" (or more)
```

```bash
# TASK 5: View captured packets
tcpdump -r /tmp/http_capture.pcap

# Expected output showing packet headers:
# 22:34:15.123456 IP 127.0.0.1.45678 > 127.0.0.1.8080: Flags [S]
# 22:34:15.123457 IP 127.0.0.1.8080 > 127.0.0.1.45678: Flags [S.]

# QUESTION 7: What does "Flags [S]" mean?
# Answer: SYN packet (start of 3-way handshake)

# QUESTION 8: What does "Flags [S.]" mean?
# Answer: SYN-ACK packet (server responding)
```

```bash
# TASK 6: View packet details
sudo tcpdump -r /tmp/http_capture.pcap -v | head -30

# QUESTION 9: Can you identify the 3-way handshake? 
# Write out the 3 packets:
# 1. ___________ (Client to Server)
# 2. ___________ (Server to Client)
# 3. ___________ (Client to Server)
```

```bash
# TASK 7: Show actual HTTP data
sudo tcpdump -r /tmp/http_capture.pcap -A | grep -i "GET\|HTTP" | head -10

# You should see HTTP request headers:
# GET / HTTP/1.1
# Host: localhost:8080
# User-Agent: curl/...

# QUESTION 10: What HTTP method is used? 
# Answer: ___________
```

---

## **LAB 2: Connectivity Testing (ping, traceroute, netcat)**
**Time Allocation: 15 minutes**

### **Exercise 2.1: Ping - Testing Reachability (5 min)**

**Scenario:** "Database server isn't responding. Is it even reachable?"

```bash
# TASK 1: Ping localhost (should always work)
ping -c 3 localhost

# Expected: 3 replies with timing
# Example:
# 64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.045 ms

# QUESTION 11: What does "ttl=64" mean?
# Answer: Time To Live - packets can bounce 64 times before expiring
```

```bash
# TASK 2: Ping your own IP
ping -c 3 127.0.0.1

# Expected: Same as localhost (127.0.0.1 IS localhost)

# QUESTION 12: Ping your web server on port 8080
# Can you do: ping -c 3 localhost:8080
# Expected: ___________
# Why or why not?: ___________
```

```bash
# TASK 3: Check round-trip time
ping -c 1 localhost
# Look at: "time=X.XXX ms"

# Banking context:
# - < 1ms = same server (localhost)
# - 1-5ms = same data center
# - 10-50ms = same region
# - 100-150ms = different continent
# - 200ms+ = very far away

# QUESTION 13: If you ping a server in Delaware from Mumbai 
# and get 180ms, is that normal?
# Answer: ___________
```

### **Exercise 2.2: Traceroute - Path Discovery (5 min)**

**Scenario:** "Connection to payment processing server is SLOW. Where's the bottleneck?"

```bash
# TASK 1: Traceroute to localhost
traceroute -n -w 1 -m 5 localhost

# Expected output:
# traceroute to localhost (127.0.0.1), 5 hops max
#  1  127.0.0.1  0.025 ms  0.031 ms  0.037 ms

# Only 1 hop because you're on the same machine!

# QUESTION 14: Why is localhost only 1 hop?
# Answer: ___________
```

```bash
# TASK 2: Try traceroute to Google (may not work in isolated lab)
traceroute -n -w 2 -m 15 google.com

# If it works: You'll see multiple hops to Google
# If it fails: You'll see timeouts (*) - this is expected in isolated lab

# QUESTION 15: What does "* * *" mean on a hop?
# Answer: ___________
```

```bash
# TASK 3: Create a traceable path (lab workaround)
# Since we don't have internet, let's simulate with localhost

# Start a netcat server on a different port
nc -l -p 5555 > /dev/null 2>&1 &
echo "Netcat listening on port 5555"

# Traceroute won't work with TCP, but this shows the concept
# In real labs, traceroute would show multiple hops to this server

# QUESTION 16: In a real scenario, what would each hop represent?
# Answer: Each router/server the packet passes through
```

### **Exercise 2.3: Netcat - Port Testing (5 min)**

**Scenario:** "The firewall might be blocking port 3306 (MySQL). Let me test it"

```bash
# TASK 1: Check if port 8080 is open (should be)
nc -zv localhost 8080

# Expected: "localhost [127.0.0.1] 8080 (http-alt) open"

# QUESTION 17: What does "zv" mean in netcat?
# -z = just scan, don't send data
# -v = verbose (tell me the results)

# QUESTION 18: What happens if port 8080 was closed?
# Answer: ___________
```

```bash
# TASK 2: Check a port that's closed
nc -zv localhost 9999

# Expected: "localhost [127.0.0.1] 9999 (??) : Connection refused"

# QUESTION 19: "Connection refused" vs "No response" - difference?
# Connection refused = firewall actively said no
# No response = firewall silently dropped packet (stealth mode)
```

```bash
# TASK 3: Scan multiple ports quickly
for port in 22 80 443 8080 3306 5432; do
  echo "=== Testing port $port ==="
  nc -zv -w 1 localhost $port 2>&1 | grep -E "open|refused"
done

# Output example:
# === Testing port 22 ===
# localhost [127.0.0.1] 22 (ssh) open
# === Testing port 80 ===
# localhost [127.0.0.1] 80 (http) : Connection refused
# === Testing port 8080 ===
# localhost [127.0.0.1] 8080 (http-alt) open

# QUESTION 20: Which ports are open on your system?
# Answer: ___________
```

---

## **LAB 3: Port Scanning with nmap**
**Time Allocation: 15 minutes**

### **Exercise 3.1: Basic Service Discovery (5 min)**

**Scenario:** "New server deployed. What services are running? Let me scan it"

```bash
# TASK 1: Scan localhost for open ports
nmap localhost

# Expected output:
# Starting Nmap 7.x...
# Host is up (0.00015s latency).
# Not shown: 998 closed ports
# PORT     STATE SERVICE
# 22/tcp   open  ssh
# 8080/tcp open  http-proxy

# QUESTION 21: What's the difference between "open" and "closed"?
# open = service listening, accepts connections
# closed = port responded with "no one here"
```

```bash
# TASK 2: Get service name and version
nmap -sV localhost

# Expected: Shows service versions
# 22/tcp   open  ssh     OpenSSH 8.9p1 Ubuntu
# 8080/tcp open  http    Python http.server

# QUESTION 22: What version of SSH is running?
# Answer: ___________

# QUESTION 23: Why do we care about version numbers?
# Answer: To check for known security vulnerabilities
```

```bash
# TASK 3: Aggressive scan (more info)
nmap -A localhost

# This combines:
# -A = OS detection, version detection, script scanning

# Output includes:
# - Open ports
# - Services and versions
# - OS fingerprinting
# - Possible vulnerabilities

# QUESTION 24: Is nmap considered a security tool or attack tool?
# Answer: Both! It's legit if you own the server you're scanning.
```

### **Exercise 3.2: Specific Port Scanning (5 min)**

**Scenario:** "Firewall admin says ports 80 and 443 are blocked. Let me verify"

```bash
# TASK 1: Scan specific ports
nmap -p 22,80,443,8080 localhost

# Expected:
# PORT     STATE   SERVICE
# 22/tcp   open    ssh
# 80/tcp   closed  http         ← closed
# 443/tcp  closed  https        ← closed
# 8080/tcp open    http-proxy

# QUESTION 25: Port 80 shows "closed" - does that mean traffic is blocked?
# Answer: Closed = port responded. Firewall DROP would show "filtered"
```

```bash
# TASK 2: Scan range of ports
nmap -p 1-1000 localhost

# Shows all ports from 1-1000
# Banking note: Ports 1-1024 are "well-known" ports (privileged)

# QUESTION 26: How many ports are typically open on a secure server?
# Answer: As few as possible! Only what's needed.
```

```bash
# TASK 3: UDP scanning
nmap -sU -p 53,123 localhost

# Scans UDP ports:
# 53 = DNS
# 123 = NTP (time sync)

# DNS might show "open|filtered" = unsure if open

# QUESTION 27: Why do we scan UDP separately?
# Answer: TCP and UDP are different protocols, need separate scanning
```

### **Exercise 3.3: Stealth vs Aggressive (5 min)**

**Scenario:** "Paranoid IDS (Intrusion Detection System) on the network. Can I scan quietly?"

```bash
# TASK 1: TCP SYN scan (stealthier)
nmap -sS localhost

# -sS = TCP SYN scan (half-open)
# Doesn't complete the connection
# Older IDS might not log it
# More stealthy than full connection

# QUESTION 28: In a 3-way handshake, what does SYN scan skip?
# Answer: The final ACK (doesn't fully open connection)
```

```bash
# TASK 2: Full connection scan (noisier)
nmap -sT localhost

# -sT = TCP connect scan (full 3-way handshake)
# Completes full connection
# More likely to be logged
# But more reliable

# QUESTION 29: Which is better for your bank's internal security team?
# Answer: -sT (full visibility of what connected)
```

```bash
# TASK 3: Timing options
nmap -T3 localhost      # Normal timing
nmap -T1 localhost      # Slow/stealthy
nmap -T5 localhost      # Fast/aggressive

# -T0 = paranoid (super slow)
# -T1 = sneaky
# -T2 = polite
# -T3 = normal (default)
# -T4 = aggressive
# -T5 = insane (fast but unreliable)

# Banking context:
# Use -T3 for regular scans
# Use -T1 if avoiding IDS alerts

# QUESTION 30: What's the downside of using -T1?
# Answer: Takes much longer (might take hours instead of seconds)
```

---

## **LAB 4: Analyzing Connection Errors**
**Time Allocation: 20 minutes**

### **Exercise 4.1: Connection Refused vs Timeout (5 min)**

**Scenario:** "Application won't connect to database. Is it a network problem or DB problem?"

```bash
# TASK 1: Successful connection (for comparison)
nc -w 2 localhost 8080
# Should connect immediately
# Type something then Ctrl+D
# Expected: HTML response

# QUESTION 31: What does this successful connection tell you?
# Answer: ___________
```

```bash
# TASK 2: Connection refused (port closed)
nc -w 2 localhost 9999
# Refused immediately
# Error: Connection refused

# QUESTION 32: "Connection refused" indicates what?
# Answer: Firewall actively rejected us, or no service listening
```

```bash
# TASK 3: Timeout (no response)
# Start a netcat server that doesn't respond
nc -l -p 7777 > /dev/null 2>&1 &

# Try to connect to it
nc -w 1 localhost 7777
# Will timeout after 1 second
# Error: No route to host

# QUESTION 33: How is timeout different from refused?
# Answer: ___________
```

```bash
# TASK 4: Diagnostic decision tree
# When DB won't connect:

echo "=== Testing Database Connectivity ==="
echo "1. Is DB port open?"
nc -zv localhost 3306 2>&1

echo "2. Is DB service running?"
ps aux | grep -i mysql

echo "3. Firewall allowing it?"
sudo ss -tunapl | grep 3306

echo "4. Can we reach the server?"
ping -c 1 localhost

# Each answer narrows down the problem

# QUESTION 34: If nc returns "Connection refused" but ps shows MySQL running,
# what's the most likely problem?
# Answer: ___________
```

### **Exercise 4.2: TCP State Analysis (5 min)**

**Scenario:** "Support ticket: 'Website is slow' - let's check connection health"

```bash
# TASK 1: Capture and analyze TCP states
# Terminal 1: Monitor connections
watch -n 0.5 'sudo ss -tunap | grep -E "LISTEN|ESTAB|SYN|TIME_WAIT"'

# Terminal 2: Generate sustained traffic
for i in {1..100}; do
  curl -s http://localhost:8080 > /dev/null &
done
wait

# QUESTION 35: During the load, what connection states did you see?
# Answer: ___________
```

```bash
# TASK 2: Check for connection leaks
# Too many TIME-WAIT = connection leak risk
sudo ss -tunap | grep TIME_WAIT | wc -l

# Normal: < 100
# Warning: 100-500
# Critical: > 500

# QUESTION 36: If you see 2000 TIME-WAIT connections, what's wrong?
# Answer: Application closing connections but OS hasn't cleaned them up
```

```bash
# TASK 3: Identify zombie connections
sudo ss -tunap | grep CLOSE_WAIT

# CLOSE_WAIT = app received FIN (close request) but didn't close its end
# = MEMORY LEAK in application!

# QUESTION 37: If your app has 500 CLOSE_WAIT connections, 
# what should you do?
# Answer: Restart the application (memory leak)
```

### **Exercise 4.3: Full Troubleshooting Workflow (10 min)**

**Scenario:** "Payment processing API is down. We need to troubleshoot it step-by-step"

```bash
# Simulate the problem: Stop the web server
kill $(lsof -t -i :8080)
echo "Web server stopped"
sleep 2

# Step 1: Can we reach the server?
echo "=== STEP 1: Connectivity ==="
ping -c 1 localhost
# Expected: FAILED (but only because port stopped, not network)
# In real scenario: checks if server is powered on

# Step 2: Is the server responding at all?
echo -e "\n=== STEP 2: Basic Response ==="
nc -zv -w 1 localhost 8080
# Expected: Connection refused
# Interpretation: Server is up, but no service on port 8080

# Step 3: Check if service is running
echo -e "\n=== STEP 3: Process Check ==="
ps aux | grep http.server | grep -v grep
# Expected: No output
# Interpretation: Service is NOT running

# Step 4: Check logs
echo -e "\n=== STEP 4: Check Logs ==="
tail -10 /tmp/webserver.log
# Expected: Shows why it stopped

# Step 5: Restart service
echo -e "\n=== STEP 5: Restart Service ==="
cd /tmp/lab-demo && python3 -m http.server 8080 > /tmp/webserver.log 2>&1 &
sleep 2

# Step 6: Verify recovery
echo -e "\n=== STEP 6: Verify ==="
curl -s http://localhost:8080 | head -3
# Expected: HTML content

# QUESTION 38: Write the troubleshooting sequence:
# 1. ___________
# 2. ___________
# 3. ___________
# 4. ___________
# 5. ___________
```

```bash
# Bonus: Create a monitoring script
cat > /tmp/check_service.sh << 'EOF'
#!/bin/bash

SERVICE_PORT=8080
SERVICE_HOST=localhost
SERVICE_NAME="API Server"

echo "Checking $SERVICE_NAME..."

# Check 1: Port responding
if nc -zv -w 1 $SERVICE_HOST $SERVICE_PORT 2>&1 | grep -q open; then
  echo "✓ Port $SERVICE_PORT is open"
else
  echo "✗ Port $SERVICE_PORT is CLOSED"
  exit 1
fi

# Check 2: Service responds
if curl -s http://$SERVICE_HOST:$SERVICE_PORT/ | grep -q "Bank"; then
  echo "✓ Service responding correctly"
else
  echo "✗ Service not responding as expected"
  exit 1
fi

# Check 3: Response time
RESPONSE_TIME=$(curl -s -o /dev/null -w '%{time_total}' http://$SERVICE_HOST:$SERVICE_PORT/)
echo "✓ Response time: ${RESPONSE_TIME}s"

if (( $(echo "$RESPONSE_TIME > 1.0" | bc -l) )); then
  echo "⚠ WARNING: Slow response detected!"
fi

echo "All checks passed!"
EOF

chmod +x /tmp/check_service.sh
/tmp/check_service.sh

# QUESTION 39: What would you add to this monitoring script?
# Answer: ___________
```

---

## **LAB 5: Integration Exercise - Build Your Own Monitoring Script (15 min)**

**Scenario:** "Create an automated health check for a banking microservice"

### **Exercise 5.1: Combine All Tools**

```bash
# Create comprehensive monitoring script
cat > /tmp/bank_health_check.sh << 'EOFSCRIPT'
#!/bin/bash

# BANK OF AMERICA - Service Health Check
# Combines: ss, tcpdump, ping, nc, nmap

SERVICE_HOST="localhost"
SERVICE_PORT="8080"
SERVICE_NAME="Payment Processing API"
REPORT_FILE="/tmp/health_report.txt"

echo "========================================" > $REPORT_FILE
echo "$SERVICE_NAME - Health Check Report" >> $REPORT_FILE
echo "Timestamp: $(date)" >> $REPORT_FILE
echo "========================================" >> $REPORT_FILE

# CHECK 1: Network Connectivity
echo -e "\n[CHECK 1] Network Connectivity" >> $REPORT_FILE
if ping -c 1 $SERVICE_HOST &>/dev/null; then
  echo "✓ Host is reachable" >> $REPORT_FILE
else
  echo "✗ Host is NOT reachable" >> $REPORT_FILE
fi

# CHECK 2: Port Status
echo -e "\n[CHECK 2] Port Status" >> $REPORT_FILE
if nc -zv -w 1 $SERVICE_HOST $SERVICE_PORT 2>&1 | grep -q open; then
  echo "✓ Port $SERVICE_PORT is open" >> $REPORT_FILE
else
  echo "✗ Port $SERVICE_PORT is closed" >> $REPORT_FILE
fi

# CHECK 3: Service Details (ss)
echo -e "\n[CHECK 3] Service Listening Details" >> $REPORT_FILE
sudo ss -tunapl | grep $SERVICE_PORT >> $REPORT_FILE 2>&1

# CHECK 4: Active Connections
echo -e "\n[CHECK 4] Active Connections" >> $REPORT_FILE
CONN_COUNT=$(sudo ss -tunap | grep ESTAB | wc -l)
echo "Active connections: $CONN_COUNT" >> $REPORT_FILE

# CHECK 5: Connection Queue
echo -e "\n[CHECK 5] Connection Queue Status" >> $REPORT_FILE
sudo ss -tunapl | grep LISTEN | grep $SERVICE_PORT >> $REPORT_FILE

# CHECK 6: Response Test
echo -e "\n[CHECK 6] Application Response" >> $REPORT_FILE
RESPONSE=$(curl -s -w "%{http_code}\n" -o /dev/null http://$SERVICE_HOST:$SERVICE_PORT/)
echo "HTTP Status Code: $RESPONSE" >> $REPORT_FILE

if [ "$RESPONSE" = "200" ]; then
  echo "✓ Service responding correctly" >> $REPORT_FILE
else
  echo "✗ Service returned error code $RESPONSE" >> $REPORT_FILE
fi

# CHECK 7: Response Time
echo -e "\n[CHECK 7] Performance Metrics" >> $REPORT_FILE
RESPONSE_TIME=$(curl -s -o /dev/null -w '%{time_total}' http://$SERVICE_HOST:$SERVICE_PORT/)
echo "Response time: ${RESPONSE_TIME}s" >> $REPORT_FILE

# Summary
echo -e "\n========================================" >> $REPORT_FILE
echo "Report generated: $(date)" >> $REPORT_FILE
echo "========================================" >> $REPORT_FILE

# Display report
cat $REPORT_FILE

EOFSCRIPT

chmod +x /tmp/bank_health_check.sh
/tmp/bank_health_check.sh
```

```bash
# View the generated report
cat /tmp/health_report.txt

# QUESTION 40: What's missing from this health check?
# Suggestions:
# - CPU/Memory usage
# - Disk space
# - Database connectivity
# - Multiple service checks
# - Alerting mechanism
```

### **Exercise 5.2: Create Packet Capture Script**

```bash
# Create a script that captures and analyzes traffic
cat > /tmp/capture_and_analyze.sh << 'EOFSCRIPT'
#!/bin/bash

# Network Analysis Script for Banking Services

PORT=$1
DURATION=${2:-5}
OUTPUT_FILE="/tmp/capture_${PORT}_$(date +%s).pcap"

echo "Capturing traffic on port $PORT for $DURATION seconds..."
echo "Output: $OUTPUT_FILE"

# Capture packets
sudo timeout $DURATION tcpdump -i any -n "port $PORT" -w $OUTPUT_FILE 2>&1 | grep -v "tcpdump:"

# Wait for capture to complete
sleep $((DURATION + 1))

# Analyze packets
echo -e "\n=== PACKET ANALYSIS ==="
echo "Total packets:"
tcpdump -r $OUTPUT_FILE -q | wc -l

echo -e "\nPacket breakdown:"
tcpdump -r $OUTPUT_FILE -q | awk '{print $NF}' | sort | uniq -c | sort -rn

echo -e "\nConnection states:"
tcpdump -r $OUTPUT_FILE | grep "Flags" | sort | uniq -c

echo -e "\nTop source IPs:"
tcpdump -r $OUTPUT_FILE -q | awk '{print $2}' | cut -d. -f1-3 | sort | uniq -c | sort -rn | head -5

EOFSCRIPT

chmod +x /tmp/capture_and_analyze.sh

# Use it to capture API traffic
/tmp/capture_and_analyze.sh 8080 3
```

---

## **Knowledge Check Quiz**

Answer these questions to verify your understanding:

```bash
# QUESTION 41: In the ss output, what does "-tunapl" stand for?
# a) TCP, UDP, Named, All, Process, Listening
# b) Transparent, Unique, Numeric, All, Process, List
# c) TCP, UDP, Numeric, All, Process, Listening
# Answer: ___________

# QUESTION 42: How is "Connection refused" different from "Timeout"?
# a) They mean the same thing
# b) Refused = active rejection, Timeout = no response
# c) Refused = network problem, Timeout = firewall
# Answer: ___________

# QUESTION 43: What does tcpdump -n do?
# a) Creates a new capture file
# b) Shows numeric addresses only (no DNS lookups)
# c) Captures nothing (dry run)
# Answer: ___________

# QUESTION 44: In traceroute output, what do "* * *" mean?
# a) The hop is unreachable
# b) The hop didn't respond within the timeout
# c) An error occurred
# Answer: ___________

# QUESTION 45: When should you use nmap -sS vs nmap -sT?
# a) -sS for stealthy/fast, -sT for complete logging
# b) -sS for UDP, -sT for TCP
# c) They're identical
# Answer: ___________

# QUESTION 46: What indicates an application memory leak?
# a) Too many LISTEN sockets
# b) Too many CLOSE_WAIT or TIME_WAIT connections
# c) Too many DNS requests
# Answer: ___________

# QUESTION 47: How do you capture only HTTP traffic to port 8080?
# a) tcpdump port 8080
# b) tcpdump -i any 'port 8080'
# c) tcpdump -i 8080
# Answer: ___________

# QUESTION 48: What's the safest nmap timing profile?
# a) -T0 (paranoid)
# b) -T3 (normal)
# c) -T5 (insane)
# Answer: ___________

# QUESTION 49: You see "CLOSE_WAIT" connections in ss output. What's the next step?
# a) Ignore it (normal)
# b) Restart the application
# c) Check the application logs
# Answer: ___________

# QUESTION 50: Ping fails but nc -zv shows port open. What does this mean?
# a) Network is down
# b) Server is reachable, service is listening
# c) Both services are broken
# Answer: ___________
```

---

## **Troubleshooting Challenge (Bonus - 20 min)**

### **Scenario: Production Incident**

Your bank's payment API is reporting slow response times. Users report timeouts every 30 seconds. Management needs answers in 15 minutes.

```bash
# CHALLENGE SETUP: Create the problem
# Simulate a resource leak by making many connections

# First, check baseline
echo "=== BASELINE CHECK ==="
sudo ss -tunap | grep 8080
curl -s -o /dev/null -w "Response time: %{time_total}s\n" http://localhost:8080

# Create sustained load
echo "=== CREATING LOAD ==="
for i in {1..50}; do
  curl -s http://localhost:8080 &
done
echo "Load generated"

# YOUR TASK: Troubleshoot
# 1. Identify if it's a network issue or application issue
# 2. Show exactly what's happening with evidence
# 3. Propose a fix

# STEPS TO FOLLOW:
echo -e "\n=== YOUR INVESTIGATION ==="

# Step 1: Check if server is responding
echo "Step 1: Is the server responding?"
# Your command: ___________

# Step 2: Check network connectivity
echo "Step 2: Are packets reaching the server?"
# Your command: ___________

# Step 3: Check connection health
echo "Step 3: How many connections are active?"
# Your command: ___________

# Step 4: Check for resource leaks
echo "Step 4: Are connections being properly closed?"
# Your command: ___________

# Step 5: Check response times
echo "Step 5: How slow is the response?"
# Your command: ___________

# DELIVERABLE: Write your incident report
cat > /tmp/incident_report.md << 'EOF'
# Incident Report: Payment API Slow Response

## Timeline
- [Time]: Issue detected
- [Time]: Investigation started

## Root Cause
[Describe what you found]

## Evidence
[Show your diagnostic output]

## Immediate Action
[What to do right now]

## Long-term Fix
[How to prevent this]

EOF

cat /tmp/incident_report.md
```

---

## **Lab Cleanup**

```bash
# When you're done, clean up
echo "Cleaning up lab environment..."

# Kill web server
kill $(lsof -t -i :8080) 2>/dev/null

# Kill netcat servers
pkill -f "nc -l" 2>/dev/null

# Remove temp files
rm -f /tmp/http_capture.pcap
rm -f /tmp/demo.pcap
rm -f /tmp/webserver.log

# Keep scripts for reference
ls -lh /tmp/*health* /tmp/*capture* /tmp/*bank* 2>/dev/null

echo "Lab cleanup complete!"
```

---

## **Cheat Sheet for Quick Reference**

```bash
# QUICK COMMAND REFERENCE

# Service Discovery
ss -tlnp              # What's listening?
ps aux | grep PID     # Is it running?
netstat -tunapl       # All connections

# Connectivity
ping -c 1 HOST        # Can we reach it?
nc -zv HOST PORT      # Is port open?
traceroute HOST       # What's the path?

# Traffic Capture
tcpdump -i any -n -w file.pcap 'port PORT'
tcpdump -r file.pcap                      # Read it
tcpdump -r file.pcap -A                   # Show data

# Port Scanning
nmap localhost        # What's open?
nmap -sV localhost    # What versions?
nmap -p PORT localhost # Specific port

# Troubleshooting Sequence
1. ping HOST                    # Reachable?
2. nc -zv HOST PORT             # Port open?
3. sudo ss -tunapl | grep PORT  # Service details
4. curl http://HOST:PORT        # Service responding?
5. tcpdump -i any 'port PORT'   # Capture traffic

# Common Issues
- timeout = server not responding
- refused = firewall or no service
- CLOSE_WAIT = app memory leak
- TIME_WAIT = normal, but watch count
- ESTAB = active connection
```

---

## **Post-Lab Reflection**

After completing these exercises, you should be able to:

✅ Identify which services are running on a server  
✅ Diagnose connectivity problems systematically  
✅ Capture and analyze network traffic  
✅ Determine if issues are network vs application  
✅ Use tools to troubleshoot real production problems  
✅ Write monitoring scripts  
✅ Perform security scans safely  

**Final Question:** "What's the most important thing you learned about network troubleshooting?"

Answer: ___________

---

**Document Version:** 1.0  
**Last Updated:** January 2025  
**Designed For:** Bank of America IT Training  
**Estimated Lab Time:** 90 minutes  
**Difficulty Level:** Intermediate

---

*These lab exercises are designed for learning in isolated environments. All commands are safe and non-destructive. In production environments, always notify relevant teams before running diagnostics.*
