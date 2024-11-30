# Nettoyage de données MySQL - Vente Immobilier 🏠

Ce mini-projet a pour objectif de nettoyer et de préparer les données dans une base MySQL, à partir d'une table contenant des informations sur les ventes immobilières. Les étapes principales incluent l'exploration, le traitement et la validation des données.

## Fonctionnalités
1. Suppression des doublons basés sur des colonnes clés (`id_parcerel`, `date_vente`, etc.).
2. Traitement des valeurs manquantes (`NULL`) dans les colonnes critiques, comme les prix et les dates.
3. Normalisation et formatage des données (par exemple : mise en majuscules des noms, séparation des champs d'adresse).
4. Validation des données nettoyées pour garantir leur cohérence et leur qualité.

## Structure du projet
- **Scripts_traitement** : Contient les scripts SQL et Python pour chaque étape du nettoyage.
- **Data** : Dossier contenant les données utilisées pour illustrer le projet.

## Technologies utilisées
- **Python (pandas)** : Utilisé pour unifier les types des colonnes, facilitant l'importation des données dans MySQL Workbench.
- **Jupyter Notebook** : Utilisé comme environnement pour l'exécution des scripts Python.
- **MySQL Workbench** : Utilisé pour l'exécution des scripts SQL.
- **MySQL 8.0** : Utilisé pour le stockage et la gestion des données.

## Instructions pour utiliser ce projet
1. Importez le fichier SQL dans MySQL Workbench.
2. Créez une table contenant toutes les colonnes de la source de données CSV.
3. Placez le fichier source dans le répertoire MySQL accessible pour l'importation :  
   `C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Nashville Housing Data for Data Cleaning1.csv`.
4. Exécutez les scripts dans l'ordre indiqué par les titres.
5. Vérifiez les résultats à l’aide des requêtes de validation fournies.

## Auteur
- **Georges**
