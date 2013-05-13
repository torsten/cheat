

# Cheat

`cheat` helps you to recall uncommon shell commands.  `cheat` is super easy to extend
and completely self-contained, all code and data is in one Ruby file.


## Example Usage

Searching for all cheats that contain "git"

<img src="https://raw.github.com/torsten/cheat/attachments/screenshot@2x.png" width=675 height=300>

<small>Note the fancy highlighting of search terms.</small>


## Installation

    $ git clone git@github.com:torsten/cheat.git
    $ ln -s path/to/cheat.rb ~/bin/cheat      # Assumes that ~/bin is in your $PATH


## Usage

### Searching

    $ cheat [SEARCHTERM]

If `SEARCHTERM` is given, `cheat` lists only cheats that contain this term.
Otherwise it will list all cheats.


### Adding Cheats

Adding new cheats is as simple as opening `cheat` and adding new entries at the
end of the file:

    $ $EDITOR ~/bin/cheat

Cheats must have a title and content.  All content between two titles counts towards
the previous cheat.  This is an example of a multi-line cheat:

    Showing extended file attributes:
    
      ls -@ video.m4v 
      -rw-r--r--@ 1 torsten   staff   2.7M Nov 17 00:34 video.m4v
      	com.apple.metadata:kMDItemWhereFroms	 157B 
      xattr -p com.apple.metadata:kMDItemWhereFroms video.m4v 
    
    [Next title starts here]
    
      [Next cheat content goes here]
