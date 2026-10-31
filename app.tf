resource "aws_security_group" "app_sg" {
  name        = "demo-app-sg"
  description = "Allow inbound traffic for web app"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "demo-app-sg"
    Environment = "production"
    Project     = "demo-app"
  }
}

resource "aws_instance" "app" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "m6i.8xlarge"
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name        = "demo-app-server"
    Environment = "production"
    Project     = "demo-app"
  }
}

resource "aws_s3_bucket" "logs" {
  bucket        = "demo-app-application-logs-2026"
  force_destroy = true

  tags = {
    Name        = "demo-app-logs"
    Environment = "production"
    Project     = "demo-app"
  }
}

resource "aws_db_subnet_group" "app" {
  name       = "demo-app-db-subnet-group"
  subnet_ids = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

resource "aws_db_instance" "app_db" {
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "15.4"
  instance_class          = "db.t3.micro"
  db_name                 = "demoapp"
  username                = "dbadmin"
  password                = "AppDatabase2026Secure!"
  db_subnet_group_name    = aws_db_subnet_group.app.name
  publicly_accessible     = true
  backup_retention_period = 0
  skip_final_snapshot     = true

  tags = {
    Name        = "demo-app-db"
    Environment = "production"
    Project     = "demo-app"
  }
}
