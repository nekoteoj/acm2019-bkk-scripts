#!/bin/bash

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

# Remove Old Installation
if [ -d "/opt/pc2_contestant" ]; then
	echo "Found existing installation!"
	echo "Removing old installation..."
	rm -r /opt/pc2_contestant
fi

# Extraction
echo "Extracting files..."
mkdir -p /opt
unzip -q pc2_contestant.zip -d /opt
mv /opt/pc2-9.6.0_contestant /opt/pc2_contestant
chmod -R 777 /opt/pc2_contestant

# Create Desktop File
echo "Creating desktop file..."
echo "
[Desktop Entry]
Version=1.0
Name=PC2
Exec=/opt/pc2_contestant/bin/pc2team
Path=/opt/pc2_contestant/bin/
Icon=/opt/pc2_contestant/pc2.ico
Terminal=false
Type=Application
Categories=Utility;Development;
" > /usr/share/applications/pc2.desktop

chmod +x /usr/share/applications/pc2.desktop
cp /usr/share/applications/pc2.desktop /home/contestant/Desktop/pc2.desktop
chmod +x /home/contestant/Desktop/pc2.desktop

echo "Finished!"
