create table foo (del_ts int, name string not null, val bigint not null);
insert into foo values (0, 'seo', 10);
prepare stmt1 from 'update foo set del_ts = 100, val=DECODE(name,?,val + ?) where name in (?)';
execute stmt1 using 'seo', 1, 'seo';
select * from foo;
drop prepare stmt1;
drop foo;


