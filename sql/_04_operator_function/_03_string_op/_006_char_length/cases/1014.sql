--test char_length function with to_char and date type 
select char_length(to_char(date'8/8/2008')) from db_root;
