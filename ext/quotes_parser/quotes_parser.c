#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "ruby.h"

#define SINGLE_QUOTE '\''
#define DOUBLE_QUOTE '\"'
#define BACKTICK     '`'
#define SPACE        ' '

VALUE QuotesParser = Qnil;

static char * original_string;
static char * buffer;
static int    at        = 0;
static bool   in_quotes = false;
static char   starting_quote;

static char * parse();
static bool chars_left();
static char current_char();
static char next_char();
static void eat_whitespace();
static void add_current_char();
static void add_to_buffer(char);
static void update_quote_status();
static int advance_char();
static bool a_quote(char);

void Init_quotes_parser();
VALUE quotes_parser(VALUE, VALUE);

/* int main(int argc, char **argv) { */
/*   char * first_arg = argv[1]; */
/*   printf("first arg: %s\n", first_arg); */
/*   printf("results of buffer: %s\n", parse(first_arg)); */
/*   printf("results of buffer: %s\n", buffer); */
/*   return 0; */
/* } */

static char * parse(char * string) {
  at = 0;
  free(original_string);
  free(buffer);
  original_string = malloc(sizeof(char) * strlen(string));
  original_string = strcpy(original_string, string);
  buffer = calloc(sizeof(char), strlen(string));

  while (chars_left()) {
    eat_whitespace();

    if (chars_left()) {
      add_current_char();
    }
  }

  return buffer;
}

static bool chars_left() {
  return (at < strlen(original_string));
}

static char current_char() {
  return original_string[at];
}

static char next_char() {
  return original_string[at + 1];
}

static void eat_whitespace() {
  if (in_quotes == false && current_char() == SPACE && next_char() == SPACE) {
    advance_char();
    eat_whitespace();
  }
}

static void add_current_char() {
  update_quote_status();
  add_to_buffer(current_char());
  advance_char();
}

static int advance_char() {
  return at++;
}

static void add_to_buffer(char c) {
  char array[2] = "";
  array[0] = c;
  strcat(buffer, array);
}

static void update_quote_status() {
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

static bool a_quote(char c) {
  return(c == SINGLE_QUOTE || c == DOUBLE_QUOTE || c == BACKTICK);
}

// Ruby-C bindings

void Init_quotes_parser() {
	QuotesParser = rb_define_module("QuotesParser");
	rb_define_method(QuotesParser, "parse", quotes_parser, 1);
}

VALUE quotes_parser(VALUE self, VALUE ruby_string) {
	return rb_str_new2(parse(RSTRING(ruby_string)->ptr));
}
