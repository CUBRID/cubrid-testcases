autocommit off;
create class strings (strnum int, str string);
insert into strings values (1, '0123456789abcdef');
insert into strings values (2, 'abcdefghijklmnop');
insert into strings values (3, 'ABCDEFGHIJKLMNOP');
update strings set str = str + str;	--   32
update strings set str = str + str;	--   64
update strings set str = str + str;	--  128
update strings set str = str + str;	--  256
update strings set str = str + str;	--  512
update strings set str = str + str;	-- 1024
update strings set str = str + str;	-- 2048
update strings set str = str + str;	-- 4096
update strings set str = str + str;	-- 8192
insert into strings
     select strnum + (select count(*) from strings), str
       from strings;
select count(*) from strings ;
select strnum, str from strings order by strnum,2;
select strnum, str from strings order by str asc, strnum;
select strnum, str from strings order by str desc, strnum;
select str from strings where strnum = 1 order by str, strnum;

rollback;
