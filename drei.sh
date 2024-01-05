#!/usr/bin/bash

script_path=$(dirname $0)
lang_detection=$(printf $LANG | grep -o "fr")
if [[ $lang_detection == "fr" ]]; then
	source $script_path/LANG/fr.lang
	
else
	source $script_path/LANG/en.lang
fi
source $script_path/DATA/desktops.data
set +o allexport

if [[ $EUID -eq 0 ]]; then
	printf "$ROOT_EXECUTION_DETECTION"
    exit 1
fi

# test_sudo=$(command -v sudo)

test_sudoers=$(groups $USER | grep -o "sudo") || test_sudoers=$(groups $USER | grep -o "wheel")
if [[ $? -eq 0 ]]; then
	test_sudoers_result=1
else
	test_sudoers_result=0
fi

set -e

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

		 by legdna                                    rev.b0.5

	\e[0m\n"
}

# Message lorsqu'une précédente installation est détecter
function old_install {
	printf "$PREVIOUS_INSTALLATION_DETECTION_MENU"
}

# Message d'erreur lors d'une syntaxe douteuse
function error_syntax {
	printf "$SYNTAX_ERROR_DETECTION"
}

function error_root {
	printf "$ELEVATION_PRIVILEGE_ERROR_DETECTION"
	exit 1
}

# Message pour le menu des options
function options {
	printf "$SETTINGS_MENU"
}

# Message pour le récapitulatif des options sélectionner
function recap_options {
	printf "$SUMMARY_MENU"
}

function root_passwd {
	printf "$ROOT_PASSWORD_INPUT"
}

function davinci_download {
	printf "$DAVINCI_RESOLVE_DOWNLOAD"
}

function davinci_download_finish {
	printf "$DAVINCI_RESOLVE_DOWNLOAD_FINISH"
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
		printf "$PREVIOUS_INSTALLATION_INPUT"; read old_install_check
		if [[ $old_install_check =~ ^[1-3]$ ]]; then
			old_install_choice=1
		else
			old_install_choice=-1
		fi
		clear
	done
	case $old_install_check in
		1)
			davinci_choice=$(cat $HOME/.config/drei/davinci.edition) ;;
		
		2)
			distrobox-rm -f drei
			clear ;;
		3)
			distrobox-rm -f drei
			if [[ -d "$HOME/.var/app/io.github.legdna.drei-im" ]]; then
				rm -fv "$HOME/.local/share/applications/drei-com.blackmagicdesign.resolve.desktop"
				rm -fv "$HOME/.local/share/applications/drei-com.blackmagicdesign.rawplayer.desktop"
				rm -fv "$HOME/.local/share/applications/drei-com.blackmagicdesign.rawspeedtest.desktop"
				rm -fv "$HOME/.local/share/applications/drei-com.blackmagicdesign.resolve-Panels.desktop"
				rm -fv "$HOME/.local/share/applications/drei-im.desktop"
				rm -rfv "$HOME/.local/share/icons/drei"
				rm -rfv "$HOME/.var/app/io.github.legdna.drei-im"
			fi
			clear
			printf "$UNINSTALL_OUTPUT"
			exit 0 ;;
	esac
fi

