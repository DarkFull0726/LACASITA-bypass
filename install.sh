#!/bin/bash
clear
CTRL_C(){
  exit
}

if [ `whoami` != 'root' ]; then
     echo -e "\e[1;31mPARA PODER USAR EL INSTALADOR ES NECESARIO SER ROOT\nDIJITA ESTE COMANDO: sudo -i\e[0m"
     exit
fi
trap "CTRL_C" INT TERM EXIT

# --- REPO BYPASS ---
REPO="https://raw.githubusercontent.com/DarkFull0726/LACASITA-bypass/main"
SCPdir="/etc/VPS-MX"
SCPinstal="$HOME/install"
SCPusr="${SCPdir}/controlador"
SCPfrm="${SCPdir}/herramientas"
SCPinst="${SCPdir}/protocolos"

BRAN='\033[1;37m' && ROJO='\e[91m' && VERMELHO='\e[91m' && VERDE='\e[92m' && AMARELO='\e[93m'
AZUL='\e[94m' && MAGENTA='\e[95m' && MAG='\033[1;96m' && NEGRITO='\e[1m' && SEMCOR='\e[0m'

msg () {
  case $1 in
    -ne)cor="${VERMELHO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nazu) cor="${ROJO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nverd)cor="${VERDE}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nama) cor="${AMARELO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -ama)cor="${AMARELO}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -verm)cor="${AMARELO}${NEGRITO}${VERMELHO}" && echo -e "${cor}${2}${SEMCOR}";;
    -azu)cor="${MAG}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -verd)cor="${VERDE}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -bra)cor="${BRAN}" && echo -ne "${cor}${2}${SEMCOR}";;
    -tit)echo -e "\e[91m≪━━─━━─━─━─━─━─━━─━━─━─━─◈─━━─━─━─━─━━─━─━━─━─━━─━≫\e[0m\n  \e[2;97m\e[3;93m❯❯❯❯❯❯ ꜱᴄʀɪᴩᴛ ᴍᴏᴅ ʟᴀᴄᴀꜱɪᴛᴀᴍx ❮❮❮❮❮❮\033[0m\n\e[91m≪━━─━─━━━─━─━─━─━─━━─━─━─◈─━─━─━─━─━━━─━─━─━━━─━─━≫\e[0m";;
    "-bar2"|"-bar")cor="${VERMELHO}————————————————————————————————————————————————————" && echo -e "${SEMCOR}${cor}${SEMCOR}";;
  esac
}

time_reboot(){
  REBOOT_TIMEOUT="$1"
  echo -e "\t\e[1;97m\e[1;100mREINICIANDO VPS EN $1 SEGUNDOS\e[0m"
  while [ $REBOOT_TIMEOUT -gt 0 ]; do
    echo -ne "\t-$REBOOT_TIMEOUT-\r"
    sleep 2
    : $((REBOOT_TIMEOUT--))
  done
  sudo reboot
}

function printTitle {
    echo ""
    echo -e "\033[1;92m$1\033[1;91m"
    printf '%0.s-' $(seq 1 ${#1})
    echo ""
}

del(){
  for (( i = 0; i < $1; i++ )); do
    tput cuu1 && tput dl1
  done
}

fun_ipe () {
  MIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
  MIP2=$(wget -qO- ipv4.icanhazip.com)
  [[ "$MIP" != "$MIP2" ]] && IP="$MIP2" || IP="$MIP"
  echo "$IP" >/bin/IPca
}

os_system(){
  system=$(cat -n /etc/issue | grep 1 | cut -d ' ' -f6,7,8 | sed 's/1//' | sed 's/      //')
  distro=$(echo "$system" | awk '{print $1}')
  case $distro in
    Debian)vercion=$(echo $system | awk '{print $3}' | cut -d '.' -f1);;
    Ubuntu)vercion=$(echo $system | awk '{print $2}' | cut -d '.' -f1,2);;
  esac
}

repo_install(){
  : # repos handled automatically
}

