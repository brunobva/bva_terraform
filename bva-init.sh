#!/bin/bash
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "This script will do the init configuration for BVA Consultoria"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
# Create group BVA
OS=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)
user=brunobva
if [ OS=="centos" ] [ OS=="rhel" ]|| ; then
  groupadd bva
else
  addgroup bva
fi
# Create user brunobva
if [ OS=="centos" ] [ OS=="rhel" ]|| ; then
  adduser -m -p bva@mudar $user
  usermod -aG bva $user
else
  adduser --force-badname --disabled-password --gecos "" brunobva
  usermod -aG bva $user
fi
# Set password
if [ OS=="debian" ]; then
  echo "brunobva:bva@mudar" | chpasswd
fi
# Expire Password
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Expiring the password"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
passwd -e $user
# create a sudoers file
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "%bva ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/bva
echo "SSH Config!"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "SSH Keys creating..."
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
runuser -l $user -c 'mkdir -p ~/.ssh'
runuser -l $user -c 'touch ~/.ssh/authorized_keys'
runuser -l $user -c 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCcPS8l6dt5xlMgO+itB54+u8poen7JDskJic8S6IR1hfWp4imXePX62y+GYFAuvpOJxAupGXam9izvUHvjr1q+92IaOcwAH/PcW14+FW6lc7StonXOHJ5FzwTJ2sm2bN0Wb7SGKI4/GcG/wz2kR765oWkxPsZ08tbQnZHilDUVehOppgZkGpnKb1r3az3iC/beVt8wtlJ3scnipWo7LX33fFwmjJYts4XouOAWnD9p0pgS1pjBkPSEr52vdYM4NkvYDVP/yMsqaLAuSl2oCbdlncCqwCsbfhvkzj7x/SYiScwMqkkf6L/N6AzSTCE63UeWpaVwE780wPnCvEWs9XuWtqvB1eON2PdE9CTE9hgY4KPfeFH0F/SGDrQoPN08jybHVcrGSABM47/OKTRFjR7NRE7+M62BBEC7ei+LzKkZWtCNohv3H7+8zgt1Fu5ImcFBfzyyN1esc+Gv32VRBK78qd6TNKTdljH1+4v3hnMIkXEcWXzOK/lSxZWPGpCjLT0p52zMnFo21Anf0xQ4/FJw0XEqsMul4phFiThqd6ivpdY1paRvGBWLEJIJqCVM89EGDXJymYwrenYjdTa/+9ftYF8ZgJARe96NV4VSbDmtXhx8yR15wVrQ/dQOxCNxq84373KmEATsqj2vKSmUCAX/qxywLxv4kPuU0ZzS71vrQQ== brunobva"
" >> ~/.ssh/authorized_keys'
runuser -l $user -c 'chmod 700 ~/.ssh'
runuser -l $user -c 'chmod 600 ~/.ssh/authorized_keys'
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
# Config SSHD
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
if [ OS=="centos" ] [ OS=="rhel" ]|| ; then
  sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
  sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
  echo "#Executou centos" >> /etc/ssh/sshd_config
else
  if [ OS=="debian" ]; then
  sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
  sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
  echo "#Executou debian" >> /etc/ssh/sshd_config 
  fi
fi
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "SSH Config changed... service will restart now!"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
service sshd restart
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Install some packages... and update it!"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
apt update -y && apt -y update && apt install python3 build-essential libssl-dev libffi-dev python3-dev python3-pip
mkdir /bva && chown brunobva:root /bva -R