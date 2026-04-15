
# 🚀 Minimal Sway Desktop for openSUSE Tumbleweed

minimal, and fully automated Wayland/Sway desktop environment built for a fresh **openSUSE Tumbleweed** (Server/Minimal) installation.

No Display Manager required — log in via TTY and type `sway`.

> **One-line install:**

> bash -c "$(curl -fsSL https://raw.githubusercontent.com/naba-r/mydotfiles/main/install.sh)"


---

## ✨ Features

- **Fully Automated Install:** `install.sh` handles package installation (`zypper`), user groups (`libvirt`, `input`), service activation, and config symlinking.
- **Smart Hardware & VM Detection:** Display script auto-detects QEMU/KVM vs. bare metal and adjusts to the maximum native resolution.
- **Aggressive Power-Saving Lock:** `swayidle` stays disabled during active use; automatically activates on lock via `gtklock`.
- **Polkit & Keyring Integration:**  `gnome-keyring` bridge — run root-level GUI apps (Nautilus, Chromium) without constant password prompts.
- **Bilingual Keybindings:** Uses `--to-code` throughout so all shortcuts work in both English (`us`) and Arabic (`ara`) layouts.
- **Modern Wayland Stack:** `waybar`, `fuzzel`, `swaync`, `clipman`, PipeWire (`wpctl`).

---

## 📦 Prerequisites

1. Fresh **openSUSE Tumbleweed** install (Server/Minimal pattern recommended).
2. Log in to the TTY as your **normal user** — do NOT run as root.
3. Active internet connection.

---

## 🛠️ Installation

### Option A — One-liner (recommended)


bash -c "$(curl -fsSL https://raw.githubusercontent.com/naba-r/mydotfiles/main/install.sh)"


### Option B — Clone and run manually


git clone https://github.com/naba-r/mydotfiles.git ~/mydotfiles

cd ~/mydotfiles

chmod +x install.sh

./install.sh


The script will prompt for your `sudo` password to install packages and enable systemd services.

### After install — reboot

Some changes (e.g. `libvirt` group membership) only apply after re-login:


reboot


---

## 💻 Starting Sway

Log in at the TTY, then start Sway under a DBus session for correct portal/keyring behavior:


exec dbus-run-session -- sway


Or simply type `sway` if your shell profile already wraps it.

---

## ⌨️ Keybindings

### 🖥️ System & Core
| Action | Shortcut |
|---|---|
| Terminal (Kitty) | `Super + Enter` |
| App Launcher (Fuzzel) | `Super + D` |
| Window Switcher | `Alt + Tab` |
| Close Window | `Super + Q` |
| Reload Sway Config | `Super + Shift + C` |
| Lock Screen | `Ctrl + Alt + L` |
| Switch Layout (EN/AR) | `Super + Space` |

### 🚀 Applications
| Action | Shortcut |
|---|---|
| File Manager (Nautilus) | `Super + E` |
| Web Browser (Firefox) | `Super + F` |
| Text Editor (GNOME) | `Super + T` |
| Code/Text Editor (Geany) | `Super + G` |
| RSS Reader (NewsFlash) | `Super + R` |

### 🪟 Window & Workspace Management
| Action | Shortcut |
|---|---|
| Focus Window (Left/Down/Up/Right) | `Super + H / J / K / L` |
| Move Window (Left/Down/Up/Right) | `Super + Shift + H / J / K / L` |
| Focus Next Monitor | `Super + O` |
| Toggle Tabbed/Split Layout | `Super + Shift + F` |
| Switch Workspace | `Super + Numpad 1 / 2 / 3` |
| Move Window to Workspace | `Super + Shift + Numpad End / Down / Next` |

### 🛠️ Utilities & Media
| Action | Shortcut |
|---|---|
| Clipboard History (Clipman) | `Super + V` |
| Screenshot → Clipboard | `Print` |
| Screenshot → Save to File | `Ctrl + Print` |
| Volume Up / Down | `Media Keys` OR `Super + Up / Down` |
| Mute Audio | `Audio Mute Key` OR `Super + M` |
| Mute Microphone | `Mic Mute Key` |
| Restart Waybar | `Super + Shift + W` |
| Toggle Waybar Visibility | `Super + Shift + R` |

---

## 📁 Repository Layout

```
mydotfiles/
├── install.sh              # Master setup script
├── packages/
│   └── packages.txt        # zypper package list
├── config/
│   ├── sway/               # Sway config + automation scripts
│   └── waybar/             # Status bar config & style
├── fonts/                  # Nerd Fonts → ~/.local/share/fonts
├── wallpaper/              # Wallpapers → ~/Pictures/wallpapers
└── Themes/                 # GTK themes + icons/cursors → ~/.themes / ~/.icons
```

