# SCRIPTS: MOVE


> `QUERY:` <br />
> in bash linux, how can I copy/move files inside a directory ( including hidden files )
> <br />


---

In Bash, hidden files are just files whose names start with `.`. The main challenge is that the glob `*` does **not** match them by default.

### Copy everything (including hidden files)

#### Method 1: Copy the directory contents using `.`

```bash
cp -a source/. destination/
```

This is usually the simplest and safest approach.

* `-a` = archive mode (preserves permissions, timestamps, symlinks, etc.)
* `source/.` means "everything inside source, including hidden files"

Example:

```bash
cp -a /tmp/source/. /tmp/destination/
```

---

### Move everything (including hidden files)

With `mv`, use:

```bash
mv source/* source/.[!.]* source/..?* destination/
```

However, this can produce errors if no hidden files exist.

A cleaner approach is:

```bash
shopt -s dotglob
mv source/* destination/
shopt -u dotglob
```

`dotglob` makes `*` match hidden files as well.

---

### Using a `for` loop

Without hidden files:

```bash
for f in *; do
    echo "$f"
done
```

Including hidden files:

```bash
shopt -s dotglob

for f in *; do
    echo "$f"
done

shopt -u dotglob
```

---

### Using `find` (very robust)

Copy all files and directories from one location to another:

```bash
find source -mindepth 1 -maxdepth 1 -exec cp -a -t destination {} +
```

Move:

```bash
find source -mindepth 1 -maxdepth 1 -exec mv -t destination {} +
```

`find` naturally includes hidden files and avoids globbing issues.

---

### Recommended

For copying directory contents (including hidden files):

```bash
cp -a source/. destination/
```

For moving directory contents (including hidden files):

```bash
shopt -s dotglob
mv source/* destination/
shopt -u dotglob
```

These are the commands most Linux administrators typically use.

---


