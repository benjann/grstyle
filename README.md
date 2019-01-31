# grstyle
Stata module to customize the overall look of graphs

`grstyle` allows you to customize the overall look of graphs from within a
do-file without having to fiddle around with external scheme files. The
advantage of `grstyle` over manually editing a scheme file is that everything
needed to reproduce your graphs can be included in a single do-file.
Furthermore, `grstyle` provides a number of useful features such as assigning
color palettes or setting absolute sizes.

To install `grstyle` in Stata, type

    . ssc install grstyle, replace
    . ssc install palettes, replace

Some features of `grstyle` rely on utilities provided by the `palettes` package.
This is why the `palettes` package needs to be installed. Alternatively, 
you can download `grstyle.zip` and `palettes.zip` from RePEc 
([ideas.repec.org/c/boc/bocode/s458414.html](http://ideas.repec.org/c/boc/bocode/s458414.html) and 
[ideas.repec.org/c/boc/bocode/s458444.html](http://ideas.repec.org/c/boc/bocode/s458444.html)) 
and add the files to your system manually 
(see file readme.txt within `grstyle.zip` or `palettes.zip` for installation instructions). 

Stata version 9.2 or newer is required. Some features may require newer Stata 
versions. 
