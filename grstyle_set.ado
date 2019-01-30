*! version 1.0.4  29dec2018  Ben Jann

program grstyle_set
    version 9.2
    if `"${GRSTYLE_FN}"'=="" {
        di as err "grstyle not initialized"
        exit 499
    }
    gettoken cmd 0 : 0, parse(" ,:")
    local l = strlen(`"`cmd'"')
    if `"`cmd'"'=="" {
        di as err "subcommand required"
        exit 198
    }
    else if `"`cmd'"'=="plain"                           local cmd plain
    else if `"`cmd'"'=="mesh"                            local cmd mesh
    else if `"`cmd'"'=="imesh"                           local cmd imesh
    else if `"`cmd'"'==substr("horizontal",1,max(3,`l')) local cmd horizontal
    else if `"`cmd'"'==substr("compact",1,max(3,`l'))    local cmd compact
    else if `"`cmd'"'=="grid"                            local cmd grid
    else if `"`cmd'"'=="nogrid"                          local cmd nogrid
    else if `"`cmd'"'==substr("noextend",1,max(4,`l'))   local cmd noextend
    else if `"`cmd'"'==substr("legend",1,max(3,`l'))     local cmd legend
    else if `"`cmd'"'=="ci"                              local cmd ci
    else if `"`cmd'"'==substr("lcolor",1,max(2,`l'))     local cmd lcolor
    else if `"`cmd'"'==substr("lpattern",1,max(2,`l'))   local cmd lpattern
    else if `"`cmd'"'==substr("color",1,max(1,`l'))      local cmd color
    else if `"`cmd'"'==substr("intensity",1,max(5,`l'))  local cmd intensity
    else if `"`cmd'"'==substr("mcolor",1,max(2,`l'))     local cmd mcolor
    else if `"`cmd'"'==substr("symbol",1,max(1,`l'))     local cmd symbol
    else if `"`cmd'"'=="graphsize"                       local cmd graphsize
    else if `"`cmd'"'=="size"                            local cmd size gsize
    else if `"`cmd'"'=="gsize"                           local cmd size gsize
    else if `"`cmd'"'=="symbolsize"                      local cmd size symbolsize
    else if `"`cmd'"'=="linewidth"                       local cmd size linewidth
    else if `"`cmd'"'=="margin"                          local cmd size margin
    //else {
    //    di as err `"`cmd' not allowed"'
    //    exit 198
    //}
    tempname fh
    file open `fh' using `"${GRSTYLE_FN}"', write append
    nobreak {
        global GRSTYLE_FH `fh'
        capt n break {
            grstyle_set_`cmd' `0'
        }
        macro drop GRSTYLE_FH
        file close `fh'
        if _rc {
            exit _rc
        }
    }
    _grstyle_refresh
end

program _grstyle_refresh
    // the following commands remove the current scheme from working memory
    // so that the scheme will be reloaded when creating the next graph
    // (the code has been provided by Vince Wiggins from StataCorp)
    capt _cls free __SCHEME
    set curscm ""
end

program _grstyle_put
    file write $GRSTYLE_FH `"`0'"' _n
end

program grstyle_set_plain
    syntax [, DOTted HORizontal COMpact NOGrid Grid Minor NOEXtend box ]
    if "`grid'"!="" & "`nogrid'"!="" {
        di as err "grid and nogrid not both allowed"
        exit 198
    }
    // region
    _grstyle_put color background white
    _grstyle_put color plotregion none
    // frame
    if "`box'"!="" _grstyle_put linestyle plotregion foreground
    else           _grstyle_put linestyle plotregion none
    // grid
    if "`dotted'"=="" {
        _grstyle_put color grid dimgray
        _grstyle_put color major_grid dimgray
        _grstyle_put color minor_grid dimgray
    }
    else {
        _grstyle_put color grid gs5
        _grstyle_put linepattern grid dot
        _grstyle_put color major_grid gs5
        _grstyle_put linepattern major_grid dot
        _grstyle_put color minor_grid gs5
        _grstyle_put linepattern minor_grid dot
    }
    _grstyle_put linewidth grid thin
    _grstyle_put linewidth major_grid thin
    _grstyle_put linewidth minor_grid thin
    if "`grid'"!="" grstyle_set_grid, `minor'
    else if "`nogrid'"!="" grstyle_set_nogrid
    // heading and text boxes
    _grstyle_put color heading black
    _grstyle_put color textbox none         // bylabel shading
    _grstyle_put color bylabel_outline none // bylabel shading
    _grstyle_put color mat_label_box none   // graph matrix diagonal shading
    // horizontal, compact
    if "`horizontal'"!="" grstyle_set_horizontal
    if "`compact'"!="" grstyle_set_compact
    if "`noextend'"!="" grstyle_set_noextend
