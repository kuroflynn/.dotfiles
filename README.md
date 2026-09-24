# Dotfiles

Configuración personal de un entorno de desarrollo y escritorio Linux. El repositorio contiene una configuración de **Hyprland + Ambxst** y un snapshot de **KDE Plasma / Project Nightjar**. La presencia de un archivo en el repositorio no demuestra que esté enlazado en `$HOME`, que se haya cargado en la sesión actual o que sus dependencias externas estén instaladas.

## Estado y checkpoints

Los checkpoints disponibles son históricos; el checkout actual está en `f1cbe26` (`main`), después de `hyprland-v1.2.0` y sin una etiqueta que lo identifique como versión estable nueva.

- **`hyprland-v0.1.0`**: baseline funcional de Hyprland.
- **`hyprland-v1.0.0`**: checkpoint de Hyprland + Ambxst v1.0.0; no es el estado actual del repositorio.
- **`hyprland-v1.1.0`**: estado estable anterior a probar Caelestia KDE.
- **`hyprland-v1.2.0`**: estado estable de Hyprland y Ambxst 1.2.6.
- **`plasma-v1.0.0`**: baseline de KDE Plasma para Project Nightjar. El subárbol de `plasma/` en `HEAD` coincide con ese tag, pero la copia local de `plasma-org.kde.plasma.desktop-appletsrc` diverge y está marcada con `skip-worktree`; no debe suponerse que Plasma sea el escritorio activo.

## Estructura

El árbol resume los archivos versionados y señala los archivos generados o de copia de respaldo que existen en el checkout local.

```text
.
├── .config/
│   ├── Trolltech.conf
│   ├── fastfetch/config.jsonc
│   ├── ghostty/
│   │   ├── config
│   │   └── themes/
│   │       ├── MoeDark
│   │       └── Otto
│   └── starship.toml
├── ambxst/
│   ├── .config/ambxst/
│   │   ├── binds.json
│   │   ├── config/
│   │   │   ├── bar.json
│   │   │   ├── compositor.json
│   │   │   ├── desktop.json
│   │   │   ├── dock.json
│   │   │   ├── lockscreen.json
│   │   │   ├── notch.json
│   │   │   ├── overview.json
│   │   │   ├── performance.json
│   │   │   ├── system.json
│   │   │   ├── theme.json
│   │   │   ├── weather.json
│   │   │   └── workspaces.json
│   │   ├── presets/active_preset
│   │   └── mods.json                 # generado localmente; ignorado por Git
│   └── .local/
│       ├── bin/
│       │   ├── ambxst -> ambxst-hypr
│       │   └── ambxst-hypr
│       └── share/ambxst/no-ddc/ddcutil
├── ambxst-custom/
│   ├── external-mods.md
│   └── patches/lockscreen-blur.patch
├── bash/
│   ├── .bash_profile
│   ├── .bashrc
│   └── .bashrc.bak_2026-01-04
├── environment.d/
│   ├── cursor.conf
│   └── ghostty.conf
├── hypr/
│   └── .config/hypr/
│       ├── hypridle.conf
│       ├── hyprland.lua
│       ├── hyprland.lua.bak
│       ├── hyprlauncher.conf
│       ├── hyprlock.conf
│       └── scheme/                    # generado localmente; ignorado por Git
├── Kvantum/
│   └── .config/Kvantum/
│       ├── kvantum.kvconfig
│       └── Otto/
│           ├── Otto.kvconfig
│           └── Otto.svg
├── nano/
│   └── .nanorc
├── plasma/
│   └── .config/
│       ├── kdeglobals
│       ├── kglobalshortcutsrc
│       ├── kscreenlockerrc
│       ├── kwinrc
│       ├── plasma-org.kde.plasma.desktop-appletsrc # HEAD/tag; variante local skip-worktree
│       └── plasmarc
├── yazi/
│   └── .config/yazi/
│       ├── flavors/                  # ashen, ayu-dark, synthwave84 y tokyo-night
│       ├── keymap.toml
│       ├── package.toml
│       ├── theme.toml
│       ├── theme.toml.bak             # copia local sin seguimiento
│       └── yazi.toml
├── .gitignore
├── ATAJOS_TECLADO.md
└── README.md
```

