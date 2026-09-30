# LACASITA V12XB — Bypass Edition

Panel de administración VPS **sin verificación de key**. Versión completamente independiente, todos los archivos alojados en este repo.

violado por t.me/DarkZFull

---

## Instalación

```bash
apt update -y; wget -q https://raw.githubusercontent.com/DarkFull0726/LACASITA-bypass/main/install.sh -O install.sh; chmod +x install.sh; ./install.sh
```

> Requiere Ubuntu 20.04 / 22.04 como root.

---

## Características

- ✅ Sin key requerida — instala sin verificación
- ✅ Todos los archivos en este repo (sin dependencias externas)
- ✅ Panel completo Version 12XB
- ✅ Crear/gestionar usuarios SSH, HWID, TOKEN
- ✅ Protocolos: SQUID, OpenVPN, SlowDNS, WireGuard, V2RAY, Dropbear
- ✅ Herramientas: Firewall, Fail2Ban, TCP BBR, DNS Netflix, Monitor

---

## Uso

Después de instalar, ejecuta:

```bash
menu
```

---

## Estructura del repo

```
install.sh          — Instalador principal (sin key)
files/              — Panel menu y scripts de protocolos
util/               — Utilidades (trans, SPR, monitor, sshd_config...)
tmp/                — Scripts auxiliares (verifi, autodes, chekuser...)
controlador/        — Archivos de control de usuarios
```

---

## Notas

- El instalador reinicia el VPS automáticamente al finalizar
- Comando para entrar al menú: `menu` o `VPSMX`
- Los kill switch directories se crean automáticamente durante la instalación
