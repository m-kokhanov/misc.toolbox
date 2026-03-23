Great idea—this is exactly the kind of thing that pays off every time you reinstall or spin up a VM.

On Ubuntu with GNOME, most of what you want lives in **`gsettings`** (GNOME’s configuration system) and sometimes **`dconf`**. A setup script is basically a collection of those commands.

---

# 🧱 1. Basic Script Structure

Start with a simple bash script:

```bash
#!/usr/bin/env bash

set -e  # exit on error

echo "Applying GNOME settings..."

# Example placeholder
gsettings set org.gnome.desktop.interface clock-show-date true

echo "Done."
```

Save as `setup-gnome.sh`, then:

```bash
chmod +x setup-gnome.sh
./setup-gnome.sh
```

---

# 🔍 2. How to Discover Settings

Before writing the script, you need to *find the right keys*.

### Useful commands:

```bash
gsettings list-schemas
gsettings list-keys org.gnome.desktop.interface
gsettings get org.gnome.desktop.interface clock-show-date
```

### GUI tool (very helpful):

```bash
sudo apt install dconf-editor
```

Then run:

```bash
dconf-editor
```

Browse and tweak settings → copy the key path into your script.

---

# ⚙️ 3. Common Tweaks (Examples)

Here are some of the exact things you mentioned:

---

## ⌨️ Keyboard delay & repeat speed

```bash
# Delay before repeat (lower = faster start)
gsettings set org.gnome.desktop.peripherals.keyboard delay 250

# Repeat speed (lower = faster repeat)
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
```

---

## 🪟 Center new windows

GNOME doesn’t natively support “always center new windows” globally 😬
…but you can approximate behavior:

```bash
# Disable automatic tiling
gsettings set org.gnome.mutter edge-tiling false
```

👉 For true centering, people usually install extensions like:

* “Put Windows”
* “Auto Move Windows”

---

## 🖥️ Workspaces (Desktops)

```bash
# Disable dynamic workspaces
gsettings set org.gnome.mutter dynamic-workspaces false

# Set fixed number of workspaces
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
```

---

## 🧭 Workspace behavior tweaks

```bash
# Switch workspaces only on primary monitor
gsettings set org.gnome.mutter workspaces-only-on-primary true
```

---

## 🪟 Window buttons (minimize/maximize)

```bash
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
```

---

## 🖱️ Focus follows mouse (optional)

```bash
gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy'
```

---

## 🎯 Disable hot corner

```bash
gsettings set org.gnome.desktop.interface enable-hot-corners false
```

---

## 🌙 Dark mode

```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

---

# 📦 4. Installing Extensions (Optional but Powerful)

You can also automate extension installs:

```bash
sudo apt install gnome-shell-extensions gnome-shell-extension-manager
```

Or via CLI (advanced):

```bash
# Install extension manager CLI
pip install gnome-extensions-cli

# Example install
gnome-extensions install user-theme@gnome-shell-extensions.gcampax.github.com
```

---

# 🧪 5. Making It Idempotent (Important)

Good setup scripts should be safe to run multiple times.

You can wrap changes like:

```bash
set_if_needed () {
  local schema=$1
  local key=$2
  local value=$3

  current=$(gsettings get "$schema" "$key")

  if [[ "$current" != "$value" ]]; then
    echo "Setting $schema::$key → $value"
    gsettings set "$schema" "$key" "$value"
  fi
}

set_if_needed org.gnome.desktop.interface clock-show-date true
```

---

# 🧰 6. Bonus: System-Level Tweaks

Some things are not GNOME-specific:

```bash
# Faster boot (example)
sudo systemctl disable bluetooth.service

# Install essentials
sudo apt update
sudo apt install -y git curl vim
```

---

# 🧭 7. Suggested Project Structure

```bash
setup/
├── setup.sh
├── gnome.sh
├── packages.sh
└── extensions.sh
```

Then `setup.sh` calls everything:

```bash
#!/usr/bin/env bash

./packages.sh
./gnome.sh
./extensions.sh
```

---

# 🚀 Next Step

If you want, I can help you:

* Build a **full production-ready script**
* Add **GNOME extensions auto-install + config**
* Export your **current machine settings automatically**
* Or tailor it to your workflow (dev, tiling-like behavior, etc.)

Just tell me what your ideal desktop feels like 👍
