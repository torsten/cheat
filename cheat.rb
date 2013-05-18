#!/usr/bin/env ruby
# Self-contained ruby script & database to remember uncommon shell commands
# and search for them using the command line.
#
# Originally written by Torsten Becker <torsten.becker@gmail.com> in 2012.
#
# Usage: cheat.rb [SEARCHTERM]
#    If SEARCHTERM is given, cheat.rb lists only cheats that contain this term.
#    Otherwise lists all cheats.
#
# To customize: Extend this file at the bottom and add your own cheats.


# ANSI Codes: http://www.termsys.demon.co.uk/vtansi.htm
# 0: reset all
# 1: bright
# 2: dim colors
# 4: underscore
# 31: red foreground
# 33: yellow fg

# Highlight matches with a underlined yellow
HIGHLIGHT = "\033[0;2;4;33m"

def print_tip header, body, search_term=nil
  if search_term
    regex = /#{Regexp::escape(search_term)}/i
    header.gsub! regex do |match|
      HIGHLIGHT + match + "\033[0;1m"
    end
    body.gsub! regex do |match|
      HIGHLIGHT + match + "\033[0m"
    end
  end
  print "\033[1m#{header}\033[0m"
  puts body
end


tips = DATA.read.split(/^(\S.+)$/)
tips.shift # first element is always the empty string

# Transform string into a list of tuples
tips = tips.inject([]) do |memory, this|
  if memory.last and memory.last.size <= 1
    memory.last << this
  else
    memory << [this]
  end
  memory
end

search = ARGV.shift
if search
  search = search.downcase
  tips.each do |header, body|
    h = header.downcase
    b = body.downcase
    if h.include? search or b.include? search
      print_tip header, body, search
    end
  end
else
  tips.each(&method(:print_tip))
end

# Add more cheats here:
__END__
Update port list and MacPorts itself:

  sudo port selfupdate

List outdated ports:

  port outdated
    
List installed ports

  port installed

Clean ports

  sudo port uninstall inactive
  sudo port clean --all installed

Upgrade/update existing port without dependency update

  sudo port upgrade -n git-core

Changes MAC address:

  sudo ifconfig en1 ether 00:11:22:33:44:55
  
Delete SVN directories:

  find . -name .svn -print0 | xargs -0 rm -rf

Showing extended file attributes and recover source URL of web downloads:

  ls -@ video.m4v 
    -rw-r--r--@ 1 root    staff   2.7M Nov 17 00:34 video.m4v
    	com.apple.metadata:kMDItemWhereFroms	 157B 
  xattr -p com.apple.metadata:kMDItemWhereFroms video.m4v | \
  ruby -ne 'print [$_.gsub /\s/,""].pack("H*")'
      bplist00?_@http://cloud.github.com/downloads/...

Saving as root from within an unprivileged vim:

  :w !sudo tee % > /dev/null

Finding files:

  find /pathname -iname '*.md'

Flush DNS Cache:

  dscacheutil -flushcache

Tarballing without ._* and .DS_Store files:

  COPYFILE_DISABLE=true tar vzcf archive.tgz --exclude=.DS_Store folder

Stopping a crashing xinit:

  launchctl remove org.x.startx

Mounting a ramdisk:

  diskutil erasevolume HFS+ "ramdisk" `hdiutil attach -nomount ram://1165430`

Generating the raw data for a git impact chart ala GitHub:

  git log --pretty=tformat:'---'%at --numstat

Remove *.pyc files:

  find . -iname '*.pyc' | xargs -n1 rm

Print bit-size and fingerprint of all local SSH public keys:

  for i in ~/.ssh/*.pub; do ssh-keygen -l -f "$i"; done

Search zsh history:

  !ssh            # Starts with "ssh"
  !?ivy           # Contains "ivy" anywhere
  !!              # Last typed command
  <Ctrl-R>word    # Incrementally start searching in history

Search for assets and copy them to somewhere else:

  find . -iname 'WKRounded*.png' -print0 | xargs -0 -J% -n1 cp % ~/tmp

  # -print0 and -0 allow spaces in filenames
  # -J% sets % as a replacement character for the command.

Recursively searching for file contents using grep:

  # pattern file/folder
  grep -R WKSpringboardIcon512 .

Do something for each file in a loop:

  for FILE in *.rb; do; wc -c $FILE; done

Undo last git commit:

  git reset --soft HEAD^

Stage only some selected chunks of a diff for committing:

  git add -p filename.x

List available Wi-Fi/WLAN networks and their channels:

  /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s

Remove/delete a remote branch:

  git push origin :torsten/some-branch-name

Redo/revert/undo a Git commit:
  
  git commit --amend

Redirect/pipe stderr:

  git status > /dev/null 2>&1

Fork a public repo as a private one
 
  # https://help.github.com/articles/duplicating-a-repo
  git clone --bare https://github.com/exampleuser/REPO.git
  cd old-repo.git
  git push --mirror git@github.com:6wunderkinder/REPO.git

Find out which process is listening to DNS port 53:

  sudo lsof -n -i4TCP:53

Shell infinite loop:

  while true; do echo 'some something FOREVER'; sleep 1; done

Generate release notes from git history:

  git log --no-merges --pretty=format:"  * %s (%an)" hockeyapp...master

In vim: When searching via / clear highlight:

  :noh

In vim: Commenting code:

  " Commenting using nerdcommenter
  Visual mode (v); mark text; <Leader>cc
  " Uncommenting:
  v; mark text; <Leader>cu

In vim: Block editing:
 
  " CTRL-V: Visual block mode
  Move to mark lines (jjj...); jump to end of line ($); Append (A); insert text; ESC
  " To inset in the beginning:
  Visual block; mark lines; Insert in beginning (I); insert text; ESC

Show all files that changed in the last week:

  git log --pretty=format: --name-only --since="7 days ago" | sort -u

Pattern rename all files in a directory:

  # Renames all files from .jpeg to $.jpg
  find . -name "*.jpeg" | while read file; do mv $file .`echo $file|cut -d. -f2`.jpg; done

Switch between the last two open files in vim:

  Ctrl-^

Change date of previous commit:

  # There are author and committer date, this changes both:
  export GIT_COMMITTER_DATE="Fri Apr 26 19:40:11 2013 -0600"
  git commit --amend --date="Fri Apr 26 19:40:11 2013 -0600"

Add a new root branch (or "orphaned" branch):

  # http://stackoverflow.com/a/9538427/278705
  cd /path/to/repo
  git symbolic-ref HEAD refs/heads/gh-pages
  rm .git/index
  git clean -fdx

Inside screen session, scroll up to see history

  Hit C-a [
  Then normal vim movements: hjkl and:
  G -    Moves to the specified line (defaults to the end of the buffer).
  C-u -  Scrolls a half page up.
  C-b -  Scrolls a full page up.
  C-d -  Scrolls a half page down.
  C-f -  Scrolls the full page down.

