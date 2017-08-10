create table tb(a int, b nchar(10), c nchar varying(10), d clob);

insert into tb values(1, N'', N'abc', char_to_clob(''));
insert into tb values(2, N'abc', N'', char_to_clob('clob2'));
insert into tb values(3, N'def', N'ghi', 'clob3');

select cast(d as nchar(10)) from tb;
select cast(d as nchar varying(10)) from tb;

update tb set b=d;
select a, b from tb order by a;

update tb set c = d;
select a, c from tb order by a;

select cast(char_to_clob('') as nchar(10));
select cast(char_to_clob('aabbcc') as nchar(10));
select cast(char_to_clob('') as nchar varying(10));
select cast(char_to_clob('aabbcc') as nchar varying(10));

drop table tb;
