#!/bin/sh
#
# @file    plotresults.sh
# @brief   Plot SBML Test Suite case results using gnuplot & batik
# @author  Michael Hucka <mhucka@caltech.edu>
# 
# $Id$
# $HeadURL$
#
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
# This file is part of the SBML Test Suite.  Please visit http://sbml.org for
# more information about SBML, and the latest version of the SBML Test Suite.
#
# Copyright 2008-2010 California Institute of Technology.
# 
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation.  A copy of the license agreement is provided
# in the file named "LICENSE.txt" included with this software distribution
# and also available at http://sbml.org/Software/SBML_Test_Suite/license.html
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

USAGE_TEXT="Usage: `basename $0`  XXXXX-results.csv

This program takes the input file (assumed be a comma-separated value file)
and runs it through gnuplot to produce a plot in an SVG file.  The output
file is named after the basename of the input file.  The input file should
normally have a name of the form XXXXX-results.csv.

This free program is part of the SBML Test Suite and is distributed under
the terms of the LGPL.  For more information, please visit http://sbml.org/.
"

# -----------------------------------------------------------------------------
# Initialization
# -----------------------------------------------------------------------------

GNUPLOT=gnuplot
EMPTYPLOTFILE=`dirname $0`/red-not-circle.svg

# -----------------------------------------------------------------------------
# Main body.
# -----------------------------------------------------------------------------

# Did we get the required number of arguments?
# Or did the user ask for help?

if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$USAGE_TEXT"
    exit 1
fi

# Does it look like we were provided with a .csv file?

CSV_FILE=$1

if [ ! "${CSV_FILE/*./}" = "csv" ]; then
    echo \"$1\" does not appear to be a CSV file.
    echo ""
    echo "$USAGE_TEXT"
    exit 1
fi

# Make sure we have a sufficient version of gnuplot

VERS=`gnuplot --version | tr -d '\015'`
major_vers=`expr "$VERS" : 'gnuplot \([0-9]*\)\.[0-9]*'`
minor_vers=`expr "$VERS" : 'gnuplot [0-9]*\.\([0-9]*\)'`

if test 4 -gt $major_vers || test $major_vers -eq 4 && test 2 -gt $minor_vers
then
    echo Very sorry, but this script needs gnuplot version 4.2 or higher.
    echo Quitting.
    exit 1
fi

# OK, let's get started.

INPUTFILE="`echo $CSV_FILE | sed -e 's/-results/-plot/'`"

trap "rm -f $INPUTFILE; exit" INT TERM EXIT

# 1) Windows line-ending conventions screw up gnuplot, which reads the ^M
# at the end of the title line and ends up thinking it's a character in a
# column name.  (You end up with this weird little angle-bracket character
# as part of the last column's title.)  The following removes trailing
# ^M's.
#
# 2) While we're mucking with the content, let's rename the column titles
# from the Mathematica pattern of, e.g., "case00350`S1" to just "S1".

sed -e 's/case[0-9][0-9][0-9][0-9][0-9][`]//g' < $CSV_FILE | tr -d '\015' > $INPUTFILE

# Check for INF or NaN values, which currently we don't have a way to draw,
# and substitute a special graphic instead of a plot.

if test -n "`egrep 'NaN|INF' ${CSV_FILE}`"; then
    cp -f ${EMPTYPLOTFILE} ${INPUTFILE/.csv/.svg}
else
    $GNUPLOT 2> /dev/null 1>/dev/null -<<EOF
    set border 0
    set datafile separator ","
    set key spacing 1.1
    set key height 0
    set key width 1
    set key below
    set key title 'Legend'
    set rmargin 3
    set bmargin 11
    set lmargin 15
    set size 0.98,0.98
    set style increment user
    set term svg size 700,600
    set output "${INPUTFILE/%.csv}.svg"
    plot for [n=2:100] "$INPUTFILE" using 1:n title column (n) with lines linewidth 2
EOF
fi
