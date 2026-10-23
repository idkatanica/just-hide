<p align="center">
  <img src="assets/icon.png" alt="Just Hide icon" width="112" height="112">
</p>

<h1 align="center">Just Hide</h1>

<p align="center">One click, and the menu bar icons you don't need are gone.</p>

<p align="center">
  <a href="https://github.com/idkatanica/just-hide/releases/latest"><img src="https://img.shields.io/github/v/release/idkatanica/just-hide?style=flat-square&label=version&color=222" alt="Latest version"></a>
  <img src="https://img.shields.io/badge/macOS-14%2B-222?style=flat-square" alt="macOS 14 or later">
  <img src="https://img.shields.io/badge/price-free-222?style=flat-square" alt="Free">
</p>

<br>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/menu-bar-dark.svg">
    <img src="assets/menu-bar-light.svg" alt="A crowded menu bar, then the same bar with Just Hide: only the capsule and system icons remain." width="100%">
  </picture>
</p>

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/idkatanica/just-hide/main/install.sh | bash
```

Puts Just Hide in Applications after checking the download. Run it again to update. Apple Silicon and Intel.

## What it does

- **Click the capsule** to hide icons; click again to bring them back in place. A shortcut works too.
- **Choose what hides** in Settings: drag an icon across the capsule in a live copy of your menu bar.
- **Hides again on its own** after a delay you pick, never while you're using a menu.

## Good to know

- Allow **Accessibility** when asked: it lets Just Hide see your icons. **Screen Recording** is optional and only shows their pictures in Settings. Nothing leaves your Mac.
- On macOS 27, all icons of an app hide together, and Focus hides along with them.
- Not notarized by Apple. If macOS ever blocks it, use **System Settings › Privacy & Security › Open Anyway**.

<details>
<summary>Remove Just Hide</summary>

```sh
curl -fsSL https://raw.githubusercontent.com/idkatanica/just-hide/main/install.sh | bash -s -- --uninstall
```

</details>

## Feedback

[Report a bug](https://github.com/idkatanica/just-hide/issues/new?template=bug.yml) · [Suggest a feature](https://github.com/idkatanica/just-hide/issues/new?template=feature.yml)

## License

Free to use under the [Just Hide Freeware License](LICENSE).
