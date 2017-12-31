Setup local development environment on Ubuntu 14.04
-------------------------------------

### Overview

1. Install [Ruby](https://www.ruby-lang.org/en/)
2. Install [MySQL](http://www.mysql.com/)
3. Install [Redis](http://redis.io/)
4. Install JavaScript Runtime
5. Configure Safewex


### Step 1: Install Ruby

Make sure your system is up-to-date.

    sudo apt-get update
    sudo apt-get upgrade

Installing [rbenv](https://github.com/sstephenson/rbenv) using a Installer

    sudo apt-get install git-core curl zlib1g-dev build-essential \
                         libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
                         libxml2-dev libxslt1-dev libcurl4-openssl-dev \
                         python-software-properties libffi-dev

    cd
    git clone git://github.com/sstephenson/rbenv.git .rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    exec $SHELL

    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
    exec $SHELL

Install Ruby through rbenv:

    rbenv install 2.2.1
    rbenv global 2.2.1

Install bundler

    echo "gem: --no-ri --no-rdoc" > ~/.gemrc
    gem install bundler
    rbenv rehash

### Step 2: Install MySQL

    sudo apt-get install mysql-server  mysql-client  libmysqlclient-dev

### Step 3: Install Redis

    **Installation for the first time**:
    wget http://download.redis.io/releases/redis-4.0.2.tar.gz
    tar xzf redis-4.0.2.tar.gz
    cd redis-4.0.2
    make
    
    **run redis**:
    src/redis-server

### Step 4: Install JavaScript Runtime

A JavaScript Runtime is needed for Asset Pipeline to work. Any runtime will do but Node.js is recommended.

    curl -sL https://deb.nodesource.com/setup | sudo bash -
    sudo apt-get install nodejs


### Step 5: Configure Safewex

**Clone the project**

    git clone https://github.com/nomiAA/safewex.git
    cd safewex
    bundle install

**Prepare configure files**

    bin/init_config

**Config database settings**

    vim config/database.yml (change the password to your password)

    # Initialize the database and load the seed data
    bundle exec rake db:setup

**Run Safewex**

    # start server
    bundle exec rails server

**Visit [http://localhost:3000](http://localhost:3000)**

