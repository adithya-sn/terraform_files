//ES Endpoint URL
output "ES_Endpoint" {
  value = aws_elasticsearch_domain.def_domain.endpoint
}

//Kibana Endpoint URL
output "Kibana_Endpoint" {
  value = aws_elasticsearch_domain.def_domain.kibana_endpoint
}
