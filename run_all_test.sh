#!/bin/bash

# stop le script si une commande echoue
set -e 

# Set root dir
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

JAVA_DIR="$ROOT_DIR/Java"
ANGULAR_DIR="$ROOT_DIR/Angular"

RESULT_DIR="$ROOT_DIR/test_result"
JAVA_RESULT_DIR="$RESULT_DIR/java"
ANGULAR_RESULT_DIR="$RESULT_DIR/angular"

# Création dossiers résultats
mkdir -p "$RESULT_DIR"
mkdir -p "$JAVA_RESULT_DIR"
mkdir -p "$ANGULAR_RESULT_DIR"

testing_java_dependencies() {
    # Test dependances Gradlew
    if [ ! -f "./gradlew" ]; then
        echo "Erreur : gradlew introuvable"
        exit 1
    fi
}

testing_angular_dependencies() {
    # Test existance node modules
    if [ ! -d "$ANGULAR_DIR/node_modules" ]; then
        echo "Erreur : node_modules n'existe pas."
        echo "Exécuter 'npm install' dans $ANGULAR_DIR."
        exit 1
    fi
}

run_java_tests() {

    # Nettoyage des anciens résultats
    rm -rf "$JAVA_RESULT_DIR"/*

    echo "===== Lancement des tests Java ====="
    cd "$JAVA_DIR"

    echo "===== Test des dependances Java ====="
    testing_java_dependencies

    #### ajout test cmd
    ./gradlew clean test

    echo "===== Tests Java terminés ====="

    # Copie des resultats
    cp "$JAVA_DIR\build\test-results\test"/*.xml "$JAVA_RESULT_DIR"/
}

run_angular_tests() {

    # Nettoyage des anciens résultats
    rm -rf "$ANGULAR_RESULT_DIR"/*

    echo "===== Lancement des tests Angular ====="
    cd "$ANGULAR_DIR"

    echo "===== Test des dependances Angular ====="
    testing_angular_dependencies

    #### ajout test cmd
    npm test

    echo "===== Tests Angular terminés ====="

    # Copie des resultats
    cp "$ANGULAR_DIR\reports"/*.xml "$ANGULAR_RESULT_DIR"/
}

# Exécution des tests
run_java_tests
run_angular_tests