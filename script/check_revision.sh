#!/bin/bash

# Construct names
ruby_version_name=2.3.0-$(git show -s --pretty=format:'%h')
ruby_install_dir=~/.rubies/$ruby_version_name

# Generate configure script if needed
if [[ ! -s configure || configure.in -nt configure ]]; then
  autoreconf || return $?
fi

# Configure Ruby
./configure --disable-install-doc --prefix="$ruby_install_dir"

# Compile and install Ruby
make && make install

# Back to byebug dir (inferred from script's name)
cd "$(dirname "$0")/.." || exit

# Test Byebug against new Ruby
chruby-exec "$ruby_version_name" -- gem install bundler --no-document
chruby-exec "$ruby_version_name" -- bundle
chruby-exec "$ruby_version_name" -- bundle exec rake || exit 1
