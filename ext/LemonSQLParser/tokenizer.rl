#ifndef SQL_TOKENIZER
#define SQL_TOKENIZER

#define TOKENIZING_ERROR sql_error // search for _error in the ragel docs

#ifndef SQL_PARSER
#include "parser.h"
#include "parser.c"
#endif

extern void *ParseAlloc(void *(*mallocProc)(size_t));
extern void ParseFree(void *, void (*)(void*));

#define PARSE_TV(TOKEN, VALUE)           Parse(pParser, TOKEN, VALUE, &state)

//parse a "simple" token - one with no value
#define NULL_TOKEN                       Token_create(NULL, 0)
#define PARSE_ST(TOKEN)                  PARSE_TV(TOKEN, NULL_TOKEN)
//parse a regular token, keeping value
#define PARSE_T(TOKEN)                   PARSE_TV(TOKEN, CURRENT_TOKEN)
#define CURRENT_TOKEN                    Token_create(ts, te-ts)

// show all of the steps lemon is going through
#define SHOW_PARSING_LOGIC 0

%%{
  machine sql;

  ws                               = " ";
  comma                            = ",";
  open_paren                       = "(";
  close_paren                      = ")";
  backtick                         = "`";
  simple_identifier                = [a-z]+;
  backticked_identifier            = backtick simple_identifier backtick;
  identifier                       = (backticked_identifier | simple_identifier);

  bit_column_type = "BIT";
  int_column_type = "INT (11)";
  column_types = (bit_column_type | int_column_type);

  create       = "CREATE";
  table        = "TABLE";

  main := |*
    create       => { PARSE_ST(CREATE);       };
    table        => { PARSE_ST(TABLE);        };
    identifier   => { PARSE_T(ID);            };
    column_types => { PARSE_ST(COLUMN_TYPE);  };
    open_paren   => { PARSE_ST(OPEN_PAREN);   };
    close_paren  => { PARSE_ST(CLOSE_PAREN);  };
    open_paren   => { PARSE_ST(OPEN_PAREN);   };
    close_paren  => { PARSE_ST(CLOSE_PAREN);  };
    comma        => { PARSE_ST(COMMA);        };
    ws+          => { };
  *|;
}%%

%% write data nofinal;

static int lemon_sql_parse(char *string) {
  int cs, act = 0;
  char *eof = 0;
  char *ts, *te = string;
  int status = 0;
  int state = 0;

  void* pParser = ParseAlloc(malloc);

  sql_init_parser();

  if (SHOW_PARSING_LOGIC) {
    ParseTrace(stdout, "lemon_trace:");
  }

  %% write init;

  char *p = string;
  char *pe = string + strlen(p);
    
  %% write exec;

  Parse(pParser, 0, NULL_TOKEN, &state);
  ParseFree(pParser, free);

  if (cs == sql_error || state == PARSE_ERROR) {
    status = 0;
  } else {
    status = 1;
  }

  return status;
}

#endif
