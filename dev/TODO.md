# ✅ Inception – TODO.md

> Objectif : mettre en place une infrastructure Docker complète avec **NGINX + WordPress + MariaDB**, en respectant les règles de sécurité et de bonnes pratiques Docker.

---

## 📁 1. Structure du projet

* [X] Créer le dossier racine `inception/`
* [X] Créer `srcs/`
* [X] Créer `srcs/docker-compose.yml`
* [X] Créer `srcs/.env`
* [X] Créer `srcs/requirements/`

## 🔐 2. Fichier `.env`

* [ ] Définir les variables d’environnement obligatoires :

  * [X] `DOMAIN_NAME`
  * [ ] `MYSQL_DATABASE`
  * [ ] `MYSQL_USER`
  * [ ] `MYSQL_PASSWORD`
  * [ ] `MYSQL_ROOT_PASSWORD`
  * [ ] `WP_ADMIN_USER`
  * [ ] `WP_ADMIN_PASSWORD`
  * [ ] `WP_ADMIN_EMAIL`
  * [ ] `WP_USER`
  * [ ] `WP_USER_PASSWORD`
  * [ ] `WP_USER_EMAIL`

---

## 🐳 3. Docker Compose

* [X] Version `3.9`
* [X] Définir **3 services obligatoires** :
  * [X] `nginx`
  * [X] `wordpress`
  * [X] `mariadb`
* [ ] Utiliser **des images construites localement** (Dockerfile obligatoire)
* [ ] Utiliser **un réseau Docker personnalisé**
* [ ] Utiliser **des volumes persistants**
* [ ] Ne pas utiliser `latest`
* [ ] Aucun `container_name` en dur (optionnel mais recommandé)
* [ ] Pas de `links`

---

## 🗄️ 4. MariaDB

* [ ] Créer un Dockerfile basé sur `debian:bullseye`
* [ ] Installer MariaDB **sans systemd**
* [ ] Créer la base de données automatiquement
* [ ] Créer l’utilisateur WordPress automatiquement
* [ ] Sécuriser MariaDB :

  * [ ] mot de passe root
  * [ ] pas d’accès root distant
* [ ] Utiliser un volume pour `/var/lib/mysql`
* [ ] Ne pas exposer le port 3306

---

## 🧠 5. WordPress (PHP-FPM)

* [ ] Dockerfile basé sur `debian:bullseye`
* [ ] Installer :
  * [ ] PHP
  * [ ] PHP-FPM
  * [ ] extensions PHP nécessaires
* [ ] Télécharger WordPress via **WP-CLI**
* [ ] Configurer `wp-config.php` dynamiquement
* [ ] Créer automatiquement :
  * [ ] l’admin WordPress
  * [ ] un utilisateur standard
* [ ] WordPress connecté à MariaDB via le réseau Docker
* [ ] PHP-FPM écoute sur `9000`
* [ ] Utiliser un volume pour `/var/www/html`

---

## 🌐 6. NGINX (HTTPS obligatoire)

* [ ] Dockerfile basé sur `debian:bullseye`
* [ ] Installer NGINX
* [ ] Générer un certificat SSL auto-signé
* [ ] Configurer NGINX pour :
  * [ ] HTTPS uniquement (port 443)
  * [ ] proxy vers PHP-FPM
* [ ] Interdire l’accès HTTP (ou rediriger)
* [ ] Ne pas utiliser `nginx:latest`
* [ ] Aucun CMS ou PHP dans NGINX

---

## 🔒 7. Sécurité & règles 42

* [ ] Aucun `--privileged`
* [ ] Aucun `network: host`
* [ ] Aucun mot de passe en dur
* [ ] Aucun `sleep infinity`
* [ ] Chaque conteneur a **un seul rôle**
* [ ] Pas de `tail -f /dev/null`
* [ ] Pas de `systemctl`

---

## 📦 8. Volumes

* [ ] Volume WordPress :

  * [ ] `/var/www/html`
* [ ] Volume MariaDB :
  * [ ] `/var/lib/mysql`
* [ ] Volumes stockés dans `/home/login/data/`
* [ ] Vérifier la persistance après `docker compose down`

---

## 🛠️ 9. Makefile

* [ ] `make` → lance `docker compose up --build`
* [ ] `make down`
* [ ] `make clean`
* [ ] `make fclean`
* [ ] `make re`
* [ ] Pas de commandes Docker dans le sujet directement

---

## 🧪 10. Tests finaux

* [ ] `docker compose ps` → tous les services **UP**
* [ ] Accès au site via `https://DOMAIN_NAME`
* [ ] WordPress fonctionnel
* [ ] Redémarrage OK sans perte de données
* [ ] Aucun warning Docker
* [ ] `docker inspect` propre
* [ ] Respect total du sujet Inception

---

## 🧠 11. Bonus (optionnel)

* [ ] Redis
* [ ] FTP
* [ ] Adminer
* [ ] Monitoring
* [ ] Second site WordPress
* [ ] Reverse proxy avancé

---

## ✅ Statut final

* [ ] Projet conforme au sujet
* [ ] Prêt pour soutenance
* [ ] Documentation claire
* [ ] Aucun hack / contournement

---

Si tu veux, au prochain message je peux :

* 🔥 te faire **un Makefile Inception clean**
* 🧱 te faire **les 3 Dockerfile complets**
* 🔍 te faire **une checklist spéciale soutenance**
* 🧪 te faire **un script de test automatique**

Dis-moi 👇
