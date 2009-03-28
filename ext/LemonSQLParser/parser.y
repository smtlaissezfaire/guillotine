%include {
  #include <stdlib.h>
  #include <stdio.h>
  #include <string.h>
  #include <stdbool.h>

  #include "token.c"
  #include "sql_helpers.c"

  #define PARSE_ERROR 1
}

%token_type Token

%extra_argument { int *state }

%syntax_error {
  *state = PARSE_ERROR;
}

sql ::= create_table.

create_table ::= CREATE TABLE table_name(A) table_declaration.

table_declaration ::= OPEN_PAREN column_list CLOSE_PAREN. {
  sql_create_table();
}

column_list ::= column_list COMMA column_declaration(A).
column_list ::= column_declaration(A).

column_declaration ::= column_name column_type.

column_name ::= ID(A). {
  add_column_definition(A);
}

column_type ::= COLUMN_TYPE.

table_name ::= ID(A). { 
  set_table(A); 
}