end

program grstyle_set_mesh
    syntax [, Minor HORizontal COMpact ]
    // region
    _grstyle_put color background white
    _grstyle_put color plotregion none
    _grstyle_put linestyle plotregion none
    // axes and grid
    _grstyle_put color tick_label gs9
    _grstyle_put color axisline none
    _grstyle_put gridstyle minor minor
    _grstyle_put color grid gs12
    _grstyle_put color major_grid gs12
    _grstyle_put color minor_grid gs12
    _grstyle_put linepattern grid solid
    _grstyle_put linepattern major_grid solid
    _grstyle_put linepattern minor_grid solid
    _grstyle_put linewidth grid thin
    _grstyle_put linewidth major_grid thin
    _grstyle_put linewidth minor_grid vthin
    _grstyle_put color tick gs12
    _grstyle_put color minortick gs12
    _grstyle_put gsize tick zero
    _grstyle_put gsize minortick zero
    grstyle_set_grid, `minor'
    // graph dot/bar/box
    _grstyle_put axisstyle dot_scale_horiz horizontal_default
    _grstyle_put axisstyle dot_scale_vert  vertical_default
    _grstyle_put axisstyle bar_scale_horiz horizontal_default
    _grstyle_put axisstyle bar_scale_vert  vertical_default
    _grstyle_put axisstyle box_scale_horiz horizontal_default
    _grstyle_put axisstyle box_scale_vert  vertical_default
    // heading and text boxes
    _grstyle_put color heading black
    _grstyle_put color textbox none         // bylabel shading
    _grstyle_put color bylabel_outline none // bylabel shading
    _grstyle_put color mat_label_box none   // graph matrix diagonal shading
    * // legend
    * _grstyle_put color key_label gs9
    * _grstyle_put color legend_line gs12
    // horizontal, compact
    if "`horizontal'"!="" grstyle_set_horizontal
    if "`compact'"!="" grstyle_set_compact
end

program grstyle_set_imesh
    syntax [, Minor HORizontal COMpact ]
    // region
    _grstyle_put color background white
    _grstyle_put color plotregion gs14
    _grstyle_put linewidth plotregion thin
    _grstyle_put color plotregion_line gs14
    _grstyle_put linestyle plotregion plotregion    // needed for s1 schemes
    _grstyle_put shadestyle plotregion plotregion   // needed for s1 schemes
    // axes and grid
    _grstyle_put color axisline none
    _grstyle_put gridstyle minor minor
    _grstyle_put color grid white
    _grstyle_put color major_grid white
    _grstyle_put color minor_grid white
    _grstyle_put linepattern grid solid
    _grstyle_put linepattern major_grid solid
    _grstyle_put linepattern minor_grid solid
    _grstyle_put linewidth grid thin
    _grstyle_put linewidth major_grid thin
    _grstyle_put linewidth minor_grid vthin
    grstyle_set_grid, `minor'
    _grstyle_put gsize minortick zero
    // graph dot/bar/box
    _grstyle_put axisstyle dot_scale_horiz horizontal_default
    _grstyle_put axisstyle dot_scale_vert  vertical_default
    _grstyle_put axisstyle bar_scale_horiz horizontal_default
    _grstyle_put axisstyle bar_scale_vert  vertical_default
    _grstyle_put axisstyle box_scale_horiz horizontal_default
    _grstyle_put axisstyle box_scale_vert  vertical_default
    // heading and text boxes
    _grstyle_put color heading black
    _grstyle_put color textbox none         // bylabel shading
    _grstyle_put color bylabel_outline none // bylabel shading
    _grstyle_put color mat_label_box none   // graph matrix diagonal shading
    // horizontal, compact
    if "`horizontal'"!="" grstyle_set_horizontal
    if "`compact'"!="" grstyle_set_compact
