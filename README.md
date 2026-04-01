# GreenOps MediTrack

Projet de formation DevOps pour automatiser le deploiement d'une infrastructure AWS simple avec Terraform et Ansible.

## Architecture retenue

- `S3 + CloudFront` : publication publique du site statique en HTTPS.
- `EC2 + Nginx + Ansible` : demonstration de configuration serveur et de securisation systeme.
- `VPC + sous-reseau public` : socle reseau minimal pour l'instance EC2.

Le site public de reference est l'URL CloudFront. L'instance EC2 ne remplace pas CloudFront ; elle sert a demontrer l'automatisation systeme imposee par l'etude de cas.

## Arborescence

```text
.
├── ansible/
│   ├── ansible.cfg
│   ├── generate_inventory.sh
│   ├── inventory.ini
│   └── playbook.yml
├── docs/
│   ├── architecture.md
│   ├── evidence-checklist.md
│   ├── report-template.md
│   └── iam/
│       └── terraform-deployer-policy.json
├── site/
│   ├── contact.html
│   └── index.html
└── terraform/
    ├── main.tf
    ├── outputs.tf
    ├── provider.tf
    ├── terraform.tfvars.example
    ├── variables.tf
    └── version.tf
```

## Prerequis

- Terraform 1.5+
- Ansible
- AWS CLI
- Un profil AWS local avec les droits IAM adaptes

## Configuration locale

1. Copier l'exemple de variables :

```bash
cd /home/llesage/greenops-mediatrack/terraform
cp terraform.tfvars.example terraform.tfvars
```

2. Adapter au minimum :

- `aws_profile`
- `allowed_ssh_cidr`

## Deploiement

### 1. Provisionner avec Terraform

Contexte : machine locale, dossier [terraform/main.tf](/home/llesage/greenops-mediatrack/terraform/main.tf)

```bash
cd /home/llesage/greenops-mediatrack/terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

### 2. Generer l'inventaire Ansible

Contexte : machine locale, dossier [ansible/generate_inventory.sh](/home/llesage/greenops-mediatrack/ansible/generate_inventory.sh)

```bash
cd /home/llesage/greenops-mediatrack/ansible
bash generate_inventory.sh
```

### 3. Configurer l'instance EC2 avec Ansible

Contexte : machine locale, dossier [ansible/playbook.yml](/home/llesage/greenops-mediatrack/ansible/playbook.yml)

```bash
cd /home/llesage/greenops-mediatrack/ansible
ansible-galaxy collection install community.general
ansible-playbook playbook.yml
```

## Verification

```bash
cd /home/llesage/greenops-mediatrack/terraform
terraform output cloudfront_url
terraform output ec2_public_dns
```

Ouvrir ensuite l'URL CloudFront dans un navigateur. Le site doit etre accessible en HTTPS. Une requete HTTP doit etre redirigee vers HTTPS par CloudFront.

## Securite mise en oeuvre

- utilisateur IAM dedie au deploiement
- utilisateur IAM retenu pour ce projet : `greenops-mediatrack-deployer`
- principe du moindre privilege documente dans `docs/iam/`
- bucket S3 prive, accessible uniquement via CloudFront
- TLS force sur CloudFront
- EBS chiffre sur l'EC2
- IMDSv2 obligatoire sur l'EC2
- SSH limite a une IP source en `/32`
- UFW active sur le serveur

## Fichiers a ne jamais publier

Le depot ignore :

- les cles privees `.pem`
- les fichiers `terraform.tfstate`
- les fichiers `terraform.tfvars`

Si ces fichiers ont deja ete pousses sur un depot distant, il faut les retirer de l'historique et regenerer les secrets concernes.
