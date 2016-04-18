[![Travis-CI Build Status](https://travis-ci.org/noamross/texttable.svg?branch=master)](https://travis-ci.org/noamross/texttable) [![Coverage Status](https://img.shields.io/codecov/c/github/noamross/texttable/master.svg)](https://codecov.io/github/noamross/texttable?branch=master)

<!-- README.md is generated from README.Rmd. Please edit that file -->
texttable
=========

This package imports tabular data that is stored in a variety of text formats.

Install
-------

    devtools::install_github('noamross/texttable')

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

Note that `texttable()` will trim leading whitespace from string inputs by default.

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

Pandoc conversion of tables from `asciidoc`, `context`, `docbook`, `latex`, `man`, `mediawiki`, `rtf`, `texinfo`, and `odt` formats has known issues and does not always work. For these formats `texttable` will provide a warning, as the output quality is unknown and will change with your current version of Pandoc.
