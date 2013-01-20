Find the copied subs in perl code
=================================

DESCRIPTION
-----------

Find the copied subs in perl code via PPI

SYNOPSIS
--------

    find_copypaste_perl_subs.pl $(find . -type f -name "*.p[lm]")

INSTALLATION
------------
Install dependencies:

    sudo cpan PPI

And install script:

if `~/bin/` exists in your `$PATH`:

    curl "https://raw.github.com/msoap/find-copypaste-perl-subs/master/find_copypaste_perl_subs.pl" > ~/bin/find_copypaste_perl_subs.pl
    chmod 744 ~/bin/find_copypaste_perl_subs.pl

or

    sudo sh -c 'curl "https://raw.github.com/msoap/find-copypaste-perl-subs/master/find_copypaste_perl_subs.pl" > /usr/local/bin/find_copypaste_perl_subs.pl'
    sudo sh -c 'chmod 744 /usr/local/bin/find_copypaste_perl_subs.pl'

AUTHOR
------
Sergey Mudrik
