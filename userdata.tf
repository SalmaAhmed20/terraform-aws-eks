data "template_cloudinit_config" "usrdata-script" {
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      echo '${tls_private_key.rsa-key.private_key_pem}' > /home/ubuntu/tf-key-pair.pem
      chmod 400 tf-key-pair.pem
      apt-get update
      apt-get -y install awscli
      curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
      chmod +x ./kubectl
      sudo mv ./kubectl /usr/local/bin/kubectl
      sudo mkdir /home/ubuntu/.aws
      touch /home/ubuntu/.aws/credentials /home/ubuntu/.aws/config
      echo [default] > /home/ubuntu/.aws/credentials
      echo 'aws_access_key_id = ' >> /home/ubuntu/.aws/credentials
      echo 'aws_secret_access_key = ' >> /home/ubuntu/.aws/credentials
      echo [default] > /home/ubuntu/.aws/config
      echo "region = eu-west-1" >>/home/ubuntu/.aws/config
      apt-get update
      apt-get install -y docker.io
      usermod -aG docker ubuntu
      apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common openssh-server openjdk-11-jre openjdk-11-jdk git
    EOF
  }
}
