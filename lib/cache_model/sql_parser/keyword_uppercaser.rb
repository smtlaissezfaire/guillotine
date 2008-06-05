module CacheModel
  class KeywordUppercaser
    # Taken from the mysql docs:
    # http://dev.mysql.com/doc/refman/5.0/en/reserved-words.html
    KEYWORDS = Set.new [
      "ADD",
      "ALL",
      "ALTER",
      "ANALYZE",
      "AND",
      "AS",
      "ASC",
      "ASENSITIVE",
      "BEFORE",
      "BETWEEN",
      "BIGINT",
      "BINARY",
      "BLOB",
      "BOTH",
      "BY",
      "CALL",
      "CASCADE",
      "CASE",
      "CHANGE",
      "CHAR",
      "CHARACTER",
      "CHECK",
      "COLLATE",
      "COLUMN",
      "CONDITION",
      "CONSTRAINT",
      "CONTINUE",
      "CONVERT",
      "CREATE",
      "CROSS",
      "CURRENT_DATE",
      "CURRENT_TIME",
      "CURRENT_TIMESTAMP",
      "CURRENT_USER",
      "CURSOR",
      "DATABASE",
      "DATABASES",
      "DAY_HOUR",
      "DAY_MICROSECOND",
      "DAY_MINUTE",
      "DAY_SECOND",
      "DEC",
      "DECIMAL",
      "DECLARE",
      "DEFAULT",
      "DELAYED",
      "DELETE",
      "DESC",
      "DESCRIBE",
      "DETERMINISTIC",
      "DISTINCT",
      "DISTINCTROW",
      "DIV",
      "DOUBLE",
      "DROP",
      "DUAL",
      "EACH",
      "ELSE",
      "ELSEIF",
      "ENCLOSED",
      "ESCAPED",
      "EXISTS",
      "EXIT",
      "EXPLAIN",
      "FALSE",
      "FETCH",
      "FLOAT",
      "FLOAT4",
      "FLOAT8",
      "FOR",
      "FORCE",
      "FOREIGN",
      "FROM",
      "FULLTEXT",
      "GRANT",
      "GROUP",
      "HAVING",
      "HIGH_PRIORITY",
      "HOUR_MICROSECOND",
      "HOUR_MINUTE",
      "HOUR_SECOND",
      "IF",
      "IGNORE",
      "IN",
      "INDEX",
      "INFILE",
      "INNER",
      "INOUT",
      "INSENSITIVE",
      "INSERT",
      "INT",
      "INT1",
      "INT2",
      "INT3",
      "INT4",
      "INT8",
      "INTEGER",
      "INTERVAL",
      "INTO",
      "IS",
      "ITERATE",
      "JOIN",
      "KEY",
      "KEYS",
      "KILL",
      "LEADING",
      "LEAVE",
      "LEFT",
      "LIKE",
      "LIMIT",
      "LINES",
      "LOAD",
      "LOCALTIME",
      "LOCALTIMESTAMP",
      "LOCK",
      "LONG",
      "LONGBLOB",
      "LONGTEXT",
      "LOOP",
      "LOW_PRIORITY",
      "MATCH",
      "MEDIUMBLOB",
      "MEDIUMINT",
      "MEDIUMTEXT",
      "MIDDLEINT",
      "MINUTE_MICROSECOND",
      "MINUTE_SECOND",
      "MOD",
      "MODIFIES",
      "NATURAL",
      "NOT",
      "NO_WRITE_TO_BINLOG",
      "NULL",
      "NUMERIC",
      "ON",
      "OPTIMIZE",
      "OPTION",
      "OPTIONALLY",
      "OR",
      "ORDER",
      "OUT",
      "OUTER",
      "OUTFILE",
      "PRECISION",
      "PRIMARY",
      "PROCEDURE",
      "PURGE",
      "READ",
      "READS",
      "REAL",
      "REFERENCES",
      "REGEXP",
      "RELEASE",
      "RENAME",
      "REPEAT",
      "REPLACE",
      "REQUIRE",
      "RESTRICT",
      "RETURN",
      "REVOKE",
      "RIGHT",
      "RLIKE",
      "SCHEMA",
      "SCHEMAS",
      "SECOND_MICROSECOND",
      "SELECT",
      "SENSITIVE",
      "SEPARATOR",
      "SET",
      "SHOW",
      "SMALLINT",
      "SONAME",
      "SPATIAL",
      "SPECIFIC",
      "SQL",
      "SQLEXCEPTION",
      "SQLSTATE",
      "SQLWARNING",
      "SQL_BIG_RESULT",
      "SQL_CALC_FOUND_ROWS",
      "SQL_SMALL_RESULT",
      "SSL",
      "STARTING",
      "STRAIGHT_JOIN",
      "TABLE",
      "TERMINATED",
      "THEN",
      "TINYBLOB",
      "TINYINT",
      "TINYTEXT",
      "TO",
      "TRAILING",
      "TRIGGER",
      "TRUE",
      "UNDO",
      "UNION",
      "UNIQUE",
      "UNLOCK",
      "UNSIGNED",
      "UPDATE",
      "USAGE",
      "USE",
      "USING",
      "UTC_DATE",
      "UTC_TIME",
      "UTC_TIMESTAMP",
      "VALUES",
      "VARBINARY",
      "VARCHAR",
      "VARCHARACTER",
      "VARYING",
      "WHEN",
      "WHERE",
      "WHILE",
      "WITH",
      "WRITE",
      "XOR",
      "YEAR_MONTH",
      "ZEROFILL",
      "ASENSITIVE",
      "CALL",
      "CONDITION",
      "CONNECTION",
      "CONTINUE",
      "CURSOR",
      "DECLARE",
      "DETERMINISTIC",
      "EACH",
      "ELSEIF",
      "EXIT",
      "FETCH",
      "GOTO",
      "INOUT",
      "INSENSITIVE",
      "ITERATE",
      "LABEL",
      "LEAVE",
      "LOOP",
      "MODIFIES",
      "OUT",
      "READS",
      "RELEASE",
      "REPEAT",
      "RETURN",
      "SCHEMA",
      "SCHEMAS",
      "SENSITIVE",
      "SPECIFIC",
      "SQL",
      "SQLEXCEPTION",
      "SQLSTATE",
      "SQLWARNING",
      "TRIGGER",
      "UNDO",
      "UPGRADE",
      "WHILE"
    ] unless defined?(KEYWORDS)

    QUOTES = Set.new ['"', "'"] unless defined?(QUOTES)

    
    class << self
      def keywords
        @keywords ||= KEYWORDS
      end

      def quotes
        @quotes ||= QUOTES
      end

      # extract this to object
      def attr_boolean(*syms)
        syms.each do |sym|
          define_method "#{sym}?" do 
            instance_variable_get("@#{sym}") ? true : false
          end
        end
      end
    end

    def initialize(string)
      @string = string
    end

    def upcase
      words.map do |word|
        upcase_word(word)
      end.join(" ")
    end

    def words(string=@string, array=[])
      string.split(" ")
    end

  private

    def upcase_word(word)
      upcased_word = word.upcase

      @in_quoted_state = true if quoted?(word)

      if in_quoted_state?
        if ends_with_quote?(word)
          @in_quote_state = false
        end
        word
      elsif included_keyword?(upcased_word)
        upcased_word
      else
        word
      end
    end

    attr_boolean :in_quoted_state

    def not_quoted?(word)
      !quoted?(word)
    end

    def quoted?(word)
      a_quote?(word.first)
    end

    def ends_with_quote?(word)
      a_quote?(word.last)
    end

    def a_quote?(char)
      quotes.include?(char)
    end

    def quotes
      @quotes ||= self.class.quotes
    end

    def included_keyword?(word)
      keywords.include?(word)
    end

    def keywords
      @keywords ||= self.class.keywords
    end
  end
end
