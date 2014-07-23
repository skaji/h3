use strict;
use warnings;
use utf8;
use Test::More;
use H3 'http_header_parse';
use Data::Dumper;
use constant CRLF => "\x0d\x0a";

my $header_body = join "", (
    "GET /method HTTP/1.1", CRLF,
    "Host: github.com", CRLF,
    "Connection: keep-alive", CRLF,
    "Content-Length: 12611", CRLF,
    "Cache-Control: no-cache", CRLF,
    CRLF,
);

my $header = http_header_parse $header_body;

is_deeply $header, {
    'HTTP_CACHE_CONTROL' => 'no-cache',
    'HTTP_CONNECTION' => 'keep-alive',
    'HTTP_CONTENT_LENGTH' => '12611',
    'HTTP_HOST' => 'github.com',
    'REQUEST_METHOD' => 'GET',
    'REQUEST_URI' => '/method',
    'SERVER_PROTOCOL' => 'HTTP/1.1',
};

note Dumper $header;


done_testing;

