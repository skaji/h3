use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::Copy 'copy';

WriteMakefile
    NAME => 'H3',
    VERSION_FROM => 'lib/H3.pm',
    EXE_FILES => [glob "bin/* script/*"],
    NO_MYMETA => 1,
    INC => "-Ilibh3/include",
    CCFLAGS => '-std=c99 -Werror -Wall -Wextra',
    MYEXTLIB => "libh3/libh3.a",
    clean => {FILES => "libh3/libh3.a libh3/src/*.o"},
;

copy 'META.json' => 'MYMETA.json' if -f 'META.json';

{
    package MY;
    sub postamble {
        <<'...';
$(MYEXTLIB):
	if [ ! -e libh3/.git ]; then git submodule update --init; fi
	cd libh3/src && $(CC) -fPIC -c -o hash.o              hash.c              -std=c99 -I../include -Wall -O2
	cd libh3/src && $(CC) -fPIC -c -o header_field.o      header_field.c      -std=c99 -I../include -Wall -O2
	cd libh3/src && $(CC) -fPIC -c -o header_field_list.o header_field_list.c -std=c99 -I../include -Wall -O2
	cd libh3/src && $(CC) -fPIC -c -o mempool.o           mempool.c           -std=c99 -I../include -Wall -O2
	cd libh3/src && $(CC) -fPIC -c -o request_header.o    request_header.c    -std=c99 -I../include -Wall -O2
	cd libh3/src && $(CC) -fPIC -c -o scanner.o           scanner.c           -std=c99 -I../include -Wall -O2
	cd libh3 && $(AR) rcs libh3.a src/*.o
...
    }
}
