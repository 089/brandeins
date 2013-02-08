[![Build Status](https://secure.travis-ci.org/guard/guard.png?branch=master)](http://travis-ci.org/grekko/brandeins) [![Gem Version](https://badge.fury.io/rb/brandeins.png)](http://badge.fury.io/rb/brandeins) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/grekko/brandeins)

About BrandEins Downloader
--------

BrandEins Downloader is a command line tool to download former volumes
of the german oeconimic magazine "Brand Eins". The articles of former
are available through there website and BrandEins Downloader takes all
these fragmented PDFs, downloads and merges them into a single pdf.


Requirements
--------
BrandEins Downloader uses [*pdftk*](http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) and depends on *ruby*, *rubygems*, and
several ruby libraries (that you can get through rubygems)


Install
--------

```bash
gem install brandeins
```


Usage
--------
Download just one magazine

```bash
brandeins download --path=/Path/where/to/download/the/files --year=2011 --volume=5
```

Download the whole collecion of a certain year

```bash
brandeins download --path=/Path/where/to/download/the/files --year=2011 --all
```


Development
--------
Pull requests are very welcome! Please try to follow these simple rules if applicable:
- Please create a topic branch for every separate change you make.
- Update the README.


### Author
[Gregory Igelmund](https://github.com/grekko) [(@grekko)](https://twitter.com/grekko)


### Contributors
[Thorben Schröder](https://github.com/walski)
