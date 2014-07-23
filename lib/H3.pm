package H3;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';
use Exporter 'import';
our @EXPORT_OK = qw(http_header_parse);

use XSLoader;
XSLoader::load __PACKAGE__, $VERSION;

1;
__END__

=encoding utf-8

=head1 NAME

H3 - a perl binding for h3

=head1 SYNOPSIS

    use H3 'http_header_parse';
    use constant CRLF => "\x0d\x0a";
    my $header_string = join "", (
        "GET /method HTTP/1.1",    CRLF,
        "Host: github.com",        CRLF,
        "Connection: keep-alive",  CRLF,
        "Content-Length: 12611",   CRLF,
        "Cache-Control: no-cache", CRLF,
        CRLF,
    );

    my $header = http_header_parse $header_body;
    # {
    #     'HTTP_CACHE_CONTROL' => 'no-cache',
    #     'HTTP_CONNECTION' => 'keep-alive',
    #     'HTTP_CONTENT_LENGTH' => '12611',
    #     'HTTP_HOST' => 'github.com',
    #     'REQUEST_METHOD' => 'GET',
    #     'REQUEST_URI' => '/method',
    #     'SERVER_PROTOCOL' => 'HTTP/1.1',
    # }


=head1 DESCRIPTION

H3 is a perl binding for h3.

=head1 SEE ALSO

L<https://github.com/c9s/h3|https://github.com/c9s/h3>

=head1 LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 AUTHOR

Shoichi Kaji E<lt>skaji@cpan.orgE<gt>

=cut

