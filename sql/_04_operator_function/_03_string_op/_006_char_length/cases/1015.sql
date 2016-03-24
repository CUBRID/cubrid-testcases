--test char_length function with to_char and time type 
select char_length(to_char(time'8:8:8 am')) from db_root;
