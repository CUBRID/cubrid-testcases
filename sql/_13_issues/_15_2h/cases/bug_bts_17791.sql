drop table if exists a;
create table a ( id int, s string collate binary, s1 string collate binary);
insert into  a values (1, '','12345abcdeabcde') , (2,'b','12345abcdeabcde');
select s, s1, position(s in s1) from a;
drop table if exists a;
