# drei - DaVinci Resolve Easy Installer (Beta)

**Attention: Ce projet est actuellement en phase beta. Utiliser le en sachant que certains problèmes peuvent survenir lors de son utilisation.**

**drei** et un script bash designer pour simplifier le processus d'installation de DaVinci Resolve sur toutes les distributions Linux. Le script utilise la conteneurisation pour garantir un environnement cohérent entre les différents systèmes.

## Fonctionnalités

- **Configuration Interactive**: Le script guide les utilisateurs de manière interactif lors du processus d'installation.
- **Distribution Supportée**: Supporte Debian, Fedora, Arch Linux, OpenSUSE et leurs équivalents.
- **Environnement de Conteneurisation**: Utilise `distrobox` pour créer un environnement conteneurisé afin d'installer DaVinci Resolve.
- **Gestion des Dépendances**: Install automatiquement les dépendances nécessaires en se basant sur la distribution Linux de l'utilisateur.

## Compatibilités

- **GPU AMD**
- **GPU NVIDIA**
- **biGPU (OPTIMUS, iGPU + dGPU, ...)**

- **Les GPU Intel seul ne sont pas supporté par DaVinci Resolve**

## Utilisation

```bash
git clone https://github.com/legdna/drei
cd drei
chmod +x ./drei.sh
./drei.sh
```

Suivez les instructions à l'écran pour compléter l'installation.

**Note: Ce project est en phase beta, des problèmes peuvent donc survenir durant l'installation où l'utilisation. Utiliser le donc avec précaution, et considérer qu'il est préférable d'éffectuer une backup de vos données importantes avant l'exécution du script. Les contributions et rapports de bugs sont hautement appréciés.**