end

program grstyle_set_horizontal
    if `"`0'"'!="" {
        di as err `"`0' not allowed"'
        exit 198
    }
    _grstyle_put anglestyle vertical_tick horizontal
end

program grstyle_set_compact
    if `"`0'"'!="" {
        di as err `"`0' not allowed"'
        exit 198
    }
    _grstyle_put gsize text             medsmall
    _grstyle_put gsize heading          medlarge
    _grstyle_put gsize subheading       medium
    _grstyle_put gsize axis_title       medsmall
    _grstyle_put gsize key_label        small
    _grstyle_put gsize tick_label       small
    _grstyle_put gsize tick_biglabel    medsmall
    _grstyle_put gsize text_option      small
    _grstyle_put symbolsize p           medsmall
    _grstyle_put gsize legend_key_ysize small
    _grstyle_put margin graph           medsmall
    _grstyle_put gsize matrix_label     medium
    _grstyle_put symbolsize matrix      medsmall
end

program grstyle_set_grid
    syntax [, Minor ]
    _grstyle_put yesno draw_major_vgrid yes
    _grstyle_put yesno draw_major_hgrid yes
    _grstyle_put yesno draw_minor_vgrid yes
    _grstyle_put yesno draw_minor_hgrid yes
    _grstyle_put yesno grid_draw_min yes
    _grstyle_put yesno grid_draw_max yes
    if "`minor'"!="" {
        _grstyle_put numticks_g horizontal_tminor 2
        _grstyle_put numticks_g vertical_tminor   2
        _grstyle_put yesno draw_minornl_hgrid yes
        _grstyle_put yesno draw_minornl_vgrid yes
    }
end

program grstyle_set_nogrid
    if `"`0'"'!="" {
        di as err `"`0' not allowed"'
        exit 198
    }
    _grstyle_put yesno draw_major_vgrid no
    _grstyle_put yesno draw_major_hgrid no
    _grstyle_put yesno draw_minor_vgrid no
    _grstyle_put yesno draw_minor_hgrid no
end

program grstyle_set_noextend
    if `"`0'"'!="" {
        di as err `"`0' not allowed"'
        exit 198
    }
    _grstyle_put yesno extend_axes_low       no
    _grstyle_put yesno extend_axes_high      no
    _grstyle_put yesno extend_axes_full_low  no
    _grstyle_put yesno extend_axes_full_high no
end

