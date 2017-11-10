alias be="bundle exec"
alias bec="bundle exec cucumber"
alias ber="bundle exec rake"
alias feeling-lucky="git pull --rebase && ber && gps"
which -s hub && alias git=hub
alias ga="git add"
alias gaun="git add -N"
alias gb="git branch"
alias gc="git commit"
alias gca="git commit -a"
alias gci="git commit -v --interactive"
alias gc-a"mend=git commit --amend -C HEAD"
alias gco="git checkout"
alias gcp="git cherry-pick"
alias gd="git diff --word-diff"
alias gdc="git diff --cached"
alias gl="git log --name-status"
alias gls="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gpl-with-stash="gss && gpl && gsp"
alias grc="git rebase --continue"
alias gra="git rebase --abort"
alias gs="git status"
alias gsa="git stash apply"
alias gsl="git stash list"
alias gsp="git stash pop"
alias gss="git stash save"
alias rdoc="bundle exec gem list --local | sed 's/ .*//g' | xargs -P 30 -L 1 gem rdoc"
alias fm="bundle exec foreman start -f Procfile.dev"
alias ll="ls -alh"
alias lr='ls -hartl'
alias gpl="git pull --rebase"
alias gps="git push"
alias gpsu="git push -u origin HEAD" # Push the current branch upstream

alias ducks='du -cks * | sort -rn|head -11' # Lists the size of all the folders$
alias top='top -o cpu'
alias systail='tail -f /var/log/system.log'
alias profileme="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

alias p='echo "PATH=:$PATH" | tr : "\n"'

alias wip='git commit -am WIP'

# Source: https://blog.engineyard.com/2013/bundler-hacking
function back() {
  ack "$@" `bundle show --paths`
}
