--test char_length function with types char, nchar 
select char_length('char') from db_root;
select char_length(n'nchar') from db_root;