program grstyle_set_legend
    syntax [anything(id="clockpos" name=pos)] [, nobox STACKed INside KLength(str) ]
    if `"`pos'"'=="" local pos 6
    numlist `"`pos'"', integer min(1) max(1) range(>=0 <=12)
    _grstyle_put clockdir legend_position `pos'
    _grstyle_put clockdir by_legend_position `pos'
    if "`inside'"!="" {
        _grstyle_put gridringstyle legend_ring 0
        _grstyle_put gridringstyle by_legend_ring 0
    }
    if inlist(`pos',2,3,4,8,9,10) {
        _grstyle_put numstyle legend_cols 1
    }
    if "`box'"!="" {
        _grstyle_put areastyle legend none
    }
    if "`stacked'"!="" {
        _grstyle_put yesno legend_stacked yes
        _grstyle_put gsize legend_key_gap minuscule
        _grstyle_put gsize legend_row_gap small
    }
    if `"`klength'"'=="" local klength huge
    _grstyle_put gsize legend_key_xsize `klength'
end

program grstyle_set_ci
    if c(stata_version)<15 {
        di as err "{bf:grstyle set ci} requires Stata 15"
        exit 9
    }
    syntax [anything(id="palette" name=palette everything equalok)] ///
        [, OPacity(numlist >=0 <=100) * ]
    if `"`palette'"'=="" {
        local c1 gs12
        local c2 ltkhaki
    }
    else {
        capt n colorpalette `palette', nograph `options'
        if _rc {
            if _rc==199 {
                di as err "package {bf:palettes} required; " _c
                di as err `"type {stata ssc install palettes}"'
            }
            exit _rc
        }
        local c1 `"`r(p1)'"'
        local c2 `"`r(p2)'"'
    }
    local o1: word 1 of `opacity'
    local o2: word 2 of `opacity'
    if "`o1'"=="" local o1 50
    if "`o2'"=="" local o2 `o1'
    _grstyle_put color ci_area "`c1'%`o1'"
    _grstyle_put color ci_arealine "`c1'%0"
    if `"`c2'"'!="" {
        _grstyle_put color ci2_area "`c2'%`o2'"
        _grstyle_put color ci2_arealine "`c2'%0"
    }
end

program grstyle_set_color
    // parse -cmd : elements-
    capt _on_colon_parse `0'
    if _rc==0 {
        local 0 `"`s(before)'"'
        local elements `"`s(after)'"'
    }
    // parse -palette(s), options-
    local p
    local palette
    while (`"`0'"'!="") {
        local palette `"`palette'`p' "'
        gettoken p 0 : 0, parse("/") quotes bind
    }
    _parse comma p 0 : p
    local palette `"`palette'`p'"'
    // parse options and get colors
    syntax [, Plots(numlist integer >0) * ]
    if c(stata_version)<14.2 local colorpalette colorpalette9
    else                     local colorpalette colorpalette
    capt n `colorpalette' `palette', nograph `options'
    if _rc {
        if _rc==199 {
            di as err "package {bf:palettes} required; " _c
            di as err `"type {stata ssc install palettes}"'
        }
        exit _rc
    }
    local n = r(n)
    // parse elements
    // if `"`elements'"'=="" {
    //     if `n'==1 & "`plots'"=="" local elements "p"
    //     else                      local elements "p#"
    // }
    if `"`elements'"'=="" local elements "p#"
    if "`plots'"==""      local plots 1/`n'
    _grstyle_parse_elements `elements' // returns pel and el
    // assign colors
    foreach e of local pel {
        local j 0
        foreach i of numlist `plots' {
            if `j'==`n' local j 0 // recycle
            local ++j
            local pj `"`r(p`j')'"'
            if `"`pj'"'=="" continue // empty pattern
            if `: list sizeof pj'>1 local pj `""`pj'""'
            _grstyle_put color p`i'`e' `pj'
        }
    }
    local j 0
    foreach e of local el {
        if `j'==`n' local j 0 // recycle
        local ++j
        local pj `"`r(p`j')'"'
        if `"`pj'"'=="" continue // empty symbol
        if `: list sizeof pj'>1 local pj `""`pj'""'
        _grstyle_put color `e' `pj'
    }
end

program grstyle_set_intensity
    capt _on_colon_parse `0'
    if _rc==0 {
        local 0 `"`s(before)'"'
        local elements `"`s(after)'"'
    }
    syntax [anything(id="intensity" name=intensity everything equalok)] ///
        [, Plots(numlist integer >0) ]
    if `"`intensity'"'=="" local intensity 100
    local n: list sizeof intensity
    foreach j of numlist 1/`n' {
        local p`j': word `j' of `intensity'
    }
    if `"`elements'"'=="" {
        if `n'==1 & "`plots'"=="" local elements "p"
        else                      local elements "p#"
    }
    if "`plots'"=="" local plots 1/`n'
    _grstyle_parse_elements `elements' // returns pel and el
    foreach e of local pel {
        local j 0
        foreach i of numlist `plots' {
            if `j'==`n' local j 0 // recycle
            local ++j
            if `"`p`j''"'=="" continue
            _grstyle_put intensity p`i'`e' `p`j''
        }
    }
    local j 0
    foreach e of local el {
        if `j'==`n' local j 0 // recycle
        local ++j
        if `"`p`j''"'=="" continue
        _grstyle_put intensity `e' `p`j''
    }
end

program grstyle_set_symbol
    capt _on_colon_parse `0'
    if _rc==0 {
        local 0 `"`s(before)'"'
        local elements `"`s(after)'"'
    }
    syntax [anything(id="palette" name=palette everything equalok)] ///
        [, Plots(numlist integer >0) * ]
    capt n symbolpalette `palette', nograph `options'
    if _rc {
        if _rc==199 {
            di as err "package {bf:palettes} required; " _c
            di as err `"type {stata ssc install palettes}"'
        }
        exit _rc
    }
    local n = r(n)
    if `"`elements'"'=="" {
        if `n'==1 & "`plots'"=="" local elements "p"
        else                      local elements "p#"
    }
    if "`plots'"=="" local plots 1/`n'
    _grstyle_parse_elements `elements' // returns pel and el
    foreach e of local pel {
        local j 0
        foreach i of numlist `plots' {
            if `j'==`n' local j 0 // recycle
            local ++j
            local pj `"`r(p`j')'"'
            if `"`pj'"'=="" continue // empty pattern
            if inlist(`"`pj'"',"X","V") local pj = strlower(`"`pj'"')
            _grstyle_put symbol p`i'`e' `pj'
        }
    }
    local j 0
    foreach e of local el {
        if `j'==`n' local j 0 // recycle
        local ++j
        local pj `"`r(p`j')'"'
        if `"`pj'"'=="" continue // empty pattern
        if inlist(`"`pj'"',"X","V") local pj = strlower(`"`pj'"')
        _grstyle_put symbol `e' `pj'
    }
end

program grstyle_set_lpattern
    capt _on_colon_parse `0'
    if _rc==0 {
        local 0 `"`s(before)'"'
        local elements `"`s(after)'"'
    }
    syntax [anything(id="palette" name=palette everything equalok)] ///
        [, Plots(numlist integer >0) * ]
    capt n linepalette `palette', nograph `options'
    if _rc {
        if _rc==199 {
            di as err "package {bf:palettes} required; " _c
            di as err `"type {stata ssc install palettes}"'
        }
        exit _rc
    }
    local n = r(n)
    if `"`elements'"'=="" {
        if `n'==1 & "`plots'"=="" local elements "p"
        else                      local elements "p#"
    }
    if "`plots'"=="" local plots 1/`n'
    _grstyle_parse_elements `elements' // returns pel and el
    foreach e of local pel {
        local j 0
        foreach i of numlist `plots' {
            if `j'==`n' local j 0 // recycle
            local ++j
            local pj `"`r(p`j')'"'
            if `"`pj'"'=="" continue // empty pattern
            if `: list sizeof pj'>1 local pj `""`pj'""'
            _grstyle_put linepattern p`i'`e' `pj'
        }
    }
    local j 0
    foreach e of local el {
        if `j'==`n' local j 0 // recycle
        local ++j
        local pj `"`r(p`j')'"'
        if `"`pj'"'=="" continue // empty symbol
        if `: list sizeof pj'>1 local pj `""`pj'""'
        _grstyle_put linepattern `e' `pj'
    }
end

program grstyle_set_graphsize
    syntax [anything(name=sizelist everything equalok)]
    _grstyle_parse_sizelist sizelist `sizelist' // remove spaces
    gettoken ysize sizelist : sizelist
    gettoken xsize sizelist : sizelist
    if `"`sizelist'"'!="" {
        di as err `"`sizelist' not allowed"'
        exit 198
    }
    if `"`ysize'"'!="" {
        _grstyle_graphsize_translate `"`ysize'"'
        local ysize `size'
    }
    else local ysize 4.0
    if `"`xsize'"'!="" {
        _grstyle_graphsize_translate `"`xsize'"'
        local xsize `size'
    }
    else local xsize 5.5
    _grstyle_put graphsize y `ysize'
    _grstyle_put graphsize x `xsize'
    global GRSTYLE_RSIZE = min(`ysize',`xsize')
end

program _grstyle_graphsize_translate
    args s
    capt confirm number `s'
    if _rc==0 {
        c_local size `s'
        exit
    }
    local u = substr(`"`s'"',-2,.)
    if !inlist(`"`u'"',"pt","mm","in","cm") {
        local u = substr(`"`s'"',-4,.)
        if `"`u'"'!="inch" {
             local u = substr(`"`s'"',-3,.)
             if `"`u'"'!="inc" {
                 di as err `"`s' not allowed"'
                 exit 198
             }
        }
    }
    local v = substr(`"`s'"',1,strlen(`"`s'"')-strlen(`"`u'"'))
    capt confirm number `v'
    if _rc {
        di as err `"`s' not allowed"'
        exit 198
    }
    if      `"`u'"'=="pt"   local s = `v' / 72
    else if `"`u'"'=="mm"   local s = `v' / 25.4
    else if `"`u'"'=="cm"   local s = `v' / 2.54
    else if `"`u'"'=="in"   local s = `v'
    else if `"`u'"'=="inch" local s = `v'
    else if `"`u'"'=="inc"  local s = `v'
    c_local size `s'
end

program grstyle_set_size
    capt _on_colon_parse `0'
    if _rc==0 {
        local 0 `"`s(before)'"'
        local elements `"`s(after)'"'
    }
    gettoken stype 0 : 0, parse(" ,")
    if !inlist(`"`stype'"',"gsize","symbolsize","linewidth","margin") {
        di as err `"`stype' not allowed"'
        exit 198
    }
    if "`stype'"=="margin" local marginopt margin
    syntax anything(id="sizelist" name=sizelist everything equalok) ///
        [, Plots(numlist integer >0) * ]
    _grstyle_size, sizelist(`sizelist') `marginopt' `options'
    local n: list sizeof sizes
    foreach j of numlist 1/`n' {
        local p`j': word `j' of `sizes'
        if `:list sizeof p`j''>1 local p`j' `""`p`j''""'
    }
    if `"`elements'"'=="" { // set defaults
        if      "`stype'"=="gsize"    local elements
        else if "`stype'"=="margin"   local elements graph
        else if inlist("`stype'", "symbolsize", "linewidth") {
            if `n'==1 & "`plots'"=="" local elements "p"
            else                      local elements "p#"
        }
    }
    if "`plots'"=="" local plots 1/`n'
    _grstyle_parse_elements `elements' // returns pel and el
    foreach e of local pel {
        local j 0
        foreach i of numlist `plots' {
            if `j'==`n' local j 0 // recycle
            local ++j
            if `"`p`j''"'=="" continue
            _grstyle_put `stype' p`i'`e' `p`j''
        }
    }
    local j 0
    foreach e of local el {
        if `j'==`n' local j 0 // recycle
        local ++j
        if `"`p`j''"'=="" continue
        _grstyle_put `stype' `e' `p`j''
    }
end

program _grstyle_size
    syntax [, sizelist(str asis) margin pt INch mm cm ]
    local units `pt' `inch' `mm' `cm'
    if `:list sizeof units'>1 {
        di as err "only one of pt, inch, mm, and cm allowed"
    }
    local rsize `"${GRSTYLE_RSIZE}"'
    if `"`rsize'"'=="" local rsize 4 // default
    _grstyle_parse_sizelist sizelist `sizelist' // remove spaces
    local sizes
    foreach s of local sizelist {
        if "`margin'"=="" {
            _grstyle_size_translate "`units'" `"`s'"' `rsize'
            local sizes `"`sizes'`size' "'
        }
        else {
            _grstyle_parse_sizelist s `s' // remove spaces
            local s1
            foreach si of local s {
                _grstyle_size_translate "`units'" `"`si'"' `rsize'
                local s1 `s1' `size'
            }
            local n: list sizeof s1
            if `n'==1 {
                capt confirm number `s1'
                if _rc {
                    local sizes `"`sizes'`s1' "'
                    continue
                }
            }
            forv i = `=`n'+1'/4 {
                local s1 `s1' `size'
            }
            mata: _flip3and4("s1") // l r b t => l r t b (scheme entry order)
            local sizes `"`sizes'"`s1'" "'
        }
    }
    c_local sizes `"`sizes'"'
