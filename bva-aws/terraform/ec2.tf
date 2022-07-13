resource "aws_instance" "bvadev001" {
  instance_type               = var.ec2Type
  ami                         = var.amiUbuntu20Lts
  subnet_id                   = aws_subnet.bvaPubSubnet.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.bvaMainRules.id]
  key_name                    = aws_key_pair.bvaKey.key_name

  user_data = <<EOF
#!/bin/bash
apt update && apt install nc -y
echo " "
echo ">|> 0- verify internet connection"
echo " "
if nc -zw1 google.com 443; then
  echo "we have connectivity"
fi
echo " "
echo ">|> 1- install dependencies"
echo " "

apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

echo " "
echo ">|> 1- END install dependencies"
echo " "

echo " "
echo ">|> 2- install docker"
echo " "

apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker app
usermod -aG sudo app

echo " "
echo ">|> 2- END install docker"
echo " "

echo " "
echo ">|> 3- install docker-composer"
echo " "

curl -L "https://github.com/docker/compoe/releases/download/1.29.2/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  EOF
  tags = {
    Name = "Server for BVA"
  }
}

resource "aws_key_pair" "bvaKey" {
  key_name   = "bvaMasterKey"
  public_key = var.sshBvaKey
}