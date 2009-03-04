#
# Check for specified utility (env var) - if unset, fail.
#
AC_DEFUN([AC_PACKAGE_NEED_UTILITY],
  [ if test -z "$2"; then
        echo
        echo FATAL ERROR: $3 does not seem to be installed.
        echo $1 cannot be built without a working $4 installation.
        exit 1
    fi
  ])

#
# Generic macro, sets up all of the global build variables.
# The following environment variables may be set to override defaults:
#  CC MAKE TAR MAKEDEPEND AWK SED ECHO SORT RPMBUILD DPKG
#
AC_DEFUN([AC_PACKAGE_UTILITIES],
  [ AC_PROG_CXX
    cc="$CXX"
    AC_SUBST(cc)
    AC_PACKAGE_NEED_UTILITY($1, "$cc", cc, [C++ compiler])

    if test -z "$MAKE"; then
        AC_PATH_PROG(MAKE, mingw32-make,, /mingw/bin:/usr/bin:/usr/local/bin)
    fi
    if test -z "$MAKE"; then
        AC_PATH_PROG(MAKE, gmake,, /usr/bin:/usr/local/bin)
    fi
    if test -z "$MAKE"; then
        AC_PATH_PROG(MAKE, make,, /usr/bin)
    fi
    make=$MAKE
    AC_SUBST(make)
    AC_PACKAGE_NEED_UTILITY($1, "$make", make, [GNU make])

    if test -z "$TAR"; then
        AC_PATH_PROG(TAR, tar,, /bin:/usr/local/bin:/usr/bin)
    fi
    tar=$TAR
    AC_SUBST(tar)

    if test -z "$ZIP"; then
	AC_PATH_PROG(ZIP, gzip,, /bin:/usr/bin:/usr/local/bin)
    fi
    zip=$ZIP
    AC_SUBST(zip)

    if test -z "$BZIP2"; then
	AC_PATH_PROG(BZIP2, bzip2,, /bin:/usr/bin:/usr/local/bin)
    fi
    bzip2=$BZIP2
    AC_SUBST(bzip2)

    if test -z "$MAKEDEPEND"; then
        AC_PATH_PROG(MAKEDEPEND, makedepend, /bin/true)
    fi
    makedepend=$MAKEDEPEND
    AC_SUBST(makedepend)

    if test -z "$AWK"; then
        AC_PATH_PROG(AWK, awk,, /bin:/usr/bin)
    fi
    awk=$AWK
    AC_SUBST(awk)

    if test -z "$SED"; then
        AC_PATH_PROG(SED, sed,, /bin:/usr/bin)
    fi
    sed=$SED
    AC_SUBST(sed)

    if test -z "$ECHO"; then
        AC_PATH_PROG(ECHO, echo,, /bin:/usr/bin)
    fi
    echo=$ECHO
    AC_SUBST(echo)

    if test -z "$SORT"; then
        AC_PATH_PROG(SORT, sort,, /bin:/usr/bin)
    fi
    sort=$SORT
    AC_SUBST(sort)

    dnl check if symbolic links are supported
    AC_PROG_LN_S

    dnl check if rpmbuild is available
    if test -z "$RPMBUILD"
    then
	AC_PATH_PROG(RPMBUILD, rpmbuild)
    fi
    rpmbuild=$RPMBUILD
    AC_SUBST(rpmbuild)

    dnl check if the dpkg program is available
    if test -z "$DPKG"
    then
	AC_PATH_PROG(DPKG, dpkg)
    fi
    dpkg=$DKPG
    AC_SUBST(dpkg)

    dnl Check for the MacOSX PackageMaker
    AC_MSG_CHECKING([for PackageMaker])
    if test -z "$PACKAGE_MAKER"
    then
	if test -x /Developer/Applications/PackageMaker.app/Contents/MacOS/PackageMaker       
	then # Darwin 6.x
	    package_maker=/Developer/Applications/PackageMaker.app/Contents/MacOS/PackageMaker
	    AC_MSG_RESULT([ yes (darwin 6.x)])
	elif test -x /Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker
	then # Darwin 7.x
	    AC_MSG_RESULT([ yes (darwin 7.x)])
	    package_maker=/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker
	else
	    AC_MSG_RESULT([ no])
	fi
    else
	package_maker="$PACKAGE_MAKER"
    fi
    AC_SUBST(package_maker)

    dnl check if the MacOSX hdiutil program is available
    test -z "$HDIUTIL" && AC_PATH_PROG(HDIUTIL, hdiutil)
    hdiutil=$HDIUTIL
    AC_SUBST(hdiutil)

    dnl check if user wants their own lex, yacc
    if test -z "$YACC"; then
	AC_PROG_YACC
    fi
    yacc=$YACC
    AC_SUBST(yacc)
    if test -z "$LEX"; then
	AC_PROG_LEX
    fi
    lex=$LEX
    AC_SUBST(lex)
    
    dnl extra check for lex and yacc as these are often not installed
    AC_MSG_CHECKING([if yacc is executable])
    binary=`echo $yacc | awk '{cmd=1; print $cmd}'`
    binary=`which "$binary"`
    if test -x "$binary"
    then
	AC_MSG_RESULT([ yes])
    else
	AC_MSG_RESULT([ no])
	echo
	echo "FATAL ERROR: did not find a valid yacc executable."
	echo "You can either set \$YACC as the full path to yacc"
	echo "in the environment, or install a yacc/bison package."
	exit 1
    fi
    AC_MSG_CHECKING([if lex is executable])
    binary=`echo $lex | awk '{cmd=1; print $cmd}'`
    binary=`which "$binary"`
    if test -x "$binary"
    then
	AC_MSG_RESULT([ yes])
    else
	AC_MSG_RESULT([ no])
	echo
	echo "FATAL ERROR: did not find a valid lex executable."
	echo "You can either set \$LEX as the full path to lex"
	echo "in the environment, or install a lex/flex package."
	exit 1
    fi
])
