# Architecture et justification

## Choix d'architecture

L'architecture cible reste volontairement simple pour respecter le brief client :

- un `VPC` avec un unique sous-reseau public
- une `EC2 t3.micro` pour demontrer l'automatisation Ansible
- un bucket `S3` prive pour stocker les pages statiques
- une distribution `CloudFront` pour exposer le site publiquement en HTTPS

## Cohérence fonctionnelle

Le point d'entree public du site est `CloudFront`, pas l'instance EC2.

L'instance EC2 est maintenue pour satisfaire la partie pedagogique de l'etude de cas :

- installation d'un serveur web
- deploiement de contenus avec Ansible
- application de regles de securite systeme

Les memes fichiers statiques sont donc deployes :

- vers `S3` pour la production publique
- vers `EC2` pour la demonstration de configuration serveur

## Mesures de securite

- IAM dedie au deploiement : `greenops-mediatrack-deployer`
- bucket S3 non public
- acces S3 restreint a CloudFront via Origin Access Control
- TLS minimum `TLSv1.2_2021`
- volume EBS chiffre
- IMDSv2 obligatoire
- acces SSH restreint a une IP precise
- pare-feu UFW active sur l'EC2
