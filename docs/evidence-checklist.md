# Preuves a conserver pour le rendu PDF

## Question 1

- capture `terraform version`
- capture `ansible --version`
- capture `aws --version`
- capture IAM de l'utilisateur dedie `greenops-mediatrack-deployer`
- capture de la politique IAM attachee
- capture `aws sts get-caller-identity --profile greenops`

## Question 2

- capture `terraform init`
- capture `terraform plan`
- capture `terraform apply`
- capture de la console AWS pour :
  - le VPC
  - l'instance EC2
  - le bucket S3
  - la distribution CloudFront

## Question 3

- capture `ansible-playbook playbook.yml`
- capture de la page par defaut Nginx remplacee sur l'EC2
- capture d'une connexion SSH reussie si utile

## Question 4

- capture de l'URL CloudFront fonctionnelle
- capture du cadenas HTTPS dans le navigateur
- capture d'un test HTTP vers HTTPS

## Question 5

- capture du volume EBS chiffre
- capture du Security Group
- capture du blocage d'acces public S3
- capture de la politique du bucket restreinte a CloudFront
