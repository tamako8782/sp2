resource "aws_iam_user" "test_taro" {
  name = "test-taro"
}

resource "aws_iam_user_login_profile" "test_taro_login_profile" {
  user                    = aws_iam_user.test_taro.name
  password_length         = 20
  password_reset_required = false
  pgp_key                 = var.pgp_key
}


resource "aws_iam_user_group_membership" "test_taro_membership" {
  user   = aws_iam_user.test_taro.name
  groups = [aws_iam_group.user-management-group.name]
}

resource "aws_iam_user" "test_jiro" {
  name = "test-jiro"
}

resource "aws_iam_user_login_profile" "test_jiro_login_profile" {
  user                    = aws_iam_user.test_jiro.name
  password_length         = 20
  password_reset_required = false
  pgp_key                 = var.pgp_key
}


resource "aws_iam_user_group_membership" "test_jiro_membership" {
  user   = aws_iam_user.test_jiro.name
  groups = [aws_iam_group.server-management-group.name]
}

resource "aws_iam_user" "test_saburo" {
  name = "test-saburo"
}

resource "aws_iam_user_login_profile" "test_saburo_login_profile" {
  user                    = aws_iam_user.test_saburo.name
  password_length         = 20
  password_reset_required = false
  pgp_key                 = var.pgp_key
}

resource "aws_iam_user_group_membership" "test_saburo_membership" {
  user   = aws_iam_user.test_saburo.name
  groups = [aws_iam_group.database-management-group.name]
}

resource "aws_iam_user" "test_shiro" {
  name = "test-shiro"
}

resource "aws_iam_user_login_profile" "test_shiro_login_profile" {
  user                    = aws_iam_user.test_shiro.name
  password_length         = 20
  password_reset_required = false
  pgp_key                 = var.pgp_key
}

output "password" {
  value = aws_iam_user_login_profile.test_shiro_login_profile.encrypted_password
}

resource "aws_iam_user_group_membership" "test_shiro_membership" {
  user = aws_iam_user.test_shiro.name
  groups = [
    aws_iam_group.server-management-group.name,
    aws_iam_group.database-management-group.name,

  ]
}

resource "aws_iam_group" "server-management-group" {
  name = "server-management-group"
}

resource "aws_iam_group_policy" "server-management-group-policy" {
  name  = "server-management-group-policy"
  group = aws_iam_group.server-management-group.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:RunInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances",
          "ec2:TerminateInstances",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:ModifyInstanceAttribute"
        ],
        Resource = "arn:aws:ec2:*:*:instance/*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:Describe*"

        ],
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_group" "database-management-group" {
  name = "database-management-group"
}

resource "aws_iam_group_policy" "database-management-group-policy" {
  name  = "database-management-group-policy"
  group = aws_iam_group.database-management-group.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:Describe*"

        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "rds:StartDBInstance",
          "rds:StopDBInstance",
          "rds:CreateDBInstance",
          "rds:RebootDBInstance",
          "rds:DeleteDBInstance",
          "rds:ModifyDBInstance",
          "rds:CreateDBSnapshot",
          "rds:DeleteDBSnapshot",
          "rds:RestoreDBInstanceFromDBSnapshot",
          "rds:RestoreDBInstanceToPointInTime"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:rds:*:*:db:*",
          "arn:aws:rds:*:*:pg:*",
          "arn:aws:rds:*:*:secgrp:*",
          "arn:aws:rds:*:*:og:*",
          "arn:aws:rds:*:*:snapshot:*"
        ]
      },
      {
        Action = [
          "rds:CreateDBSubnetGroup",
          "rds:DeleteDBSubnetGroup"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]

  })
}

resource "aws_iam_group" "user-management-group" {
  name = "user-management-group"
}

resource "aws_iam_group_policy" "user-management-group-policy" {
  name  = "user-management-group-policy"
  group = aws_iam_group.user-management-group.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:CreateUser",
          "iam:DeleteUser",
          "iam:UpdateUser",
          "iam:ListUsers",
          "iam:GetUser",
          "iam:TagUser",
          "iam:ListGroups",
          "iam:GetGroup",
          "iam:AddUserToGroup",
          "iam:RemoveUserFromGroup",
          "iam:ListUserPolicies",
          "iam:ListGroupsForUser",
          "iam:GetUserPolicy",
          "iam:ListUserPolicies",
          "iam:ListAccessKeys",
          "iam:ListServiceSpecificCredentials",
          "iam:ListSigningCertificates",
          "iam:ListAttachedUserPolicies",
          "iam:ListAttachedGroupPolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListAttachedUserPolicies",
          "iam:ListAttachedGroupPolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListSSHPublicKeys",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          "iam:GetUserPolicy",
          "iam:UntagUser",
          "iam:CreateAccessKey",
          "iam:DeleteAccessKey",
          "iam:UpdateAccessKey",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:iam::*"
      }
    ]
  })
}
