# my .bashrc addons
alias lsa='ls -al' # -F=adds directory slash after directories.
alias rmf='rm -rf'
alias cls='clear'
# https://www.linux.org/docs/man1/cp.html
alias cpp='cp -vRp' #-p=preserve ownership,timestamps,mode... -R=copy directory and children -v=verbose
alias skaf="skaffold dev --no-prune=false --cache-artifacts=false"

# create directory and file touch2 ./folder1/folder2/file.txt
touchy() { mkdir -p "$(dirname "$1")" && touch "$1" ; }

# run ls -al when you change directory
function cd () {
    builtin cd "$1"
    ls -al
}

LOCAL="/home/${USER}/.local/bin"
PATH="$LOCAL:$PATH"