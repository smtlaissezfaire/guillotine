#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <ruby.h>

#define SINGLE_QUOTE '\''
#define DOUBLE_QUOTE '\"'
#define BACKTICK     '`'
#define SPACE        ' '

static char *       original_string = NULL;
static char *       buffer          = NULL;
static unsigned int at              = 0;
static bool         in_quotes       = false;
static bool         upcasing        = true;
static char         starting_quote;
       VALUE        QuotesParser    = Qnil;

static char * parse();
static bool   chars_left();
static char   current_char();
static char   next_char();
static void   eat_whitespace();
static void   add_current_char();
static void   add_to_buffer(char);
static void   update_quote_status();
static int    advance_char();
static bool   a_quote(char);
static bool   rb_to_bool(VALUE);
       void   Init_quotes_parser();
       VALUE  quotes_parser(int, VALUE *);