---

## 🔧 Sway Session Helpers

Started automatically from the Sway config:

- `gnome-policykit-agent` — Polkit auth dialogs
- `waybar` — status bar
- `swaync` — notification daemon
- Output auto-config script (VM/bare metal detection)
- Clipboard watcher script

Optional keyring bridge (if enabled):


~/.config/sway/scripts/start-keyring.sh


---

## ⚠️ Safety & Expectations

The config sync step runs:

```bash
rsync -a --delete config/ ~/.config/
```

This **will remove** any `~/.config/` content not present in this repo. Safe for fresh installs; use caution on existing systems.

All scripts under `~/.config/sway/scripts/*.sh` are made executable automatically by the installer.

---

## 📰 NewsFlash Configuration

NewsFlash is installed as a native openSUSE Tumbleweed package and launched with a custom XDG
config path to keep its settings isolated from other GTK4 apps:

- `~/.config/news-flash/` — backend config, feed settings, keybindings
- `~/.config/newsflash-gtk4/` — GTK appearance overrides

### Font
Dubai font is set as the system sans-serif via fontconfig (`~/.config/fontconfig/fonts.conf`),
and NewsFlash is configured to use sans-serif. This makes Dubai apply automatically to all
article text without hardcoding it per-app.

### Theme & Styling
`~/.config/newsflash-gtk4/gtk.css` handles:
- Dark theme via Adwaita dark stylesheet
- Invisible toolbar icon fix (common issue on non-GNOME desktops)
- Dubai font applied to the article view (NewsFlash 5 uses a native GTK widget instead of WebKit)

### Sway Keybinding
NewsFlash is launched via `Super + R` with a custom XDG config path:
bindsym --to-code mod+rexecenvXDGCONFIGHOME=mod+r exec env XDG_CONFIG_HOME=
mod+rexecenvXDGC​ONFIGH​OME=HOME/.config/newsflash-gtk4 GSETTINGS_SCHEMA_DIR=/usr/share/glib-2.0/schemas io.gitlab.news_flash.NewsFlash


---

## 🗒️ Notes

- This repo is opinionated and tuned for *my* workflow.  keyboad layout in English US and Arabic
- Tested exclusively on openSUSE Tumbleweed (rolling). Not tested on Leap or other distros.


# 🚀 بيئة Sway  لـ openSUSE Tumbleweed

هذا إعدادٌ شخصيٌّ مُبسَّطٌ ومُؤتمَتٌ بالكامل، صُمِّم ليُناسب تثبيتًا حديثا من **openSUSE Tumbleweed** — خاصةً نسختي الخادم أو الاساسية (Server/Minimal). لا يحتاج إلى مدير عرض، ولا إلى واجهة رسومية معقدة. دخولك عبر الطرفية (TTY) ثم كتابة `sway` يكفي لتشغيل كل شيء كما يجب.

> **تثبيت فوري بسطر واحد:**

> ```bash
> bash -c "$(curl -fsSL https://raw.githubusercontent.com/naba-r/mydotfiles/main/install.sh)"
> ```

---
<div dir="rtl">
## ✨ ما الذي يميّز هذا الإعداد؟

 **تثبيت ذاتي كامل**: السكربت `install.sh` تكفّل بكل شيء — من تثبيت الحزم (`zypper`)، إلى إضافة المستخدم للمجموعات المناسبة (`libvirt`, `input`)، وتفعيل الخدمات، وربط ملفات الإعداد في أماكنها الصحيحة.

 ** التعامل مع العتاد**: يكتشف تلقائيًا إن كنت تعمل داخل آلة افتراضية (QEMU/KVM) أم على جهاز حقيقي، ويضبط دقة الشاشة وفقًا لذلك دون تدخلك.

- **قفل شاشة **: يتم تعطيل ميزة الخمول `swayidle` أثناء استخدامك للجهاز، لكنه ينشط فور قفل الشاشة عبر `gtklock` — لتوفير الطاقة.

 **تكامل سلس مع المصادقات  Polkit و Keyring**: بفضل `gnome-keyring`، لن تُطلب منك كلمة المرور مرارًا عند تشغيل تطبيقات تحتاج صلاحيات روت مثل Nautilus أو Chromium.

- **اختصارات ثنائية اللغة**: جميع الاختصارات تعمل سواء كنت تستخدم لوحة مفاتيح إنجليزية (`us`) أو عربية (`ara`) — لأنها مبنية على الرمز (`--to-code`) وليس الحرف.

- **حزمة Wayland حديثة ومتناسقة**: تتضمن `waybar`، `fuzzel`، `swaync`، `clipman`، و PipeWire.
</div>
---

## 📦 قبل أن تبدأ

