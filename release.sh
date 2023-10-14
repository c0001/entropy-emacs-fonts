#!/bin/sh
set -e

err_exit ()
{
    echo "err: $*" ; exit 1
}

arc_fname=eemacs-fonts_v$(cat .version).tar.xz

if [ -f $arc_fname ] ; then
    err_exit "release archive exist: $arc_fname"
fi

tar -Jcv -f $arc_fname \
    install.sh .version README.org Fonts
sha256sum -b $arc_fname > ${arc_fname}.sha256sum.log
