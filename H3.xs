#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "h3.h"

static char tou(char ch) {
    if ('a' <= ch && ch <= 'z') {
        ch -= 'a' - 'A';
    }
    return ch;
}

MODULE = H3 PACKAGE = H3
PROTOTYPES: DISABLE

void
http_header_parse(...)
PPCODE:
{
    if (items != 1) {
        croak("missing argument");
    }
    SV* header_string = ST(0);
    if (!SvPOK(header_string)) {
        croak("argument is not a string");
    }
    STRLEN len;
    char *ptr;
    ptr = SvPV(header_string, len);

    RequestHeader *header = h3_request_header_new();
    h3_request_header_parse(header, ptr, len);

    HV* header_hash = newHV();
    hv_store(header_hash,
        "SERVER_PROTOCOL", strlen("SERVER_PROTOCOL"),
        newSVpv(header->HTTPVersion, header->HTTPVersionLen),
        0
    );
    hv_store(header_hash,
        "REQUEST_METHOD", strlen("REQUEST_METHOD"),
        newSVpv(header->RequestMethod, header->RequestMethodLen),
        0
    );
    hv_store(header_hash,
        "REQUEST_URI", strlen("REQUEST_URI"),
        newSVpv(header->RequestURI, header->RequestURILen),
        0
    );

    for (unsigned int i = 0; i < header->HeaderSize; i++) {
        HeaderField field = header->Fields[i];
        char field_name[ field.FieldNameLen + 5 ];
        strcpy(field_name, "HTTP_");

        const char* c;
        int l;
        int d;
        for (
            c = field.FieldName, l = field.FieldNameLen, d = 5;
            l > 0;
            c++, l--, d++
        ) {
            field_name[d] = *c == '-' ? '_' : tou(*c);
        }

        hv_store(header_hash,
            field_name, field.FieldNameLen + 5,
            newSVpv(header->Fields[i].Value, header->Fields[i].ValueLen),
            0
        );
    }
    h3_request_header_free(header);

    XPUSHs(sv_2mortal((SV*)newRV_noinc((SV*)header_hash)));
    XSRETURN(1);
}
