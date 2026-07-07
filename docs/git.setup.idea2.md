# Git Setup - Idea #2


> `QUERY:`
> I want to update the input values, the file contents for the profile info is: <br />
> <br />
> john doe <br />
> j.doe@ex.com <br />
> <br />
> and if no file provided - I want to as the user to input the name and email in the terminal prompt <br />
> <br />


---


# Response:


Perfect — even cleaner 👌
So the rules are now:

* **Input format (stdin)**:

  ```
  John Doe
  j.doe@ex.com
  ```
* **If stdin is empty / not provided** → prompt interactively
* Works on **Linux + macOS**
* Sets **local git config only**

Here’s a small, solid script that does exactly that.

---

## ✅ `git-setup.sh`

```bash
#!/usr/bin/env bash
set -e

# Ensure we're inside a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "❌ Not inside a git repository"
  exit 1
fi

# Detect if stdin has data
if [ -t 0 ]; then
  # Interactive mode
  read -r -p "Git user name: " name
  read -r -p "Git user email: " email
else
  # Read from stdin
  IFS= read -r name || true
  IFS= read -r email || true
fi

# Trim whitespace (portable)
name="$(printf '%s' "$name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
email="$(printf '%s' "$email" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

# Validate input
if [[ -z "$name" || -z "$email" ]]; then
  echo "❌ Name or email is empty"
  exit 1
fi

# Apply git config (local only)
git config --local user.name "$name"
git config --local user.email "$email"

echo "✅ Git local config set:"
echo "   user.name  = $name"
echo "   user.email = $email"
```

---

## 🧪 Usage examples

### 📄 From a profile file

```bash
cat ~/profile.work.txt | git-setup.sh
```

### 🔁 Using input redirection

```bash
git-setup.sh < ~/profile.work.txt
```

### 💬 Interactive (no stdin)

```bash
git-setup.sh
```

---

## 📝 Example profile file

```txt
John Doe
j.doe@ex.com
```

(no keys, no syntax — just clean and human-readable)

---

## 💡 Why this works well

* `-t 0` reliably detects **interactive vs piped input**
* `read -r` keeps names like `John O'Connor` intact
* No Bash 4+ features → **macOS safe**
* No temp files
* Local-only Git config

---

If you want next-level polish, I can add:

* email format validation
* masked email input
* confirmation prompt
* auto-fill from existing repo config
* fallback to global config values

Just tell me 😄
