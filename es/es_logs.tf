resource "aws_cloudwatch_log_group" "def_lg" {
  name = join("", ["es_", var.domain_name, "_log_group"])
}

resource "aws_cloudwatch_log_resource_policy" "def_lrp" {
  policy_name = join("", ["es_", var.domain_name, "_log_resource_policy"])

  policy_document = templatefile("${path.module}/log_resource_policy.tpl", {})
}
