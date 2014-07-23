use strict;
use warnings;
use utf8;
use Test::More;
use Test::Requires 'Test::LeakTrace';
use H3 'http_header_parse';
use constant CRLF => "\x0d\x0a";

no_leaks_ok {
    my $header_body = join "", (
        "GET /method HTTP/1.1", CRLF,
        "Host: github.com", CRLF,
        "Connection: keep-alive", CRLF,
        "Content-Length: 12611", CRLF,
        "Cache-Control: no-cache", CRLF,
        CRLF,
    );
    my $header = http_header_parse $header_body;
};


done_testing;