end

program _grstyle_size_translate
    args units s rsize
    capt confirm number `s'
    if _rc==0 {
        if "`units'"!="" {
            if      "`units'"=="pt"   local s = `s' / (`rsize'*72)   * 100
            else if "`units'"=="mm"   local s = `s' / (`rsize'*25.4) * 100
            else if "`units'"=="cm"   local s = `s' / (`rsize'*2.54) * 100
            else if "`units'"=="inch" local s = `s' /  `rsize'       * 100
        }
        c_local size `s'
        exit
    }
    local u = substr(`"`s'"',-2,.)
    if !inlist(`"`u'"',"pt","mm","in","cm") {
        local u = substr(`"`s'"',-4,.)
        if `"`u'"'!="inch" {
             local u = substr(`"`s'"',-3,.)
             if `"`u'"'!="inc" {
                 c_local size `s'
                 exit
             }
        }
    }
    local v = substr(`"`s'"',1,strlen(`"`s'"')-strlen(`"`u'"'))
    capt confirm number `v'
    if _rc {
        c_local size `s'
        exit
    }
    if      `"`u'"'=="pt"   local s = `v' / (`rsize'*72)   * 100
    else if `"`u'"'=="mm"   local s = `v' / (`rsize'*25.4) * 100
    else if `"`u'"'=="cm"   local s = `v' / (`rsize'*2.54) * 100
    else if `"`u'"'=="in"   local s = `v' /  `rsize'       * 100
    else if `"`u'"'=="inch" local s = `v' /  `rsize'       * 100
    else if `"`u'"'=="inc"  local s = `v' /  `rsize'       * 100
    c_local size `s'
end

program _grstyle_parse_sizelist
    gettoken lname 0 : 0
    local sizelist
    local size0
    local space
    gettoken size 0 : 0, quotes qed(qed)
    while (`"`size'"'!="") {
        if `qed' {
            local sizelist `"`sizelist'`space'`size'"'
        }
        else {
            if inlist(`"`size'"',"pt","mm","in","inc","inch","cm") {
                capt confirm number `size0'
                if _rc {
                    local sizelist `"`sizelist'`space'`size'"'
                }
                else {
                    local sizelist `"`sizelist'`size'"'
                }
            }
            else {
                local sizelist `"`sizelist'`space'`size'"'
            }
        }
        local size0 `"`size'"'
        gettoken size 0 : 0, quotes qed(qed)
        local space " "
    }
    c_local `lname' `"`sizelist'"'
end

program _grstyle_parse_elements 
    foreach e of local 0 {
        if substr(`"`e'"',1,2)=="p#" {
            local e = substr(`"`e'"', 3, .)
            local pel `"`pel'`space'`"`e'"'"'
            local space " "
            continue
        }
        local el `el' `e'
    }
    c_local el `"`el'"'
    c_local pel `"`pel'"'
end

version 9.2
mata:
mata set matastrict on

void _flip3and4(string scalar lname)
{
    string rowvector s
    
    s = tokens(st_local(lname))
    if (cols(s)!=4) return
    st_local(lname, s[1]+" "+s[2]+" "+s[4]+" "+s[3])
}
end

exit
