sudo yum update -y
wget https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.rpm
sudo yum -y install https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.rpm
java --version
sudo yum install wget -y
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl enable jenkins --now
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