`hypr/.config/hypr/scheme/current.conf`, `hypr/.config/hypr/scheme/current.lua` y `ambxst/.config/ambxst/mods.json` están ignorados por `.gitignore`; pueden aparecer en una instalación local, pero no forman parte del contenido versionado. `hyprland.lua.bak`, `.bashrc.bak_2026-01-04` y `theme.toml.bak` son copias históricas y no son archivos de configuración que se carguen automáticamente.

Además, el archivo versionado `plasma/.config/plasma-org.kde.plasma.desktop-appletsrc` de `HEAD`/`plasma-v1.0.0` tiene una variante extensa de 585 líneas, mientras que la copia que está físicamente en el checkout tiene 78 líneas y no incluye los mismos applets. Git la tiene marcada con `skip-worktree`, por lo que `git status` no muestra esa divergencia.

## `hypr/`

### Configuración principal

- **`hyprland.lua`**: configuración principal escrita en Lua. Define `uwsm app -- ghostty` como terminal, `dolphin` como gestor de archivos y `hyprlauncher` como lanzador. También contiene reglas de ventanas, animaciones, separación `dwindle` con `preserve_split`, sombras, blur, bordes y reglas para XWayland.
- **Monitores**: el archivo fija `HDMI-A-1` en `2560x1440@144`, escala `1`, posición `2048x0`, y `eDP-2` en `2560x1600@240`, escala `1.25`, posición `0x0`. Asigna los workspaces 1–5 a `HDMI-A-1` y 6–10 a `eDP-2`. El comentario de la sección llama `Odyssey G5` al monitor principal; no se verificó el hardware más allá de ese comentario.
- **Foco y integración con Ambxst**: la carga de `~/.local/share/ambxst/hyprland.lua` ocurre al final de la configuración y, después de ella, se vuelve a aplicar `follow_mouse = 0`. La intención es evitar que el foco siga al hover del ratón. La llamada `loadfile(...)()` no tiene `pcall` ni fallback: si falta la integración externa, la carga de Hyprland puede fallar. La ruta está fijada a `$HOME/.local/share`, no a `XDG_DATA_HOME`. Los valores de gaps, redondeo y blur aparecen tanto en el archivo local como en la integración de Ambxst; su precedencia efectiva depende del orden de carga y no se debe presentar un único valor como estado vivo sin verificarlo.

Los ocho binds que están activos directamente en `hyprland.lua` son:

- `Super+Q`: Ghostty mediante UWSM.
- `Super+E`: Dolphin.
- `Super+R`: Hyprlauncher.
- `Super+F`: alternar el modo flotante.
- `Super+P`: pseudotiling.
- `Super+J`: alternar la división en `dwindle`.
- `Super+M`: ejecutar `hyprshutdown` si existe; si no, intentar salir de Hyprland. En la máquina auditada no se encontró `hyprshutdown`, por lo que se usaría la ruta de fallback.
- `XF86AudioMicMute`: silenciar o restaurar el micrófono.

En el archivo actual están comentados los binds de `Super+C`, `Super+V`, `Super+L`, los workspaces numéricos, las flechas, el workspace especial, los arrastres con `Super` y la mayoría de las teclas multimedia. Esos comportamientos proceden de la integración de Ambxst que se carga, no de binds activos de este archivo. En particular, el bind local de `Super+V` está comentado y Ambxst lo asocia al portapapeles. También hay un gesto activo de tres dedos horizontal para cambiar de workspace y un ajuste de sensibilidad específico para `epic-mouse-v1`.

### Archivos auxiliares

