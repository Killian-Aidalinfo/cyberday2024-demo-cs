#!/bin/bash

# URL de la base de données CouchDB
COUCHDB_URL="http://195.15.200.248:5984/_users/_all_docs"

# Informations d'identification correctes
VALID_USER="udhyiautHJDAVGDHJ"
VALID_PASSWORD="IDAUYTZVDGBHnjahvgdgHJDAVUGDH"

# Liste des utilisateurs et mots de passe aléatoires
USERNAMES=("randomuser1" "randomuser2" "randomuser3" "randomuser4" "randomuser5")
PASSWORDS=("randompass1" "randompass2" "randompass3" "randompass4" "randompass5")

if [ "$1" == "--ok" ]; then
  # Utiliser les informations d'identification correctes
  echo "Utilisation des informations d'identification correctes"
  response=$(curl -s -w "\n%{http_code}" -X GET "$COUCHDB_URL" -u $VALID_USER:$VALID_PASSWORD)
  http_code=$(echo "$response" | tail -n1)
  if [ $http_code -eq 200 ]; then
    echo "Succès : Tous les documents ont été récupérés avec $VALID_USER:$VALID_PASSWORD"
  else
    echo "Échec : Impossible de récupérer les documents avec $VALID_USER:$VALID_PASSWORD (Code HTTP: $http_code)"
  fi
else
  # Utiliser des informations d'identification aléatoires
  echo "Tentative d'accès avec des informations d'identification aléatoires"
  for i in "${!USERNAMES[@]}"; do
    USERNAME=${USERNAMES[$i]}
    PASSWORD=${PASSWORDS[$i]}
    
    echo "Tentative avec $USERNAME:$PASSWORD"
    response=$(curl -s -w "\n%{http_code}" -X GET "$COUCHDB_URL" -u $USERNAME:$PASSWORD)
    http_code=$(echo "$response" | tail -n1)
    if [ $http_code -eq 200 ]; then
      echo "Succès : Documents récupérés avec $USERNAME:$PASSWORD"
    else
      echo "Échec : Impossible de récupérer les documents avec $USERNAME:$PASSWORD (Code HTTP: $http_code)"
    fi
  done
fi
