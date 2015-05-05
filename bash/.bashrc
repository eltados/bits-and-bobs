alias bounced='sudo /etc/init.d/datacash-authd restart;sudo /etc/init.d/datacash-bankd restart;sudo /etc/init.d/datacash-redsimd restart;sudo /etc/init.d/datacash-tcp-proxy restart;sudo /etc/init.d/tomcat6 restart;sudo /etc/init.d/apache2 restart'
alias bouncedall='sudo /etc/init.d/datacash-authd restart;sudo /etc/init.d/datacash-bankd restart;sudo /etc/init.d/datacash-redsimd restart;sudo /etc/init.d/datacash-tcp-proxy restart;sudo /etc/init.d/tomcat6 restart;sudo /etc/init.d/squid restart;sudo /etc/init.d/apache2 restart'
alias bouncedauthd='sudo /etc/init.d/datacash-authd restart;sudo /etc/init.d/datacash-bankd restart;'
alias redep='cd "./$1"'
alias bb='debuild -uc -us'
alias ii='sudo dpkg -i $1'
alias reloadrc='source ~/.bashrc'
alias my='mysql-regression-tests -uroot data_dict_test --auto-rehash'
alias my-generaldb='mysql-generaldb-txn -uroot --auto-rehash'
alias s9m='mysql-regression-tests -uroot s9m --auto-rehash'
alias rep_conf='mysql-regression-tests-repconfdb -uroot rep_conf --auto-rehash'
alias myreg='mysql-regression-tests -uroot regtest --auto-rehash'
alias h='history'
alias g='grep --color'
alias ll='ls -l'
alias gti='git'
alias prc-tidsetup='wget -O /tmp/jenkins.out http://vm-001-lenny-jenkins-main:8080/job/Run%20datacash-tidsetup-testing%20on%20vm-007-lenny-damn-client/lastBuild/consoleText;  echo "100 * `grep -o "Running" nohup.out  | wc -w` / `grep -o "Running" /tmp/jenkins.out  | wc -w ` " | bc; echo `grep "Total time:" /tmp/jenkins.out`;'
alias prc-reporting='wget -O /tmp/jenkins.out http://vm-001-lenny-jenkins-main:8080/job/Run%20datacash-reporting-testing%20on%20vm-006-lenny-reporting-client/lastBuild/consoleText;  echo "100 * `grep -o "Running" nohup.out  | wc -w` / `grep -o "Running" /tmp/jenkins.out  | wc -w ` " | bc; echo `grep "Total time:" /tmp/jenkins.out`;'
alias prc-dpg='cat nohup.out ; tail log/regtest_log; cat log/regtest_log | g "result \["; cat log/regtest_log |  g "result \[0\|\[test crash";tail -f log/regtest_log |  g "result \[0\|\[crash"'
alias reloaddpg='sudo cp lib/DataCash/ /usr/lib/perl5/ -r;sudo /etc/init.d/datacash-authd restart'
alias git-last='git-for-each-ref --format="%(tag)" --count=1 --sort=-taggerdate refs/tags/debian refs/tags/productionrelease'
alias monitor='cat nohup.out ; tail log/regtest_log; cat log/regtest_log | g "result \["; cat log/regtest_log |  g "result \[0";tail -f log/regtest_log |  g "result \[0"'
alias lsd="ls -d */"
alias run-baby-run="dc-vm-devhost-clean; rm -fr nohup.out; nohup ./harness -KFZ "
alias smc="dmc -xd -I ./std_merchant_config -P"
alias pr="cd /home/www/datacash/releases/"
alias dd="~/git/tools/mpm/mpm-crp-diff"
alias ddd="~/git/tools/mpm/mpm-crp-diff"
alias foreach="~/git/tools/mpm/mpm-foreach"
alias gc="git clone git:/home/git/$1 ; cd $1 ; git checkout  origin/$2 -b $2"
alias git-sync="cd `echo  \`git config --get remote.origin.url\``; git status;cd -; git pull"
alias git-local="git clone `pwd` `echo ~/local/\`basename \\\`pwd\\\` \``"
alias mount-win="sudo apt-get install cifs-utils;mkdir ~/vm-share ; sudo mount -t cifs //EDIUSRDSK050/vm-share  ~/vm-share  -o user=mpm,username=mpm,workgroup=DATACASH,uid=mpm; "
alias ppp="basename \`pwd\`"
alias rb="ruby1.9.3 -W0 ~/git/investigation/user-scripts/mpm/cmd.rb"
alias mmp="ruby1.9.3 ~/git/investigation/user-scripts/mpm/mmp.rb"
alias rename="ruby1.9.3 ~/git/investigation/user-scripts/mpm/rename.rb"
alias jen="ruby1.9.3 ~/git/investigation/user-scripts/mpm/jenkins.rb"
alias processor="/usr/share/bin/dc-mmp-processor.sh"
alias parent="git rev-list --first-parent "origin/master"  | head -n1 | git describe --abbrev=0"
alias dd="sudo echo 'go';git commit -a --amend  ; dc-git-buildpackage -ic HEAD ;  bounced"
alias ui="sudo echo 'go';git commit -a --amend ; dc-git-buildpackage -ic HEAD ;  dc-vm-devhost-deploy-webapps mmp"
alias install_ruby="sudo apt-get -y install ruby1.9; sudo apt-get install -y rubygems1.9 ;sudo gem1.9.1 install json --http-proxy http://proxy.win.datacash.com:8080; sudo gem1.9.1 install sequel --http-proxy http://proxy.win.datacash.com:8080;  sudo gem1.9.1 install mysql --http-proxy http://proxy.win.datacash.com:8080;  sudo gem1.9.1 install trollop --http-proxy http://proxy.win.datacash.com:8080;  sudo gem1.9.1 install rake --http-proxy http://proxy.win.datacash.com:8080;sudo gem1.9.1 install bundler --http-proxy http://proxy.win.datacash.com:8080; sudo gem1.9.1 install grit --http-proxy http://proxy.win.datacash.com:8080; sudo gem1.9.1 install jenkins_api_client --http-proxy http://proxy.win.datacash.com:8080"
alias update_jenkins="git checkout  mmp_phase_8a_jenkins;  git merge  phase_8a_view; git push origin mmp_phase_8a_jenkins;  git checkout  phase_8a_view"
alias update_lang="cd ../datacash-mmp-localisation/ ;  git commit  -am 'Add more keys' --amend ;dc-git-buildpackage -ic HEAD; bounced; cd -"
alias dep_install="groovy ~/vm-share/dc-dependencies/install_dependencies.groovy"
alias jenkins_test="git tag mpm_test; git push origin mpm_test"
export EDITOR=vi # unless you like nano (in which case seek help) set this to the editor of your choice
export EMAIL='mathieu.patureau@datacash.com' 
export http_proxy=http://proxy.win.datacash.com:8080
export HTTP_PROXY=http://proxy.win.datacash.com:8080
# git config --global http.proxy http://proxy.win.datacash.com:8080

