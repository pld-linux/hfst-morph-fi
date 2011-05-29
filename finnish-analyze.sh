#!/bin/bash
trdir=/usr/share/hfst/fi
if [ ! -d "$trdir" ] ; then
    echo $trdir not found
    exit 1
fi
if [ ! -e "$trdir"/fi-analysis.hfst.ol ] ; then
    echo "$trdir/fi-analysis.hfst.ol not found"
    exit 1
fi
if [ "$1" == "--help" ] ; then
    echo Usage: $0 [OUTPUT FORMAT] [FILENAME]
    exit 0
fi

# Determine which ways to analyse transducers we have available
proc_present=1
cpp_optlookup_present=1
java_optlookup_present=1
type hfst-proc > /dev/null 2>/dev/null
proc_present=$?
type hfst-optimized-lookup > /dev/null 2>/dev/null
cpp_optlookup_present=$?
type java > /dev/null 2> /dev/null
if [ $? -eq 0 ] ; then
    java HfstOptimizedLookup > /dev/null 2> /dev/null
    java_optlookup_present=$?
fi

if [ $proc_present -eq 0 ] ; then
    echo 1>&2 Using hfst-proc...
    if [ $# -lt 1 ] ; then
	hfst-proc -x "$trdir"/fi-analysis.hfst.ol
    elif [ $# -lt 2 ] ; then
	case $1 in
	    cg,CG)
		hfst-proc --cg "$trdir"/fi-analysis.hfst.ol ;;
	    apertium)
		hfst-proc --apertium "$trdir"/fi-analysis.hfst.ol ;;
	    xerox)
		hfst-proc -x "$trdir"/fi-analysis.hfst.ol ;;
	    *)
		echo Unknown output format $1, using xerox
		hfst-proc -x "$trdir"/fi-analysis.hfst.ol ;;
	esac
    else
	if [ $# -gt 3 ] ; then
	    echo 1>&2 "Ignoring $3..., for multiple file analysis use cat"
	fi
	case $1 in
	    cg,CG)
		hfst-proc --cg "$trdir"/fi-analysis.hfst.ol $2 ;;
	    apertium)
		hfst-proc --apertium "$trdir"/fi-analysis.hfst.ol $2 ;;
	    xerox)
		hfst-proc -x "$trdir"/fi-analysis.hfst.ol $2 ;;
	    *)
		echo Unknown output format $1, using xerox
		hfst-proc -x "$trdir"/fi-analysis.hfst.ol $2 ;;
	esac
    fi
elif [ $cpp_optlookup_present -eq 0 ] ; then
    echo 1>&2 Using hfst-optimized-lookup...
    if [ $# -lt 1 ] ; then
	hfst-optimized-lookup "$trdir"/fi-analysis.hfst.ol
    else
	if [ $# -gt 3 ] ; then
	    echo 1>&2 "Ignoring $3..., for multiple file analysis use cat"
	fi
	hfst-optimized-lookup "$trdir"/fi-analysis.hfst.ol < $2
    fi
elif [ $java_optlookup_present -eq 0 ] ; then
    echo 1>&2 Using hfst-optimized-lookup-java...
    if [ $# -lt 1 ] ; then
	java HfstOptimizedLookup "$trdir"/fi-analysis.hfst.ol
    else
	if [ $# -gt 3 ] ; then
	    echo 1>&2 "Ignoring $3..., for multiple file analysis use cat"
	fi
	java HfstOptimizedLookup "$trdir"/fi-analysis.hfst.ol < $2
    fi
else
    echo "Unable to find analysis utility; tried hfst-proc,"
    echo "hfst-optimized-lookup and hfst-optimized-lookup-java."
    exit 1
fi
