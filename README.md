Gazetteer
=========

Semantic location information for [Vim](http://www.vim.org).
Typing '``\g``' will print the (scoped) name of the function, method, class, etc.
of the current cursor position.

Requires [Exuberant Ctags](http://ctags.sourceforge.net/) to be installed and
available on the system path.

Installation
------------

### [pathogen.vim](https://github.com/tpope/vim-pathogen)

    $ cd ~/.vim/bundle
    $ git clone git://github.com/tacahiroy/ctrlp-pythonic.git


### [Vundle](https://github.com/gmarik/vundle.git)

    :BundleInstall jeetsukumaran/ctrlp-funky

Add the line below into your _.vimrc_.

    Bundle 'jeetsukumaran/ctrlp-pythonic'

### Manually

Copy the _autoload_ and _plugin_ sub-directories to your _.vim_ directory (on
Windows: _vimfiles_).

Key Maps
--------

By default, typing ``<Leader>g`` will print the name of the current code entity
in the message area. If you want to use another key-mapping to invoke this,
then define it in your '_.vimrc_' . For example:

    nmap g@ <Plug>GazetteerEchoLocation

License
-------

Copyright 2014 Jeet Sukumaran

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
