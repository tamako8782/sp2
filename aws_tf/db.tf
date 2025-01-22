# プライベートサブネットの作成
resource "aws_subnet" "sprint2_db_sub_01" {
  vpc_id                  = aws_vpc.sprint1_vpc.id
  cidr_block              = "10.0.2.0/24"     # サブネットの範囲を指定
  availability_zone       = "ap-northeast-1c" # アベイラビリティゾーンを指定
  map_public_ip_on_launch = false             # インスタンスにパブリックIPを割り当て
  tags = {
    Name = "db-subnet-01"
  }
}


resource "aws_subnet" "sprint2_db_sub_02" {
  vpc_id                  = aws_vpc.sprint1_vpc.id
  cidr_block              = "10.0.3.0/24"     # サブネットの範囲を指定
  availability_zone       = "ap-northeast-1a" # アベイラビリティゾーンを指定
  map_public_ip_on_launch = false             # インスタンスにパブリックIPを割り当て
  tags = {
    Name = "db-subnet-02"
  }
}

resource "aws_db_subnet_group" "sprint2_db_sub_group" {
  name = "db-subnet-group"
  description = "sprint2-db-subnet-group"
  subnet_ids = [aws_subnet.sprint2_db_sub_01.id, aws_subnet.sprint2_db_sub_02.id]
}


# dbインスタンスの作成
resource "aws_db_instance" "sprint2_db_instance" {
  identifier = "sprint2-db-instance"
  instance_class = "db.t3.micro"
  engine = "mysql"
  engine_version = "8.0.40"
  db_subnet_group_name = aws_db_subnet_group.sprint2_db_sub_group.name

  db_name = var.db_name
  username = var.db_username
  password = var.db_password
  allocated_storage = 20
  storage_type = "gp2"
  multi_az = var.multi_az

  vpc_security_group_ids = [aws_security_group.tamako_rds_sg.id]           

    # 削除時にsnapshot取得をスキップする設定
  skip_final_snapshot = true
}

resource "aws_security_group" "tamako_rds_sg" {
  name = "tamako-rds-sg"
  description = "tamako-rds-sg"
  vpc_id = aws_vpc.sprint1_vpc.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.api.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



output "db_endpoint" {
  value = aws_db_instance.sprint2_db_instance.endpoint
}