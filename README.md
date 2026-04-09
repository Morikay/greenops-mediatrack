# GreenOps MediTrack - Bloc 1

Projet de formation DevOps pour automatiser le deploiement d'une infrastructure AWS simple avec Terraform et Ansible.

## Objectif

Ce projet repond a une etude de cas orientee AWS avec les contraintes suivantes :

- provisionner l'infrastructure avec Terraform ;
- configurer l'instance EC2 avec Ansible ;
- publier un site statique via S3 et CloudFront ;
- appliquer des mesures de securite simples et coherentes.

## Architecture retenue

- `VPC + sous-reseau public` : reseau minimal pour l'instance EC2.
- `EC2 Ubuntu t3.micro` : serveur leger configure avec Ansible.
- `Nginx` : service web sur l'EC2 avec redirection HTTP vers HTTPS.
- `S3` : stockage des fichiers statiques du site.
- `CloudFront` : diffusion publique du site en HTTPS.

Le point d'entree public principal du projet est CloudFront. L'instance EC2 sert a la partie configuration systeme demandee par l'etude de cas.

## Etat de l'infrastructure deployee

- URL CloudFront : `https://difzkce0aqf6s.cloudfront.net`
- Nom de domaine CloudFront : `difzkce0aqf6s.cloudfront.net`
- EC2 DNS public : `ec2-35-180-79-188.eu-west-3.compute.amazonaws.com`
- EC2 IP publique : `35.180.79.188`
- Bucket S3 : `greenops-mediatrack-af18a78a`

## Arborescence reelle

```text
.
├── ansible/
│   ├── ansible.cfg
│   ├── inventory.ini
│   ├── playbook.yml
│   └── templates/
│       └── meditrack-nginx.conf.j2
├── site/
│   ├── assets/
│   ├── contact.html
│   └── index.html
└── terraform/
    ├── main.tf
    ├── outputs.tf
    ├── provider.tf
    ├── variables.tf
    └── version.tf
```

## Role des dossiers

- `terraform/` : creation de l'infrastructure AWS.
- `ansible/` : configuration de l'instance EC2.
- `site/` : contenu statique du site web.

## Prerequis

- Terraform 1.5 ou plus
- AWS CLI
- Ansible
- un profil AWS CLI local fonctionnel
- une paire de cles IAM rattachee a l'utilisateur `greenops-mediatrack-deployer`

## Authentification AWS

Terraform utilise le provider AWS declare dans [provider.tf](/home/llesage/greenops-mediatrack/terraform/provider.tf) avec :

- la region `eu-west-3`
- le profil local `greenops`
- les fichiers AWS locaux :
  - `/home/llesage/.aws/config`
  - `/home/llesage/.aws/credentials`

Le profil local `greenops` pointe vers l'utilisateur IAM AWS `greenops-mediatrack-deployer`.

## Deploiement Terraform

Contexte : machine locale, dans le dossier `/home/llesage/greenops-mediatrack/terraform`

```bash
cd /home/llesage/greenops-mediatrack/terraform
HOME=/home/llesage terraform init
HOME=/home/llesage terraform validate
HOME=/home/llesage terraform plan
HOME=/home/llesage terraform apply
```

## Deploiement Ansible

Contexte : machine locale, dans le dossier `/home/llesage/greenops-mediatrack/ansible`

Le fichier [inventory.ini](/home/llesage/greenops-mediatrack/ansible/inventory.ini) doit contenir le DNS public de l'instance EC2, l'utilisateur `ubuntu` et le chemin de la cle SSH.

```bash
cd /home/llesage/greenops-mediatrack/ansible
ansible-galaxy collection install community.general
ansible -i inventory.ini web -m ping
ansible-playbook -i inventory.ini playbook.yml
```

## Verification

### Terraform

```bash
cd /home/llesage/greenops-mediatrack/terraform
HOME=/home/llesage terraform output
```

### Site public

Ouvrir :

- `https://difzkce0aqf6s.cloudfront.net`

### Instance EC2

Verifier :

- `http://ec2-35-180-79-188.eu-west-3.compute.amazonaws.com` redirige vers HTTPS
- `https://ec2-35-180-79-188.eu-west-3.compute.amazonaws.com` repond correctement

## Securite mise en oeuvre

- utilisateur IAM dedie : `greenops-mediatrack-deployer`
- principe du moindre privilege applique au compte de deploiement
- chiffrement EBS sur l'instance EC2
- IMDSv2 obligatoire sur l'EC2
- SSH restreint a une IP source precise
- UFW active sur l'instance
- HTTPS force via CloudFront
- HTTPS egalement configure sur l'EC2 avec certificat autosigne

## Remarque importante

Le certificat HTTPS de l'EC2 est autosigne. Il permet de demontrer le chiffrement du flux sur l'instance, mais le point d'entree public de reference reste CloudFront.

## Fichiers sensibles

Ces fichiers ne doivent pas etre publies dans un depot public :

- `terraform/terraform.tfstate`
- `terraform/terraform.tfstate.backup`
- `terraform/greenops-mediatrack-ec2.pem`
- tout fichier `terraform.tfvars` local

Si une cle ou un secret a deja ete expose, il faut le regenerer.
