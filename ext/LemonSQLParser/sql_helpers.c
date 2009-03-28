static void  sql_create_table();
static void  add_column_definition(Token);

static VALUE rb_table_name;
static VALUE rb_column_definitions;

#define set_table(tbl)  { rb_table_name = token_to_rb_str(tbl); }

static void sql_init_parser() {
  rb_column_definitions = rb_ary_new();
}

static void sql_create_table() {
  VALUE class = rb_path2class("Guillotine::Expressions::CreateTable");
  rb_funcall(class,
             rb_intern("new"),
             2,
             rb_table_name,
             rb_column_definitions);
}

static void add_column_definition(Token column) {
  VALUE class = rb_path2class("Guillotine::Expressions::ColumnDefinition");
  VALUE rb_str = token_to_rb_str(column);
  VALUE instance = rb_funcall(class, rb_intern("new"), 1, rb_str);

  rb_ary_push(rb_column_definitions, instance);
}
