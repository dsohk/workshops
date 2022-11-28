# Data for AWS module

# AWS data
# ----------------------------------------------------------

# Use latest OpenSUSE Leap 15 SP4
data "aws_ami" "opensuse_x86" {
  most_recent = true
  owners      = ["679593333241"] # openSUSE

  filter {
    name   = "name"
    values = ["openSUSE-Leap-15-4*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Use latest SLES 15 SP4 BYOS
data "aws_ami" "sles_x86" {
  most_recent = true
  owners      = ["013907871322"] # SUSE

  filter {
    name   = "name"
    values = ["suse-sles-15-sp4-byos-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Use latest SLE Micro 5.2 BYOS
data "aws_ami" "slemicro_x86" {
  most_recent = true
  owners      = ["013907871322"] # SUSE

  filter {
    name   = "name"
    values = ["suse-sle-micro-5-2-byos*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "windows" {
  most_recent = true
  owners      = ["801119661308"] #Amazon
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-ContainersLatest-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}