<p align="center">
  <img src="assets/icon.png" alt="Just Hide app icon: a glossy capsule" width="128" height="128">
</p>

<h1 align="center">Just Hide</h1>

<p align="center">A quieter menu bar. Free, native, and small.</p>

<p align="center">
  <a href="#install">Install</a> &nbsp;·&nbsp;
  <a href="#what-it-does">What it does</a> &nbsp;·&nbsp;
  <a href="#permissions">Permissions</a> &nbsp;·&nbsp;
  <a href="#update-and-remove">Update and remove</a> &nbsp;·&nbsp;
  <a href="#feedback">Feedback</a>
</p>

## Install

Open Terminal and run:

```sh
curl -fsSL https://raw.githubusercontent.com/idkatanica/just-hide/main/install.sh | bash
```

The installer downloads the latest release, checks its SHA-256 checksum and signature, puts Just Hide in Applications and opens it. It doesn't need `sudo` and doesn't change any system security settings. [Read it first](install.sh) if you like.

Requires macOS 14 or later, on Apple Silicon or Intel.

## What it does

- **One click hides the icons you don't need.** Click the capsule in the menu bar to hide them, and click it again to bring them back in place. A keyboard shortcut works too.
- **You choose what hides.** Settings shows a live copy of your menu bar, with the capsule in it. Drag an icon across the capsule to hide or show it.
- **Hides again on its own** after a delay you pick, but never while you're using a menu.
- **New apps, your call.** Icons of apps you open for the first time can start out hidden, or stay visible. It's off by default.
- **Stays out of the way.** Launches at login if you want, offers six button styles, and comes in light and dark themes, or follows your Mac.

### On macOS 27

macOS 27 changed how the menu bar works, and Just Hide uses macOS's own way of hiding icons there:

- All icons of one app hide together.
- While icons are hidden, macOS also hides Focus and a few of its own extras. They come back when you show icons. Focus itself keeps working.
- Clicking the date and time still opens Notification Center.
- Keep one copy of Just Hide, in Applications. The installer puts it there.

Just Hide has been tested on macOS 27. Earlier versions use the classic approach, an invisible divider. Reports from those versions are welcome.

## Permissions

- **Accessibility** lets Just Hide find your menu bar icons and arrange them. It is needed to choose which icons hide.
- **Screen Recording** is optional. It shows your icons' pictures in Settings; without it, app icons are used. Nothing is recorded or saved.

Everything stays on your Mac. There are no accounts, analytics or network requests.

## Update and remove

To update, run the install command again. It quits Just Hide, replaces it, and keeps your settings and permissions.

To remove Just Hide and its settings:

```sh
curl -fsSL https://raw.githubusercontent.com/idkatanica/just-hide/main/install.sh | bash -s -- --uninstall
```

Just Hide is not notarized by Apple. If macOS ever blocks it, use **System Settings › Privacy & Security › Open Anyway**. See [Apple's guidance](https://support.apple.com/102445).

## Feedback

[Report a bug](https://github.com/idkatanica/just-hide/issues/new?template=bug.yml) or [suggest a feature](https://github.com/idkatanica/just-hide/issues/new?template=feature.yml). Include your macOS version, Mac model and display setup, and remove private information from screenshots.

## License

Just Hide is free to use under the [Just Hide Freeware License](APP-LICENSE.md). The installer and the documents in this repository are under the [MIT License](LICENSE).

This repository holds downloads, installation and feedback; the source is maintained privately. Just Hide is developed independently and is not affiliated with Apple.
