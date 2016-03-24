select char_length('123456789012') from db_root;
select char_length('1234567890123456') from db_root;
select char_length('123456789012345612345678') from db_root;
select char_length('12345678901234561234567890123456') from db_root;
select char_length('1234567890123456123456789012345612345678901234561234567890123456') from db_root;
select char_length('a') from db_root;
select char_length('ab') from db_root;
select char_length('abc') from db_root;
select char_length('abcd') from db_root;
select char_length('abcde') from db_root;
select char_length('abcdef') from db_root;
select char_length('abcdefg') from db_root;
select char_length('abcfefgh') from db_root;
select char_length('abcdefghi') from db_root;

select char_length('abcd') from db_root;

select char_length(123) as cl from db_root;

select char_length(NULL) as cl from db_root;
