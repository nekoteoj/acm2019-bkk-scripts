#!/bin/bash

# Run in superuser
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

# Cleaning up old installation
# Disable VPN
if [[ -f "/etc/systemd/system/icpc.service" ]]; then
	systemctl stop icpc
	systemctl disable icpc
fi

if grep -q "contestant" /etc/passwd; then
	echo "Removing old contestant user"
	# Deleting user
	deluser --remove-all-files contestant
	rm -rf /home/contestant
fi

/usr/sbin/useradd contestant --create-home --shell /bin/bash
echo -e "contestant\ncontestant" | passwd contestant

sudo -u contestant bash -c "HOME=/home/contestant xdg-user-dirs-update"
sudo -u contestant bash -c "mkdir -p /home/contestant/.config/autostart"

echo '
#!/bin/bash
# Wait for nautilus-desktop
while ! pgrep -f "nautilus-desktop" > /dev/null; do
  sleep 1
done
# Trust all desktop files
for i in ~/Desktop/*.desktop; do
  [ -f "${i}" ] || break
  gio set "${i}" "metadata::trusted" yes
done
# Restart nautilus, so that the changes take effect (otherwise we would have to press F5)
killall nautilus-desktop && nautilus-desktop &
# Remove X from this script, so that it wont be executed next time
chmod -x ${0}
' > /home/contestant/Desktop/desktop-truster.sh
chown contestant:contestant /home/contestant/Desktop/desktop-truster.sh

bash pc2-installer.sh

echo "Creating docs files"
cp javadocs.desktop /home/contestant/Desktop/javadocs.desktop
cp contest_dashboard.desktop /home/contestant/Desktop/.
cp scoreboard.desktop /home/contestant/Desktop/.
chmod +x /home/contestant/Desktop/javadocs.desktop
cp /usr/share/applications/codeblocks.desktop /home/contestant/Desktop/.
cp /usr/share/applications/emacs25.desktop /home/contestant/Desktop/.
cp /usr/share/applications/geany.desktop /home/contestant/Desktop/.
cp /usr/share/applications/gedit.desktop /home/contestant/Desktop/.
cp /usr/share/applications/gvim.desktop /home/contestant/Desktop/.
cp /var/lib/snapd/desktop/applications/eclipse_eclipse.desktop /home/contestant/Desktop/.
cp /var/lib/snapd/desktop/applications/intellij-idea-community_intellij-idea-community.desktop /home/contestant/Desktop/.

tar xJf CPP_reference.tar.xz -C /home/contestant/Desktop/

chown -R contestant:contestant /home/contestant/Desktop/*
chmod +x /home/contestant/Desktop/*.desktop
chmod +x /home/contestant/Desktop/*.sh

sudo -u contestant bash -c "bash /home/contestant/.config/autostart/desktop-truster.sh"