dependencias(){
  msg -tit
  msg -ama "               PREPARANDO INSTALACION"
  msg -bar2
  clear
  printTitle "Limpieza de caché local"
  apt-get clean
  clear
  printTitle "Actualizando paquetes"
  dpkg --configure -a &>/dev/null
  apt install sudo -y &>/dev/null
  clear
  os_system
  msg -tit
  echo "$distro $vercion" >/tmp/distro
  echo -e "\e[1;31m\t🖥SISTEMA: \e[33m$distro $vercion"
  echo -e "\e[1;31m\t🖥IP: \e[33m$IP"
  echo -e "  \033[41m   -- INSTALACION DE PAQUETES 2026 --    \e[49m"
  msg -bar
  soft="sudo bsdmainutils zip unzip ufw curl python python3 python3-pip openssl screen cron iptables lsof nano at mlocate gawk figlet grep bc jq curl socat netcat net-tools cowsay lolcat figlet toilet pv perl apache2"
  for install in $soft; do
    leng="${#install}"
    puntos=$(( 21 - $leng))
    pts="."
    for (( a = 0; a < $puntos; a++ )); do pts+="."; done
    msg -nazu "   INSTALANDO $install $(msg -ama "$pts")"
    if [[ $(dpkg --get-selections | grep -w "${install}" | head -1) ]] || sudo apt-get install ${install} -y &>/dev/null; then
      msg -verd " INSTALADO"
    else
      msg -verm " FALLA"
      sleep 1; del 1
      sudo apt install $install -y &>/dev/null && msg -verd " INSTALADO" || msg -verm " FALLA"
    fi
  done
  sudo apt-get install apache2 -y &>/dev/null
  sed -i "s;Listen 80;Listen 81;g" /etc/apache2/ports.conf > /dev/null 2>&1
  service apache2 restart > /dev/null 2>&1
  clear
}

install_start(){
  clear
  os_system
  msg -bar
  echo -e "\e[1;31m\t🖥SISTEMA: \e[33m$distro $vercion"
  msg -bar
  repo_install
}

install_continue(){
  dependencias
  apt autoremove -y &>/dev/null
}

install_fim () {
  msg -ama "               Finalizando Instalacion"
  [[ ! -d ${SCPusr} ]] && mkdir -p ${SCPusr}
  [[ $(find ${SCPusr} -name nombre.log | grep -w "nombre.log" | head -1) ]] || \
    wget -q -O ${SCPusr}/nombre.log "$REPO/controlador/nombre.log" &>/dev/null
  [[ $(find ${SCPusr} -name IDT.log | grep -w "IDT.log" | head -1) ]] || \
    wget -q -O ${SCPusr}/IDT.log "$REPO/controlador/IDT.log" &>/dev/null
  [[ $(find ${SCPusr} -name tiemlim.log | grep -w "tiemlim.log" | head -1) ]] || \
    wget -q -O ${SCPusr}/tiemlim.log "$REPO/controlador/tiemlim.log" &>/dev/null
  touch /usr/share/lognull &>/dev/null
  wget -q "$REPO/util/SPR" -O /usr/bin/SPR &>/dev/null && chmod 775 /usr/bin/SPR
  [[ -z $(cat /etc/resolv.conf | grep "8.8.8.8") ]] && echo "nameserver 8.8.8.8" >> /etc/resolv.conf
  [[ -z $(cat /etc/resolv.conf | grep "1.1.1.1") ]] && echo "nameserver 1.1.1.1" >> /etc/resolv.conf
  wget -q "$REPO/util/rebootnb" -O /bin/rebootnb &>/dev/null && chmod +x /bin/rebootnb
  wget -q "$REPO/util/resetsshdrop" -O /bin/resetsshdrop &>/dev/null && chmod +x /bin/resetsshdrop
  wget -q "$REPO/util/sshd_config" -O /tmp/sshd_config_new &>/dev/null
  if sshd -t -f /tmp/sshd_config_new &>/dev/null; then
    cp /tmp/sshd_config_new /etc/ssh/sshd_config
    chmod 644 /etc/ssh/sshd_config
  fi
  rm -f /tmp/sshd_config_new
  service ssh restart &>/dev/null
  msg -bar2
  echo '#!/bin/sh -e' > /etc/rc.local
  sudo chmod +x /etc/rc.local
  echo "sudo rebootnb" >> /etc/rc.local
  echo "sudo resetsshdrop" >> /etc/rc.local
  echo "sleep 2s" >> /etc/rc.local
  echo "exit 0" >> /etc/rc.local
  /bin/cp /etc/skel/.bashrc ~/
  echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/' >> /etc/profile
  echo 'clear' >> .bashrc
  echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/' >> .bashrc
  echo 'echo ""' >> .bashrc
  echo 'fecha=$(date +"%d-%b-%y")' >> .bashrc
  echo 'hora=$(date +"%T")' >> .bashrc
  echo 'echo -e "\033[1;91m——————————————————————————————————————————————————\e[0m"' >> .bashrc
  echo 'mess1="$(less /etc/VPS-MX/message.txt)"' >> .bashrc
  echo 'echo -e "\033[1;91m——————————————————————————————————————————————————\e[0m"' >> .bashrc
  echo 'echo -e "\t\033[1;91mRESELLER :\e[92m $mess1"' >> .bashrc
  echo 'echo -e "\e[1;97m  HORA: \e[1;91m$hora    \e[1;97mFECHA: \e[1;91m${fecha}\e[0m"' >> .bashrc
  echo 'echo -e "\033[1;91m——————————————————————————————————————————————————\e[0m"' >> .bashrc
  echo 'echo -e "\t\033[1;100mPARA PODER ENTRAR AL MENÚ ESCRIBA:\e[0m\e[1;41m menu \e[0m"' >> .bashrc
  echo 'echo ""' >> .bashrc
  echo -e "         COMANDO PRINCIPAL PARA ENTRAR AL SCRIPT"
  echo -e "  \033[1;41m               sudo menu             \033[0;37m" && msg -bar2
  rm -rf /usr/bin/pytransform &>/dev/null
  service ssh restart &>/dev/null
  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/
  time_reboot "10"
}

