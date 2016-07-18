# RecitAll

RecitAll is a simple bash script to mass update several git repositories on your machine. RecitAll goes through every directory, from the script path, that start with a user defined prefix, and executes the update routine on them:

  - Switch to master
  - Sync with remote master
  - Runs composer update just if the public path has a composer.json file
  - Commit all changes
  - Push and sync the remote git repo

### Background notes

RecitAll expects that all your repos (the ones you want to mass update) live in the same path. It will check for every directory with an user defined prefix, for example **/site-**, and will cycle through them.
RecitAll then will try to detect a composer.json config file in the project's root. If one is present, then it will be used to update. If not, then RecitAll optionally will *cd* into the public directory of the repo (user can define it too), before starting the update routine.

You need to prepare your repo (and yourself) so your master branch is always ready for production. Every feature or bug fix should reside in a new branch, and not in the master branch. ResitAll will sync, update, commit and push the master branch without asking. Please, be careful with that!.

We use this with our repos, mainly with WordPress instances using composer (thansk to [wpackagist.org](http://wpackagist.org)), to mass update WordPress's plugins and core (with some tweaks thanks to composer's post-update script support). Hassle-free :)

### Usage

Download **resitall.sh** and configure it inside with you favorite editor.
Put your configured **resitall.sh** into the folder containing your git repos (as subfolders), and run it from the terminal.

```sh
./resitall.sh
```

And watch ;)

You can also pass an argument to the script. That argument should be a composer's run-script defined command. Check [composer documentation](https://getcomposer.org/doc/articles/scripts.md#running-scripts-manually) for info about it.

```sh
./resitall.sh wp-core
```

In this case the updater will execute *wp-core* as defined in composer.json script. It's useful to put a routine in there, for example, to update WordPress core directly from git, or any specific routine post update that should not run every time you mass update with ResitAll.

### Changelog
v1.0.2 (2016-07-18)
* Fix legit sync routine.

v1.0.1 (2015-08-11)
* Attempts to detect a root composer.json config file on every directory, and use it to update. If not, RecitAll goes like before, according the PUBDIR's value.

v1.0.0 (2015-04-21)
* First public release

### License
ResitAll is licensed under GPLv2

https://www.gnu.org/licenses/gpl-2.0.html