- **`hypridle.conf`**: bloqueo a los 600 s (10 min), DPMS a los 660 s (11 min) y suspensión a los 1800 s (30 min). También bloquea antes de dormir. El repositorio no contiene una unidad o autostart que lo habilite; su carga efectiva depende de Hyprland/UWSM o de otro mecanismo externo.
- **`hyprlock.conf`**: oculta el cursor, renderiza inmediatamente y usa una captura de pantalla desenfocada (`blur_passes = 3`, `blur_size = 7`).
- **`hyprlauncher.conf`**: añade el prefijo `uwsm app --` al lanzar aplicaciones de escritorio. El lanzador de Ambxst (`Super+Super_L`) es una interfaz distinta de Hyprlauncher.
- Las reglas de permisos para `grim`, el portal de Hyprland y `hyprpm` aparecen comentadas; el repositorio no define una política de permisos activa.
- **`hyprland.lua.bak`**: respaldo histórico de una configuración Lua anterior; contiene binds que ya no están activos en `hyprland.lua` y no se carga junto a este último.
- **`scheme/current.conf` y `scheme/current.lua`**: archivos generados e ignorados; el `hyprland.lua` versionado no contiene una referencia explícita a ellos. La paleta que Ambxst usa en la instalación auditada proviene de `~/.cache/ambxst/colors.json`, que tampoco está versionada.

## `ambxst/`

El paquete contiene la configuración que Ambxst edita y que puede guardarse bajo control de versiones. La configuración principal incluye:

- Barra superior en la parte superior, fijada al inicio y revelable por hover; sin marco, sombra ni borde propios, con `containBar=false` y exclusión de `blueman` en la bandeja.
- Dock y escritorio de Ambxst deshabilitados.
- Overview de 5 columnas por 2 filas y 10 workspaces no dinámicos, con iconos de aplicaciones.
- Tema oscuro, esquinas redondeadas, `Roboto Condensed` e `Iosevka Nerd Font Mono`.
- Preferencias de compositor: bordes, redondeo, gaps, sombras y blur. `syncRoundness` está activo, pero no todos los ajustes de sincronización están habilitados y sus valores no coinciden necesariamente con los de Hyprland.
- `performance.json` habilita transiciones de blur, previews de ventanas, línea ondulada y rotación de cover art; `presets/active_preset` selecciona `Ambxst Default`.
- Lockscreen y notch: lockscreen en la parte inferior; notch superior con `customText = "Ambxst"` y `noMediaDisplay = "userHost"`.
- Energía, OCR en español, portapapeles, pomodoro y otros ajustes de sistema. El pomodoro usa 1500 s de trabajo y 300 s de descanso, con `autoStart=false` y sincronización de Spotify; el portapapeles tiene `tmpfs=false` y el servicio de actualización está habilitado.
- Clima configurado para Lo Espejo (Región Metropolitana, Chile), en grados Celsius.

`config/system.json` define además tiempos de brillo (150 s), bloqueo (300 s), DPMS (330 s) y suspensión (1800 s) propios de Ambxst. Son distintos de los tiempos de `hypridle.conf`; no se verificó qué servicio o componente tiene precedencia en una sesión real. La generación externa auditada inicializa el `IdleService` de Ambxst, por lo que esta segunda pila puede ejecutarse con independencia de `hypridle`.

`binds.json` contiene los binds integrados y una lista `custom`. En el checkout actual hay **99 elementos `custom`, todos habilitados**, incluidos los atajos de dashboard, overview, energía, capturas, grabación, recarga, workspaces, foco, multimedia, brillo, workspace especial y tapa del portátil. `Super+/` ejecuta `ambxst run shortcuts` para abrir la referencia de atajos; `Super+Shift+B` alterna la barra. La tabla ampliada está en [`ATAJOS_TECLADO.md`](ATAJOS_TECLADO.md); ese documento conserva una cifra anterior de 98 elementos y describe algunos binds nativos que el `hyprland.lua` actual tiene comentados, por lo que el número y el estado de `binds.json`/`hyprland.lua` son la referencia directa.

