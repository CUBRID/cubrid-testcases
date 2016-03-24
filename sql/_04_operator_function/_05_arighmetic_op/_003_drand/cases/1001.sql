--test random(), drandom() functions with the types int,float, and numeric.
--it tests random(), drandom() functions with the types int,float, and numeric.it also used decode function and the keyword 'null', and 'not null'

create class xoo ( a int, b float, c numeric(10,2), d string);
insert into xoo select random(), random(), drandom(), to_char(drandom()) from db_root;
insert into xoo values(random(), drandom(), drandom(), to_char(random()) );
select decode(a, null, 0, 1), decode(b, null, 0, 1), decode(c, null, 0, 1), decode(d, null, '0', '1') from xoo order by 1;
update xoo set a = random();
select decode(a, null, 0, 1), decode(b, null, 0, 1), decode(c, null, 0, 1), decode(d, null, '0', '1') from xoo order by 1;
delete from xoo where rownum = decode(random(), null, 100, 1);
select decode(a, null, 0, 1), decode(b, null, 0, 1), decode(c, null, 0, 1), decode(d, null, '0', '1') from xoo order by 1;


select decode(random(), null, 0, 1), decode(drandom(), null, 0, 1) from db_root order by 1;

select decode(random(), null, 0, 1), decode(drandom(), null, 0, 1) from db_root where random() is not null order by 1;

drop xoo;
