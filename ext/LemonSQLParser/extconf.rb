require 'mkmf'

# Compile with full warnings on (even though lemon generates warnings)
$CFLAGS = "-Wall -Wextra"

# don't link the tokenizer and the parser.  They are
# #includ'ed into the files
$objs = ["LemonSQLParser.o"]

dir_config("LemonSQLParser")

create_makefile("LemonSQLParser")
