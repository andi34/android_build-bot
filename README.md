Getting Started
---------------

To get started with Android, you'll need to get
familiar with [Git and Repo](http://source.android.com/source/using-repo.html).

To initialize your local repository using theese trees, use a command like this:

    repo init -u git://github.com/andi34/android_build-bot.git -b manifest

Then to sync up:

    repo sync -d -c -q --jobs=8 --no-tags

