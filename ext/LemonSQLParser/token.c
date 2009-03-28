
struct Token {
  int length;
  char *start;
};

typedef struct Token Token;
typedef char *       String;

extern VALUE rb_ary_new(void);

Token Token_create(String start, int length) {
  Token token;

  token.length = length;
  token.start  = start;

  return token;
}

String token_to_string(Token token) {
  if (token.length == 0) {
    return "";
  } else {
    String str = malloc(sizeof(String) * (token.length + 1));

    strncpy(str, token.start, token.length);
    str[token.length] = '\0';
   
    return str;
  }
}

VALUE token_to_rb_str(Token token) {
  if (token.length > 0) {
    return rb_str_new2(token_to_string(token));
  } else {
    return rb_str_new2("");
  }
}
