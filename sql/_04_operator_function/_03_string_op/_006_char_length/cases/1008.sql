--test CHAR_LENGTH with time type
select char_length(to_timestamp('5/5/2005 8:8:8 am')) from db_root order by 1;