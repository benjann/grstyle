# grstyle
Stata module to customize the overall look of graphs

`grstyle` allows you to customize the overall look of graphs from within a
do-file without having to fiddle around with external scheme files. The
advantage of `grstyle` over manually editing a scheme file is that everything
needed to reproduce your graphs can be included in a single do-file.
Furthermore, `grstyle` provides a number of useful features such as assigning
color palettes or setting absolute sizes.

Online documentation of `grstyle` can be found at
[repec.sowi.unibe.ch/stata/grstyle](http://repec.sowi.unibe.ch/stata/grstyle/).

To install the `grstyle` package from the SSC Archive, type

    . ssc install grstyle, replace

in Stata. Stata version 9.2 or newer is required. Some features of `grstyle` 
rely on utilities provided by the `palettes` package. To install this package, 
type

    . ssc install palettes, replace

Furthermore, in Stata 14.2 or newer, also the `colrspace` package is required; type

    . ssc install colrspace, replace

---

Installation from GitHub:

    . net install grstyle, replace from(https://raw.githubusercontent.com/benjann/grstyle/master/)

---

Main changes:

    17apr2020
    - installation files added to GitHub distribution
    
    30jan2019
    - command -grstyle set color- now calls command -colorpalette9- instead of 
      -colorpalette- if used in a Stata version older than 14.2

    12apr2018
    - command -grstyle set plain- now has options -box- and -minor-
    - commands -grstyle set mesh- and -grstyle set imesh- no longer print a minor 
      grid by default, instead they now have a -minor- option
    - command -grstyle set color- now supports selecting colors from multiple palettes
    - spaces are now allowed between values and units in size specifications and -in- 
      can now also be specified as -inch- (or -inc-); this concerns -gstyle set 
      graphsize-, -grstyle set size-, -grstyle set symbolsize-, -grstyle set 
      linewidth-, and -grstyle set margin-
    - the default element set by -grstyle set intensity-, -grstyle set symbol-, 
      -grstyle set lpattern-, -grstyle set symbolsize-, and -grstyle set linewidth-
      is now -p- if a single value is provided and -p#- if more than one value 
      is provided or option plots() is specified

    14feb2018
    - command -grstyle set nogrid- has been added
    - command -grstyle set noextend- has been added
    - command -grstyle set plain- now has new options -nogrid- and -noextend-
    - -grstyle set margins- now reorders the provided numbers when writing a
      scheme entry (because Stata interprets margins scheme entries as 
      "left right top bottom" instead of the usual "left right bottom top")

    22dec2017
    - new command grstyle set
    - new command grstyle type
    - command gstyle refresh discarded; settings are now refreshed automatically

    18oct2017
    - some minor bug fixes and small improvements

    15oct2017
    - grstyle released on SSC