> `QUERY:`<br />
> I want to use `mv src/* dst/` approach, what will this look like ( I'd like it to be compatible both with linux and macos )
> <br />


---

For a command that works on both Linux and macOS using `mv`, the most portable solution is:

```bash
mv src/* src/.[!.]* src/..?* dst/
```

Explanation:

* `src/*` → normal files/directories
* `src/.[!.]*` → hidden entries like `.git`, `.env`
* `src/..?*` → hidden entries whose names are 2+ characters after the dot (covers things like `.config`, `.ssh`)
* Does **not** match `.` or `..`

### Caveat

If any of the patterns don't match anything, Bash may pass them literally to `mv`, causing messages such as:

```text
mv: cannot stat 'src/.[!.]*': No such file or directory
```

To avoid that, use Bash's `nullglob`:

```bash
shopt -s nullglob

mv src/* src/.[!.]* src/..?* dst/

shopt -u nullglob
```

This works on both Linux and macOS **when running under Bash**.

### Alternative: enable `dotglob`

If you specifically like the `mv src/* dst/` form:

```bash
shopt -s dotglob nullglob

mv src/* dst/

shopt -u dotglob nullglob
```

This makes `*` include hidden files as well.

I generally prefer the `dotglob` version because the actual `mv` command remains simple and you don't have to remember the hidden-file glob patterns. The only requirement is that the script runs under Bash (`#!/usr/bin/env bash`).

---


> `QUERY:` <br />
> help me create a script `move.sh` that will work both linux and macos
> - accepts two arguments src and dst
> - I need transparency (when the process is not a straightforward, I want to see the log of additional steps that were taken)
> - if src is a file - move file into dst (unless dst is a directory, if it's a directory - move file with it's own name)
> - if src is a directory - move all it's contents (including hidden files), if dst  does not exists (if src is a file, create the folder structure necessary: example - /tmp/backup/ exists, but I'm trying to move files into /tmp/backup/2026/06/25/, I expect 2026/06/25 folders to be created along the way, dst should always be treated as a directory: example - dst="~/2026/06/25.zip" will result in a directory 25.zip with src.file in it, or src/* files in it, including hidden)
> - split code into bash functions when necessary
> thanks
> <br />


---

A few design choices I'd recommend based on your requirements:

* Treat `dst` **always as a directory**.
* Create `dst` with `mkdir -p`.
* If `src` is a file, move the file into `dst/`.
* If `src` is a directory, move the **contents** of the directory (including hidden files), not the directory itself.
* Use Bash (`#!/usr/bin/env bash`) and enable `dotglob` + `nullglob` only when moving directory contents.
* Print log messages whenever the script does something non-obvious.

```bash
#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '[move.sh] %s\n' "$*"
}

usage() {
    cat <<EOF
Usage:
    move.sh <src> <dst>

Examples:
    move.sh file.txt /tmp/backup/2026/06/25/
    move.sh photos/ /tmp/archive/
    move.sh file.txt ~/2026/06/25.zip
EOF
    exit 1
}

ensure_directory() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        log "Creating destination directory: $dir"
        mkdir -p "$dir"
    fi
}

move_file() {
    local src="$1"
    local dst="$2"

    ensure_directory "$dst"

    log "Source is a file"
    log "Moving: $src -> $dst/"

    mv "$src" "$dst/"
}

move_directory_contents() {
    local src="$1"
    local dst="$2"

    ensure_directory "$dst"

    log "Source is a directory"
    log "Moving contents of: $src"
    log "Destination: $dst"

    shopt -s dotglob nullglob

    local items=("$src"/*)

    if (( ${#items[@]} == 0 )); then
        log "Directory is empty, nothing to move"
        shopt -u dotglob nullglob
        return 0
    fi

    log "Including hidden files and directories"

    mv "${items[@]}" "$dst/"

    shopt -u dotglob nullglob
}

main() {
    if [[ $# -ne 2 ]]; then
        usage
    fi

    local src="$1"
    local dst="$2"

    if [[ ! -e "$src" ]]; then
        echo "Error: source does not exist: $src" >&2
        exit 1
    fi

    if [[ -f "$src" ]]; then
        move_file "$src" "$dst"
    elif [[ -d "$src" ]]; then
        move_directory_contents "$src" "$dst"
    else
        echo "Error: unsupported source type: $src" >&2
        exit 1
    fi

    log "Done"
}

main "$@"
```

### Example 1

```bash
move.sh report.pdf /tmp/backup/2026/06/25/
```

Output:

```text
[move.sh] Creating destination directory: /tmp/backup/2026/06/25/
[move.sh] Source is a file
[move.sh] Moving: report.pdf -> /tmp/backup/2026/06/25//
[move.sh] Done
```

Result:

```text
/tmp/backup/2026/06/25/report.pdf
```

---

### Example 2

```bash
move.sh project/ /tmp/archive/
```

Where `project/` contains:

```text
project/
├── file.txt
├── .env
└── .git/
```

Result:

```text
/tmp/archive/file.txt
/tmp/archive/.env
/tmp/archive/.git/
```

(`project/` itself remains, but becomes empty.)

---

### Example 3

```bash
move.sh photo.jpg ~/2026/06/25.zip
```

Result:

```text
~/2026/06/25.zip/photo.jpg
```

because `dst` is always treated as a directory, regardless of its name.

---


> `QUERY:`<br />
> let's make a tweak, if dst ends with "/" we treat this as a directory, or, if src is a directory.
> so I could rename single files during move operations, but have control over how dst is interpreted
> <br />


---

That makes the behavior more Unix-like and removes the ambiguity around file renames.

I'd suggest these rules:

### Interpretation Rules

#### `src` is a file

| dst                           | Behavior                                                                   |
| ----------------------------- | -------------------------------------------------------------------------- |
| `/tmp/archive/`               | Treat as directory, create if needed, move to `/tmp/archive/<src-name>`    |
| `/tmp/archive/new-name.txt`   | Treat as file path, create parent directories, rename file                 |
| `/tmp/archive/2026/06/25.zip` | Treat as file path, create `/tmp/archive/2026/06`, rename file to `25.zip` |

Examples:

```bash
move.sh report.pdf /tmp/archive/
```

→

```text
/tmp/archive/report.pdf
```

```bash
move.sh report.pdf /tmp/archive/final-report.pdf
```

→

```text
/tmp/archive/final-report.pdf
```

---

#### `src` is a directory

Always move **contents** of the directory.

`dst` is always treated as a directory regardless of trailing slash.

Examples:

```bash
move.sh project /tmp/archive
```

or

```bash
move.sh project /tmp/archive/
```

Both mean:

```text
move project/* (including hidden files)
into
/tmp/archive/
```

creating `/tmp/archive` if necessary.

---

### Helper Function

This makes the logic very explicit:

```bash
is_directory_destination() {
    local src="$1"
    local dst="$2"

    [[ -d "$src" || "$dst" == */ ]]
}
```

---

### File Move Logic

```bash
move_file() {
    local src="$1"
    local dst="$2"

    if [[ "$dst" == */ ]]; then
        log "Destination interpreted as directory"

        mkdir -p "$dst"

        log "Moving file:"
        log "  $src"
        log "  -> $dst"

        mv "$src" "$dst"
    else
        local parent

        parent="$(dirname "$dst")"

        if [[ ! -d "$parent" ]]; then
            log "Creating parent directories: $parent"
            mkdir -p "$parent"
        fi

        log "Destination interpreted as file path"
        log "Moving file:"
        log "  $src"
        log "  -> $dst"

        mv "$src" "$dst"
    fi
}
```

---

### Transparency Example

```bash
move.sh report.pdf /backup/2026/06/final.pdf
```

Output:

```text
[move.sh] Source is a file
[move.sh] Creating parent directories: /backup/2026/06
[move.sh] Destination interpreted as file path
[move.sh] Moving file:
[move.sh]   report.pdf
[move.sh]   -> /backup/2026/06/final.pdf
[move.sh] Done
```

and

```bash
move.sh report.pdf /backup/2026/06/
```

Output:

```text
[move.sh] Source is a file
[move.sh] Creating destination directory: /backup/2026/06/
[move.sh] Destination interpreted as directory
[move.sh] Moving file:
[move.sh]   report.pdf
[move.sh]   -> /backup/2026/06/
[move.sh] Done
```

This gives you explicit control:

* Trailing `/` ⇒ directory.
* No trailing `/` ⇒ file rename path (for file sources).
* Directory sources always mean "move contents into this directory".


---


> `QUERY:`<br />
> provide me the final script, so I could copy/n/paste into my env
> <br />


---

```bash
#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '[move.sh] %s\n' "$*"
}