# Vérifie si le script effectue une mise à jour de DaVinci Resolve
if [[ $old_install_check != 1 ]]; then

	# Initiallisation de la variable yes_or_no et d'une boucle while pour vérifier les erreurs de syntaxe
	yes_or_no="NULL"
	while [[ $yes_or_no != "o" ]] && [[ $yes_or_no != "O" ]] && [[ $yes_or_no != "y" ]] && [[ $yes_or_no != "Y" ]]; do
		distro_choice=0
		while [[ $distro_choice == 0 ]] || [[ $distro_choice == -1 ]]; do
			title; options
			if [[ $distro_choice == -1 ]]; then
				clear; title; error_syntax; sleep 2; clear; title; options
			fi
			printf "$DISTRO_INPUT"; read distro
			if [[ $distro =~ ^[1-4]$ ]]; then
				distro_choice=1
			else
				distro_choice=-1
			fi
			clear
		done

		davinci_choice=0
		while [[ $davinci_choice == 0 ]] || [[ $davinci_choice == -1 ]]; do
			title; options
			if [[ $davinci_choice == -1 ]]; then
				clear; title; error_syntax; sleep 2; clear; title; options
			fi
			printf "$DAVINCI_RESOLVE_INPUT"; read davinci_check
			case $davinci_check in
				1)
					davinci_choice=1 ;;
				2)
					davinci_choice=2 ;;
				*)
					davinci_choice=-1 ;;
			esac
			clear
		done

		nvidia_choice=0
		while [[ $nvidia_choice == 0 ]] || [[ $nvidia_choice == -1 ]]; do
			title; options
			if [[ $nvidia_choice == -1 ]]; then
				clear; title; error_syntax; sleep 2; clear; title; options
			fi
			printf "$NVIDIA_INPUT"; read nvidia_check
			if [[ $nvidia_check == "o" ]] || [[ $nvidia_check == "O" ]] || [[ $nvidia_check == "y" ]] || [[ $nvidia_check == "Y" ]]; then
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
			printf "$BIGPU_INPUT"; read bigpu_check
			if [[ $bigpu_check == "o" ]] || [[ $bigpu_check == "O" ]] || [[ $bigpu_check == "y" ]] || [[ $bigpu_check == "Y" ]]; then
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
			printf "$MANAGER_INPUT"; read manager_check
			if [[ $manager_check == "o" ]] || [[ $manager_check == "O" ]] || [[ $manager_check == "y" ]] || [[ $manager_check == "Y" ]] || [[ $manager_check == "" ]]; then
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
					distro_type=$DEBIAN_TYPE ;;
				2)
					distro_type=$FEDORA_TYPE ;;
				3)
					distro_type=$ARCHLINUX_TYPE ;;
				4)
					distro_type=$OPENSUSE_TYPE ;;
			esac
			printf "\n  \e[44;1m  Distro  :  \e[0;1m	$distro_type \e[0m"

			case $davinci_choice in
				1)
					davinci_type="\e[35;1mDaVinci Resolve\e[0m" ;;
				2)
					davinci_type="\e[35;1mDaVinci Resolve Studio\e[0m" ;;
			esac
			printf "\n  \e[44;1m  Edition :  \e[0;1m	$davinci_type \e[0m"
			
			case $nvidia_choice in
				1)
					gpu_type="\e[31;1mAMD\e[0m" ;;
				2)
					gpu_type="\e[32;1mNVIDIA\e[0m" ;;
			esac
			printf "\n  \e[44;1m  CG      :  \e[0;1m	$gpu_type \e[0m"

			case $bigpu_choice in
				1)
					bigpu_type=$NO_OUTPUT ;;
				2)
					bigpu_type=$YES_OUTPUT ;;
			esac
			printf "\n  \e[44;1m  biGPU   :  \e[0;1m	$bigpu_type \e[0m"
			
			case $manager_choice in
				1)
					manager_type=$NO_OUTPUT ;;
				2)
					manager_type=$YES_OUTPUT ;;
			esac
			printf "\n  \e[44;1m  Manager :  \e[0;1m	$manager_type \e[0m"

			printf "$SUMMARY_INPUT"
			read yes_or_no
			if [[ $yes_or_no == "o" ]] || [[ $yes_or_no == "O" ]] || [[ $yes_or_no == "y" ]] || [[ $yes_or_no == "Y" ]]; then
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
		case $test_sudoers_result in
			0)
				case $distro in	
					1)
						su - -c "apt update -y; apt upgrade -y; apt install -y distrobox podman fuse-overlayfs unzip curl" ;;
					2)
						su - -c "dnf update -y"
						su - -c "dnf install -y distrobox podman fuse-overlayfs unzip curl" ;;
					3)
						su - -c "pacman -Suy --noconfirm distrobox podman fuse-overlayfs unzip curl" ;;
					4)
						su - -c "zypper update -y"
						su - -c "zypper install -y distrobox podman fuse-overlayfs unzip curl" ;;
				esac ;;
			1)
				case $distro in	
					1)
						sudo apt update -y && sudo apt upgrade -y
						sudo apt install -y distrobox podman fuse-overlayfs unzip curl ;;
					2)
						sudo dnf update -y
						sudo dnf install -y distrobox podman fuse-overlayfs unzip curl ;;
					3)
						sudo pacman -Suy --noconfirm distrobox podman fuse-overlayfs unzip curl ;;
					4)
						sudo zypper update -y
						sudo zypper install -y distrobox podman fuse-overlayfs unzip curl ;;
				esac ;;
		esac || {
			clear; error_root
		}
	fi

	if [[ $nvidia_choice == 2 ]]; then
		distrobox-create --name drei --image fedora:38 --nvidia --yes
	else
		distrobox-create --name drei --image fedora:38 --yes
	fi
	distrobox-enter --name drei -- sudo dnf install -y alsa-plugins-pulseaudio libxcrypt-compat xcb-util-renderutil xcb-util-wm pulseaudio-libs xcb-util xcb-util-image xcb-util-keysyms libxkbcommon-x11 libXrandr libXtst mesa-libGLU mtdev libSM libXcursor libXi libXinerama libxkbcommon libglvnd-egl libglvnd-glx libglvnd-opengl libICE librsvg2 libSM libX11 libXcursor libXext libXfixes libXi libXinerama libxkbcommon libxkbcommon-x11 libXrandr libXrender libXtst libXxf86vm mesa-libGLU mtdev pulseaudio-libs xcb-util alsa-lib apr apr-util fontconfig freetype libglvnd fuse-libs fuse rocm-opencl