### Diferencias entre el JSON y la integración generada

La integración instalada en `~/.local/share/ambxst/hyprland.lua` es un artefacto externo y no necesariamente una traducción exacta de `binds.json`. En la copia auditada se observaron estas diferencias:

- La acción JSON `system.calculator` está asociada a `Super+equal`, pero el Lua generado ejecuta `notify-send "Soon"`; no debe documentarse como una calculadora efectiva.
- Los binds JSON `Super+Alt+1…0` se llaman `move-window-silent`, pero el Lua generado usa `hl.dsp.window.move`; el comportamiento silencioso no queda demostrado por el artefacto Lua.
- La integración generada contiene 118 binds numerados, un conjunto más amplio que la lista `custom`, y puede incorporar reglas de layout que no están visibles en el JSON.
- La integración generada usa cambios de volumen del 10 %; la referencia del 5 % describe el backup anterior, no la capa activa.

La cadena efectiva es, por tanto, `hyprland.lua` versionado → integración Lua generada → `axctl.toml`/generaciones de mods → fuente externa de Ambxst. No se verificó que todos los binds de `binds.json` se ejecuten de la misma manera. `hyprlock.conf` y el lockscreen de Ambxst son sistemas distintos: el bind generado `system.lock` observado ejecuta `loginctl lock-session`.

### Integraciones externas y extensiones

[`ambxst-custom/external-mods.md`](ambxst-custom/external-mods.md) documenta extensiones de audio y Bluetooth que son dependencias externas y no están vendorizadas en este repositorio. [`lockscreen-blur.patch`](ambxst-custom/patches/lockscreen-blur.patch) es un parche de referencia histórico para el lockscreen; su presencia no demuestra que esté aplicado. El `mods.json` local, ignorado por Git, puede registrar instalaciones generadas por Ambxst; en la instalación auditada aparecían también Bar Glance, el overlay de atajos y lockscreen blur, y sus revisiones pueden no coincidir con las instrucciones de `external-mods.md`. No es una fuente versionada.

### Wrapper local y bloqueo de DDC/CI

El archivo versionado `ambxst/.local/bin/ambxst` es un enlace simbólico a `ambxst-hypr`. El wrapper real es [`ambxst/.local/bin/ambxst-hypr`](ambxst/.local/bin/ambxst-hypr) y hace exactamente esto:

```bash
export PATH="$HOME/.local/share/ambxst/no-ddc:$PATH"
exec /usr/local/bin/ambxst "$@"
```

`ambxst/.local/share/ambxst/no-ddc/ddcutil` es un shim no-op:

```sh
#!/bin/sh
exit 0
```

Al anteponer `no-ddc` al `PATH`, el shim tiene prioridad sobre el `ddcutil` del sistema para los procesos lanzados a través del wrapper. Si Ambxst invoca `ddcutil`, la operación se convierte en un no-op y no se envía DDC/CI al monitor externo. El alcance es local al árbol de procesos iniciado por el wrapper; no sustituye globalmente a `/usr/bin/ddcutil` ni protege invocaciones directas del sistema.

El mecanismo de arranque previsto es el siguiente:

1. `hypr/.config/hypr/hyprland.lua` ejecuta `loadfile("$HOME/.local/share/ambxst/hyprland.lua")()`.
2. La integración instalada de Ambxst registra un callback `hyprland.start` que ejecuta `ambxst`.
3. Si `~/.local/bin` tiene prioridad en el `PATH`, `ambxst` resuelve al enlace local, que apunta a `ambxst-hypr`; el wrapper añade el shim y delega en `/usr/local/bin/ambxst`.

