#!/bin/bash

#RecitAll v1.0.2
#A simple git/composer script for mass update repositories
#Info and usage instructions at: https://github.com/TCattd/RecitAll
#
#Created by Esteban <esteban@attitude.cl>
#
#Licensed under GPLv2
#https://www.gnu.org/licenses/gpl-2.0.html

#Configuration:
DIRSPREFIX="/site-" #Directories prefix (slash at the beginning). Will cycle through dirs with a name using that prefix. To cycle through all, use a single forward slash: /
PUBDIR="" #Public directory (with composer data) inside every repo (no slashes). Leavy empty to NOT cd into a subdirectory for every repo

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

				echo '### Updating '$D'/ ...';

				#Git?
				if [ -d "$D/.git/" ]; then
					git_folder=true
				else
					git_folder=false
				fi

				#Go to dir
				cd "$D"

				#Initial Git sync
				if [ "$git_folder" = true ]; then
					echo -e '### Git initial sync\n\n';
					git checkout master
					legit sync
				fi

				#Pub dir?
				if [ -n "$PUBDIR" ]; then
					cd "./$PUBDIR/"
				fi

				#Composer
				if [ -f composer.json ]; then
					composer update

					if [ ! -z "$COMPOSERSCRIPT" ]; then
						composer run-script $COMPOSERSCRIPT
					fi
				fi

				#Git final sync
				if [ "$git_folder" = true ]; then
					echo -e '### Git final sync\n\n';

					if [ -n "$PUBDIR" ]; then
						cd ..
					fi

					git add -A
						if [ ! -z "$COMPOSERSCRIPT" ]; then
							git commit -m "RecitAll auto-update (run-script $COMPOSERSCRIPT)"
						else
							git commit -m "RecitAll auto-update"
						fi
					legit sync
				fi

				#Leave
				echo -e '### '$D'/ done!\n\n';
				cd ..

		fi
	fi
done

echo -e '### RecitAll completed'

exit 1
