#!/usr/bin/env bash

#TODO: fzf installation

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. $dir/echo_message

! ping -c2 example.org &>/dev/null && echo_message error "Sin conexión a internet." && exit 1
! command -v sudo &>/dev/null && echo_message error "sudo no está instalado o no es ejecutable." && exit 2

echo_message info "Actualizando repositorios..." && sudo apt update &>/dev/null && echo_message success "Repositorios actualizados."
echo_message info "Comprobando e instalando dependencias..."
sudo apt install -y curl wget unzip &>/dev/null && echo_message success "Dependencias instaladas correctamente."

#######################################################################################


# Installation functions
install_i3 () {
    echo_message info "\nInstalando i3..."
    sudo apt install -y i3 picom dunst py3status rofi libnotify-bin playerctl pavucontrol xbacklight feh network-manager-gnome xdo xdotool arandr xclip lxappearance diodon unclutter-xfixes colordiff dbus-x11 && echo_message && \

# Install i3-gaps for Debian 11 bullseye
    if echo $(lsb_release -ds) | grep -q "Debian"; then
        echo_message info "\nInstalando i3-gaps..."
        command -v i3 &>/dev/null && sudo apt remove -y i3 i3-wm
        curl -s https://api.github.com/repos/barnumbirr/i3-gaps-debian/releases/latest \
            | grep "browser_download_url" \
            | grep "bullseye.deb\"" \
            | awk '{print $2}' \
            | tr -d \" \
            | xargs wget -nv -O "/tmp/i3gaps.deb" \
        && sudo apt install -y "/tmp/i3gaps.deb" && echo_message success "\ni3-gaps instalado correctamente."
    fi
}

install_nerdfont () {
    if fc-list | grep -q 'Roboto Mono Nerd Font'; then
        echo_message success "\nRoboto Mono Nerd Font ya se encuentra instalado."
    else
        if [ -e /tmp/RobotoMono.zip ]; then
            echo_message info "\nContinuando la instalación de Roboto Mono Nerd Font..."
            sudo unzip /tmp/RobotoMono.zip -d /usr/share/fonts/truetype/roboto_mono_nerd_font
        else
            echo_message info "\nInstalando Roboto Mono Nerd Font..."
            curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
            | grep "browser_download_url" \
            | grep "RobotoMono.zip" \
            | awk '{print $2}' \
            | tr -d \" \
            | xargs wget -nv -O /tmp/RobotoMono.zip \
            && sudo unzip /tmp/RobotoMono.zip -d /usr/share/fonts/truetype/roboto_mono_nerd_font
        fi
    fi
}

install_git () {
    if ! command -v git &>/dev/null ; then
        echo_message info "\nInstalando git..." && sudo apt install -y git && echo_message success "\ngit instalado correctamente."
    fi

    [ ! -d $HOME/.local/bin ] && mkdir -p $HOME/.local/bin && echo_message success "\nDirectorio ~/.local/bin creado."

    if command -v diff-so-fancy &>/dev/null; then
        echo_message info "\ndiff-so-fancy ya está instalado."
    else
        echo_message info "\nInstalando diff-so-fancy..."
        curl -s https://api.github.com/repos/so-fancy/diff-so-fancy/releases/latest \
        | grep "browser_download_url" \
        | grep "diff-so-fancy" \
        | awk '{print $2}' \
        | tr -d \" \
        | xargs wget -nv -O $HOME/.local/bin/diff-so-fancy \
        && chmod +x $HOME/.local/bin/diff-so-fancy \
        && PATH="$HOME/.local/bin:$PATH" git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX" \
        && echo_message success "\ndiff-so-fancy instalado correctamente."
    fi
}

install_mpv () {
    if ! command -v mpv &>/dev/null; then
        echo_message info "\nInstalando mpv..."
        sudo apt install mpv && echo_message success "\nmpv instalado correctamente."
    fi

    ## mpv-mpris
    echo_message info "\nInstalando mpv-mpris..."
    curl -s https://api.github.com/repos/hoyon/mpv-mpris/releases/latest \
    | grep "browser_download_url" \
    | grep ".so\"" \
    | awk '{print $2}' \
    | tr -d \" \
    | xargs wget -nv -O $HOME/.config/mpv/scripts/mpris.so && echo_message success "\nmpv-mpris instalado correctamente."
}

install_evince () {
    if command -v evince &>/dev/null; then
        sudo ln -s /etc/apparmor.d/usr.bin.evince /etc/apparmor.d/disable/usr.bin.evince
        sudo /etc/init.d/apparmor restart
    fi
}

install_pynvim () {
    echo_message info "\nInstalando python3-pip..."
    sudo apt install -y python3-pip && \
        echo_message success "\npython3-pip instalado correctamente." && \
        echo_message info "\nInstalando pynvim..." && python3 -m pip install pynvim && echo_message success "\npynvim instalado correctamente."
}

# install_X11 () {
#     echo_message info "\nInstalando ficheros de configuración de X11..."
#     bash $dir/X11/install.sh && echo_message success "Ficheros de configuración de X11 instalados correctamente."
# }