`/usr/local/bin/ambxst` y `~/.local/share/ambxst/hyprland.lua` son dependencias externas y no están versionadas aquí. La integración instalada puede ser generada y no necesariamente coincide bind por bind con `ambxst/.config/ambxst/binds.json`. El `hyprland.lua` del repositorio no contiene un `exec-once` propio y no se encontró una entrada de autostart de Ambxst en el repositorio. El `~/.local/share/ambxst/hyprland.conf` externo que acompaña a la integración también contiene `exec-once = ambxst`, pero el archivo Lua versionado no lo incluye. Además, durante la auditoría no se pudo confirmar que el proceso Ambxst de la sesión observada se hubiera iniciado mediante el wrapper; solo se pudo verificar el mecanismo de resolución descrito en los archivos.

## `plasma/` — Project Nightjar

Este directorio conserva el baseline `plasma-v1.0.0`, no una garantía del escritorio actual:

- **`.config/kdeglobals`**: `ColorScheme=MoeDark`, look and feel `Moe-Dark`, tema de iconos `Slot-Symbolic-Dark-Icons`, Ghostty como terminal, fuentes y preferencias generales de KDE.
- **`.config/plasma-org.kde.plasma.desktop-appletsrc`**: en `HEAD` y `plasma-v1.0.0` es el applet/panel de Project Nightjar y contiene referencias a CatWalk, Panel Colorizer, `adhe.launchpadPlasma` (Launchpad Plasma), `plasmusic-toolbar` (PlasMusic Toolbar), Kurve, bandeja, reloj, notificaciones y otros widgets, además de fondos de imagen y video. La copia local del repositorio de 78 líneas es una variante distinta sin esos applets; no debe confundirse con el archivo del tag ni con el archivo activo de `$HOME`.
- **`.config/kwinrc`**: efectos de KWin, plugin de KZones, layouts de mosaico, separación de 4 px, mosaico horizontal 25/50/25, decoración Aurorae y escala XWayland 1.25.
- **`.config/kglobalshortcutsrc`**: atajos de Plasma/KWin y el lanzador de servicio `Alt+W` para Skwd. Las acciones directas de KZones aparecen como `none,none`.
- **`.config/kscreenlockerrc`**: `Autolock=false` y `Timeout=0`; además guarda una ruta absoluta a un fondo Materia Dark.
- **`.config/plasmarc`**: lista local de fondos de usuario con rutas absolutas.

`kglobalshortcutsrc` contiene una entrada `Launchpad Plasma` con atajo `none,none`, pero eso no equivale a que el widget esté instalado o visible. Las rutas de fondos, Caelestia y los plugins de video son externas al repositorio; algunas rutas absolutas configuradas no existían en la máquina auditada. En la máquina auditada, solo `~/.config/kscreenlockerrc` era un enlace al archivo de este repositorio; `kdeglobals`, `kglobalshortcutsrc`, `kwinrc`, `plasmarc` y `plasma-org.kde.plasma.desktop-appletsrc` eran archivos regulares, y algunos no coincidían con el contenido de `HEAD`. Por ejemplo, `~/.config/plasma-org.kde.plasma.desktop-appletsrc` tiene 585 líneas y contiene Launchpad/PlasMusic, mientras que la variante del repositorio marcada con `skip-worktree` tiene 78 líneas. También `~/.config/kdeglobals` usa `Theme=pixora-dark` en lugar del tema de iconos del repositorio, y `~/.config/kwinrc` tiene ajustes adicionales y no la misma línea de Aurorae. Ninguno de esos archivos debe describirse como configuración Plasma activa solo por su presencia.

## Configuración de sesión y herramientas

### `environment.d/`

- **`cursor.conf`**: `XCURSOR_THEME=Bibata-Modern-Ice` y `XCURSOR_SIZE=24`.
- **`ghostty.conf`**: `GTK_IM_MODULE=simple`.

Estos archivos están pensados para enlazarse dentro de `~/.config/environment.d/`; que el cargador de la sesión los lea depende del entorno y no se verificó aquí. En `$HOME` también existe un `qt.conf` local que no pertenece a este repositorio.

### `bash/`