verificar_arq () {
  case $1 in
    "menu"|"message.txt"|"ID")ARQ="${SCPdir}/";;
    "C-SSR.sh"|"slowdns.sh"|"openvpn.sh"|"squid.sh"|"wireguard.sh"|"ports.sh")ARQ="${SCPinst}/";;
    "python.py"|"PDirect.py"|"PGet.py"|"POpen.py"|"PPriv.py"|"PPub.py")ARQ="${SCPinst}/";;
    "ADMbot.sh"|"squidpass.sh"|"fai2ban.sh"|"speed.py")ARQ="${SCPinst}/";;
    "adminkey"|"name")ARQ="${SCPdir}/tmp/";;
    *)ARQ="${SCPfrm}/";;
  esac
  mv -f ${SCPinstal}/$1 ${ARQ}/$1
  chmod +x ${ARQ}/$1
}

# --- INICIO ---
cd $HOME
SCPdir="/etc/VPS-MX"
SCPinstal="$HOME/install"
SCPusr="${SCPdir}/controlador"
SCPfrm="${SCPdir}/herramientas"
SCPinst="${SCPdir}/protocolos"

rm -rf /etc/localtime &>/dev/null
ln -s /usr/share/zoneinfo/America/Chihuahua /etc/localtime &>/dev/null
rm -rf /usr/local/lib/systemubu1 &>/dev/null

fun_ipe
source /etc/os-release; export PRETTY_NAME

install_start
install_continue

wget -q -O /usr/bin/trans "$REPO/util/trans" &>/dev/null && chmod +x /usr/bin/trans
wget -q -O /bin/Desbloqueo.sh "$REPO/tmp/Desbloqueo.sh" &>/dev/null && chmod +x /bin/Desbloqueo.sh
wget -q -O /bin/monitor.sh "$REPO/util/monitor.sh" &>/dev/null && chmod +x /bin/monitor.sh
wget -q -O /var/www/html/estilos.css "$REPO/util/estilos.css" &>/dev/null

