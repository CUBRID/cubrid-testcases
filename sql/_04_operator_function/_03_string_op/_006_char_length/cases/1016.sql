--test char_length function with to_char and timestamp type 
select char_length(to_char(timestamp'2/2/2002 8:8:8 am')) from db_root;
