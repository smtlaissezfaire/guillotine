#include <ruby.h>
#include <stdbool.h>

#include "tokenizer.c"

static VALUE rb_sql_parse(VALUE self, VALUE string) {
  int success = lemon_sql_parse(RSTRING_PTR(string));
  
  if (success) {
    return self;
  } else {
    return Qnil;
  }
}

static VALUE rb_sql_eval(VALUE self) {
  return self;
}

void Init_LemonSQLParser() {
	VALUE LemonSQLParser = rb_define_class_under(rb_path2class("Guillotine::Parser"), "LemonSQLParser", rb_cObject);
	rb_define_method(LemonSQLParser, "parse", rb_sql_parse, 1);
	rb_define_method(LemonSQLParser, "eval",  rb_sql_eval, 0);
}
