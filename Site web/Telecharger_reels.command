#!/bin/bash
# Script d'extraction automatique des covers de Reels Instagram
# Double-clique sur ce fichier pour lancer l'extraction
# Les images seront téléchargées DIRECTEMENT dans le dossier DJ/reels/

DEST="$HOME/Documents/Claude/Projects/DJ/reels"
mkdir -p "$DEST"

echo "🎬 Extraction des covers de Reels Instagram pour Harry Gozlan DJ"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⚠️  NE PAS fermer Chrome ni cette fenêtre pendant l'opération"
echo "⚠️  Laisse Chrome rester au premier plan"
echo ""
echo "Démarrage dans 3 secondes..."
sleep 3

# Function to run AppleScript on Chrome
run_js() {
  osascript -e "tell application \"Google Chrome\" to execute active tab of first window javascript \"$1\""
}

navigate_to() {
  osascript -e "
    tell application \"Google Chrome\"
      set URL of active tab of first window to \"$1\"
    end tell"
  sleep 3
}

download_reel() {
  local N=$1
  local CODE=$2
  local LABEL=$3

  echo "📹 [$N/27] $LABEL..."

  # Navigate to embed page
  navigate_to "https://www.instagram.com/p/$CODE/embed/"
  sleep 2

  # Find biggest image and navigate to its CDN URL
  IMG_CHECK=$(run_js "var img=Array.from(document.querySelectorAll('img')).filter(function(i){return i.src.indexOf('t51.82787-15')>-1||i.src.indexOf('t51.2885-15')>-1}).sort(function(a,b){return b.naturalWidth-a.naturalWidth})[0]; img?'found:'+img.naturalWidth:'none'")

  if [[ "$IMG_CHECK" == *"found:"* ]]; then
    run_js "var img=Array.from(document.querySelectorAll('img')).filter(function(i){return i.src.indexOf('t51.82787-15')>-1||i.src.indexOf('t51.2885-15')>-1}).sort(function(a,b){return b.naturalWidth-a.naturalWidth})[0]; window.location.href=img.src;" > /dev/null 2>&1
    sleep 3

    # Extract via canvas and download
    RESULT=$(run_js "var img=document.querySelector('img'); if(img&&img.naturalWidth>100){var c=document.createElement('canvas');c.width=img.naturalWidth;c.height=img.naturalHeight;c.getContext('2d').drawImage(img,0,0);var b64=c.toDataURL('image/jpeg',0.88);var a=document.createElement('a');a.href=b64;a.download='reel-$N.jpg';document.body.appendChild(a);a.click();document.body.removeChild(a);'OK:'+img.naturalWidth+'x'+img.naturalHeight}else{'SMALL:'+(img?img.naturalWidth:'none')}")

    if [[ "$RESULT" == *"OK:"* ]]; then
      echo "   ✅ Téléchargé: $RESULT"
      sleep 1
    else
      echo "   ⚠️  Image trop petite ou absente: $RESULT — passage au suivant"
    fi
  else
    echo "   ⚠️  Aucune image trouvée sur l'embed — passage au suivant"
  fi
}

# Process all 27 reels
download_reel 1  "DVIwzLCDQio" "Mariage de rêve à Paris"
download_reel 2  "DUoKb2fDQxP" "Set clubbing — énergie maximale"
download_reel 3  "DS6zsHHDco2" "Bar-Mitsvah en feu"
download_reel 4  "DSaZRh5jbfC" "DJ Live avec saxophoniste"
download_reel 5  "DR4cC_pDW09" "Soirée d'entreprise premium"
download_reel 6  "DRGhu1GCJ5i" "Première danse — moment éternel"
download_reel 7  "DQ3lQNwCPzU" "Hora du mariage"
download_reel 8  "DP_mKulCGun" "Entrée spectaculaire"
download_reel 9  "DJGlnKDs2tr" "Tel Aviv vibes"
download_reel 10 "DIkePpIoIfV" "Rooftop party"
download_reel 11 "DGgPXiks4Ka" "Nuit à Dubai"
download_reel 12 "DGGltBmMh1L" "Mariage séfarade — ambiance folle"
download_reel 13 "DFstgYGMZ4U" "Behind the decks"
download_reel 14 "DEQEBQjMc8K" "Anniversaire inoubliable"
download_reel 15 "DBEctbusG4J" "Live show — chanteur + DJ"
download_reel 16 "C_Iu57jsfa-" "Feux Sparkular — effet waouh"
download_reel 17 "C-SBFEzspkT" "Piste de danse en transe"
download_reel 18 "C79zf9nMBcW" "Bat-Mitsvah élégante"
download_reel 19 "C7u3-QOIGej" "Mix exclusif — vibes underground"
download_reel 20 "C7n-cGLMh-f" "Mariage en plein air"
download_reel 21 "C7CCJKtsAHr" "Corporate gala — Grande scène"
download_reel 22 "C5xvDMps4H7" "Ambiance marocaine chaleureuse"
download_reel 23 "C5lQwcHN8Ww" "Marbella — pool party"
download_reel 24 "ConC1_-MLkO" "Salon du Mariage — showcase"
download_reel 25 "CncZdbphN0E" "Anniversaire surprise — moment parfait"
download_reel 26 "CmB-a1ROo6q" "Set 3h du matin — la salle reste"
download_reel 27 "CkYeLVZD1ln" "La dernière danse — jusqu'au bout"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Extraction terminée !"
echo ""

# Move downloaded files from Downloads to reels folder
echo "📁 Déplacement des fichiers vers le dossier reels..."
count=0
for i in $(seq 1 27); do
  f="$HOME/Downloads/reel-$i.jpg"
  if [ -f "$f" ]; then
    mv "$f" "$DEST/reel-$i.jpg"
    echo "   ✅ reel-$i.jpg → reels/"
    count=$((count + 1))
  fi
done

# Also check if files were downloaded directly to dest
already=$(ls "$DEST"/reel-*.jpg 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "🎉 $already cover(s) prête(s) dans le dossier reels/"
echo "Recharge la page du site pour voir les résultats."
echo ""
echo "Appuie sur Entrée pour fermer."
read
