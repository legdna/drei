#!/usr/bin/bash
set -e

if [[ $EUID -eq 0 ]]; then
  printf "\n
  		\e[41;1m                                                            \e[0m
		\e[41;1m  Ce script ne supporte pas l'exécution en tant que root !  \e[0m
		\e[41;1m                                                            \e[0m
	\n\n"
    exit 1
fi
test_sudo=$(command -v sudo)
if [[ $? -ne 0 ]]; then
    printf "\n
		\e[41;1m                                                           \e[0m
		\e[41;1m        Sudo n'est pas installé sur votre machine !        \e[0m
		\e[41;1m                                                           \e[0m
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

		 \e[0;46;30;1m  DaVinci Resolve Easy Installer  \e[0;1m

		 by legdna                                    rev.a0.4

	\e[0m\n"
}

# Message lorsqu'une précédente installation est détecter
function old_install {
	printf "\n
			\e[45;1m                                          \e[0m
			\e[45;1m    Précédente installation détecter !    \e[0m
			\e[45;1m                                          \e[0m
	\n\n"
}

# Message d'erreur lors d'une syntaxe douteuse
function error_syntax {
	printf "\n
				\e[41;1m                       \e[0m
				\e[41;1m  Erreur de syntaxe !  \e[0m
				\e[41;1m                       \e[0m
	\n\n"
}

# Message pour le menu des options
function options {
	printf "\n
				\e[44;1m                       \e[0m
				\e[44;1m        Options        \e[0m
				\e[44;1m                       \e[0m
	\n\n"
}

# Message pour le récapitulatif des options sélectionner
function recap_options {
	printf "\n
				\e[46;1m                       \e[0m
				\e[46;1m     Récapitulatif     \e[0m
				\e[46;1m                       \e[0m
	\n\n"
}

function root_passwd {
	printf "\n
	\e[42;1m                                                                        \e[0m
	\e[42;1m  Entrez votre mot de passe utilisateur pour installer les dépendances  \e[0m
	\e[42;1m  nécessaire au programme.                                              \e[0m
	\e[42;1m                                                                        \e[0m
  	\n\n"
}

clear
old_install_detection=$(distrobox-list | grep -oh "\w*drei") || old_install_detection="NULL"
old_install_check=0
if [[ $old_install_detection == "drei" ]]; then
	old_install_choice=0
	while [[ $old_install_choice == 0 ]] || [[ $old_install_choice == -1 ]]; do
		title; old_install
		if [[ $old_install_choice == -1 ]]; then
			clear; title; error_syntax; sleep 2; clear; title; old_install
		fi
		printf "\e[36;1m  Que souhaitez-vous faire ?\e[0m\n"
		printf "\n	1. \e[32;1mMettre à jour DaVinci Resolve\e[0m"
		printf "\n	2. \e[34;1mRéinstaller DaVinci Resolve\e[0m"
		printf "\n	3. \e[31;1mDésinstaller DaVinci Resolve\e[0m"
		printf "\n\e[33;1m  -> \e[0m"; read old_install_check
		if [[ $old_install_check =~ ^[1-3]$ ]]; then
			old_install_choice=1
		else
			old_install_choice=-1
		fi
		clear
	done
	case $old_install_check in
		2)
			distrobox-rm -f drei
			clear ;;
		3)
			distrobox-rm -f drei
			if [[ -d "$HOME/.var/app/io.github.legdna.drei-im" ]]; then
				rm -fv "$HOME/.local/share/applications/drei-im.desktop"
				rm -fv "$HOME/.local/share/icons/hicolor/128x128/apps/drei.png"
				rm -rfv "$HOME/.var/app/io.github.legdna.drei-im"
			fi
			clear
			printf "\n
				\e[41;1m                                                   \e[0m
				\e[41;1m  La désinstallation s'est terminée avec succès !  \e[0m
				\e[41;1m                                                   \e[0m
			\n\n"
			exit 0 ;;
	esac
fi

# Vérifie si le script effectue une mise à jour de DaVinci Resolve
if [[ $old_install_check != 1 ]]; then

	# Initiallisation de la variable yes_or_no et d'une boucle while pour vérifier les erreurs de syntaxe
	yes_or_no="NULL"
	while [[ $yes_or_no != "o" ]] && [[ $yes_or_no != "O" ]]; do
		distro_choice=0
		while [[ $distro_choice == 0 ]] || [[ $distro_choice == -1 ]]; do
			title; options
			if [[ $distro_choice == -1 ]]; then
				clear; title; error_syntax; sleep 2; clear; title; options
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
			title; options
			if [[ $nvidia_choice == -1 ]]; then
				clear; title; error_syntax; sleep 2; clear; title; options
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

		bigpu_choice=0
		while [[ $bigpu_choice == 0 ]] || [[ $bigpu_choice == -1 ]]; do
			title; options
			if [[ $bigpu_choice == -1 ]]; then
				clear; title; error_syntax; sleep 2; clear; title; options
			fi
			printf "\n\e[36;1m  Avez-vous une configuration biGPU (OPTIMUS, iGPU + dGPU, ...) ? o/N : \e[0m"; read bigpu_check
			if [[ $bigpu_check == "o" ]] || [[ $bigpu_check == "O" ]]; then
				bigpu_choice=2
			elif [[ $bigpu_check == "n" ]] || [[ $bigpu_check == "N" ]] || [[ $bigpu_check == "" ]]; then
				bigpu_choice=1
			else
				bigpu_choice=-1
			fi
			clear
		done

		manager_choice=0
		while [[ $manager_choice == 0 ]] || [[ $manager_choice == -1 ]]; do
			title; options
			if [[ $manager_choice == -1 ]]; then
				clear; title; error_syntax; sleep 2; clear; title; options
			fi
			printf "\n\e[36;1m  Souhaitez-vous installer le Gestionnaire d'installation de DREI ? O/n : \e[0m"; read manager_check
			if [[ $manager_check == "o" ]] || [[ $manager_check == "O" ]] || [[ $manager_check == "" ]]; then
				manager_choice=2
			elif [[ $manager_check == "n" ]] || [[ $manager_check == "N" ]]; then
				manager_choice=1
			else
				manager_choice=-1
			fi
			clear
		done

		recap_choice=0
		while [[ $recap_choice == 0 ]] || [[ $recap_choice == -1 ]]; do
			title; recap_options
			if [[ $recap_choice == -1 ]]; then
				clear; title; error_syntax; sleep 2; clear; title; recap_options
			fi

			case $distro in
				1)
					distro_type="\e[31;1mDebian\e[0m ou équivalent (Ubuntu, Linux Mint, ...)" ;;
				2)
					distro_type="\e[34;1mFedora\e[0m ou équivalent (Bazzite, ...)" ;;
				3)
					distro_type="\e[36;1mArch Linux\e[0m ou équivalent (Manjaro, Endeavour, ...)" ;;
				4)
					distro_type="\e[32;1mOpenSUSE\e[0m ou équivalent (SUSE, ...)" ;;
			esac
			printf "\n  \e[44;1m  Distro  :  \e[0;1m	$distro_type \e[0m"

			case $nvidia_choice in
				1)
					gpu_type="\e[31;1mAMD\e[0m" ;;
				2)
					gpu_type="\e[32;1mNVIDIA\e[0m" ;;
			esac
			printf "\n  \e[44;1m  CG      :  \e[0;1m	$gpu_type \e[0m"

			case $bigpu_choice in
				1)
					bigpu_type="\e[1mNon\e[0m" ;;
				2)
					bigpu_type="\e[1mOui\e[0m" ;;
			esac
			printf "\n  \e[44;1m  biGPU   :  \e[0;1m	$bigpu_type \e[0m"
			
			case $manager_choice in
				1)
					manager_type="\e[1mNon\e[0m" ;;
				2)
					manager_type="\e[1mOui\e[0m" ;;
			esac
			printf "\n  \e[44;1m  Manager :  \e[0;1m	$manager_type \e[0m"

			printf "\n\n\e[33;1m  Voulez-vous appliquer ces options lors de l'installation ? o/N : \e[0m"
			read yes_or_no
			if [[ $yes_or_no == "o" ]] || [[ $yes_or_no == "O" ]]; then
				recap_choice=2
			elif [[ $yes_or_no == "n" ]] || [[ $yes_or_no == "N" ]] || [[ $yes_or_no == "" ]]; then
				recap_choice=1
				clear
			else
				recap_choice=-1
			fi
		done
	done

	if [[ $old_install_check != 2 ]]; then
		clear; title; root_passwd
		case $distro in	
			1)
				sudo apt update -y && sudo apt upgrade -y
				sudo apt install -y distrobox podman fuse-overlayfs unzip ;;
			2)
				sudo dnf update -y
				sudo dnf install -y distrobox podman fuse-overlayfs unzip ;;
			3)
				sudo pacman -Suy --noconfirm distrobox podman fuse-overlayfs unzip ;;
			4)
				sudo zypper update -y
				sudo zypper install -y distrobox podman fuse-overlayfs unzip ;;
		esac
	fi

	if [[ $nvidia_choice == 2 ]]; then
		distrobox-create --name drei --image fedora:38 --nvidia --yes
	else
		distrobox-create --name drei --image fedora:38 --yes
	fi
	distrobox-enter --name drei -- sudo dnf install -y alsa-plugins-pulseaudio libxcrypt-compat xcb-util-renderutil xcb-util-wm pulseaudio-libs xcb-util xcb-util-image xcb-util-keysyms libxkbcommon-x11 libXrandr libXtst mesa-libGLU mtdev libSM libXcursor libXi libXinerama libxkbcommon libglvnd-egl libglvnd-glx libglvnd-opengl libICE librsvg2 libSM libX11 libXcursor libXext libXfixes libXi libXinerama libxkbcommon libxkbcommon-x11 libXrandr libXrender libXtst libXxf86vm mesa-libGLU mtdev pulseaudio-libs xcb-util alsa-lib apr apr-util fontconfig freetype libglvnd fuse-libs fuse rocm-opencl
fi

clear; title

printf "\n
	  \e[42;1m                                                                   \e[0m
	  \e[42;1m    Téléchargez votre version de DaVinci Resolve sur :             \e[0m
	  \e[42;34;1m    https://www.blackmagicdesign.com/fr/products/davinciresolve    \e[0m
	  \e[42;1m                                                                   \e[0m

	\e[33;1mUne fois fait glisser déposer le fichier 'zip' téléchargé ici : \e[0m"
read davinci_path

davinci_path="${davinci_path//\'/}"
script_path=$(dirname $0)
tmp_path="$HOME/.cache/drei"
if [[ ! -d "$tmp_path" ]]; then
	mkdir -v $tmp_path
else
	rm -rfv $tmp_path
	mkdir -v $tmp_path
fi
unzip -o $davinci_path -d $tmp_path
if [[ -e davinci.run ]]; then
	rm -f davinci.run
fi
mv $tmp_path/*.run $tmp_path/davinci.run
distrobox-enter --name drei -- sudo $tmp_path/davinci.run -iy
rm -rfv $tmp_path
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libglib-2.0.so"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libglib-2.0.so.0"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libglib-2.0.so.0.6800.4"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libgio-2.0.so"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libgio-2.0.so.0"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libgio-2.0.so.0.6800.4"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libgmodule-2.0.so"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libgmodule-2.0.so.0"
distrobox-enter --name drei -- sudo rm -rf "/opt/resolve/libs/libgmodule-2.0.so.0.6800.4"

distrobox-enter --name drei -- distrobox-export -a "/opt/resolve/bin/resolve"
cat << EOF > "$HOME/.local/share/applications/drei-com.blackmagicdesign.resolve.desktop"
[Desktop Entry]
Version=1.0
Type=Application
Name=DaVinci Resolve (drei)
Comment=Revolutionary new tools for editing, visual effects, color correction and professional audio post production, all in a single application!
Exec=/usr/bin/distrobox-enter  -n drei -- /bin/sh -l -c  /opt/resolve/bin/resolve  %u
Terminal=false
MimeType=application/x-resolveproj;
Icon=$HOME/.local/share/icons/DV_Resolve.png
StartupNotify=true
EOF
if [[ $bigpu_choice == 2 ]]; then
	echo "PrefersNonDefaultGPU = true" >> "$HOME/.local/share/applications/drei-com.blackmagicdesign.resolve.desktop"
fi

distrobox-enter --name drei -- distrobox-export -a "/opt/resolve/BlackmagicRAWPlayer/BlackmagicRAWPlayer"
cat << EOF > "$HOME/.local/share/applications/drei-com.blackmagicdesign.rawplayer.desktop"
[Desktop Entry]
Type=Application
Version=1.0
Name=Blackmagic RAW Player (drei)
Icon=blackmagicraw-player
Exec=/usr/bin/distrobox-enter  -n drei -- /bin/sh -l -c  /opt/resolve/BlackmagicRAWPlayer/BlackmagicRAWPlayer  %f
Terminal=false
MimeType=application/x-braw-clip;application/x-braw-sidecar
Categories=Video
EOF
if [[ $bigpu_choice == 2 ]]; then
	echo "PrefersNonDefaultGPU = true" >> "$HOME/.local/share/applications/drei-com.blackmagicdesign.rawplayer.desktop"
fi

distrobox-enter --name drei -- distrobox-export -a "/opt/resolve/BlackmagicRAWSpeedTest/BlackmagicRAWSpeedTest"
cat << EOF > "$HOME/.local/share/applications/drei-com.blackmagicdesign.rawspeedtest.desktop"
[Desktop Entry]
Type=Application
Version=1.0
Name=Blackmagic RAW Speed Test (drei)
Icon=blackmagicraw-speedtest
Exec=/usr/bin/distrobox-enter  -n drei -- /bin/sh -l -c  /opt/resolve/BlackmagicRAWSpeedTest/BlackmagicRAWSpeedTest  %f
Terminal=false
Categories=Video
EOF
if [[ $bigpu_choice == 2 ]]; then
	echo "PrefersNonDefaultGPU = true" >> "$HOME/.local/share/applications/drei-com.blackmagicdesign.rawspeedtest.desktop"
fi

distrobox-enter --name drei -- distrobox-export -a "/opt/resolve/DaVinci Control Panels Setup/DaVinci Control Panels Setup"
cat << EOF > "$HOME/.local/share/applications/drei-com.blackmagicdesign.resolve-Panels.desktop"
[Desktop Entry]
Version=1.0
Type=Application
Name=DaVinci Control Panels Setup (drei)
Exec=/usr/bin/distrobox-enter  -n drei -- /bin/sh -l -c  "/opt/resolve/DaVinci\ Control\ Panels\ Setup/DaVinci\ Control\ Panels\ Setup"
Terminal=false
Icon=$HOME/.local/share/icons/DV_Panels.png
EOF
if [[ $bigpu_choice == 2 ]]; then
	echo "PrefersNonDefaultGPU = true" >> "$HOME/.local/share/applications/drei-com.blackmagicdesign.resolve-Panels.desktop"
fi

if [[ $manager_choice == 2 ]]; then
	if [[ ! -d "$HOME/.var/app/io.github.legdna.drei-im" ]]; then
		mkdir -v "$HOME/.var/app/io.github.legdna.drei-im"
	fi

	if [[ $script_path != "$HOME/.var/app/io.github.legdna.drei-im" ]]; then
		cp -fv "$script_path/drei.sh" "$HOME/.var/app/io.github.legdna.drei-im/drei.sh"
		cp -fv "$script_path/drei.png" "$HOME/.var/app/io.github.legdna.drei-im/drei.png"
		cp -fv "$script_path/drei.png" "$HOME/.local/share/icons/hicolor/128x128/apps/drei.png"
		cat << EOF > "$HOME/.local/share/applications/drei-im.desktop"
[Desktop Entry]
Version=a0.4
Type=Application
Name=DREI Installation Manager
Name[fr]=Gestionnaire d'installation de DREI
Name[en]=DREI Installation Manager
Comment=An installation manager for DREI
Comment[fr]=Un gestionnaire d'installation pour DREI
Comment[en]=An installation manager for DREI
Exec=/usr/bin/bash $HOME/.var/app/io.github.legdna.drei-im/drei.sh %u
Terminal=true
MimeType=application/drei;
Icon=drei
StartupNotify=true
EOF
	fi
fi

clear

case $old_install_check in
	0)
		printf "\n
				\e[42;1m                                                 \e[0m
				\e[42;1m   L'installation s'est terminée avec succès !   \e[0m
				\e[42;1m                                                 \e[0m
		\n\n";;
	1)
		printf "\n
				\e[42;1m                                                 \e[0m
				\e[42;1m   La mise à jour s'est terminée avec succès !   \e[0m
				\e[42;1m                                                 \e[0m
		\n\n";;
	2)
		printf "\n
				\e[44;1m                                                  \e[0m
				\e[44;1m  La réinstallation s'est terminée avec succès !  \e[0m
				\e[44;1m                                                  \e[0m
		\n\n";;
esac

exit 0