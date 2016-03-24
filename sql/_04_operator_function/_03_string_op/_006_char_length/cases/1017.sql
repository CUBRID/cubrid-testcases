--test char_length function with to_char and int,decimal type 
select char_length(to_char(10)) from db_root;
select char_length(to_char(10.12)) from db_root order by 1;