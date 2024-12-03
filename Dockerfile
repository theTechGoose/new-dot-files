FROM sickcodes/docker-osx:latest

ENV DISPLAY=${DISPLAY:-:0.0} \
    GENERATE_UNIQUE=true \
    CPU=Haswell-noTSX \
    CPUID_FLAGS="kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on" \
    MASTER_PLIST_URL=https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-custom-sonoma.plist \
    SHORTNAME=sonoma

WORKDIR /dotfiles
Copy ./scripts /dotfiles/scripts

# Install Brew
RUN ./scripts/install-brew

# Set environment variables for Brew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
ENV MANPATH="/home/linuxbrew/.linuxbrew/share/man:${MANPATH}"
ENV INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH}"

# Install dependencies
RUN sudo pacman -S --noconfirm base-devel

# Use Brew to install packages
RUN brew install gcc neovim zsh

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
COPY . /dotfiles
RUN ./scripts/fix-git
