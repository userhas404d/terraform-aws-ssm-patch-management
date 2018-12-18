// S3 Bucket For Logs
resource "aws_s3_bucket" "ssm_patch_log_bucket" {
  bucket        = "${var.name}-ssm-patch-logs"
  force_destroy = true

  tags = "${var.tags}"
}
