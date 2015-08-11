#!/bin/bash

#RecitAll v1.0.1
#A simple git/composer script for mass update repositories
#Info and usage instructions at: https://github.com/TCattd/RecitAll
#
#Created by Esteban <esteban@attitude.cl>
#
#Licensed under GPLv2
#https://www.gnu.org/licenses/gpl-2.0.html

#Configuration:
DIRSPREFIX="/site-" #Directories prefix (slash at the beginning). Will cycle through dirs with a name using that prefix. To cycle through all, use a single forward slash: /
PUBDIR="" #Public directory inside every repo (no slashes). Leavy empty to NOT cd into a subdirectory for every repo

#Do not edit below this line!

#Name of the defined run-script (in composer.json) to run after composer update. Leave blank to not use it.
COMPOSERSCRIPT=$1

#Required to run
command -v git >/dev/null 2>&1 || { echo >&2 "git is required for this updater to run. Please install it first: http://git-scm.com/"; exit 1; }
command -v legit >/dev/null 2>&1 || { echo >&2 "legit extension for git is required for this updater to run. Please install it first. Ubuntu: sudo apt-get install legit. OSX (with homebrew): brew install legit. More info at: http://www.git-legit.org"; exit 1; }
command -v composer >/dev/null 2>&1 || { echo >&2 "composer is required for this updater to run. Please install it first: https://getcomposer.org/"; exit 1; }

#Start
echo -e '### Starting RecitAll\n'

#RendeZook!
for D in ./*; do
	if [ -d "$D" ]; then
		if([[ "$D" =~ $DIRSPREFIX ]]); then

			if [ -f "$D/composer.json" ]; then
				#root composer.json found
				cd "$D"
			else
				if [ -z "$PUBDIR" ]; then
					cd "$D"
				else
					cd "$D/$PUBDIR/"
				fi
			fi

			echo '### Updating '$D'/ ...';
			git checkout master
			legit sync

			if [ -f composer.json ]; then
				composer update

				if [ ! -z "$COMPOSERSCRIPT" ]; then
					composer run-script $COMPOSERSCRIPT
				fi
			fi

			git add -A
				if [ ! -z "$COMPOSERSCRIPT" ]; then
					git commit -m "RecitAll auto-update (run-script $COMPOSERSCRIPT)"
				else
					git commit -m "RecitAll auto-update"
				fi
			legit sync
			echo -e '### '$D'/ done!\n\n';

			if [ -f "$D/composer.json" ]; then
				cd ..
			else
				if [ -z "$PUBDIR" ]; then
					cd ..
				else
					cd ../..
				fi
			fi

		fi
	fi
done

echo -e '### RecitAll completed'

exit 1
