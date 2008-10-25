#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#define SINGLE_QUOTE '\''
#define DOUBLE_QUOTE '\"'
#define BACKTICK     '`'
#define SPACE        ' '

char   original_string[1000];
char   buffer[1000] = "";
int    at        = 0;
bool   in_quotes = false;
char   starting_quote;

char * parse_and_eval();
bool chars_left();
char current_char();
char next_char();
void eat_whitespace();
void add_current_char();
void add_to_buffer(char);
void update_quote_status();
int advance_char();
bool a_quote(char);

int main(int argc, char **argv) {
  strcpy(original_string, argv[1]);
  parse_and_eval();
  printf("%s", buffer);
  return 0;
}

char * parse_and_eval() {
  while (chars_left()) {
    eat_whitespace();

    if (chars_left()) {
      add_current_char();
    }
  }
  return buffer;
}

bool chars_left() {
  return (at < strlen(original_string));
}

char current_char() {
  return original_string[at];
}

char next_char() {
  return original_string[at + 1];
}

void eat_whitespace() {
  if (in_quotes == false && current_char() == SPACE && next_char() == SPACE) {
    advance_char();
    eat_whitespace();
  }
}

void add_current_char() {
  update_quote_status();
  add_to_buffer(current_char());
  advance_char();
}

int advance_char() {
  return at++;
}

void add_to_buffer(char c) {
  char array[2] = "";
  array[0] = c;
  strcat(buffer, array);
}

void update_quote_status() {
  char c = current_char();

  if (in_quotes == true) {
    if (c == starting_quote) {
      in_quotes = false;
      starting_quote = c;
    }
  } else if (a_quote(c)) {
    in_quotes = true;
    starting_quote = c;
  }
}

bool a_quote(char c) {
  return(c == SINGLE_QUOTE || c == DOUBLE_QUOTE || c == BACKTICK);
}
