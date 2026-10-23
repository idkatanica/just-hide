#!/bin/bash
# Just Hide installer. Read this file before running it.
# Installs or updates Just Hide from a versioned GitHub release, after checking its
# SHA-256 checksum and signature. No sudo is required.
#
#   curl -fsSL https://raw.githubusercontent.com/idkatanica/just-hide/main/install.sh | bash
#   bash install.sh --uninstall
set -euo pipefail
archive=""
checksum=""
version=""
# macOS recognizes one copy of an app; Just Hide hides icons only from that copy.
# /Applications is writable for administrators; otherwise fall back to ~/Applications.
destination="/Applications"
[[ -w /Applications ]] || destination="$HOME/Applications"
should_open=true
uninstall=false
bundle_id="com.idkatanica.justhide"
usage() {
  echo "Usage: bash install.sh [--version vX.Y.Z] [--destination DIR] [--no-open]"
  echo "Local: bash install.sh --archive FILE --sha256 HASH [--destination DIR] [--no-open]"
  echo "Remove: bash install.sh --uninstall [--destination DIR]"
}
fail() { printf 'Just Hide: %s\n' "$*" >&2; exit 1; }
while [[ $# -gt 0 ]]; do
  case "$1" in
    --version|--archive|--sha256|--destination)
      [[ $# -ge 2 && -n "$2" ]] || fail "Missing value for $1"
      case "$1" in
        --version) version="$2" ;; --archive) archive="$2" ;;
        --sha256) checksum="$2" ;; --destination) destination="$2" ;;
      esac
      shift 2 ;;
    --no-open) should_open=false; shift ;;
    --uninstall) uninstall=true; shift ;;
    --help|-h) usage; exit 0 ;;
    *) usage >&2; fail "Unknown option: $1" ;;
  esac
