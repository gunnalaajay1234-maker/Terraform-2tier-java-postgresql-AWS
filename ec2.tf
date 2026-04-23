# EC2 App Server (FINAL FIXED)
resource "aws_instance" "app" {
  ami                    = "ami-05d2d839d4f73aafb"
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.app_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = "ec2-key"

  tags = {
    Name = var.ec2_name
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("ec2-key.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",

      "mkdir -p /home/ubuntu/employee-api/src/main/java/com/example/employeeapi/model",
      "mkdir -p /home/ubuntu/employee-api/src/main/java/com/example/employeeapi/repository",
      "mkdir -p /home/ubuntu/employee-api/src/main/java/com/example/employeeapi/controller",
      "mkdir -p /home/ubuntu/employee-api/src/main/resources/static",
      "mkdir -p /home/ubuntu/employee-api/src/main/resources",

      "sudo chown -R ubuntu:ubuntu /home/ubuntu/employee-api"
    ]
  }

  provisioner "file" {
    content = templatefile("${path.module}/index.html.tpl", {
      ec2_ip = self.public_ip
    })

    destination = "/home/ubuntu/employee-api/src/main/resources/static/index.html"
  }

  provisioner "file" {
    source      = "./java/pom.xml"
    destination = "/home/ubuntu/employee-api/pom.xml"
  }

  provisioner "file" {
    source      = "./java/Employee.java"
    destination = "/home/ubuntu/employee-api/src/main/java/com/example/employeeapi/model/Employee.java"
  }

  provisioner "file" {
    source      = "./java/EmployeeRepository.java"
    destination = "/home/ubuntu/employee-api/src/main/java/com/example/employeeapi/repository/EmployeeRepository.java"
  }

  provisioner "file" {
    source      = "./java/EmployeeController.java"
    destination = "/home/ubuntu/employee-api/src/main/java/com/example/employeeapi/controller/EmployeeController.java"
  }

  provisioner "file" {
    source      = "./java/EmployeeApiApplication.java"
    destination = "/home/ubuntu/employee-api/src/main/java/com/example/employeeapi/EmployeeApiApplication.java"
  }

  provisioner "file" {
    source      = "./java/application.properties"
    destination = "/home/ubuntu/employee-api/src/main/resources/application.properties"
  }

  provisioner "remote-exec" {
    inline = [

      "set -e",

      # Install dependencies
      "sudo apt update -y",
      "sudo apt install -y openjdk-17-jdk maven postgresql-client",

      "java -version",
      "mvn -version",

      # STEP 4: SET ENV VARIABLES (CORRECT WAY)
      "echo 'DB_HOST=${aws_db_instance.db.address}' | sudo tee /etc/environment",
      "echo 'DB_PORT=5432' | sudo tee -a /etc/environment",
      "echo 'DB_NAME=${var.db_name}' | sudo tee -a /etc/environment",
      "echo 'DB_USER=${var.db_user}' | sudo tee -a /etc/environment",
      "echo 'DB_PASSWORD=${var.db_password}' | sudo tee -a /etc/environment",

      # reload environment for current session
      ". /etc/environment",

      "sudo bash -c 'echo export DB_HOST=${aws_db_instance.db.address} > /etc/profile.d/db.sh'",
      "sudo bash -c 'echo export DB_PORT=5432 >> /etc/profile.d/db.sh'",
      "sudo bash -c 'echo export DB_NAME=${var.db_name} >> /etc/profile.d/db.sh'",
      "sudo bash -c 'echo export DB_USER=${var.db_user} >> /etc/profile.d/db.sh'",
      "sudo bash -c 'echo export DB_PASSWORD=${var.db_password} >> /etc/profile.d/db.sh'",
      "sudo chmod +x /etc/profile.d/db.sh",

      "sudo bash -c 'echo DB_HOST=${aws_db_instance.db.address} >> /etc/environment'",
      "sudo bash -c 'echo DB_PORT=5432 >> /etc/environment'",
      "sudo bash -c 'echo DB_NAME=${var.db_name} >> /etc/environment'",
      "sudo bash -c 'echo DB_USER=${var.db_user} >> /etc/environment'",
      "sudo bash -c 'echo DB_PASSWORD=${var.db_password} >> /etc/environment'",

      "sudo chmod +x /etc/profile.d/db.sh",

      # STEP 5: BUILD PROJECT
      "cd /home/ubuntu/employee-api",
      "mvn clean package -DskipTests",

      # STEP 6: RUN APPLICATION (WITH ENV LOADED)
      "nohup bash -c 'set -a && . /etc/profile.d/db.sh && set +a && java -jar target/*.jar' > app.log 2>&1 &",
      "sleep 10",

      "echo '--- APP LOG ---'",
      "cat app.log || true",

      "ps -ef | grep java | grep -v grep || true"
    ]
  }
}