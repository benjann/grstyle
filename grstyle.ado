*! version 1.1.1  15sep2020  Ben Jann

program grstyle
    version 9.2
    gettoken cmd : 0, parse(", ")
    if `"`cmd'"'=="init" {
        grstyle_`0' // grstyle_init ...
        exit
    }
    if `"`cmd'"'=="set" {
        grstyle_`0' // grstyle_set ...
        exit
    }
    if `"`cmd'"'=="clear" {
        grstyle_`0' // grstyle_clear
        exit
    }
    if `"`cmd'"'=="type" {
        grstyle_`0' // grstyle_type
        exit
    }
    grstyle_put `0'
end

program grstyle_init
    grstyle_clear // clear previous grstyle settings
    syntax [name(name=handle)] [, path(str) Replace ///
        append /// undocumented
        ]
    if `"`handle'"'=="" {
        if `"`path'"'!="" {
            di as err "path() only allowed with {bf:grstyle init} {it:newscheme}"
            exit 198
        }
        if "`replace'"!="" {
            di as err "replace only allowed with {bf:grstyle init} {it:newscheme}"
            exit 198
        }
        if "`append'"!="" {
            di as err "append only allowed with {bf:grstyle init} {it:newscheme}"
            exit 198
        }
        local handle _GRSTYLE_
        if `"`c(scheme)'"'==`"`handle'"' {
            di as txt"Scheme {bf:`handle'} already active although {bf:grstyle}"/*
                */ " is not running"
            di as txt "Press any key to reset default scheme to {bf:s2color}"/*
                */ " and overwrite scheme {bf:`handle'}, or Break to abort"
            more
            set scheme s2color, permanently
                // using option -permanently- to make sure that restarting
                // Stata will not bring scheme _GRSTYLE_ back
            _grstyle_refresh
        }
        local path `"`c(sysdir_personal)'"'
        mata: grstyle_mkdir(st_local("path"))
        local replace replace
    }
    else {
        if `"`c(scheme)'"'==`"`handle'"' {
            di as err `"`handle' not allowed"' _c
            di as err  "; {it:newscheme} must be different from current scheme"
            exit 198
        }
    }
    mata: grstyle_fn(st_local("handle"), st_local("path")) // returns local fn
    tempname fh
    quietly file open `fh' using `"`fn'"', write `replace' `append'
    if "`append'"=="" {
        file write `fh' `"#include `c(scheme)'"' _n
    }
    file close `fh'
    global GRSTYLE_FN `"`fn'"'
    global GRSTYLE_SN `"`handle'"'
    global GRSTYLE_SN0 `"`c(scheme)'"'
    set scheme `handle'
end

program grstyle_clear
    syntax [, erase ]
    if "`erase'"!="" {
        if `"${GRSTYLE_FN}"'!="" {
            erase `"${GRSTYLE_FN}"'
        }
    }
    if `"${GRSTYLE_SN0}"'!="" {
        if `"`c(scheme)'"'==`"${GRSTYLE_SN}"' {
            set scheme ${GRSTYLE_SN0}
        }
        _grstyle_refresh
    }
    macro drop GRSTYLE_FN
    macro drop GRSTYLE_SN
    macro drop GRSTYLE_SN0
    macro drop GRSTYLE_RSIZE
end

program grstyle_put
    if `"${GRSTYLE_FN}"'=="" {
        di as err "grstyle not initialized"
        exit 499
    }
    tempname fh
    file open `fh' using `"${GRSTYLE_FN}"', write append
    file write `fh' `"`0'"' _n
    file close `fh'
    _grstyle_refresh
end

program grstyle_type
    if `"${GRSTYLE_FN}"'=="" {
        di as err "grstyle not initialized"
        exit 499
    }
    type `"${GRSTYLE_FN}"'
end

program _grstyle_refresh
    // the following commands remove the current scheme from working memory
    // so that the scheme will be reloaded when creating the next graph
    // (the code has been provided by Vince Wiggins from StataCorp)
    capt _cls free __SCHEME
    set curscm ""
end

version 9.2
mata:
mata set matastrict on

void grstyle_fn(handle, path)
{
    if (pathisabs(path)==0) path = pathjoin(pwd(), path)
    st_local("fn", pathjoin(path, "scheme-" + handle + ".scheme"))
}

void grstyle_mkdir(path)
{
    real scalar      i
    string scalar    d
    string rowvector dlist
    pragma unset     d
    pragma unset     dlist
    
    if (direxists(path)) return
    if (path=="") return
    printf("{txt}PERSONAL directory (see {helpb personal}) does not exist")
    printf("; will create directory\n")
    printf("{txt}%s\n", path)
    printf("{txt}press any key to continue, or Break to abort\n")
    more()
    while (1) {
        pathsplit(path, path, d)
        dlist = dlist, d
        if (path=="") break
        if (direxists(path)) break
    }
    for (i=cols(dlist); i>=1; i--) {
        path = pathjoin(path, dlist[i])
        mkdir(path)
    }
}

end

exit
