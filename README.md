docker-android
===============

Automatic Build Server for Android ROMs.

This creates a build container with [docker](https://www.docker.com/).

Hardware Requirements
---------------------

- CPU: Quad Core or more
- Memory: 16GB or more
- Hard Drive: 100GB or more

Software Requirements
---------------------

### Ubuntu

- [Install Docker](http://docs.docker.com/installation/ubuntulinux/)

### OSX/Windows

- [Install Boot2Docker](http://boot2docker.io/)
- [Install Docker](http://docs.docker.com/installation/)

Get Started
-----------

Create the container and installs all the needed packages:
    
    user@host> cd $REPO
    user@host> docker build -t android . # It can takes several hours depending on your internet connection

Lift the container:

    user@host> docker run -p 127.0.0.1:2222:22 -v $HOME/android/:/home/builder/android/ -d -t android

Connect to the container with:

    user@host> ssh builder@localhost -p 2222 # The default password for builder is builder

Your android build distribution is ready to be use:

    builder@guest> # do whatever you want
    
Real World Android Build
------------------------
    
    user@host> docker build -t android . # Build the Container
    user@host> docker run -p 127.0.0.1:2222:22 -v $HOME/android/:/home/builder/android/ -d -t android # Configure the Container
    user@host> ssh builder@localhost -p 2222 # Connects to the Container
    builder@guest> cd android # Move to android directory 
    builder@guest:android> repo init -u https://android.googlesource.com/platform/manifest -b android-4.4.4_r2
    builder@guest:android> repo sync \
      # It can takes several hours depending on your internet connection
    builder@guest:android> source build/envsetup.sh # Set-up compilation environment
    builder@guest:android> lunch 1 # Selects the generic arm build
    builder@guest:android> make -j4 \
      # It can takes several hours depending on your horsepowers

Usefull Links
-------------

- [Android Build Informations](https://source.android.com/source/building-running.html)
- [Docker Docs](https://docs.docker.com/)
