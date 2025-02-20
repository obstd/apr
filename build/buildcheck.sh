#! /bin/sh

echo "buildconf: checking installation..."
res=0

# any python
python=${PYTHON-`build/PrintPath python3 python2 python`}
if test -z "$python"; then
  echo "buildconf: python not found."
  echo "           You need python installed"
  echo "           to build APR from SVN."
  res=1
else
  py_version=`$python -c 'import sys; print(sys.version)' 2>&1|sed 's/ .*//;q'`
  echo "buildconf: python version $py_version (ok)"
fi

# autoconf 2.59 or newer
ac_version=`${AUTOCONF:-autoconf} --version 2>/dev/null|sed -e 's/^[^0-9]*//;s/[a-z]* *$//;q'`
if test -z "$ac_version"; then
  echo "buildconf: autoconf not found."
  echo "           You need autoconf version 2.59 or newer installed"
  echo "           to build APR from SVN."
  res=1
else
  IFS=.; set $ac_version; IFS=' '
  if test "$1" = "2" -a "$2" -lt "59" || test "$1" -lt "2"; then
    echo "buildconf: autoconf version $ac_version found."
    echo "           You need autoconf version 2.59 or newer installed"
    echo "           to build APR from SVN."
    res=1
  else
    echo "buildconf: autoconf version $ac_version (ok)"
  fi
fi

# Sample libtool --version outputs:
# ltmain.sh (GNU libtool) 1.3.3 (1.385.2.181 1999/07/02 15:49:11)
# ltmain.sh (GNU libtool 1.1361 2004/01/02 23:10:52) 1.5a
# output is multiline from 1.5 onwards

# Require libtool 1.4 or newer
if test -z "$libtool"; then
  libtool=`build/PrintPath glibtool1 glibtool libtool libtool15 libtool14 libtoolize`
fi
lt_pversion=`$libtool --version 2>/dev/null|sed -e 's/([^)]*)//g;s/^[^0-9]*//;s/[- ].*//g;q'`
if test -z "$lt_pversion"; then
  echo "buildconf: libtool not found."
  echo "           You need libtool version 1.4 or newer installed"
  echo "           to build APR from SVN."
  res=1
else
  lt_version=`echo $lt_pversion|sed -e 's/\([a-z]*\)$/.\1/'`
  IFS=.; set $lt_version; IFS=' '
  lt_status="good"
  if test "$1" = "1"; then
    if test "$2" -lt "4"; then
      lt_status="bad"
    fi
  fi
  if test $lt_status = "good"; then
    echo "buildconf: libtool version $lt_pversion (ok)"
  else
    echo "buildconf: libtool version $lt_pversion found."
    echo "           You need libtool version 1.4 or newer installed"
    echo "           to build APR from SVN."
    res=1
  fi
fi

exit $res