fi

clear; title; davinci_download

{
	user_agent="User-Agent: Mozilla/5.0 (X11; Linux x86_64) \
	                        AppleWebKit/537.36 (KHTML, like Gecko) \
    	                    Chrome/77.0.3865.75 \
        	                Safari/537.36"

	case $davinci_choice in
		1)
			latest_release=$(curl -s "https://www.blackmagicdesign.com/api/support/latest-stable-version/davinci-resolve/linux")
			req_json="{ \
	    		\"firstname\": \"DREI\", \
	    		\"lastname\": \"IM\", \
	    		\"email\": \"drei-im@distrobox.script\", \
	    		\"phone\": \"202-555-0194\", \
	    		\"country\": \"us\", \
	    		\"street\": \"Bowery 146\", \
	    		\"state\": \"New York\", \
	    		\"city\": \"Distrobox\", \
	    		\"product\": \"DaVinci Resolve\" \
			}" ;;
		2)
			latest_release=$(curl -s "https://www.blackmagicdesign.com/api/support/latest-stable-version/davinci-resolve-studio/linux")
			req_json="{ \
	    		\"firstname\": \"DREI\", \
	    		\"lastname\": \"IM\", \
	    		\"email\": \"drei-im@distrobox.script\", \
	    		\"phone\": \"202-555-0194\", \
	    		\"country\": \"us\", \
	    		\"street\": \"Bowery 146\", \
	    		\"state\": \"New York\", \
	    		\"city\": \"Distrobox\", \
	    		\"product\": \"DaVinci Resolve Studio\" \
			}" ;;
	esac

	download_id=$(printf "%s" $latest_release | sed -n 's/.*"downloadId":"\([^"]*\).*/\1/p')
	davinci_version=$(printf "%s" $latest_release | awk -F'[,:]' '{for(i=1;i<=NF;i++){if($i~/"major"/){print $(i+1)} if($i~/"minor"/){print $(i+1)} if($i~/"releaseNum"/){print $(i+1)}}}' | sed 'N;s/\n/./;N;s/\n/./')

	req_json="$(printf '%s' "$req_json" | sed 's/[[:space:]]\+/ /g')"
	user_agent="$(printf '%s' "$user_agent" | sed 's/[[:space:]]\+/ /g')"
	user_agent_escaped="${user_agent// /\\ }"

	site_url="https://www.blackmagicdesign.com/api/register/us/download/${download_id}"
	davinci_url="$(curl -s -H 'Host: www.blackmagicdesign.com' -H 'Accept: application/json, text/plain, */*' -H 'Origin: https://www.blackmagicdesign.com' -H "$user_agent" -H 'Content-Type: application/json;charset=UTF-8' -H "Referer: https://www.blackmagicdesign.com/support/download/${download_id}/Linux" -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9' -H 'Authority: www.blackmagicdesign.com' -H 'Cookie: _ga=GA1.2.1849503966.1518103294; _gid=GA1.2.953840595.1518103294' --data-ascii "$req_json" --compressed "$site_url")"

	curl -o $script_path/davinci.zip $davinci_url
	davinci_path="$script_path/davinci.zip"

	clear; title; davinci_download_finish
} 

#printf "$DAVINCI_RESOLVE_DOWNLOAD_FILE"
#read davinci_path

