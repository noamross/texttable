[![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip) [![Travis-CI Build Status](https://travis-ci.org/noamross/texttable.svg?branch=master)](https://travis-ci.org/noamross/texttable) [![Coverage Status](https://img.shields.io/codecov/c/github/noamross/texttable/master.svg)](https://codecov.io/github/noamross/texttable?branch=master)

<!-- README.md is generated from README.Rmd. Please edit that file -->
texttable
=========

This package imports tabular data that is stored in a variety of text formats. It uses [Pandoc](http://pandoc.org/) to convert various formats to HTML and then imports them via `rvest::html_table`.

Install
-------

    devtools::install_github('noamross/texttable')

Note that **testtable** requires the latest pandoc, which can be downloaded [here](https://github.com/jgm/pandoc/releases/tag/1.17.0.2). To install via the command line:

Linux:

    wget https://github.com/jgm/pandoc/releases/download/1.17.0.2/pandoc-1.17.0.2-1-amd64.deb
    sudo dpkg -i pandoc-1.17.0.2-1-amd64.deb

OSX (Homebrew):

    brew install pandoc

Windows:

    ????

Usage
-----

Enter tabular in the text format of your choice:

``` r
library(texttable)
sample_table = "
                | My | Tabular  | Data |
                |----|----------|------|
                |   1| Sample 1 | 0.3  |
                |   2| Sample 2 | 1.2  |
               "
imported = texttable(sample_table)
imported
#> [[1]]
#>   My  Tabular Data
#> 1  1 Sample 1  0.3
#> 2  2 Sample 2  1.2
```

Note that `texttable()` will trim leading whitespace from character inputs by default.

Get tables out of text files, and even MS Word files:

``` r
tables = texttable('tests/testthat/tables.markdown')
tables[[1]]
#>   Right Left Center Default
#> 1    12   12     12      12
#> 2   123  123    123     123
#> 3     1    1      1       1
word_tables = texttable('tests/testthat/tables.docx')
word_tables[[1]]
#>             Name       Game      Fame             Blame
#> 1   Lebron James Basketball Very High Leaving Cleveland
#> 2     Ryan Braun   Baseball  Moderate          Steroids
#> 3 Russell Wilson   Football      High     Tacky uniform
```

Known issues
------------

Pandoc conversion of tables from `latex`, `haddock`, `odt`, formats has known issues and does not always work. For these formats `texttable` will provide a warning, as the output quality is unknown and will change with your current version of Pandoc.
