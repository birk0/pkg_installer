#!/bin/bash

DIR="$HOME/.local/share/applications"
SCR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCR="pkg_installer"

if command -v apt &> /dev/null; then
    PKG="apt"
elif command -v dnf &> /dev/null; then
    PKG="dnf"
else
    echo "PKG Err: only apt/dnf is supported." >&2
    exit 1
fi

cat > "$SCR.desktop" <<EOF
[Desktop Entry]
Name=Package Installer
Exec=pkexec $SCR_DIR/$SCR.sh %f
Type=Application
Terminal=true
EOF

cat > "$SCR.sh" <<EOF
#!/bin/bash

if ! command -v pkexec &> /dev/null; then
    echo "Depends Error: pkexec is not installed." >&2
    exit 1
fi

$PKG install -y "\$1" | tee /dev/tty
sleep 2
clear  
echo "Installation Complete, exiting..."
sleep 1
exit
EOF

mv "$SCR.desktop" "$DIR"
rm -- "$0"
