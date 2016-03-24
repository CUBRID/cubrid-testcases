--test CHAR_LENGTH with time type
select char_length(to_time('8:8:8 am')) from db_root order by 1;