done
[[ "$(uname -s)" == "Darwin" ]] || fail "macOS is required."
major="$(sw_vers -productVersion | cut -d. -f1)"
[[ "$major" -ge 14 ]] || fail "macOS 14 or later is required."
[[ "$destination" == /* ]] || fail "The destination must be an absolute path."

# Quits a running Just Hide the normal way, so it puts every hidden icon back first.
quit_running() {
  pgrep -x JustHide >/dev/null || return 0
  osascript -e "tell application id \"$bundle_id\" to quit" >/dev/null 2>&1 || true
  for _ in $(seq 1 50); do pgrep -x JustHide >/dev/null || return 0; sleep 0.1; done
  fail "Just Hide didn't quit. Quit it from its menu bar menu, then run the installer again."
}

if [[ "$uninstall" == true ]]; then
  target="$destination/Just Hide.app"
  [[ -d "$target" ]] || fail "Just Hide is not installed in $destination."
  [[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$target/Contents/Info.plist" 2>/dev/null)" == "$bundle_id" ]] ||
    fail "$target is not Just Hide; nothing was removed."
  quit_running
  rm -rf "$target"
  defaults delete "$bundle_id" >/dev/null 2>&1 || true
  printf 'Removed %s and its settings.\n' "$target"
  printf 'You can also remove Just Hide from System Settings › Privacy & Security › Accessibility and Screen Recording.\n'
  exit 0
fi
[[ ! -L "$destination" ]] || fail "The destination must not be a symbolic link."
mkdir -p "$destination"
[[ -d "$destination" && -w "$destination" ]] || fail "The destination must be a writable directory."
work="$(mktemp -d "$destination/.just-hide-install.XXXXXX")"
backup=""
target="$destination/Just Hide.app"
cleanup() {
  if [[ -n "$backup" && -d "$backup" && ! -e "$target" ]]; then mv "$backup" "$target"; fi
  rm -rf "$work"
}
trap cleanup EXIT
download() { curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 --connect-timeout 15 --max-time 180 "$1" -o "$2"; }
if [[ -n "$archive" ]]; then
  [[ -f "$archive" && -n "$checksum" ]] || fail "Local installation requires an archive and its SHA-256 checksum."
  cp "$archive" "$work/app.zip"
else
  [[ -z "$checksum" ]] || fail "--sha256 is only used with --archive."
  if [[ -z "$version" ]]; then
    download "https://api.github.com/repos/idkatanica/just-hide/releases/latest" "$work/release.json" ||
      fail "No release is available. See https://github.com/idkatanica/just-hide/releases"
    version="$(plutil -extract tag_name raw -o - "$work/release.json")"
  fi
  [[ "$version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9.-]+)?$ ]] || fail "Invalid release version."
  asset="Just-Hide-${version#v}-universal.zip"
  release="https://github.com/idkatanica/just-hide/releases/download/$version/$asset"
  download "$release" "$work/app.zip"
  download "$release.sha256" "$work/checksum"
  checksum="$(awk 'NR == 1 {print $1}' "$work/checksum")"
fi
[[ "$checksum" =~ ^[0-9a-fA-F]{64}$ ]] || fail "Invalid SHA-256 checksum."
actual="$(shasum -a 256 "$work/app.zip" | awk '{print $1}')"
[[ "$(printf '%s' "$checksum" | tr 'A-F' 'a-f')" == "$actual" ]] || fail "Checksum mismatch. The existing application was not changed."
unzip -Z1 "$work/app.zip" > "$work/entries" || fail "Invalid ZIP archive."
unzip -Z -l "$work/app.zip" > "$work/attributes" || fail "Invalid ZIP directory."
awk '$1 ~ /^l/ {bad=1} END {exit bad ? 1 : 0}' "$work/attributes" ||
  fail "Symbolic links are not allowed in the application archive."
awk '
  /^\// || /(^|\/)\.\.(\/|$)/ || /\\/ {bad=1}
  $0 !~ /^(Just Hide\.app\/|__MACOSX\/)/ {bad=1}
  END {exit bad ? 1 : 0}
' "$work/entries" || fail "Unexpected paths in ZIP archive."
mkdir "$work/extracted"
ditto -x -k "$work/app.zip" "$work/extracted"
bundle="$work/extracted/Just Hide.app"
[[ -d "$bundle" && ! -L "$bundle" && -f "$bundle/Contents/Info.plist" && -x "$bundle/Contents/MacOS/JustHide" ]] || fail "The archive does not contain a valid Just Hide application."
[[ -z "$(find "$bundle" -type l -print -quit)" ]] || fail "Symbolic links are not allowed in the application archive."
identifier="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$bundle/Contents/Info.plist")"
[[ "$identifier" == "com.idkatanica.justhide" ]] || fail "Unexpected application identifier."
codesign --verify --strict "$bundle" || fail "Application signature verification failed."
[[ ! -L "$target" ]] || fail "The existing application path must not be a symbolic link."
if [[ -e "$target" ]]; then
  [[ -d "$target" ]] || fail "An unexpected file already exists at the installation path."
  existing_id="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$target/Contents/Info.plist" 2>/dev/null || true)"
  [[ "$existing_id" == "com.idkatanica.justhide" ]] || fail "The existing app is not Just Hide; it was not changed."
fi
quit_running
if [[ -d "$target" ]]; then
  backup="$work/previous.app"
  mv "$target" "$backup"
fi
mv "$bundle" "$target"
printf 'Installed: %s\n' "$target"
# Another copy of the app confuses macOS about which one may keep its menu bar icon.
others="$(mdfind "kMDItemCFBundleIdentifier == '$bundle_id'" 2>/dev/null | grep -v -F -x "$target" | grep -v -e '/\.Trash/' -e '/\.just-hide-install' || true)"
if [[ -n "$others" ]]; then
  printf '\nAnother copy of Just Hide was found. Delete it so macOS uses this one:\n%s\n' "$others"
fi
if [[ "$should_open" == true ]]; then
  open "$target" || printf 'Open Just Hide from %s when ready.\n' "$destination"
fi
printf 'Just Hide is not notarized by Apple. If macOS ever blocks it, use System Settings › Privacy & Security › Open Anyway.\n'
