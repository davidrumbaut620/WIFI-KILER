# 🚨 WiFi Killer - ARP Spoofing Ético Kali Linux

[![GitHub stars](https://img.shields.io/github/stars/davidrumbaut620/WIFI-KILER?style=social)](https://github.com/davidrumbaut620/WIFI-KILER)
[![GitHub forks](https://img.shields.io/github/forks/davidrumbaut620/WIFI-KILER?style=social)](https://github.com/davidrumbaut620/WIFI-KILER)
[![GitHub issues](https://img.shields.io/github/issues/davidrumbaut620/WIFI-KILER)](https://github.com/davidrumbaut620/WIFI-KILER/issues)

**Script automatizado de ARP Spoofing para Kali Linux** que detecta dispositivos en tu red, los lista con IP/MAC/hostname y corta el acceso a internet de forma ética.  
Ideal para **pentesting**, **redes de prueba** y **expulsar intrusos**.

> ⚠️ **SOLO PARA USO ÉTICO** – Entornos controlados, laboratorios y pruebas autorizadas.

---

## ✨ Características

| Funcionalidad | Automatización |
|---------------|----------------|
| 🔍 Escaneo automático con `arp-scan` | 📡 Detección AUTO/MANUAL de interfaces |
| 📱 Lista IP / MAC / hostname | 🔧 Instalación automática de dependencias |
| 🎯 Cálculo automático de gateway | 🎨 Interfaz con colores y banner |
| ⌨️ Menús interactivos | 🛑 Cleanup automático con CTRL+C |

---

## 🚀 Ejecución Rápida (One-Liners)

### 1️⃣ One-Click Total
```bash
curl -sL https://raw.githubusercontent.com/davidrumbaut620/WIFI-KILER/refs/heads/main/wifi_kiler.sh | bash -s -- --auto-run
```

### 2️⃣ Ejecución Directa (sin guardar archivo)
```bash
curl -sL https://raw.githubusercontent.com/davidrumbaut620/WIFI-KILER/refs/heads/main/wifi_kiler.sh | bash
```

### 3️⃣ Descarga + Ejecutar (recomendado)
```bash
curl -sL https://raw.githubusercontent.com/davidrumbaut620/WIFI-KILER/refs/heads/main/wifi_kiler.sh -o wifi_kiler.sh \
&& chmod +x wifi_kiler.sh \
&& ./wifi_kiler.sh
```

### 4️⃣ Con wget
```bash
wget -q https://raw.githubusercontent.com/davidrumbaut620/WIFI-KILER/refs/heads/main/wifi_kiler.sh \
&& chmod +x wifi_kiler.sh \
&& ./wifi_kiler.sh
```

### 5️⃣ Clonar repositorio completo
```bash
git clone https://github.com/davidrumbaut620/WIFI-KILER.git
cd WIFI-KILER
chmod +x wifi_kiler.sh
./wifi_kiler.sh
```

---

## 📱 Demo del Script

```text
    __        _  __ 
 __ _ / | ___ | |/ |
/ ` | | / _ \| | |
| (_| | || __/| | |
 \__,_|_||___||_|_|

      WIFI KILLER
     (ARP SPOOFING)
```

---

## 🎯 Cómo Funciona

1. 🔍 Escanea la red (`arp-scan --localnet`)
2. 📋 Lista dispositivos IP / MAC / Vendor
3. 🎯 Selección por número
4. ⚡ Calcula gateway automáticamente
5. 🚀 Ejecuta ARP spoofing
6. 📴 El objetivo pierde conexión hasta `CTRL+C`

Ejemplo:
```bash
arpspoof -i eth0 -t 192.168.1.15 192.168.1.1
```

---

## 🛠️ Requisitos (Auto-instalados)

| Herramienta | Paquete | Instalación |
|------------|--------|-------------|
| arpspoof | dsniff | `sudo apt install dsniff` |
| arp-scan | arp-scan | `sudo apt install arp-scan` |

> El script instala todo automáticamente si falta algo.

---

## 🔒 Uso Ético y Legal

✅ Laboratorios personales  
✅ Redes propias  
✅ Pentesting autorizado  
✅ Educación  

❌ Redes ajenas sin permiso  
❌ Ataques maliciosos  
❌ Producción sin autorización  

---

## 📊 Ejemplo de Escaneo

```text
IP: 192.168.1.10  MAC: aa:bb:cc:dd:ee:ff  INFO: Android
IP: 192.168.1.15  MAC: 11:22:33:44:55:66  INFO: Windows-PC
IP: 192.168.1.100 MAC: 77:88:99:aa:bb:cc INFO: iPhone
```

---

## 🚨 Troubleshooting

| Problema | Solución |
|--------|----------|
| Permission denied | Usa `sudo` |
| No devices found | Verifica red/interfaz |
| arpspoof not found | Deja que el script instale dsniff |
| No route to host | Revisa gateway |

---

## 🔗 Enlaces Útiles

- https://www.kali.org/tools/dsniff/
- https://www.kali.org/tools/arp-scan/
- https://www.youtube.com/results?search_query=arp+spoofing+kali+linux

---

## 📈 SEO Keywords

ARP Spoofing Kali Linux  
WiFi Killer Script  
Ethical Hacking ARP  
MITM Kali  
arp-scan automatizado  
dsniff bash  

---

## ⭐ Contribuye

```bash
git checkout -b feature/AmazingFeature
git commit -m "Add AmazingFeature"
git push origin feature/AmazingFeature
```

---

## 📄 Licencia

MIT License  
Uso educativo y ético únicamente  

---

**Creado por Davidrt**  
🕒 Actualizado: **Dec 2025**
