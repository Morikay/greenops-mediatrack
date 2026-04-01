# IP publique de l'instance EC2.
output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

# Nom DNS public de l'instance EC2.
output "ec2_public_dns" {
  value = aws_instance.web.public_dns
}

# Chemin local de la cle privee.
output "ec2_private_key_file" {
  value     = local_file.private_key_pem.filename
  sensitive = true
}

# Nom du bucket S3.
output "s3_bucket_name" {
  value = aws_s3_bucket.site.bucket
}

# URL publique principale du site.
output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.site.domain_name}"
}

# Nom de domaine CloudFront, utile pour les captures d'ecran.
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.site.domain_name
}
