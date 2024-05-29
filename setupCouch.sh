#!/bin/bash

# Informations d'identification administratives
ADMIN_USER="udhyiautHJDAVGDHJ"
ADMIN_PASSWORD="IDAUYTZVDGBHnjahvgdgHJDAVUGDH"

# URL de base de CouchDB
COUCHDB_BASE_URL="http://localhost:5984"

# Créer la base de données _users
create_users_db() {
  echo "Création de la base de données _users..."
  response=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "$COUCHDB_BASE_URL/_users" -u $ADMIN_USER:$ADMIN_PASSWORD)
  if [ $response -eq 201 ]; then
    echo "Succès : La base de données _users a été créée."
  elif [ $response -eq 412 ]; then
    echo "La base de données _users existe déjà."
  else
    echo "Échec : Impossible de créer la base de données _users (Code HTTP: $response)"
    exit 1
  fi
}

# Ajouter des utilisateurs
add_user() {
  local username=$1
  local password=$2

  echo "Ajout de l'utilisateur $username..."
  response=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "$COUCHDB_BASE_URL/_users/org.couchdb.user:$username" -u $ADMIN_USER:$ADMIN_PASSWORD \
            -H "Content-Type: application/json" \
            -d '{
                  "name": "'"$username"'",
                  "password": "'"$password"'",
                  "roles": [],
                  "type": "user"
                }')
  if [ $response -eq 201 ]; then
    echo "Succès : L'utilisateur $username a été ajouté."
  else
    echo "Échec : Impossible d'ajouter l'utilisateur $username (Code HTTP: $response)"
  fi
}

# Créer la base de données _users
create_users_db

# Ajouter des utilisateurs
USERS=("user1:password1" "user2:password2" "user3:password3" "user4:password4" "user5:password5")

for user in "${USERS[@]}"; do
  IFS=':' read -r username password <<< "$user"
  add_user "$username" "$password"
done
