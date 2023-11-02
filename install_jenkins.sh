sudo yum update -y
sudo amazon-linux-extras install java-openjdk11 -y
java --version
sudo yum install wget -y
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl enable jenkins --now
sudo cat /var/lib/jenkins/secrets/initialAdminPassword