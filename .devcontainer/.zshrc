autoload -U colors && colors
precmd() {
   drawline=""
   for i in {1..$COLUMNS}; drawline=" $drawline"
   drawline="%U${drawline}%u"
   PS1="%F{252}${drawline}
%B%F{124}%n:%~>%b%f "
}

eval $(opam env)

alias ls="ls --color"

export QEMU_LD_PREFIX=/usr/x86_64-linux-gnu

