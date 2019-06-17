#!/bin/bash
wmctrl_pkg=$(ls /var/log/packages | grep wmctrl)
xdotool_pkg=$(ls /var/log/packages | grep xdotool)
if [[ ${#wmctrl_pkg} -eq 0 ]]; then
    echo "Nao tem wmctrl instalado"
    exit
fi

if [[ ${#xdotool_pkg} -eq 0 ]]; then
    echo "Nao tem xdotool instalado"
    exit
fi

EYEBEAM=$( find ${HOME}/.wine/drive_c/ -type f -iname eyebeam.exe )
wine "${EYEBEAM}"  -dial="*1" &>/dev/null &

sleep 2

WID=""
while [ "$WID" == "" ]; do
    # Busca o ID da janela do programa
    WID=$( wmctrl -lp | grep -P "eyeBeam\b(?=(\n|))" | awk '{print $1}' | xargs printf '%d' )
    echo "$WID"
done

sleep 1

#SUBSTITUA RAMAL PELO NÚMERO DO SEU RAMAL
xdotool windowactivate --sync "$WID" type --delay 0.1 RAMAL

#SUBSTITUA SENHA PELA SENHA DO SEU RAMAL.
#LEMBRE-SE DE MANTER O CERQUILHA (#) NO FIM DA SENHA.
xdotool windowactivate --sync "$WID" type --delay 0.1 SENHA#
