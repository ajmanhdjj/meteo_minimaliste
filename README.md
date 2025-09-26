# Météo Minimaliste

Une application Flutter simple pour afficher la météo actuelle et les prévisions sur 5 jours pour une ville donnée. Utilise l'API Open-Meteo (aucune clé API requise).

## Fonctionnalités
- Recherche d'une ville via un champ texte
- Affichage de la température, de la vitesse du vent, et de l'humidité (prévisions)
- Fond dynamique selon la température
- Prévisions sur 5 jours

## Design
- Interface moderne avec une palette de couleurs sombre (bleu-noir, violet sombre, bleu-gris)
- Champ de recherche avec effet glassmorphism (flou), bordure dynamique au focus, et animations fluides
- Icônes Material (soleil, nuages, pluie) avec animations de mise à l'échelle
- Cartes de prévision avec effet glassmorphism, coins arrondis, et animations progressives
- Typographie Poppins avec tailles et poids optimisés pour une hiérarchie visuelle claire

## Prérequis
- Flutter SDK

## Installation
1. Clonez le dépôt : `git clone https://github.com/ajmanhdjj/meteo_minimaliste.git`
2. Exécutez `flutter pub get`
3. Lancez l'app avec `flutter run`