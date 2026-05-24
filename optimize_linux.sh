#!/bin/bash
# Linux optimizations for Minecraft server host
set -e
if [ "$EUID" -ne 0 ]; then
  echo "ERROR: Must run as root to apply system settings."
  exit 1
fi

echo "Setting swappiness to 10..."
echo 10 > /proc/sys/vm/swappiness

echo "Writing sysctl config..."
cat > /etc/sysctl.d/99-minecraft.conf <<'EOF'
vm.swappiness=10
vm.dirty_ratio=15
vm.dirty_background_ratio=5
fs.file-max=100000
EOF
sysctl --system

echo "Setting default nofile limit..."
if ! grep -q '^minecraft' /etc/security/limits.conf 2>/dev/null; then
  cat >> /etc/security/limits.conf <<'EOF'
minecraft soft nofile 100000
minecraft hard nofile 100000
EOF
fi

echo "Linux optimization complete. Reboot recommended."
