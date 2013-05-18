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

def print_cheat header, body, search_term=nil
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
  matching = tips.find_all do |header, body|
    header.downcase.include? search or body.downcase.include? search
  end

  # If cheat is running in a subshell: try to print just
  # the body of that cheat so that it can be used inside backticks.
  inside_backticks = (ENV["SHLVL"] == "0")

  if inside_backticks
    if matching.length == 1
      cheat = matching.first[1].strip
      STDERR.puts "Running `#{cheat}`"
      STDOUT.puts cheat
    else
      puts "echo Found #{matching.length} cheats matching '#{search}'"
      exit 1
    end
  else
    matching.each do |header, body|
      print_cheat header, body, search
    end
  end
else
  tips.each(&method(:print_cheat))
end

# Add more cheats here:
__END__
Changes MAC address:

  sudo ifconfig en1 ether 00:11:22:33:44:55
  
Delete SVN directories:

  find . -name .svn -print0 | xargs -0 rm -rf

Showing extended file attributes:

  ls -@ video.m4v 
  -rw-r--r--@ 1 torsten   staff   2.7M Nov 17 00:34 video.m4v
  	com.apple.metadata:kMDItemWhereFroms	 157B 
  xattr -p com.apple.metadata:kMDItemWhereFroms video.m4v 

Saving as root from within an unprivileged vim:

  :w !sudo tee % > /dev/null

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

  rm **/*.pyc
