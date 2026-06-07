# SCRIPTS: IS EMPTY DIR


> `QUERY:` <br />
> I want a small script, that will allow me to check if first argument is a directory, and if so,
> is it empty or not (has files/sub-folders)
> <br />


---


A portable Bash version:

```bash
#!/usr/bin/env bash

dir="$1"

if [[ ! -d "$dir" ]]; then
    echo "Not a directory: $dir"
    exit 1
fi

if [[ -n "$(find "$dir" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]; then
    echo "Directory is not empty"
else
    echo "Directory is empty"
fi
```

### Why use `find`?

* Works on both Linux and macOS.
* Correctly handles hidden files (`.git`, `.foo`, etc.).
* Doesn't break on filenames containing spaces.
* Stops after finding the first entry (`-quit`), so it's efficient even for large directories.

If you only need a boolean check inside a script:

```bash
if [[ -n "$(find "$1" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]; then
    # not empty
else
    # empty
fi
```

Or as a reusable function:

```bash
is_empty_dir() {
    [[ -d "$1" ]] &&
    [[ -z "$(find "$1" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]
}

if is_empty_dir "$1"; then
    echo "empty"
else
    echo "not empty (or not a directory)"
fi
```

This approach is more reliable than glob-based solutions (`*`, `dotglob`, etc.) and remains portable across Bash versions, including the older Bash shipped with macOS.