error() {
    printf '[move.sh] ERROR: %s\n' "$*" >&2
    exit 1
}

usage() {
    cat <<'EOF'
Usage:
    move.sh <src> <dst>

Rules:
    - If src is a file:
        * dst ending with "/" => destination directory
        * otherwise => destination file path (rename allowed)

    - If src is a directory:
        * move contents of the directory (including hidden files)
        * dst is always treated as a directory

Examples:
    move.sh report.pdf /tmp/archive/
    move.sh report.pdf /tmp/archive/final-report.pdf
    move.sh project/ /tmp/archive/
    move.sh project/ /tmp/archive
EOF
    exit 1
}

ensure_directory() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        log "Creating directory: $dir"
        mkdir -p "$dir"
    fi
}

move_file() {
    local src="$1"
    local dst="$2"

    if [[ "$dst" == */ ]]; then
        log "Source is a file"
        log "Destination interpreted as a directory"

        ensure_directory "$dst"

        log "Moving:"
        log "  $src"
        log "  -> $dst"

        mv "$src" "$dst"
    else
        local parent
        parent="$(dirname "$dst")"

        ensure_directory "$parent"

        log "Source is a file"
        log "Destination interpreted as a file path"

        log "Moving:"
        log "  $src"
        log "  -> $dst"

        mv "$src" "$dst"
    fi
}

move_directory_contents() {
    local src="$1"
    local dst="$2"

    log "Source is a directory"
    log "Destination interpreted as a directory"

    ensure_directory "$dst"

    shopt -s dotglob nullglob

    local items=("$src"/*)

    if (( ${#items[@]} == 0 )); then
        log "Directory is empty, nothing to move"

        shopt -u dotglob nullglob
        return 0
    fi

    log "Including hidden files and directories"

    mv "${items[@]}" "$dst/"

    shopt -u dotglob nullglob

    log "Moved ${#items[@]} item(s)"
}

main() {
    if [[ $# -ne 2 ]]; then
        usage
    fi

    local src="$1"
    local dst="$2"

    if [[ ! -e "$src" ]]; then
        error "Source does not exist: $src"
    fi

    if [[ -f "$src" ]]; then
        move_file "$src" "$dst"
    elif [[ -d "$src" ]]; then
        move_directory_contents "$src" "$dst"
    else
        error "Unsupported source type: $src"
    fi

    log "Done"
}

main "$@"
```

### Install

```bash
chmod +x move.sh
```

### Examples

Move a file into a directory:

```bash
./move.sh report.pdf /tmp/archive/
```

Rename while moving:

```bash
./move.sh report.pdf /tmp/archive/final-report.pdf
```

Move all contents of a directory (including hidden files):

```bash
./move.sh project/ /tmp/archive
```

or

```bash
./move.sh project/ /tmp/archive/
```

Both move:

```text
project/*
project/.env
project/.git
project/.*
```

into `/tmp/archive/`, creating the destination directory if needed.
