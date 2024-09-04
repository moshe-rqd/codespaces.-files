#!/bin/zsh
/workspaces/.codespaces/.persistedshare/dotfiles/
mcd /tmp/setup-emacs/

#TODO: less hardcoding and mitigate implicit assumptions of file names
#CONSIDER: using wget
alias dl=curl\ -LO # -sS
dl https://ftp.gnu.org/gnu/gnu-keyring.gpg
dl https://ftp.wayne.edu/gnu/emacs/emacs-29.4.tar.xz
dl https://ftp.gnu.org/gnu/emacs/emacs-29.4.tar.xz.sig
gpg --verify --keyring=./gnu-keyring.gpg ./emacs-29.4.tar.xz{.sig,}

tar -vx -f ./emacs-29.4.tar.xz

sudo apt install libgccjit-10-dev
sudo apt install libjansson-dev
sudo apt install texinfo

git clone https://github.com/tree-sitter/tree-sitter/
./tree-sitter/
make #TODO: compilation flags, etc.
sudo make install

./configure  --prefix=~  --datarootdir="$XDG_DATA_HOME"  --program-suffix=-nw  --enable-gtk-deprecation-warnings=no  --enable-gcc-warnings=no --enable-check-lisp-object-type=no --enable-link-time-optimization=yes --disable-silent-rules  --disable-acl  --without-mailutils --without-pop --without-kerberos{,5} --without-hesiod  --without-sound  --with-x-toolkit=no --with-wide-int --without-{xpm,jpeg,tiff,gif,png,rsvg,webp} --with-sqlite3  --with-libsystemd  --with-json --with-tree-sitter  --without-harfbuzz  --without-toolkit-scroll-bars  --with-pgtk=no  --with-modules --with-threads  --with-native-compilation=aot --without-x --with-libgmp --with-included-regex CFLAGS='-Wall -Wextra -ggdb3 -fno-omit-frame-pointer -pipe -march=native -O2 -ftree-vectorize -fpeel-loops -ffat-lto-objects'
export LD_LIBRARY_PATH=/usr/local/lib/
make --jobs="$(nproc)"


mkdir "$XDG_CONFIG_HOME/emacs"/{,packages,sessions}/
mkdir "$XDG_CONFIG_HOME/emacs"/{config,data,eln-cache,themes,undo}

cp -t "$XDG_CONFIG_HOME/emacs/" -- ../config/emacs/*


"$XDG_CONFIG_HOME/emacs/packages/"

gelpa_stock_repo_clone() { for arg ("$@") git clone --verbose --branch=externals/"$arg" --single-branch https://git.savannah.gnu.org/git/emacs/elpa.git "$arg" }
gelpa_stock_repo_clone compat
git clone --verbose --recursive https://github.com/emacscollective/no-littering
gelpa_stock_repo_clone vertico corfu vundo marginalia dash seq transient avy
() { for arg ("$@") git clone --verbose --branch=elpa/"$arg" --single-branch https://git.savannah.gnu.org/git/emacs/nongnu.git "$arg" } with-editor
git clone --verbose --recursive https://codeberg.org/ideasman42/emacs-undo-fu-session
for arg (Wilfred/{helpful,elisp-refs} magnars/s.el rejeep/f.el bbatsov/crux magit/magit emacs-rustic/rustic dacap/keyfreq) git clone --verbose --recursive https://github.com/"$arg"
./magit/
make
