# RecitAll

RecitAll is a simple bash script to mass update several git repositories on your machine. RecitAll goes through every directory, from the script path, that start with a user defined prefix, and executes the update routine on them:

  - Switch to master
  - Sync with remote master
  - Runs composer update just if the public path has a composer.json file
  - Commit all changes
  - Push and sync the remote git repo

### Background notes

RecitAll expects that all your repos (the ones you want to mass update) live in the same path. It will check for every directory with an user defined prefix, for example **/site-**, and will cycle through them.
RecitAll then optionally will *cd* into the public directory of the repo (user can define it too), before starting the update routine.

You need to prepare your repo (and yourself) so your master branch is always ready for production. Every feature or bug fix should reside in a new branch, and not in the master branch. ResitAll will sync, update, commit and push the master branch without asking. Please, be careful with that!.

We use this with our repos, mainly with WordPress instances using composer (thansk to [wpackagist.org](http://wpackagist.org)), to mass update plugins and WP version (with a custom composer's post-update script). Hassle-free :)

### Usage

Download **resitall.sh** and configure it inside with you favorite editor.
Put your configured **resitall.sh** into the folder containing your git repos (as subfolders), and run it from the terminal.

```sh
./resitall.sh
```

And watch ;)

### Changelog
v1.0.0 (2015-04-21)
* First public release

### License
ResitAll is licensed under GPLv2

https://www.gnu.org/licenses/gpl-2.0.html
