#!/usr/bin/bash

# "black"      "\e[30m"
# "red"        "\e[31m"
# "green"      "\e[32m"
# "yellow"     "\e[33m"
# "blue"       "\e[34m"
# "magenta"    "\e[35m"
# "cyan"       "\e[36m"
# "white"      "\e[37m"
# "reset"      "\e[0m"
# "bold"       "\e[1m"
# "faint"      "\e[2m"
# "italic"     "\e[3m"
# "underlined" "\e[4m"

function title {
	printf "\e[1m                                     
		     _____          ___           ___                 
		    /  /::\        /  /\         /  /\        ___     
		   /  /:/\:\      /  /::\       /  /:/_      /  /\    
		  /  /:/  \:\    /  /:/\:\     /  /:/ /\    /  /:/    
		 /__/:/ \__\:|  /  /:/~/:/    /  /:/ /:/_  /__/::\    
		 \  \:\ /  /:/ /__/:/ /:/___ /__/:/ /:/ /\ \__\/\:\__ 
		  \  \:\  /:/  \  \:\/:::::/ \  \:\/:/ /:/    \  \:\/\\
		   \  \:\/:/    \  \::/~~~~   \  \::/ /:/      \__\::/
		    \  \::/      \  \:\        \  \:\/:/       /__/:/ 
		     \__\/        \  \:\        \  \::/        \__\/  
		                   \__\/         \__\/                
	
		 by legdna
	
	
	\e[0m\n"
}

function error_syntax {
	printf "\e[31;1m
		-----------------------
		| Erreur de syntaxe ! |
		-----------------------
		\e[0m\n\n"
}

clear
yes_or_no="NULL"
while [[ $yes_or_no != "o" ]] && [[ $yes_or_no != "O" ]]; do
	distro_choice=0
	while [[ $distro_choice == 0 ]] || [[ $distro_choice == -1 ]]; do
		title
		if [[ $distro_choice == -1 ]]; then
			error_syntax
		fi
		printf "\e[36;1m  Sur quelle distribution Linux es-tu ?\e[0m\n"
		printf "\n	1. \e[31mDebian\e[0m ou équivalent (Ubuntu, Linux Mint, ...)"
		printf "\n	2. \e[34mFedora\e[0m ou équivalent (Bazzite, ...)"
		printf "\n	3. \e[36mArch Linux\e[0m ou équivalent (Manjaro, Endeavour, ...)\n"
		printf "\n\e[33;1m  -> \e[0m"; read distro
		if [[ $distro == 1 ]]; then
			distro_choice=1
		elif [[ $distro == 2 ]]; then
			distro_choice=1
		elif [[ $distro == 3 ]]; then
			distro_choice=1
		else
			distro_choice=-1
		fi
		clear
	done

	if [[ $distro == 1 ]]; then
		printf "\n\e[33;1m  Es-tu sûr d'être sur Debian ou équivalent ? o/N : \e[0m"
		read yes_or_no
		if [[ $yes_or_no == "o" ]] || [[ $yes_or_no == "O" ]]; then
			clear
			printf "\n\e[32;1m
		------------------------------------------------------------------------------------------------
		| Entrer votre mot de passe utilisateur pour installer les dépendences nécessaire au programme |
		------------------------------------------------------------------------------------------------
  			\e[0m\n\n"
			sudo apt update -y && sudo apt upgrade -y
			sudo apt install -y distrobox podman fuse-overlayfs unzip
		else
			clear
		fi
	elif [[ $distro == 2 ]]; then
		printf "\n\e[33;1m  Es-tu sûr d'être sur Fedora ou équivalent ? o/N : \e[0m"
		read yes_or_no
		if [[ $yes_or_no == "o" ]] || [[ $yes_or_no == "O" ]]; then
			clear
			printf "\n\e[32;1m
		------------------------------------------------------------------------------------------------
		| Entrer votre mot de passe utilisateur pour installer les dépendences nécessaire au programme |
		------------------------------------------------------------------------------------------------
  			\e[0m\n\n"
			sudo dnf update -y
			sudo dnf install -y distrobox podman fuse-overlayfs unzip
		else
			clear
		fi
	elif [[ $distro == 3 ]]; then
		printf "\n\e[33;1m  Es-tu sûr d'être sur Arch Linux ou équivalent ? o/N : \e[0m"
		read yes_or_no
		if [[ $yes_or_no == "o" ]] || [[ $yes_or_no == "O" ]]; then
			clear
			printf "\n\e[32;1m
		------------------------------------------------------------------------------------------------
		| Entrer votre mot de passe utilisateur pour installer les dépendences nécessaire au programme |
		------------------------------------------------------------------------------------------------
  			\e[0m\n\n"
			sudo pacman -Suy --noconfirm distrobox podman fuse-overlayfs unzip
		fi
	fi
done

distrobox-create --name drei --image fedora:38
distrobox-enter --name drei -- sudo dnf install -y alsa-plugins-pulseaudio libxcrypt-compat xcb-util-renderutil xcb-util-wm pulseaudio-libs xcb-util xcb-util-image xcb-util-keysyms libxkbcommon-x11 libXrandr libXtst mesa-libGLU mtdev libSM libXcursor libXi libXinerama libxkbcommon libglvnd-egl libglvnd-glx libglvnd-opengl libICE librsvg2 libSM libX11 libXcursor libXext libXfixes libXi libXinerama libxkbcommon libxkbcommon-x11 libXrandr libXrender libXtst libXxf86vm mesa-libGLU mtdev pulseaudio-libs xcb-util alsa-lib apr apr-util fontconfig freetype libglvnd fuse-libs fuse rocm-opencl

clear
printf "\e[36;1m\n
	----------------------------------------------------------------------------------------------------------------
	| Télécharger votre version de DaVinci Resolve sur https://www.blackmagicdesign.com/fr/products/davinciresolve |
	----------------------------------------------------------------------------------------------------------------
\e[0m\e[33;1m
	Une fois fait glisser déposer le fichier téléchargé ici : \e[0m"
read davinci_path

davinci_path="${davinci_path//\'/}"
unzip -f $davinci_path
distrobox-enter --name drei -- sudo "${davinci_path//zip/run}" -iy
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libglib-2.0.so"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libglib-2.0.so.0"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libglib-2.0.so.0.6800.4"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libgio-2.0.so"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libgio-2.0.so.0"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libgio-2.0.so.0.6800.4"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libgmodule-2.0.so"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libgmodule-2.0.so.0"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libgmodule-2.0.so.0.6800.4"
distrobox-enter --name drei -- distrobox-export -a /opt/resolve/bin/resolve