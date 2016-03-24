SELECT STRCMP('FOOTBALL','football') FROM DB_ROOT;
select STRCMP('I''M Chinese!','I''m Chinese') from db_root;
select STRCMP('I''M Chinese','I''m Chinese') from db_root;
select STRCMP('I''M Chinese','I''m Chinese!') from db_root;
select STRCMP('I''M Chinese ','I''m Chinese                   ') from db_root;
select STRCMP(char_length(null),char_length('111')) from db_root;
select STRCMP(concat('I''M ','Chinese'),concat('I''M','  Chinese')) from db_root;
select STRCMP(concat_ws('a','b','c'),concat('b','!a','c')) from db_root;
select strcmp(lcase('I Love This Game!'),'I Love This Game!') from db_root;