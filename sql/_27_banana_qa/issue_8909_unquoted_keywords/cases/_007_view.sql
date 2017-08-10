--test rw column used in a view

create table "join"(
	"insert" int,
	"from" char(10),
	"key" time
);

create table "like"(
	"into" int,
	"order" char(10),
	"limit" enum('aa', 'bb', 'cc')
);

insert into "join" values(1, 'a', '1:1:1');
insert into "join" values(2, 'b', '1:1:1');
insert into "join" values(3, 'c', '1:1:1');
insert into "join" values(4, 'd', '1:1:1');

insert into "like" values(1, 'aaa', 'aa');
insert into "like" values(2, 'bbb', 2);
insert into "like" values(4, 'ddd', 3);


--test: create view with RW columns
create view v as select t1.insert, t1.from, t1.key, t2.into, t2.order, t2.limit from "join" t1, "like" t2 where t1.insert=t2.into order by t1.insert;

--test: select from a view
select v.insert, v.key, v.into, v.limit from v where v.from < 'c' order by v.into;


--test: with subquery
create view vvv as select t1.insert, t1.key, (select t2.limit from "like" t2 where t2.into=t1.insert) as aaa from "join" t1;
select v.insert, v.key, v.aaa from vvv v order by v.insert;

drop view v, vvv;
drop table "join", "like";
