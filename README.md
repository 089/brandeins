# About BrandEins Downloader

BrandEins Downloader is a command line tool to download former volumes
of the german oeconimic magazine "Brand Eins". The articles of former
are available through there website and BrandEins Downloader takes all
these fragmented PDFs, downloads and merges them into a single pdf.


## Requirements
BrandEins Downloader uses *pdftk* and depends on *ruby*, *rubygems*, and
several ruby libraries (that you can get through rubygems)


## Install
`gem install brandeins-dl`


## Usage

Download just one magazine

`brandeins download --path=/Path/where/to/download/the/files --year=2011 --volume=5`

Download the whole collecion of a certain year

`brandeins download_all --path=/Path/where/to/download/the/files --year=2011`