install_dmenu () {
    echo_message info "\nInstalando dmenu..."
    sudo apt install -y libx11-dev libxinerama-dev libxinerama-dev libxft-dev
    sudo git clone https://git.suckless.org/dmenu /opt/dmenu && \
        cd /opt/dmenu || return
        sudo git apply $dir/dmenu/dmenu-config.diff && \
        echo_message success "dmenu disponible en /opt/dmenu"
        echo_message warning "Recuerda compilar dmenu desde el directorio de la aplicación:\n    sudo make && sudo make install"
}

install_gtk () {
    if [ -d /usr/share/themes/Gruvbox-Material-Dark ] && [ -d /usr/share/icons/Gruvbox-Material-Dark ]; then
        echo_message info "\nTema GTK e iconos ya instalados."
    else
        echo_message info "\nInstalando tema gtk..."
        git clone https://github.com/sainnhe/gruvbox-material-gtk.git /tmp/gruvbox-material-gtk && \
            sudo mv /tmp/gruvbox-material-gtk/themes/Gruvbox-Material-Dark /usr/share/themes && \
            sudo mv /tmp/gruvbox-material-gtk/icons/Gruvbox-Material-Dark /usr/share/icons && \
        echo_message success "Tema gtk instalado correctamente."
        echo_message warning "Actualiza el tema gtk con lxappearance."
    fi
}

install_zsh () {
    echo_message info "\nInstalando zsh.." && sudo apt install -y zsh && echo_message success "\nzsh instalado correctamente."
    echo_message info "\nInstalando oh-my-zsh..."
    [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh" ] && rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"
    [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/zsh" ] && rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
    ZSH="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh" ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    # Remove default oh-my-zsh's zshrc file.
    rm -rf ~/.zshrc ~/.zshrc.pre-oh-my-zsh && \
    echo_message success "\noh-my-zsh instalado correctamente."
}

update_dirs () {
    echo_message info "\nActualizando directorios..."
    [ -d $HOME/Descargas ] && mv $HOME/Descargas $HOME/dl && xdg-user-dirs-update --set DOWNLOAD $HOME/dl
    [ -d $HOME/Documentos ] && mv $HOME/Documentos $HOME/docs && xdg-user-dirs-update --set DOCUMENTS $HOME/docs
    [ -d $HOME/Música ] && mv $HOME/Música $HOME/music && xdg-user-dirs-update --set MUSIC $HOME/music
    [ -d $HOME/Imágenes ] && mv $HOME/Imágenes $HOME/pics && xdg-user-dirs-update --set PICTURES $HOME/pics
    [ -d $HOME/Vídeos ] && mv $HOME/Vídeos $HOME/vids && xdg-user-dirs-update --set VIDEOS $HOME/vids
    echo_message success "\nDirectorios actualizados."
}

#######################################################################################


echo_message question "\n¿Realizar la preinstalación? [ 1 / 2 ]?"

pre () {
select preinstallation in "Sí" "No"; do
    case "$preinstallation" in
        Sí) 
            echo_message question "\n¿Realizar instalación completa? [ 1 / 2 ]?"
            select all in "Sí" "No"; do
                case "$all" in
                    Sí)
                        install_i3
                        install_git
                        #install_X11
                        install_dmenu
                        install_evince
                        install_gtk
                        install_mpv
                        install_nerdfont
                        install_pynvim
                        install_zsh
                        update_dirs
                        break ;;
                    No)
                        echo_message question "\nSelecciona qué deseas instalar:"
                        select all in "i3" "git" "dmenu" "evince" "gtk" "mpv" "nerdfont" "pynvim" "zsh" "update_dirs"; do
                            case "$all" in
                                i3) install_i3 ;;
                                git) install_git ;;
                                # X11) install_X11 ;;
                                dmenu) install_dmenu ;;
                                evince) install_evince ;;
                                gtk) install_gtk ;;
                                mpv) install_mpv ;;
                                nerdfont) install_nerdfont ;;
                                pynvim) install_pynvim ;;
                                zsh) install_zsh ;;
                                update_dirs) update_dirs ;;
                                # "Volver atras") break ;;
                                *) echo_message warning "Opción no disponible." ;;
                            esac
                        done ;;
                    *) echo_message warning "No sé a qué te refieres con eso." ;;
                esac
            done
        ;;
        No) echo_message info "OK!" && break ;;
        *) echo_message warning "No sé a qué te refieres con eso." ;;
    esac
done
}

pre

# Manage dotfiles
if ! command -v stow &>/dev/null; then
    echo_message info "\nInstalando stow..."
    sudo apt install -y stow &>/dev/null && echo_message success "\nstow instalado correctamente."
fi
stow -v alacritty
stow -v bat
stow -v dunst
stow -v git
stow -v i3
stow -v misc
stow -v mpv
stow -v newsboat
stow -v nvim
stow -v picom
mkdir -p $HOME/.cache/py3status && stow -v py3status
stow -v rofi
stow -v shell
stow -v wget
stow -v youtube-dl