#davinci_path="${davinci_path//\'/}"


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


if [[ ! -d "$HOME/.local/share/icons" ]]; then
	mkdir -v "$HOME/.local/share/icons"
fi
if [[ ! -d "$HOME/.local/share/icons/drei" ]]; then
	mkdir -v "$HOME/.local/share/icons/drei"
fi


cp -fv "$script_path/DATA/ICONS/blackmagic-resolve.png" "$HOME/.local/share/icons/drei/blackmagic-resolve.png"
printf "$DAVINVI_DESKTOP" > "$HOME/.local/share/applications/drei-com.blackmagicdesign.resolve.desktop"
if [[ $bigpu_choice == 2 ]]; then
	printf "\nPrefersNonDefaultGPU = true" >> "$HOME/.local/share/applications/drei-com.blackmagicdesign.resolve.desktop"
fi

cp -fv "$script_path/DATA/ICONS/blackmagicraw-player.png" "$HOME/.local/share/icons/drei/blackmagicraw-player.png"
printf "$RAW_PLAYER_DESKTOP" > "$HOME/.local/share/applications/drei-com.blackmagicdesign.rawplayer.desktop"
if [[ $bigpu_choice == 2 ]]; then
	printf "\nPrefersNonDefaultGPU = true" >> "$HOME/.local/share/applications/drei-com.blackmagicdesign.rawplayer.desktop"
fi

cp -fv "$script_path/DATA/ICONS/blackmagicraw-speedtest.png" "$HOME/.local/share/icons/drei/blackmagicraw-speedtest.png"
printf "$RAW_SPEEDTEST" > "$HOME/.local/share/applications/drei-com.blackmagicdesign.rawspeedtest.desktop"
if [[ $bigpu_choice == 2 ]]; then
	printf "\nPrefersNonDefaultGPU = true" >> "$HOME/.local/share/applications/drei-com.blackmagicdesign.rawspeedtest.desktop"
fi

cp -fv "$script_path/DATA/ICONS/blackmagic-panels.png" "$HOME/.local/share/icons/drei/blackmagic-panels.png"
printf "$CONTROL_PANELS" > "$HOME/.local/share/applications/drei-com.blackmagicdesign.resolve-Panels.desktop"
if [[ $bigpu_choice == 2 ]]; then
	printf "\nPrefersNonDefaultGPU = true" >> "$HOME/.local/share/applications/drei-com.blackmagicdesign.resolve-Panels.desktop"
fi

if [[ $manager_choice == 2 ]]; then
	if [[ ! -d "$HOME/.var" ]]; then
		mkdir -v "$HOME/.var"
	fi
	if [[ ! -d "$HOME/.var/app" ]]; then
		mkdir -v "$HOME/.var/app"
	fi
	if [[ ! -d "$HOME/.var/app/io.github.legdna.drei-im" ]]; then
		mkdir -v "$HOME/.var/app/io.github.legdna.drei-im"
	fi

	if [[ $script_path != "$HOME/.var/app/io.github.legdna.drei-im" ]]; then
		cp -fv "$script_path/drei.sh" "$HOME/.var/app/io.github.legdna.drei-im/drei.sh"
		cp -rfv "$script_path/DATA" "$HOME/.var/app/io.github.legdna.drei-im/DATA"
		cp -rfv "$script_path/LANG" "$HOME/.var/app/io.github.legdna.drei-im/LANG"
		cp -fv "$script_path/DATA/ICONS/drei.png" "$HOME/.local/share/icons/drei/drei.png"
		printf "$DREI_IM" > "$HOME/.local/share/applications/drei-im.desktop"
	fi
fi

if [[ ! -d "$HOME/.config/drei" ]]; then
	mkdir -v "$HOME/.config/drei"
fi
if [[ -f $HOME/.config/drei/davinci.edition ]]; then
	rm -fv $HOME/.config/drei/davinci.edition
fi

case $davinci_choice in
	1)
		printf "1" > $HOME/.config/drei/davinci.edition ;;
	2)
		printf "2" > $HOME/.config/drei/davinci.edition ;;
esac

clear

case $old_install_check in
	0)
		printf "$INSTALL_OUTPUT" ;;
	1)
		printf "$UPDATE_OUTPUT" ;;
	2)
		printf "$REINSTALL_OUTPUT" ;;
esac

exit 0