- **`.bash_profile`**: carga `~/.bashrc` y define `QSG_RHI_BACKEND=opengl`.
- **`.bashrc`**: carga el prompt de Starship, autocompletado, la función `cfetch` de Fastfetch, el wrapper `y()` para Yazi, NVM, aliases de Exa y mantenimiento de Arch (incluido `pacrefresh`), navegación, la función `comfy`, `~/.local/bin/env` y el `PATH` de Bun. Devuelve el flujo temprano para shells no interactivas.
- **`.bashrc.bak_2026-01-04`**: respaldo histórico; no es el archivo que carga `.bash_profile`. Al usar Stow, puede aparecer como `~/.bashrc.bak_2026-01-04`, pero no se carga.

No hay un alias o función `tdl` en los archivos Bash versionados. La referencia actual del shell es `comfy`, no `tdl`.

### `.config/ghostty/`

- **`config`**: ventana de 115×30, centering, opacidad 0.5, tema `MoeDark`, portapapeles y atajos para crear/mover splits y cerrar una superficie.
- **`themes/MoeDark`**: tema usado por `config`.
- **`themes/Otto`**: tema alternativo incluido en el repositorio.

En la instalación auditada, `~/.config/ghostty/` es un directorio real: solo `config` y `themes` son enlaces al repositorio. `skwd-theme` es un archivo local no versionado.

### `.config/fastfetch/`

`config.jsonc` define el título, módulos de sistema, separadores y una búsqueda de logo. En la instalación auditada solo `config.jsonc` está enlazado al repositorio; `media/` contiene logos locales y `config-old.jsonc` es un archivo local.

Hay una discrepancia detectable: `config.jsonc` busca png en `~/.config/fastfetch/png/`, pero en el sistema de archivos auditado no existe `png/`; los logos están en `media/`. La función `cfetch` de `.bashrc` sí busca explícitamente `media/`. Por ello, el logo predeterminado de Fastfetch no se considera verificado.

### `.config/starship.toml`

Prompt de Starship con información del sistema, usuario, directorio, Git, lenguajes, Conda, hora y duración de comandos. El archivo está enlazado como archivo individual. Durante la auditoría tenía un cambio local no confirmado en la paleta; no se trata como parte de un checkpoint estable.

### `.config/Trolltech.conf`

Paleta de Qt/KDE para aplicaciones heredadas: colores de ventanas, controles y texto, además de la fuente. En la instalación auditada está enlazado como archivo individual.

### `Kvantum/`

- **`kvantum.kvconfig`**: selecciona `MoeDark` como tema.
- **`Otto/Otto.kvconfig` y `Otto/Otto.svg`**: tema Otto incluido como alternativa; `kvantum.kvconfig` no lo selecciona.

En `$HOME` se enlazan individualmente `kvantum.kvconfig` y el directorio `Otto`; el resto de temas locales de Kvantum no pertenece a este repositorio.

### `nano/`

`.nanorc` activa `noconvert`, `rawsequences`, `rebinddelete` y `unix`, e incluye `/usr/share/nano/*.nanorc`. Las numerosas opciones de ejemplo y keybindings que aparecen comentadas no son configuración activa.

### `yazi/`

- **`yazi.toml`**: gestión, previews, openers, reglas MIME, tareas y plugins de Yazi. Los comandos citados (`nano`, `code`, `glow`, `bat`, `magick`, etc.) son dependencias externas. El valor `image_alloc = 536870512` no coincide exactamente con el comentario `512MB` (536870912).
- **`keymap.toml`**: `Shift+Enter` abre el menú interactivo `Open with...`.
- **`theme.toml`**: usa el flavor oscuro `synthwave84` y añade iconos para directorios frecuentes.
- **`package.toml`**: declara dependencias de flavors para `tokyo-night`, `ashen` y `synthwave84`.
- **`flavors/`**: contiene `ashen`, `ayu-dark`, `synthwave84` y `tokyo-night`; `ayu-dark` está incluido en el árbol aunque no aparece en las dependencias declaradas por `package.toml`.
- **`theme.toml.bak`**: copia local sin seguimiento; `theme.toml` es el archivo que se enlaza y se considera la configuración versionada. Al enlazar todo `~/.config/yazi`, el backup también queda visible en ese directorio, pero no debe usarse como configuración activa.