1. نظام حديث التثبيت من **openSUSE Tumbleweed** (نمط Server أو Minimal).
2. تسجيل الدخول كمستخدم عادي — **ليس root**.
3. اتصال  بالإنترنت.

---

## 🛠️ طريقة التثبيت

### الطريقة السريعة و المباشرة

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/naba-r/mydotfiles/main/install.sh)"
```

### الطريقة اليدوية (إذا أردت التحكم الكامل)

```bash
git clone https://github.com/naba-r/mydotfiles.git ~/mydotfiles
cd ~/mydotfiles
chmod +x install.sh
./install.sh
```

سيُطلب منك كلمة مرور `sudo` لإكمال التثبيت.

### بعد التثبيت — أعد التشغيل

بعض التغييرات — مثل إضافة المستخدم لمجموعات النظام `libvirt` — لا تُفعّل إلا بعد إعادة تسجيل الدخول:

```bash
reboot
```

---

## 💻 كيف تشغّل البيئة؟

بعد تسجيل الدخول من الطرفية، اكتب:

```bash
exec dbus-run-session -- sway
```

أو ببساطة (و الافضل):

```bash
sway
```



---

## ⌨️ مفاتيح الاختصار

### النظام والواجهة
- فتح الطرفية: `Super + Enter`
- مشغّل التطبيقات: `Super + D`
- التنقل بين النوافذ: `Alt + Tab`
- إغلاق النافذة: `Super + Q`
- إعادة تحميل الإعدادات: `Super + Shift + C`
- قفل الشاشة: `Ctrl + Alt + L`
- تبديل اللغة (عربي/إنجليزي): `Super + Space`

### تشغيل التطبيقات
- مدير الملفات: `Super + E`
- المتصفّح: `Super + F`
- محرر النصوص: `Super + T`
- محرر الأكواد "برنامج جيني": `Super + G`
- قارئ الأخبار (NewsFlash): `Super + R`

### إدارة النوافذ ومساحات العمل
- التركيز على نافذة (يسار/أسفل/أعلى/يمين): `Super + H / J / K / L`
- نقل النافذة: `Super + Shift + H / J / K / L`
- الانتقال إلى الشاشة التالية: `Super + O`
- تبديل نمط العرض: `Super + Shift + F`
- التنقل بين مساحات العمل: `Super + Numpad 1 / 2 / 3`

### الوسائط والأدوات
- سجل الحافظة: `Super + V`
- لقطة شاشة (نسخ): `Print`
- لقطة شاشة (حفظ): `Ctrl + Print`
- رفع/خفض الصوت: مفاتيح الوسائط أو `Super + Up / Down`
- كتم الصوت: `Super + M`
- إظهار/إخفاء شريط الحالة: `Super + Shift + R`

---

## 📁 هيكلة الملفات

```
mydotfiles/
├── install.sh              ← السكربت الرئيسي للتثبيت
├── packages/packages.txt   ← قائمة الحزم
├── config/sway/            ← إعدادات Sway والسكربتات الملحقة
├── config/waybar/          ← إعدادات شريط الحالة
├── fonts/                  ← خطوط 
├── wallpaper/              ← الخلفيات
└── Themes/                 ← ثيمات GTK وأيقونات
```

---

## 🔧 ما بعمل تلقائيًا مع Sway

- لإدارة صلاحيات التطبيقات: `gnome-policykit-agent`
- شريط الحالة العلوي: `waybar`
- نظام الإشعارات: `swaync`
- سكربت ضبط الشاشة (آلة افتراضية أم حقيقية)
- مراقب الحافظة

---

## ⚠️ تنبيه مهم

خلال التثبيت، تتم مزامنة الإعدادات عبر الأمر:

```bash
rsync -a --delete config/ ~/.config/
```

هذا يعني أن أي ملفات إعداد سابقة داخل المسار `~/.config/` سيتم حذفها واستبدالها بملفات هذا المستودع. الإجراء آمن تمامًا على الأنظمة الجديدة، لكن يُنصح بالحذر على الأنظمة المستخدمة مسبقًا.

---

## 📰 إعدادات NewsFlash

تم ضبط التطبيق ليعمل بإعدادات معزولة لضمان عدم تداخلها مع بقية تطبيقات GTK4، مع اعتماد خط "Dubai" بشكل افتراضي لعرض النصوص العربية بشكل صحيح.

---

## 🗒️ ملاحظات أخيرة

- هذه الإعدادات تعكس أسلوب استخدام شخصي، ومضبوطة لتخطيط لوحة مفاتيح إنجليزي/عربي.
- تم اختبارها فقط على **openSUSE Tumbleweed** ، وقد لا تعمل كما يجب على Leap أو غيره.


