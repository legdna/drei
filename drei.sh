#!/usr/bin/bash
set -e

test_sudo=$(which sudo)
if [[ $? -ne 0 ]]; then
    printf "\n
		\e[41;1m                                               \e[0m
		\e[41;1m  Sudo n'est pas installé sur votre machine !  \e[0m
		\e[41;1m                                               \e[0m
	\n\n"
    exit 1
fi

# "black"      "\e[30m"
# "red"        "\e[31m"
# "green"      "\e[32m"
# "yellow"     "\e[33m"
# "blue"       "\e[34m"
# "magenta"    "\e[35m"
# "cyan"       "\e[36m"
# "light_gray" "\e[37m"
# "reset"      "\e[0m"
# "bold"       "\e[1m"
# "faint"      "\e[2m"
# "italic"     "\e[3m"
# "underlined" "\e[4m"

function title {
	printf "\e[35;1m
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
	\e[0;1m
		 by legdna                                    rev.a0.2
	
	
	\e[0m\n"
}

# Message d'erreur lors d'une syntaxe douteuse
function error_syntax {
	printf "\n
		\e[41;1m                       \e[0m
		\e[41;1m  Erreur de syntaxe !  \e[0m
		\e[41;1m                       \e[0m
	\n\n"
}

function root_passwd {
	printf "\n
		\e[42;1m                                                                                                \e[0m
		\e[42;1m  Entrez votre mot de passe utilisateur pour installer les dépendances nécessaire au programme  \e[0m
		\e[42;1m                                                                                                \e[0m
  	\n\n"
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
		printf "\e[36;1m  Sur quelle distribution Linux êtes-vous ?\e[0m\n"
		printf "\n	1. \e[31;1mDebian\e[0m ou équivalent (Ubuntu, Linux Mint, ...)"
		printf "\n	2. \e[34;1mFedora\e[0m ou équivalent (Bazzite, ...)"
		printf "\n	3. \e[36;1mArch Linux\e[0m ou équivalent (Manjaro, Endeavour, ...)"
		printf "\n	4. \e[32;1mOpenSUSE\e[0m ou équivalent (SUSE, ...)\n"
		printf "\n\e[33;1m  -> \e[0m"; read distro
		if [[ $distro =~ ^[1-4]$ ]]; then
			distro_choice=1
		else
			distro_choice=-1
		fi
		clear
	done

	nvidia_choice=0
	while [[ $nvidia_choice == 0 ]] || [[ $nvidia_choice == -1 ]]; do
		if [[ $nvidia_choice == -1 ]]; then
			error_syntax
		fi
		printf "\n\e[36;1m  Avez-vous une carte NVIDIA ? o/N : \e[0m"; read nvidia_check
		if [[ $nvidia_check == "o" ]] || [[ $nvidia_check == "O" ]]; then
			nvidia_choice=2
		elif [[ $nvidia_check == "n" ]] || [[ $nvidia_check == "N" ]] || [[ $nvidia_check == "" ]]; then
			nvidia_choice=1
		else
			nvidia_choice=-1
		fi
		clear
	done

	if [[ $distro == 1 ]]; then
		printf "\n\e[33;1m  Êtes-vous sûr d'être sur Debian ou équivalent ? o/N : \e[0m"
		read yes_or_no
		if [[ $yes_or_no == "o" ]] || [[ $yes_or_no == "O" ]]; then
			clear
			root_passwd
			sudo apt update -y && sudo apt upgrade -y
			sudo apt install -y distrobox podman fuse-overlayfs unzip
		else
			clear
		fi
	elif [[ $distro == 2 ]]; then
		printf "\n\e[33;1m  Êtes-vous sûr d'être sur Fedora ou équivalent ? o/N : \e[0m"
		read yes_or_no
		if [[ $yes_or_no == "o" ]] || [[ $yes_or_no == "O" ]]; then
			clear
			root_passwd
			sudo dnf update -y
			sudo dnf install -y distrobox podman fuse-overlayfs unzip
		else
			clear
		fi
	elif [[ $distro == 3 ]]; then
		printf "\n\e[33;1m  Êtes-vous sûr d'être sur Arch Linux ou équivalent ? o/N : \e[0m"
		read yes_or_no
		if [[ $yes_or_no == "o" ]] || [[ $yes_or_no == "O" ]]; then
			clear
			root_passwd
			sudo pacman -Suy --noconfirm distrobox podman fuse-overlayfs unzip
		else
			clear
		fi
	elif [[ $distro == 4 ]]; then
		printf "\n\e[33;1m  Êtes-vous sûr d'être sur OpenSUSE ou équivalent ? o/N : \e[0m"
		read yes_or_no
		if [[ $yes_or_no == "o" ]] || [[ $yes_or_no == "O" ]]; then
			clear
			root_passwd
			sudo zypper update -y 
			sudo zypper install -y distrobox podman fuse-overlayfs unzip
		else
			clear
		fi
	fi
done

if [[ $nvidia_choice == 2 ]]; then
	distrobox-create --name drei --image fedora:38 --nvidia --yes
else
	distrobox-create --name drei --image fedora:38 --yes
fi
distrobox-enter --name drei -- sudo dnf install -y alsa-plugins-pulseaudio libxcrypt-compat xcb-util-renderutil xcb-util-wm pulseaudio-libs xcb-util xcb-util-image xcb-util-keysyms libxkbcommon-x11 libXrandr libXtst mesa-libGLU mtdev libSM libXcursor libXi libXinerama libxkbcommon libglvnd-egl libglvnd-glx libglvnd-opengl libICE librsvg2 libSM libX11 libXcursor libXext libXfixes libXi libXinerama libxkbcommon libxkbcommon-x11 libXrandr libXrender libXtst libXxf86vm mesa-libGLU mtdev pulseaudio-libs xcb-util alsa-lib apr apr-util fontconfig freetype libglvnd fuse-libs fuse rocm-opencl

clear
printf "\n
	\e[42;1m                                                                                                                \e[0m
	\e[42;1m  Téléchargez votre version de DaVinci Resolve sur https://www.blackmagicdesign.com/fr/products/davinciresolve  \e[0m
	\e[42;1m                                                                                                                \e[0m
\e[0m\e[33;1m
	Une fois fait glisser déposer le fichier téléchargé ici : \e[0m"
read davinci_path

davinci_path="${davinci_path//\'/}"
current_path=$(pwd)
unzip -o $davinci_path -d $current_path
if [[ -e davinci.run ]]; then
	rm -f davinci.run
fi
mv $current_path/*.run $current_path/davinci.run
distrobox-enter --name drei -- sudo $current_path/davinci.run -iy
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
clear

printf "\n
	\e[42;1m                                               \e[0m
	\e[42;1m  L'installation s'est terminée avec succès !  \e[0m
	\e[42;1m                                               \e[0m
\n\n"