## Gestión de enlaces e instalación

No existe un `install.sh` ni otro instalador automático en el árbol actual. La disposición de los directorios es compatible con GNU Stow, pero la instalación observada mezcla enlaces que Stow puede reconocer con enlaces creados manualmente. No todos los archivos están gestionados por Stow.

### Estado observado de los enlaces

| Origen en el repositorio | Destino habitual | Tipo/mecanismo observado |
| --- | --- | --- |
| `hypr/.config/hypr/` | `~/.config/hypr` | Enlace de directorio |
| `ambxst/.config/ambxst/` | `~/.config/ambxst` | Enlace de directorio |
| `ambxst/.local/bin/ambxst` y `ambxst-hypr` | `~/.local/bin/ambxst` y `~/.local/bin/ambxst-hypr` | Enlaces a archivos; el primero apunta al wrapper |
| `ambxst/.local/share/ambxst/no-ddc/ddcutil` | `~/.local/share/ambxst/no-ddc/ddcutil` | Enlace al shim |
| `yazi/.config/yazi/` | `~/.config/yazi` | Enlace de directorio |
| `Kvantum/.config/Kvantum/kvantum.kvconfig` y `Otto/` | `~/.config/Kvantum/kvantum.kvconfig` y `Otto/` | Enlaces individuales |
| `.config/ghostty/config` y `themes/` | `~/.config/ghostty/config` y `themes/` | Entradas específicas enlazadas; el directorio madre es local |
| `.config/fastfetch/config.jsonc` | `~/.config/fastfetch/config.jsonc` | Enlace de archivo; `media/` permanece local |
| `.config/starship.toml` | `~/.config/starship.toml` | Enlace de archivo |
| `.config/Trolltech.conf` | `~/.config/Trolltech.conf` | Enlace de archivo |
| `environment.d/*.conf` | `~/.config/environment.d/*.conf` | Enlaces de archivo |
| `bash/.bash_profile`, `bash/.bashrc` y `nano/.nanorc` | `~/.bash_profile`, `~/.bashrc` y `~/.nanorc` | Enlaces de archivo |
| `plasma/.config/kscreenlockerrc` | `~/.config/kscreenlockerrc` | Único archivo de Plasma enlazado en la máquina auditada |

Esta tabla describe una observación local, no una garantía para otra máquina. En el estado auditado, `stow --simulate` encuentra conflictos para `hypr`, `ambxst`, `bash`, `nano` y `plasma`; no se debe ejecutar Stow a ciegas sobre esos destinos. Además, una clonación limpia no contiene `scheme/current.*`, `mods.json` ni `theme.toml.bak`, que sí existen en este checkout local.

### Stow en un destino limpio

Para una instalación nueva, primero hay que comprobar los conflictos:

```bash
cd ~/.dotfiles
stow --simulate hypr ambxst yazi bash nano Kvantum plasma
```

Si el destino no contiene archivos o enlaces incompatibles, los paquetes pueden enlazarse por separado, por ejemplo:

```bash
stow hypr ambxst yazi
stow bash nano
```

`plasma` requiere especial cuidado: en la instalación auditada cinco de sus archivos ya existen como archivos regulares. Retirarlos, adoptarlos o reemplazarlos es una decisión local; no se debe asumir que `stow plasma` conserva el escritorio actual. Del mismo modo, no se debe enlazar todo `~/.config/ghostty` ni todo `~/.config/fastfetch`, porque se podrían ocultar o reemplazar archivos locales como `skwd-theme`, `media/` y `config-old.jsonc`.

### Enlaces manuales

Si se prefiere hacerlo archivo por archivo, los enlaces deben crearse solamente cuando el destino no exista. Un ejemplo mínimo para los directorios completos es:

```bash
mkdir -p ~/.config ~/.local/bin ~/.local/share/ambxst/no-ddc
ln -s ~/.dotfiles/hypr/.config/hypr ~/.config/hypr
ln -s ~/.dotfiles/ambxst/.config/ambxst ~/.config/ambxst
ln -s ~/.dotfiles/yazi/.config/yazi ~/.config/yazi
ln -s ~/.dotfiles/ambxst/.local/bin/ambxst ~/.local/bin/ambxst
ln -s ~/.dotfiles/ambxst/.local/bin/ambxst-hypr ~/.local/bin/ambxst-hypr
ln -s ~/.dotfiles/ambxst/.local/share/ambxst/no-ddc/ddcutil ~/.local/share/ambxst/no-ddc/ddcutil
```

Para las entradas específicas de herramientas se usan enlaces de archivo (o de subdirectorio), no enlaces de los directorios completos:

```bash
mkdir -p ~/.config/environment.d ~/.config/ghostty ~/.config/fastfetch ~/.config/Kvantum
ln -s ~/.dotfiles/environment.d/cursor.conf ~/.config/environment.d/cursor.conf
ln -s ~/.dotfiles/environment.d/ghostty.conf ~/.config/environment.d/ghostty.conf
ln -s ~/.dotfiles/.config/ghostty/config ~/.config/ghostty/config
ln -s ~/.dotfiles/.config/ghostty/themes ~/.config/ghostty/themes
ln -s ~/.dotfiles/.config/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
ln -s ~/.dotfiles/.config/starship.toml ~/.config/starship.toml
ln -s ~/.dotfiles/.config/Trolltech.conf ~/.config/Trolltech.conf
ln -s ~/.dotfiles/Kvantum/.config/Kvantum/kvantum.kvconfig ~/.config/Kvantum/kvantum.kvconfig
ln -s ~/.dotfiles/Kvantum/.config/Kvantum/Otto ~/.config/Kvantum/Otto
ln -s ~/.dotfiles/bash/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/bash/.bashrc ~/.bashrc
ln -s ~/.dotfiles/nano/.nanorc ~/.nanorc
```

Antes de crear cualquier enlace hay que respaldar o retirar manualmente los archivos que ocupen el destino. Los comandos anteriores son ejemplos de estructura, no una garantía de que una configuración esté activa; después de enlazarlos puede ser necesario reiniciar la sesión o la aplicación correspondiente.

## Notas de alcance

- Los archivos de `plasma/`, los backups y los archivos generados se conservan como parte de la historia y del estado local, pero no se debe inferir su uso solo por estar presentes.
- `/usr/local/bin/ambxst`, la integración de `~/.local/share/ambxst`, las fuentes, los comandos de las aplicaciones, los fondos y los plugins de Plasma/Ambxst son dependencias externas.
- La configuración de monitores, las rutas de fondos y la referencia al monitor externo son específicas de la máquina del autor.
- `ATAJOS_TECLADO.md` es una referencia auxiliar y conserva una cifra anterior de binds; para el estado actual de Ambxst, `binds.json` es la fuente versionada.
- En el checkout auditado también había cambios locales no confirmados en `.config/starship.toml` y `bash/.bash_profile`, además de `yazi/theme.toml.bak` sin seguimiento; no forman parte de `f1cbe26`. El applet de Plasma del repositorio también está marcado con `skip-worktree` y difiere de `HEAD`.
- Fuera del repositorio existen `~/.config/kwinoutputconfig.json`, `~/.config/kwinrulesrc` y un perfil de Konsave/Caelestia que pueden afectar al escritorio Plasma; ninguno representa el snapshot de `plasma/`.
- No se ejecutaron pruebas de arranque ni se verificaron sesión activa, disponibilidad de programas, fuentes, plugins, permisos o hardware. La auditoría se limita a los archivos del repositorio y a los enlaces observados.

## Licencia

Estos dotfiles son de uso personal. Siéntete libre de adaptarlos a tus necesidades.
