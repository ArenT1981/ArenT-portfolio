#!/bin/bash

# If you want emacs installations/configs to reside elsewhere, change these variables as necessary
# If you do so, you'll also have to edit ~/.emacs-profiles.el when generated, or manually edit the
# paths below 

# Edit below
EMACS_CONFIGS_BASE_DIR=~/.emacs-configs
SPACEMACS_STABLE=spacemacs-stable
SPACEMACS_DAILY=spacemacs-daily
# Stop editing!

cd ~

echo "This script will move your spacemacs installation, and create a cloned copy."
echo "It makes use of chemacs, a project that enables emacs to switch profile based"
echo "on a \"--with-profile\" switch specified at launch time."
echo ""
echo "If you have not already installed chemacs, you need to go and do so."
echo "Visit:"
echo ""
echo "https://github.com/plexus/chemacs"
echo ""
echo "The cloned copy is set to read only so you cannot accidentally break it!"
echo "This means you will have a guaranteed \"always working\" setup in case you"
echo "break something and have critical work to do, and a daily setup which you can"
echo "edit and experiment with as normal ('cos we all like to tinker with emacs...)."
echo ""
echo "Directory variables:"
echo ""
echo "Base: $EMACS_CONFIGS_BASE_DIR"
echo "Stable: $SPACEMACS_STABLE"
echo "Daily: $SPACEMACS_DAILY"
echo ""
echo "Spacemacs stable/backup (read only) configuration will be moved to:"
echo "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_STABLE"
echo ""
echo "Spacemacs daily/testing configuration will be moved to:"
echo "Path: $EMACS_CONFIGS_BASE_DIR/$SPACEMACS_DAILY"
echo ""
echo "Is this correct? Type \"yes\" if you wish to proceed, otherwise script will abort."
echo -n "> "

read CHOICE
if [ "$CHOICE" != "yes" ]; then
    exit 0
else
    echo "Installation moved and profile switching enabled, assuming you have installed"
    echo "chemacs. If not, you need to go and install chemacs from:"
    echo "https://github.com/plexus/chemacs"
    echo ""
    echo "You can now start spacemacs by simply launching emacs as normal"
    echo "If you break something, in your setup you always have your older working spacemacs"
    echo "which you can simply launch with:"
    echo ""
    echo "$ emacs --with-profile stable"
    echo ""
    echo "This means you can continue work as normal and fix your broken setup when you have"
    echo "time to investigate what the problem is."

# Create backups first
cp -av .emacs.d .emacs.d.bak
cp -av .spacemacs .spacemacs.bak

# Create new directories for spacemacs installation
mkdir -pv "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_STABLE/spacemacs"
mkdir -pv "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_STABLE/.spacemacs.d"

mkdir -pv "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_DAILY/spacemacs"
mkdir -pv "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_DAILY/.spacemacs.d"

# Move the spacemacs installation
cp -av .emacs.d "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_STABLE/spacemacs"
cp -av .spacemacs "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_STABLE/.spacemacs.d/init.el"

mv -av .emacs.d "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_DAILY/spacemacs"
mv -av .spacemacs "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_DAILY/.spacemacs.d/init.el"

# Now make our $SPACEMACS_STABLE installation read-only so we cannot possibly
# bork it
find "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_STABLE/spacemacs" -exec chmod a-w {} \;

# Change a few of the read only files so spacemacs doesn't complain
# These are just recently used files and perspectives layouts
# If you habitually change any other trivial settings you may need
# to add the necessary chmod command here to make the file writeable

chmod u+w "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_STABLE/spacemacs/transient/history.el"
chmod u+w "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_STABLE/spacemacs/.cache/recentf"
chmod u+w "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_STABLE/spacemacs/.cache/layouts"
chmod u+w "$EMACS_CONFIGS_BASE_DIR/$SPACEMACS_STABLE/spacemacs/.cache/savehist"

# Now create our switching profile for use with chemacs
# NOTE: if you've changed any of the variables above:
# EMACS_CONFIGS_BASE_DIR, SPACEMACS_STABLE, or SPACEMACS_DAILY
# You'll have to manually edit the paths below
# Or edit the resultant file ~/.emacs-profiles.el
# Before running emacs for the first time

cat << EOF > ~/.emacs-profiles.el
(
 ("stable" . (
	       (user-emacs-directory . "~/.emacs-configs/spacemacs-stable/spacemacs")
		(env . (("SPACEMACSDIR" . "~/.emacs-configs/spacemacs-stable/.spacemacs.d")))))
 ("doom" . (
	       (user-emacs-directory . "~/.emacs-configs/doom-stable/doom")
		(env . (("DOOMDIR" . "~/.emacs-configs/doom-stable/doom-config")))))

 ("spacemacs" . (
	       (user-emacs-directory . "~/.emacs-configs/spacemacs-daily/spacemacs")
		(env . (("SPACEMACSDIR" . "~/.emacs-configs/spacemacs-daily/.spacemacs.d")))))

)
EOF

 Done
 Now you can launch spacemacs with:

 emacs --with-profile spacemacs

 If something breaks, you always have your known working installation at:

 emacs --with-profile stable

