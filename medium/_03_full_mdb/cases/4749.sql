autocommit off;
create class big_uniq_str (strnum int, str string unique);
insert into big_uniq_str values (1, '0123456789abcdef');
insert into big_uniq_str values (2, 'abcdefghijklmnop');
insert into big_uniq_str values (3, 'ABCDEFGHIJKLMNOP');
update big_uniq_str set str = str + str;	--   32
update big_uniq_str set str = str + str;	--   64
update big_uniq_str set str = str + str;	--  128
update big_uniq_str set str = str + str;	--  256
update big_uniq_str set str = str + str;	--  512
update big_uniq_str set str = str + str;	-- 1024
update big_uniq_str set str = str + str;	-- 2048
update big_uniq_str set str = str + str;	-- 4096
update big_uniq_str set str = str + str;	-- 8192
select count(*) from big_uniq_str;
insert into big_uniq_str
     select strnum + (select count(*) from big_uniq_str), str+str
       from big_uniq_str;
select count(*) from big_uniq_str;

delete from big_uniq_str;
select count(*) from big_uniq_str;
rollback work;

