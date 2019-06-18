#!/bin/bash
WMCTRL_PKG=$(ls /var/log/packages | grep wmctrl)
XDOTOOL_PKG=$(ls /var/log/packages | grep xdotool)

#SUBSTITUA ***** PELO NÚMERO DO SEU RAMAL
RAMAL=*****

#SUBSTITUA ********************** PELA SENHA DO SEU RAMAL.
SENHA=**********************

if [[ ${#WMCTRL_PKG} -eq 0 ]]; then
    echo "Nao tem wmctrl instalado"
    exit
fi

if [[ ${#XDOTOOL_PKG} -eq 0 ]]; then
    echo "Nao tem xdotool instalado"
    exit
fi

EYEBEAM=$( find ${HOME}/.wine/drive_c/ -type f -iname eyebeam.exe )
wine "${EYEBEAM}" -dial="*1" &>/dev/null &

sleep 2

WID=""
TENTATIVAS=0
while [[ "$WID" == "" || "$WID" == "0" ]]; do
    # Busca o ID da janela do programa
    WID=$( wmctrl -lp | grep -P "eyeBeam\b(?=(\n|))" | awk '{print $1}' | xargs printf '%d' )
    if [[ "$WID" != "" || "$WID" != "0" ]]; then
        echo "$WID"
    fi
    ((TENTATIVAS++)) && ((TENTATIVAS==200)) && exit 1
done

sleep 1

xdotool windowactivate --sync "$WID" type --delay 0.1 $RAMAL

xdotool windowactivate --sync "$WID" type --delay 0.1 $SENHA#

sleep 5

PID_FIREFOX=$( ps -a | grep firefox | awk '{print $1}' | head -n1 )

if [[ ${#PID_FIREFOX} -eq 0 ]]; then
    firefox -new-tab -url http://totalip5.nube/ &>/dev/null &
else
    firefox -new-tab -url http://totalip5.nube/
fi

WID=""
TENTATIVAS=0
while [[ "$WID" == "" || "$WID" == "0" ]]; do
    # Busca o ID da janela do programa
    WID=$( wmctrl -lp | grep "softphone" | head -n1 | awk '{print $1}' | xargs printf '%d' )
    if [[ "$WID" != "" || "$WID" != "0" ]]; then
        echo "$WID"
    fi

    ((TENTATIVAS++)) && ((TENTATIVAS==200)) && exit 2
done

sleep 1

xdotool windowactivate --sync "$WID" key CTRL+a
xdotool windowactivate --sync "$WID" type --delay 10 $RAMAL
xdotool windowactivate --sync "$WID" key Tab
xdotool windowactivate --sync "$WID" key CTRL+a
xdotool windowactivate --sync "$WID" type --delay 10 $SENHA
xdotool windowactivate --sync "$WID" key Return
