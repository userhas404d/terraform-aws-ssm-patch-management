resource "aws_iam_role" "ssm_maintenance_window" {
  name = "${var.name}-ssm-mw-role"
  path = "/system/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com","ssm.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role_attach_ssm_mw" {
  role       = "${aws_iam_role.ssm_maintenance_window.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
}

# Create the iam role for ssm with permissions to do sts assumeRole only.
resource "aws_iam_role" "role" {
  name               = "${var.name}-ssm-ec2-update"
  path               = "/system/"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

# Attach the aws policy document for the "AmazonEC2RoleforSSM" service role.
resource "aws_iam_role_policy_attachment" "ssm-attach" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${data.aws_iam_policy.ssm-policy.arn}"
}

# Create the profile for ec2 instances linked to the ssm role above.
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.name}-ssm-instance-profile"
  role = "${aws_iam_role.role.name}"
}
