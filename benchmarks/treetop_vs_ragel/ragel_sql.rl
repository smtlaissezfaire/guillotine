%%{ 
  machine sql;

  table_name = "foo";
  from_clause = "FROM"  space  table_name;
  table_names = "*";
  select_clause = "SELECT" space  table_names;

  select = select_clause space from_clause;
  
  insert = "INSERT INTO foo VALUES (1,2)";
  
  command = select | insert;

  main := command;
}%%

class RagelSQLParser
  %% write data;

  class Error < StandardError; end
  class InvalidMessageFormat < Error; end

  def self.parse(input)
    data = input
    p = 0;
    pe = data.length
    cs = 0
    
    %% write init;
    %% write exec;

    if cs >= sql_first_final
      data
    else
      puts "couldn't parse #{input}"
    end
  end

  def parse(string)
    self.class.parse(string)
  end
end
