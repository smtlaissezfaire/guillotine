module CacheModel
  module Keywords
    IMPLEMENTED_KEYWORDS = Set.new [
      :AND,
      :ASC,
      :BY,
      :DELETE,
      :DESC,
      :FROM,
      :IS,
      :NOT,
      :NULL,
      :OR,
      :ORDER,
      :WHERE,
      :SELECT,
    ] unless defined?(IMPLEMENTED_KEYWORDS)
    
    NOT_IMPLEMENTED_KEYWORDS = Set.new [
      :ADD,
      :ALL,
      :ALTER,
      :ANALYZE,
      :AS,
      :ASENSITIVE,
      :BEFORE,
      :BETWEEN,
      :BIGINT,
      :BINARY,
      :BLOB,
      :BOTH,
      :CALL,
      :CASCADE,
      :CASE,
      :CHANGE,
      :CHAR,
      :CHARACTER,
      :CHECK,
      :COLLATE,
      :COLUMN,
      :CONDITION,
      :CONSTRAINT,
      :CONTINUE,
      :CONVERT,
      :CREATE,
      :CROSS,
      :CURRENT_DATE,
      :CURRENT_TIME,
      :CURRENT_TIMESTAMP,
      :CURRENT_USER,
      :CURSOR,
      :DATABASE,
      :DATABASES,
      :DAY_HOUR,
      :DAY_MICROSECOND,
      :DAY_MINUTE,
      :DAY_SECOND,
      :DEC,
      :DECIMAL,
      :DECLARE,
      :DEFAULT,
      :DELAYED,
      :DESCRIBE,
      :DETERMINISTIC,
      :DISTINCT,
      :DISTINCTROW,
      :DIV,
      :DOUBLE,
      :DROP,
      :DUAL,
      :EACH,
      :ELSE,
      :ELSEIF,
      :ENCLOSED,
      :ESCAPED,
      :EXISTS,
      :EXIT,
      :EXPLAIN,
      :FALSE,
      :FETCH,
      :FLOAT,
      :FLOAT4,
      :FLOAT8,
      :FOR,
      :FORCE,
      :FOREIGN,
      :FULLTEXT,
      :GRANT,
      :GROUP,
      :HAVING,
      :HIGH_PRIORITY,
      :HOUR_MICROSECOND,
      :HOUR_MINUTE,
      :HOUR_SECOND,
      :IF,
      :IGNORE,
      :IN,
      :INDEX,
      :INFILE,
      :INNER,
      :INOUT,
      :INSENSITIVE,
      :INSERT,
      :INT,
      :INT1,
      :INT2,
      :INT3,
      :INT4,
      :INT8,
      :INTEGER,
      :INTERVAL,
      :INTO,
      :ITERATE,
      :JOIN,
      :KEY,
      :KEYS,
      :KILL,
      :LEADING,
      :LEAVE,
      :LEFT,
      :LIKE,
      :LIMIT,
      :LINES,
      :LOAD,
      :LOCALTIME,
      :LOCALTIMESTAMP,
      :LOCK,
      :LONG,
      :LONGBLOB,
      :LONGTEXT,
      :LOOP,
      :LOW_PRIORITY,
      :MATCH,
      :MEDIUMBLOB,
      :MEDIUMINT,
      :MEDIUMTEXT,
      :MIDDLEINT,
      :MINUTE_MICROSECOND,
      :MINUTE_SECOND,
      :MOD,
      :MODIFIES,
      :NATURAL,
      :NO_WRITE_TO_BINLOG,
      :NUMERIC,
      :ON,
      :OPTIMIZE,
      :OPTION,
      :OPTIONALLY,
      :OUT,
      :OUTER,
      :OUTFILE,
      :PRECISION,
      :PRIMARY,
      :PROCEDURE,
      :PURGE,
      :READ,
      :READS,
      :REAL,
      :REFERENCES,
      :REGEXP,
      :RELEASE,
      :RENAME,
      :REPEAT,
      :REPLACE,
      :REQUIRE,
      :RESTRICT,
      :RETURN,
      :REVOKE,
      :RIGHT,
      :RLIKE,
      :SCHEMA,
      :SCHEMAS,
      :SECOND_MICROSECOND,
      :SENSITIVE,
      :SEPARATOR,
      :SET,
      :SHOW,
      :SMALLINT,
      :SONAME,
      :SPATIAL,
      :SPECIFIC,
      :SQL,
      :SQLEXCEPTION,
      :SQLSTATE,
      :SQLWARNING,
      :SQL_BIG_RESULT,
      :SQL_CALC_FOUND_ROWS,
      :SQL_SMALL_RESULT,
      :SSL,
      :STARTING,
      :STRAIGHT_JOIN,
      :TABLE,
      :TERMINATED,
      :THEN,
      :TINYBLOB,
      :TINYINT,
      :TINYTEXT,
      :TO,
      :TRAILING,
      :TRIGGER,
      :TRUE,
      :UNDO,
      :UNION,
      :UNIQUE,
      :UNLOCK,
      :UNSIGNED,
      :UPDATE,
      :USAGE,
      :USE,
      :USING,
      :UTC_DATE,
      :UTC_TIME,
      :UTC_TIMESTAMP,
      :VALUES,
      :VARBINARY,
      :VARCHAR,
      :VARCHARACTER,
      :VARYING,
      :WHEN,
      :WHILE,
      :WITH,
      :WRITE,
      :XOR,
      :YEAR_MONTH,
      :ZEROFILL,
      :ASENSITIVE,
      :CALL,
      :CONDITION,
      :CONNECTION,
      :CONTINUE,
      :CURSOR,
      :DECLARE,
      :DETERMINISTIC,
      :EACH,
      :ELSEIF,
      :EXIT,
      :FETCH,
      :GOTO,
      :INOUT,
      :INSENSITIVE,
      :ITERATE,
      :LABEL,
      :LEAVE,
      :LOOP,
      :MODIFIES,
      :OUT,
      :READS,
      :RELEASE,
      :REPEAT,
      :RETURN,
      :SCHEMA,
      :SCHEMAS,
      :SENSITIVE,
      :SPECIFIC,
      :SQL,
      :SQLEXCEPTION,
      :SQLSTATE,
      :SQLWARNING,
      :TRIGGER,
      :UNDO,
      :UPGRADE,
      :WHILE
    ] unless defined?(SQL_KEYWORDS)

    # Taken from the mysql docs:
    # http://dev.mysql.com/doc/refman/5.0/en/reserved-words.html
    SQL_KEYWORDS = IMPLEMENTED_KEYWORDS.merge(NOT_IMPLEMENTED_KEYWORDS) unless defined?(SQL_KEYWORDS)
  end
end
