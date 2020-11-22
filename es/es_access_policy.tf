//ES Domain Policy
resource "aws_elasticsearch_domain_policy" "policy" {
  domain_name = aws_elasticsearch_domain.def_domain.domain_name
  // access_policies = data.template_file.def_template.rendered
  access_policies = templatefile("${path.module}/access_policy.tpl", { resource_arn = aws_elasticsearch_domain.def_domain.arn })
}
