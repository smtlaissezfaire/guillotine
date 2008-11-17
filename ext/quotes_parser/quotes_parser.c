#include "quotes_parser.h"

static char * parse(char * string) {
  at = 0;
  original_string = string;
  buffer = calloc(sizeof(char), strlen(original_string) + 1);

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
  if (upcasing && !in_quotes && islower(c)) {
    c = toupper(c);
  }
  buffer[strlen(buffer)] = c;
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

static bool rb_to_bool(VALUE value) {
  return (value == Qnil || value == Qfalse) ? false : true;
}

// Ruby-C bindings
void Init_quotes_parser() {
	QuotesParser = rb_define_class_under(rb_path2class("Guillotine::Parser"), "QuotesParser", rb_cObject);
	rb_define_method(QuotesParser, "parse", quotes_parser, -1);
}

VALUE quotes_parser(int argc, VALUE *argv, VALUE self) {
  VALUE ruby_string;
  VALUE upcase;
  char *string;

  rb_scan_args(argc, argv, "11", &ruby_string, &upcase);

  if (string = RSTRING(ruby_string)->ptr)  {
    upcasing = rb_to_bool(upcase);
    return rb_str_new2(parse(string));
  } else {
    return Qnil;
  }
}
