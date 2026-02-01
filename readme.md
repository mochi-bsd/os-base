# Mochi OS

A custom Unix-like operating system designed with a modern, modular root filesystem (RootFS) architecture. This project prioritizes a strict separation between the **immutable system core**, **dynamic libraries**, and **sandboxed applications**.

## 🏗 System Architecture

The RootFS is organized to provide a clear distinction between system-level binaries and user-space resources.

### Key Design Principles:

* **Symlinked Core:** High-level directories like `/bin` and `/etc` are symlinked to `/system`, keeping the root directory clean and the core system easily upgradable.
* **App Bundles:** Applications are self-contained in `/apps/[AppName].app`, containing their own manifests and executables.
* **Media-Centric Libraries:** A specialized `/library` path for creative assets, including native support for audio (VST/CLAP), photo, and video plugins.
* **ELF Runtime:** Uses a custom runtime linker path located in `/system/runtime/elf`.

---

## 📁 Directory Structure

### Root Level

| Path | Description |
| --- | --- |
| `/apps` | User applications stored in bundle formats. |
| `/bin` | Symlink to `system/sysbin/` for standard command execution. |
| `/boot` | Symlink to `system/boot` for kernel and bootloader configs. |
| `/dev` | Device nodes (e.g., `nda0` NVMe storage). |
| `/library` | Shared resources, frameworks, and creative plugins. |
| `/system` | The immutable core of the operating system. |
| `/users` | Home directories (Primary: `sysadmin`). |
| `/volumes` | Mount points for external and system drives. |

---

### Deep Dive: The `/system` Directory

The heart of the OS, containing the kernel, system configurations, and the primary command suite.

* **`system/sysbin`**: Contains core utilities (`sh`, `ls`, `ps`, `init`, etc.).
* **`system/runtime`**: Houses the dynamic ELF linkers (`ld-elf.ext`).
* **`system/etc`**: System-wide configuration files like `fstab` and `passwd`.

### Deep Dive: The `/library` Directory

Designed for extensibility and creative workflows.

* **`core/`**: Essential system libraries (`libc.ext`, `libsys.ext`).
* **`media/`**: A structured plugin architecture:
* **Audio**: Native, VST, VST3, and CLAP support.
* **Photo**: Image processors and RAW editors.
* **Video**: Glow effects and LUTs.


* **`shared/`**: System assets like fonts and audio assets.

---

## 🚀 Getting Started

### Bootstrapping

The system initializes via `/system/sysbin/init`, which reads the configuration from `/system/boot/coreservices/loader.conf`.

### Drive Mapping

By default, the system drive is mounted from `/dev/nda0p2` to `/volumes/disk1p1`.

```bash
# Example: Checking system version
uname -a

# Navigating to the system core
cd /system/sysbin

```

## 🛠 Development

To add new system utilities, place them in `src/sysbin` and ensure they link against the libraries found in `/library/core`.

---