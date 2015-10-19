/* 
eureka
CreateRole
PutRolePolicy
CreateInstanceProfile
AddRoleToInstanceProfile
*/
#-----------------------------------------------

resource "aws_iam_user" "eureka" {
    name = "eureka"
    path = "/system/"
}

resource "aws_iam_role_policy" "eureka_role_policy" {
    name = "eureka_role_policy"
    role = "${aws_iam_role.eureka_role.id}"
    policy = <<EOF
{
   "Statement": [
      {
       "Action": [
         "ec2:DescribeAddresses",
         "ec2:AssociateAddress",
         "ec2:DisassociateAddress"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Action": [
          "autoscaling:DescribeAutoScalingGroups"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
}
EOF
}

resource "aws_iam_role" "eureka_role" {
    name = "eureka_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "eureka_instance_profile" {
  name = "eureka_profile"
  roles = ["${aws_iam_role.eureka_role.id}"]

}

#
# Spinnaker, the new hotness
#
resource "aws_iam_user" "spinnaker" {
  name = "spinnaker"
  path = "/system/"
}

resource "aws_iam_role" "spinnaker_role" {
  name = "spinnaker_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
     "Action": "sts:AssumeRole",
      "Principal": {
       "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
     "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_autoscale_policy" {
  name = "asgard_autoscale_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:CreateAutoScalingGroup",
        "autoscaling:CreateLaunchConfiguration",
        "autoscaling:CreateOrUpdateScalingTrigger",
        "autoscaling:CreateOrUpdateTags",
        "autoscaling:DeleteAutoScalingGroup",
        "autoscaling:DeleteLaunchConfiguration",
        "autoscaling:DeleteNotificationConfiguration",
        "autoscaling:DeletePolicy",
        "autoscaling:DeleteScheduledAction",
        "autoscaling:DeleteTags",
        "autoscaling:DeleteTrigger",
        "autoscaling:DescribeAdjustmentTypes",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeAutoScalingNotificationTypes",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeMetricCollectionTypes",
        "autoscaling:DescribeNotificationConfigurations",
        "autoscaling:DescribePolicies",
        "autoscaling:DescribeScalingActivities",
        "autoscaling:DescribeScalingProcessTypes",
        "autoscaling:DescribeScheduledActions",
        "autoscaling:DescribeTags",
        "autoscaling:DescribeTerminationPolicyTypes",
        "autoscaling:DescribeTriggers",
        "autoscaling:DisableMetricsCollection",
        "autoscaling:EnableMetricsCollection",
        "autoscaling:ExecutePolicy",
        "autoscaling:PutNotificationConfiguration",
        "autoscaling:PutScalingPolicy",
        "autoscaling:PutScheduledUpdateGroupAction",
        "autoscaling:ResumeProcesses",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:SetInstanceHealth",
        "autoscaling:SuspendProcesses",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "autoscaling:UpdateAutoScalingGroup"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_cloudwatch_policy" {
  name = "asgard_cloudwatch_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "asgard_dynamodb_policy" {
  name = "asgard_dynamodb_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "asgard_ec2_policy" {
  name = "asgard_ec2_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AssociateAddress",
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CancelSpotInstanceRequests",
        "ec2:CopyImage",
        "ec2:CopySnapshot",
        "ec2:CreateImage",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DeregisterImage",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeImageAttribute",
        "ec2:DescribeImages",
        "ec2:DescribeInstanceAttribute",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeInstances",
        "ec2:DescribeKeyPairs",
        "ec2:DescribeRegions",
        "ec2:DescribeReservedInstances",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSpotInstanceRequests",
        "ec2:DescribeSpotPriceHistory",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DescribeVpcs",
        "ec2:DetachVolume",
        "ec2:DisassociateAddress",
        "ec2:GetConsoleOutput",
        "ec2:ModifyImageAttribute",
        "ec2:RebootInstances",
        "ec2:RegisterImage",
        "ec2:RequestSpotInstances",
        "ec2:ResetImageAttribute",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RunInstances",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_elasticache_policy" {
  name = "asgard_elasticache_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticache:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_elb_policy" {
  name = "asgard_elb_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_iam-passrole_policy" {
  name = "asgard_iam-passrole_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_route53_policy" {
  name = "asgard_route53_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_rds_policy" {
  name = "asgard_rds_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds:AuthorizeDBSecurityGroupIngress",
        "rds:CreateDBInstance",
        "rds:CreateDBSecurityGroup",
        "rds:CreateDBSnapshot",
        "rds:DeleteDBInstance",
        "rds:DeleteDBSecurityGroup",
        "rds:DeleteDBSnapshot",
        "rds:DescribeDBInstances",
        "rds:DescribeDBSecurityGroups",
        "rds:DescribeDBSnapshots",
        "rds:ModifyDBInstance",
        "rds:RestoreDBInstanceFromDBSnapshot",
        "rds:RevokeDBSecurityGroupIngress"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_s3_policy" {
  name = "asgard_s3_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:Get*",
        "s3:List*",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:PutObjectVersionAcl",
        "s3:PutLifecycleConfiguration"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_simpledb_policy" {
  name = "asgard_simpledb_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sdb:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_sms_policy" {
  name = "asgard_sns_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sns:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_sqs_policy" {
  name = "asgard_sqs_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_swf_policy" {
  name = "asgard_swf_policy"
  role = "${aws_iam_role.spinnaker_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "swf:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "asgard_instance_profile" {
  name = "asgard_profile"
  roles = ["${aws_iam_role.spinnaker_role.id}"]

}
#
# End Spinnaker
#

#-----------------------------------------------
# now for asgard 

resource "aws_iam_user" "asgard" {
  name = "asgard"
  path = "/system/"
}

resource "aws_iam_role" "asgard_role" {
  name = "asgard_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_autoscale_policy" {
  name = "asgard_autoscale_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:CreateAutoScalingGroup",
        "autoscaling:CreateLaunchConfiguration",
        "autoscaling:CreateOrUpdateScalingTrigger",
        "autoscaling:CreateOrUpdateTags",
        "autoscaling:DeleteAutoScalingGroup",
        "autoscaling:DeleteLaunchConfiguration",
        "autoscaling:DeleteNotificationConfiguration",
        "autoscaling:DeletePolicy",
        "autoscaling:DeleteScheduledAction",
        "autoscaling:DeleteTags",
        "autoscaling:DeleteTrigger",
        "autoscaling:DescribeAdjustmentTypes",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeAutoScalingNotificationTypes",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeMetricCollectionTypes",
        "autoscaling:DescribeNotificationConfigurations",
        "autoscaling:DescribePolicies",
        "autoscaling:DescribeScalingActivities",
        "autoscaling:DescribeScalingProcessTypes",
        "autoscaling:DescribeScheduledActions",
        "autoscaling:DescribeTags",
        "autoscaling:DescribeTerminationPolicyTypes",
        "autoscaling:DescribeTriggers",
        "autoscaling:DisableMetricsCollection",
        "autoscaling:EnableMetricsCollection",
        "autoscaling:ExecutePolicy",
        "autoscaling:PutNotificationConfiguration",
        "autoscaling:PutScalingPolicy",
        "autoscaling:PutScheduledUpdateGroupAction",
        "autoscaling:ResumeProcesses",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:SetInstanceHealth",
        "autoscaling:SuspendProcesses",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "autoscaling:UpdateAutoScalingGroup"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_cloudwatch_policy" {
  name = "asgard_cloudwatch_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "asgard_dynamodb_policy" {
  name = "asgard_dynamodb_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "asgard_ec2_policy" {
  name = "asgard_ec2_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AssociateAddress",
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CancelSpotInstanceRequests",
        "ec2:CopyImage",
        "ec2:CopySnapshot",
        "ec2:CreateImage",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DeregisterImage",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeImageAttribute",
        "ec2:DescribeImages",
        "ec2:DescribeInstanceAttribute",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeInstances",
        "ec2:DescribeKeyPairs",
        "ec2:DescribeRegions",
        "ec2:DescribeReservedInstances",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSpotInstanceRequests",
        "ec2:DescribeSpotPriceHistory",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DescribeVpcs",
        "ec2:DetachVolume",
        "ec2:DisassociateAddress",
        "ec2:GetConsoleOutput",
        "ec2:ModifyImageAttribute",
        "ec2:RebootInstances",
        "ec2:RegisterImage",
        "ec2:RequestSpotInstances",
        "ec2:ResetImageAttribute",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RunInstances",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_elasticache_policy" {
  name = "asgard_elasticache_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticache:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_elb_policy" {
  name = "asgard_elb_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_iam-passrole_policy" {
  name = "asgard_iam-passrole_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_route53_policy" {
  name = "asgard_route53_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_rds_policy" {
  name = "asgard_rds_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds:AuthorizeDBSecurityGroupIngress",
        "rds:CreateDBInstance",
        "rds:CreateDBSecurityGroup",
        "rds:CreateDBSnapshot",
        "rds:DeleteDBInstance",
        "rds:DeleteDBSecurityGroup",
        "rds:DeleteDBSnapshot",
        "rds:DescribeDBInstances",
        "rds:DescribeDBSecurityGroups",
        "rds:DescribeDBSnapshots",
        "rds:ModifyDBInstance",
        "rds:RestoreDBInstanceFromDBSnapshot",
        "rds:RevokeDBSecurityGroupIngress"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_s3_policy" {
  name = "asgard_s3_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:Get*",
        "s3:List*",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:PutObjectVersionAcl",
        "s3:PutLifecycleConfiguration"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_simpledb_policy" {
  name = "asgard_simpledb_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sdb:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_sms_policy" {
  name = "asgard_sns_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sns:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_sqs_policy" {
  name = "asgard_sqs_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "asgard_swf_policy" {
  name = "asgard_swf_policy"
  role = "${aws_iam_role.asgard_role.id}"
  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "swf:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "asgard_instance_profile" {
  name = "asgard_profile"
  roles = ["${aws_iam_role.asgard_role.id}"]

}

