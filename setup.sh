#!/usr/bin/env bash
set -euo pipefail

# Colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Detect username
USER_NAME=$(whoami)

# Pretty print functions
print_header() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${MAGENTA}$1${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_step() {
    echo -e "${CYAN}▶️  $1${NC}"
}

# Installation functions
install_zsh_omz() {
    print_header "Installing Zsh & Oh-My-Zsh"
    
    # Install Zsh if not present
    if ! command -v zsh &>/dev/null; then
        print_step "Installing Zsh..."
        sudo apt-get update && sudo apt-get install -y zsh
        print_success "Zsh installed"
    else
        print_success "Zsh already installed"
    fi
    
    # Install Oh-My-Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_step "Installing Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh-My-Zsh installed"
    else
        print_success "Oh-My-Zsh already installed"
    fi
    
    # Install plugins
    print_step "Installing Zsh plugins..."
    ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
    
    [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || {
        git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
        print_success "zsh-autosuggestions installed"
    }
    
    [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || {
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
        print_success "zsh-syntax-highlighting installed"
    }
    
    [ -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ] || {
        git clone https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
        print_success "zsh-autocomplete installed"
    }
    
    # Set Zsh as default shell
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        print_step "Setting Zsh as default shell..."
        chsh -s "$(command -v zsh)" "$USER" || print_warning "Please run 'chsh -s $(which zsh)' manually and re-login"
        print_success "Zsh set as default shell"
    else
        print_success "Zsh already default shell"
    fi
}

install_docker() {
    print_header "Installing Docker"
    
    if command -v docker &>/dev/null; then
        print_success "Docker already installed"
        DOCKER_VERSION=$(docker --version)
        print_info "$DOCKER_VERSION"
    else
        print_step "Installing Docker prerequisites..."
        sudo apt-get update
        sudo apt-get install -y \
            ca-certificates \
            curl \
            gnupg \
            lsb-release
        
        print_step "Adding Docker's official GPG key..."
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        
        print_step "Setting up Docker repository..."
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        print_step "Installing Docker Engine..."
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        print_success "Docker installed successfully"
    fi
    
    # Create docker group if it doesn't exist
    if ! getent group docker > /dev/null 2>&1; then
        print_step "Creating docker group..."
        sudo groupadd docker
        print_success "Docker group created"
    else
        print_success "Docker group already exists"
    fi
    
    # Add user to docker group
    if ! groups "$USER_NAME" | grep -q docker; then
        print_step "Adding $USER_NAME to docker group..."
        sudo usermod -aG docker "$USER_NAME"
        print_success "User added to docker group"
        print_warning "You need to log out and log back in for group changes to take effect"
        print_info "Or run: newgrp docker"
    else
        print_success "User already in docker group"
    fi
    
    # Enable and start Docker service
    print_step "Enabling Docker service..."
    if sudo systemctl enable docker 2>/dev/null; then
        print_success "Docker service enabled"
    else
        print_warning "Could not enable Docker service automatically"
    fi
    
    if sudo systemctl start docker 2>/dev/null; then
        print_success "Docker service started"
    else
        print_warning "Docker service may already be running"
    fi
    
    # Check Docker service status
    if sudo systemctl is-active --quiet docker; then
        print_success "Docker service is running"
    else
        print_error "Docker service is not running. Try: sudo systemctl start docker"
    fi
    
    # Verify Docker installation
    print_step "Verifying Docker installation..."
    if sudo docker run hello-world &>/dev/null; then
        print_success "Docker is working correctly!"
    else
        print_warning "Docker test failed. You may need to restart your system."
    fi
    
    print_info "Docker Compose is included as a plugin (use: docker compose)"
}

install_nix() {
    print_header "Installing Nix Package Manager"
    
    if ! command -v nix &>/dev/null; then
        print_step "Installing Nix..."
        sh <(curl -L https://nixos.org/nix/install) --daemon
        . /etc/profile.d/nix.sh
        print_success "Nix installed"
    else
        print_success "Nix already installed"
    fi
    
    # Enable flakes
    print_step "Enabling Nix flakes..."
    mkdir -p "$HOME/.config/nix"
    if ! grep -q "flakes" "$HOME/.config/nix/nix.conf" 2>/dev/null; then
        echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"
        print_success "Flakes enabled"
    else
        print_success "Flakes already enabled"
    fi
}

install_home_manager() {
    print_header "Installing Home Manager"
    
    if ! command -v home-manager &>/dev/null; then
        print_step "Installing Home Manager..."
        nix run home-manager/master -- init --switch
        print_success "Home Manager installed"
    else
        print_success "Home Manager already installed"
    fi
}

apply_home_manager_config() {
    print_header "Applying Home Manager Configuration"
    
    if [ -f "$PWD/flake.nix" ]; then
        print_step "Applying flake configuration for $USER_NAME..."
        home-manager switch --flake .#$(whoami)
        print_success "Configuration applied"
    elif [ -f "$PWD/home.nix" ]; then
        print_warning "No flake.nix found, using home.nix"
        home-manager switch -f "$PWD/home.nix"
        print_success "Configuration applied"
    else
        print_error "No configuration file found (flake.nix or home.nix)"
    fi
}

install_stow() {
    print_header "Installing GNU Stow"
    
    if ! command -v stow &>/dev/null; then
        print_step "Installing GNU Stow..."
        sudo apt-get update && sudo apt-get install -y stow
        print_success "GNU Stow installed"
    else
        print_success "GNU Stow already installed"
    fi
}

symlink_dotfiles() {
    print_header "Symlinking Dotfiles"
    
    for dir in zsh nvim; do
        if [ -d "$PWD/$dir" ]; then
            print_step "Stowing $dir..."
            
            # Backup and remove existing config files to avoid conflicts
            if [ "$dir" = "zsh" ]; then
                if [ -f "$HOME/.zshrc" ]; then
                    print_info "Backing up existing .zshrc to .zshrc.backup"
                    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
                fi
                if [ -f "$HOME/.zshenv" ]; then
                    print_info "Backing up existing .zshenv to .zshenv.backup"
                    mv "$HOME/.zshenv" "$HOME/.zshenv.backup"
                fi
            elif [ "$dir" = "nvim" ]; then
                if [ -d "$HOME/.config/nvim" ]; then
                    print_info "Backing up existing nvim config to .config/nvim.backup"
                    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
                fi
            fi
            
            # Unstow first (clean any existing stow links)
            stow -D -v -d "$PWD" -t "$HOME" "$dir" 2>/dev/null || true
            
            # Now stow
            stow -v -d "$PWD" -t "$HOME" "$dir"
            print_success "$dir configured"
        else
            print_warning "$dir directory not found, skipping..."
        fi
    done
}

# Menu function
show_menu() {
    clear
    print_header "Dotfiles Setup Script"
    echo -e "${MAGENTA}Select installation steps:${NC}\n"
    echo -e "  ${GREEN}1)${NC} Install Zsh & Oh-My-Zsh (Run this first!)"
    echo -e "  ${GREEN}2)${NC} Install Docker & Docker Compose"
    echo -e "  ${GREEN}3)${NC} Install Nix Package Manager"
    echo -e "  ${GREEN}4)${NC} Install Home Manager"
    echo -e "  ${GREEN}5)${NC} Apply Home Manager Config"
    echo -e "  ${GREEN}6)${NC} Install GNU Stow"
    echo -e "  ${GREEN}7)${NC} Symlink Dotfiles"
    echo -e "  ${GREEN}8)${NC} Run All Steps"
    echo -e "  ${GREEN}0)${NC} Exit"
    echo -e "\n${CYAN}─────────────────────────────────────────────────────${NC}"
}

# Read function that works in both Bash and Zsh
read_choice() {
    if [ -n "${ZSH_VERSION:-}" ]; then
        # Zsh syntax
        echo -ne "${YELLOW}Enter your choice: ${NC}"
        read choice
    else
        # Bash syntax
        read -p "$(echo -e ${YELLOW}Enter your choice: ${NC})" choice
    fi
}

read_continue() {
    if [ -n "${ZSH_VERSION:-}" ]; then
        echo -ne "${CYAN}Press Enter to continue...${NC}"
        read
    else
        read -p "$(echo -e ${CYAN}Press Enter to continue...${NC})"
    fi
}

# Main logic
main() {
    # Check if running in Zsh (except first time)
    if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ] && [ -z "${ZSH_VERSION:-}" ]; then
        print_warning "Oh-My-Zsh is installed. Switching to Zsh..."
        exec zsh "$0" "$@"
    fi
    
    while true; do
        show_menu
        read_choice
        
        case $choice in
            1)
                install_zsh_omz
                print_info "Please restart your terminal or run: exec zsh"
                read_continue
                ;;
            2)
                install_docker
                read_continue
                ;;
            3)
                install_nix
                read_continue
                ;;
            4)
                install_home_manager
                read_continue
                ;;
            5)
                apply_home_manager_config
                read_continue
                ;;
            6)
                install_stow
                read_continue
                ;;
            7)
                symlink_dotfiles
                read_continue
                ;;
            8)
                install_zsh_omz
                install_docker
                install_nix
                install_home_manager
                apply_home_manager_config
                install_stow
                symlink_dotfiles
                print_header "Setup Complete! 🎉"
                print_info "Please restart your terminal or run: exec zsh"
                print_info "For Docker: Log out and log back in, or run: newgrp docker"
                exit 0
                ;;
            0)
                print_info "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please try again."
                sleep 2
                ;;
        esac
    done
}

# Run main function
main "$@"
