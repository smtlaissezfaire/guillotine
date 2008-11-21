require 'mkmf'

$CFLAGS += " -W -Wall"

dir_config("quotes_parser")
create_makefile("quotes_parser")