[[ -f "/usr/sbin/ufw" ]] && {
  ufw allow 443/tcp &>/dev/null
  ufw allow 80/tcp &>/dev/null
  ufw allow 3128/tcp &>/dev/null
  ufw allow 8799/tcp &>/dev/null
  ufw allow 8080/tcp &>/dev/null
  ufw allow 81/tcp &>/dev/null
}

# --- DIRECTORIOS REQUERIDOS POR EL MENU ---
mkdir -p /usr/local/include/snaps
mkdir -p /usr/local/lib/sped/tools
mkdir -p /usr/local/lib/rm
mkdir -p /usr/local/libreria
mkdir -p /usr/local/megat

# Archivo de versión
wget -q "$REPO/util/vercion" -O /etc/versin_script 2>/dev/null || echo "12XB" > /etc/versin_script
cp /etc/versin_script /etc/versin_script_new 2>/dev/null

# --- INSTALACIÓN BYPASS (sin key) ---
msg -tit
msg -ama "          ACTIVANDO BYPASS - SIN KEY REQUERIDA"
msg -bar2

[[ ! -d ${SCPinstal} ]] && mkdir -p ${SCPinstal}
[[ ! -d ${SCPdir}/tmp ]] && mkdir -p ${SCPdir}/tmp
[[ ! -d ${SCPusr} ]] && mkdir -p ${SCPusr}
[[ ! -d ${SCPfrm} ]] && mkdir -p ${SCPfrm}
[[ ! -d ${SCPinst} ]] && mkdir -p ${SCPinst}

archivos='wireguard.sh adminkey name ID slowdns.sh ADMbot.sh C-SSR.sh PDirect.py PGet.py POpen.py PPriv.py PPub.py fai2ban.sh menu message.txt openvpn.sh ports.sh speed.py squid.sh squidpass.sh python.py'

for arqx in $archivos; do
  msg -ne "   Instalando $arqx: "
  wget -q -O ${SCPinstal}/${arqx} "$REPO/files/$arqx" 2>/dev/null && \
    verificar_arq "$arqx" && msg -verd "OK" || msg -verm "FALLA"
done

# Archivos de control y protocolos
wget -q -O ${SCPdir}/protocolos/chekuser.sh "$REPO/tmp/chekuser.sh" &>/dev/null && chmod 777 ${SCPdir}/protocolos/chekuser.sh
wget -q -O ${SCPdir}/protocolos/chekuser.py "$REPO/tmp/chekuser.py" &>/dev/null && chmod 777 ${SCPdir}/protocolos/chekuser.py
mkdir -p ${SCPdir}/tmp
wget -q -O ${SCPdir}/tmp/verifi "$REPO/tmp/verifi" &>/dev/null && chmod 777 ${SCPdir}/tmp/verifi
wget -q -O ${SCPdir}/tmp/monitor "$REPO/tmp/monitor_db" &>/dev/null && chmod 777 ${SCPdir}/tmp/monitor
wget -q -O ${SCPdir}/tmp/autodes "$REPO/tmp/autodes" &>/dev/null && chmod 777 ${SCPdir}/tmp/autodes

mkdir -p ${SCPdir}/passw
wget -qO- ipv4.icanhazip.com > ${SCPdir}/IP.log
rm -rf /usr/bin/menu /usr/bin/VPSMX &>/dev/null
ln -s ${SCPdir}/menu /usr/bin/menu
ln -s ${SCPdir}/menu /usr/bin/VPSMX

echo "BYPASS" > ${SCPdir}/key.txt

cat /etc/bash.bashrc | grep -v '\[\[ \$UID != 0 \]\] && TMOUT=15 && export TMOUT' > /etc/bash.bashrc.2
echo '[[ $UID != 0 ]] && TMOUT=15 && export TMOUT' >> /etc/bash.bashrc.2
mv -f /etc/bash.bashrc.2 /etc/bash.bashrc

[[ -d ${SCPinstal} ]] && rm -rf ${SCPinstal}

msg -bar2
msg -verd "  ✅ INSTALACIÓN COMPLETADA - LACASITA BYPASS"
msg -bar2

install_fim
