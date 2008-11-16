
static char *       original_string = NULL;
static char *       buffer          = NULL;
static unsigned int at              = 0;
static bool         in_quotes       = false;
static bool         upcasing        = true;
static char         starting_quote;

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

#define SINGLE_QUOTE '\''
#define DOUBLE_QUOTE '\"'
#define BACKTICK     '`'
#define SPACE        ' '

VALUE QuotesParser = Qnil;
void  Init_quotes_parser();
VALUE quotes_parser(int, VALUE *, VALUE);

