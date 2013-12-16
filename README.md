[![Build Status](https://secure.travis-ci.org/guard/guard.png?branch=master)](http://travis-ci.org/grekko/brandeins) [![Gem Version](https://badge.fury.io/rb/brandeins.png)](http://badge.fury.io/rb/brandeins) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/grekko/brandeins)

Brandeins
--------

brandeins is a command line tool to access the [online pdf archive](http://www.brandeins.de/archiv.html) of the german economic journal [brand eins](http://www.brandeins.de/). You can use it to download articles and merge them together into a single pdf document.


Requirements
--------
Brandeins uses [*pdftk*](http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) to merge the pdf files, [*nokogiri](https://github.com/sparklemotion/nokogiri) to parse the online archive and [*prawn*](https://github.com/prawnpdf/prawn) to create a simple cover page.


Install
--------

```bash
gem install brandeins
```


Usage
--------
Download all available articles of any given issue:

```bash
brandeins download --path=/Path/where/to/download/the/files --year=2013 --month=12
```


Development
--------
Pull requests are very welcome! Please try to follow these simple rules if applicable:
- Please create a topic branch for every separate change you make.
- Add a spec if you find a bug.
- Update the README.


### Author
[Gregory Igelmund](https://github.com/grekko) [(@grekko)](https://twitter.com/grekko)


### Contributors
[Thorben Schröder](https://github.com/walski)
