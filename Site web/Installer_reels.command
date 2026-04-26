#!/bin/bash
# Script pour déplacer les thumbnails de reels vers le bon dossier
# Double-clique sur ce fichier pour l'exécuter

DOWNLOADS=~/Downloads
DEST=~/Documents/Claude/Projects/DJ/reels

echo "📁 Déplacement des thumbnails reels vers $DEST..."
mkdir -p "$DEST"

count=0
for i in $(seq 1 27); do
  f="$DOWNLOADS/reel-$i.jpg"
  if [ -f "$f" ]; then
    mv "$f" "$DEST/reel-$i.jpg"
    echo "✅ reel-$i.jpg déplacé"
    count=$((count + 1))
  fi
done

echo ""
echo "✅ $count fichier(s) déplacé(s) vers le dossier reels."
echo "Appuie sur Entrée pour fermer."
read
