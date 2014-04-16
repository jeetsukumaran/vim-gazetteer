Gazetteer
=========

Semantic location information for [Vim](http://www.vim.org).

Typing '``gG``' will echo the (scoped) name of the function, method, class, etc.
of the current cursor position.

If the [Ctrl-P](https://github.com/kien/ctrlp.vim) fuzzy-finder plugin for
[Vim](http://www.vim.org)  is installed, then typing '``g@``' or the command
'``CtrlPGazetteer``' will invoke fuzzy-finding-and-jumping for tags of the
current buffer.

Mandatory Prerequisites
-----------------------

[Exuberant Ctags](http://ctags.sourceforge.net/) to be installed and
available on the system path.

Optional Prerequisites
----------------------
[Ctrl-P](https://github.com/kien/ctrlp.vim) to enable fuzzy-searching and
navigation of buffer tags.
_Gazetteer_ also provides an extension for the
[Ctrl-P](https://github.com/kien/ctrlp.vim) fuzzy-finder plugin for
[Vim](http://www.vim.org).  [Ctrl-P](https://github.com/kien/ctrlp.vim) ships
with a tag finder built-in, but this requires external management of a tags
file. _Gazetteer_ avoids this by implementing dynamic, on-demand
buffer-specific tag generation.

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

Activating the Ctrl-P Extension
-------------------------------

To enable the [Ctrl-P](https://github.com/kien/ctrlp.vim) extension, add
*gazetteer* to the variable `g:ctrlp_extensions` in your _.vimrc_:

    let g:ctrlp_extensions = ['gazetteer']

Key Maps
--------

By default, typing '``gG``' will print the name of the current code entity
in the message area. If you want to use another key-mapping to invoke this,
then define it in your '_.vimrc_'  by, for example:

    nmap <Leader>g <Plug>GazetteerEchoLocation

By default, typing '``g@``' will invoke
[Ctrl-P](https://github.com/kien/ctrlp.vim) to search for and, if selected, go
to, tags in the current buffer. If you want to use another key-mapping to
invoke this, then define it in your '_.vimrc_' by, for example:

    nmap <Leader>G <Plug>CtrlPGazetteer

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
