# Trame de rapport PDF

## 1. Contexte

Presenter MediTrack, les objectifs d'automatisation et les contraintes de securite.

## 2. Architecture cible

Expliquer :

- pourquoi `S3 + CloudFront` est retenu pour le site public
- pourquoi `EC2 + Ansible` est conserve pour la configuration serveur
- pourquoi une architecture minimale a ete privilegiee

## 3. Preparation de l'environnement

- outils installes
- utilisateur IAM dedie `greenops-mediatrack-deployer`
- profil AWS local
- principe du moindre privilege

## 4. Provisionnement Terraform

- VPC
- sous-reseau
- security group
- EC2
- S3
- CloudFront

Ajouter les commandes executees :

```bash
terraform init
terraform plan
terraform apply
```

## 5. Configuration Ansible

- installation de Nginx
- deploiement des pages statiques
- UFW
- creation de l'utilisateur technique

Ajouter les commandes executees :

```bash
bash generate_inventory.sh
ansible-galaxy collection install community.general
ansible-playbook playbook.yml
```

## 6. Verification

- URL CloudFront
- acces HTTPS
- test local Nginx sur EC2

## 7. Securite et conformite

- IAM
- moindre privilege
- chiffrement EBS
- TLS
- blocage d'acces public S3
- restriction SSH

## 8. Conclusion

Conclure sur l'automatisation obtenue, la simplicite de l'architecture et la mise en production publique.