. ~/git/tools/z.sh


review() {
  if [  $# -ne 1 ]
  then
    echo "dc-sign-doc -a \"Reviewer\" -m \"Review ok\" pr-files-chksums.txt"
  else
    echo "dc-sign-doc -a \"Reviewer\" -m \"Review ok\" $1"
  fi
}



function makehup {
  local dest=`echo "/home/www/$1" |  sed 's~http://intranet.ed.datacash.com/\(.*\)/[^/]*~\1~'`
  local file=`echo $1 |  sed 's~http://intranet.ed.datacash.com/.*/\([^/]*\)~\1~'`
  ssh edioffsrv001 "mkdir -p $dest "
  scp -q nohup.out  edioffsrv001:$dest/$file
  ssh edioffsrv001 "chmod 644 $dest/$file"
  echo "nohup COMPLETE"
}

function valmorph {
  echo "I'm making your VM just like theirs..."
#  dc-pkg-versions > ~/packages.txt && echo - >> ~/packages.txt && scp /home/dfm/packages.txt edioffsrv001://home/dfm/public_html &> /dev/null
  GET "http://localhost/dc_compare_regtest_package_lists?from=localhost&to=$1&.submit=Submit+Query" | grep -e '^dc-git-buildpackage' -e 'apt-get' | sed 's|<.*>$||' | sed 's/apt-get remove/sudo apt-get remove -y/' | sh &> /tmp/valmorph
  less /tmp/valmorph | grep 'Preparing to replace'
  local commit=`GET "$1" | grep 'Commit ID:'`
  echo "Make your regtest branch point $commit"
  echo "VALMORPHANISATION COMPLETE!";
}

function cc () {
  local dir=`/home/dfm/workspace/.dc-url2dir.pl $1`;
  cd $dir
}

function git_diff_origin_current_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "git diff origin/${ref#refs/heads/}"
  git diff origin/${ref#refs/heads/}
}


function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

function parse_git_hash {
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "($ref)"
}

function parse_deb_changelog {
  echo `grep "\((.*)\) " debian/changelog -m 1 -o  2> /dev/null`
#  /usr/bin/perl ~/getDebVer.pl
}

export PS1="\[\033[0;32m\][\\h] \[\033[0;35m\]\\w \[\033[0;33m\]\$(parse_git_hash)\$(parse_git_branch)\$(parse_deb_changelog)\[\033[1;37m\]$ "


#file_list() {
#  echo "<ul>";for f in `ls`; do echo "  <li><a href="$f">$f</a></li>"; done;echo "</ul>";
#}


dl() {
  if [  $# -ne 1 ]
  then
    action=${PWD##*/}
  else
    action=$1
  fi
  echo "" 
  echo "========" 
  echo "Downloaded $action.out from  http://vm-sdt-mmp-jenkins-master:8080/job/mpm__$action/lastBuild/consoleText " 
  wget -qO- http://vm-sdt-mmp-jenkins-master:8080/job/mpm__$action/lastBuild/consoleText > $action.txt
  echo "========" 
  tail $action.txt
}

dlall() {
 for t in libdatacash-mmp-common-java pre-checks dc-mmp-webservice-testing dc-mmp-webservice dc-mmp-ui-testing dc-mmp-ui dc-mmp-processor-testing ; do
  dl $t 
 done
 for t in `ls` ; do  echo "<li><a href='testing/$t'>$t</a></li>" ; done
}


  
  
current_folder() {
  current_folder=${PWD##*/}
  echo $current_folder
}

jrun(){
  if [  $# -ne 1 ]
  then
    action=${PWD##*/}
  else
    action=$1
  fi
  wget -qO- http://vm-sdt-mmp-jenkins-master:8080/job/mpm__$action/build?delay=0sec > /dev/null
  echo "Run \"$action\" on Jenkins"
}

jrun2(){
  if [  $# -ne 1 ]
  then
    action=${PWD##*/}
  else
    action=$1
  fi
  wget -qO- http://vm-sdt-mmp-jenkins-master:8080/job/mpm2__$action/build?delay=0sec > /dev/null
  echo "Run \"$action\" on Jenkins"
}

_jrun() {
    local cur opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=$(ls -d ../*/. | sed 's|../||'  | sed 's|/\.||')
    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F _jrun jrun

push(){
  git status;
  git tag -f  z_mpm_test ; 
  git push origin z_mpm_test;
}

remove_test_tag(){
  git tag -d z_mpm_test ; git push origin :refs/tags/z_mpm_test
}


pre() {
  echo ${PWD##*/}  
  dc-perform-pre-checks  >  ../${PWD##*/}-pre-check.out 
  cat  ../${PWD##*/}-pre-check.out
}



sign() {
  if [  $# -ne 2 ]
  then
    echo "cvs commit -m '$1' ; dc-generate-files-chksums; dc-sign-doc  -a 'Author'   -m  '$1' pr-files-chksums.txt"
  else
    echo "cvs commit -m '$1'  $2;  dc-sign-doc  -a 'Author'  -m  '$1' $2"
  fi
}


export CVS_RSH="ssh"
export CVSROOT=":ext:stoney.ed.datacash.com:/home/cvs"
export PRCS_REPOSITORY=/home/prcs
export PRCS_LOGQUERY=1
export JAVA_HOME=/usr/local/java
export ANT_HOME=/usr/share/ant
export PATH=${PATH}:${ANT_HOME}/bin






# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi



function makehup {
  local dest=`echo "/home/www/$1" |  sed 's~http://intranet.ed.datacash.com/\(.*\)/[^/]*~\1~'`
  local file=`echo $1 |  sed 's~http://intranet.ed.datacash.com/.*/\([^/]*\)~\1~'`
  ssh edioffsrv001 "mkdir -p $dest "
  scp -q nohup.out  edioffsrv001:$dest/$file
  ssh edioffsrv001 "chmod 644 $dest/$file"
  echo "nohup COMPLETE"
}

function valmorph {
  echo "I'm making your VM just like theirs..."
#  dc-pkg-versions > ~/packages.txt && echo - >> ~/packages.txt && scp /home/dfm/packages.txt edioffsrv001://home/dfm/public_html &> /dev/null
  GET "http://localhost/dc_compare_regtest_package_lists?from=localhost&to=$1&.submit=Submit+Query" | grep -e '^dc-git-buildpackage' -e 'apt-get' | sed 's|<.*>$||' | sed 's/apt-get remove/sudo apt-get remove -y/' | sh &> /tmp/valmorph
  less /tmp/valmorph | grep 'Preparing to replace'
  local commit=`GET "$1" | grep 'Commit ID:'`
  echo "Make your regtest branch point $commit"
  echo "VALMORPHANISATION COMPLETE!";
}

function cc () {
  local dir=`/home/dfm/workspace/.dc-url2dir.pl $1`;
  cd $dir
}

function git_diff_origin_current_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "git diff origin/${ref#refs/heads/}"
  git diff origin/${ref#refs/heads/}
}


function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

function parse_git_hash {
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "($ref)"
}

function parse_deb_changelog {
  echo `grep "\((.*)\) " debian/changelog -m 1 -o  2> /dev/null`
#  /usr/bin/perl ~/getDebVer.pl
}

export PS1="\[\033[0;32m\][\\h] \[\033[0;35m\]\\w \[\033[0;33m\]\$(parse_git_hash)\$(parse_git_branch)\$(parse_deb_changelog)\\n\[\033[1;37m\]$ "


export JAVA_HOME=/usr/local/java
export ANT_HOME=/usr/share/ant
export PATH=${PATH}:${ANT_HOME}/bin
export CATALINA_HOME=/usr/share/tomcat5
export AXIS2_HOME=~/workspace/datacash-axis2
export HISTCONTROL=ignoredups

# If not running interactively, don't do anything
export CVS_RSH="ssh"
export CVSROOT=":ext:edioffsrv001.ed.datacash.com:/home/cvs"
export PRCS_REPOSITORY=/home/prcs
export PRCS_LOGQUERY=1

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

restart_dbs ()
{
  ls /etc/init.d/mysql-* | grep -v "4.1" | grep -v "ndb" | xargs -i sudo {} restart
  dc-vm-devhost-install-sa-keys
  mysql-regression-slave -u root -e "slave start"
}

function clone() {
  if [ -n "$1" ]; then
    git clone git:/home/git/$1
  else
    echo "Usage : clone <repo>"
  fi
}

function checkout() {
  if [ -n "$1" ]; then
    git checkout $1
  else
    echo "Usage : checkout <branch>"
  fi
}

function status() {
  git status
}

function dif() {
  git diff
}

function log() {
  git log --decorate
}

function commit(){
  if [ -n "$1" ]; then
    git commit -a -m "$1"
  else
    echo "Usage : commit <commit message>"
  fi
}

#function buildlocal() {
#  if [ -n "$1" ]; then
#    dc-git-buildpackage -ci $1
#  else
#    echo "Usage : buildlocal <package version to build>"
#  fi
#}

function build() {
   if [ -n "$1" ];
   then
     if [ -n "$2" ];
     then
       dc-git-buildpackage -pi $1 $2
     else
       dc-git-buildpackage -pi $1 master
     fi
   else
     echo "Usage : build <package name> <branch name>"
   fi
}

function parse_git_branch_for_building {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function buildlocal() {
  dc-git-buildpackage -ci $(parse_git_branch_for_building)
}

function version() {
  if [ -n "$1" ]; then
    dpkg -l | grep $1
  else
    echo "Usage : version <package name>"
  fi
}
