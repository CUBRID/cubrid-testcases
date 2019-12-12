--test rw column with joining 2 tables

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


--test: as select expressions
select t1.insert, t1.from, t2.into, t2.order from "join" t1, "like" t2 where t1.insert=t2.into order by t1.insert;

--test: as join condition
select t1.insert, t1.from, t2.into, t2.order from "join" t1 inner join "like" t2 on t1.insert=t2.into order by t2.into;
select t1.insert, t1.key, t2.into, t2.limit from "join" t1 left outer join "like" t2 on t1.insert=t2.into where t1.from < 'c' order by t2.into;
select t1.insert, t1.key, t2.into, t2.limit from "join" t1 right outer join "like" t2 on t1.insert=t2.into where t2.limit < 'cc' order by t2.into;

--test: with subquery
select t1.insert, t1.key, (select t2.limit from "like" t2 where t2.into=t1.insert) as limit from "join" t1 order by t1.insert;
select t1.insert, t1.key, (select t2.limit from "like" t2 where t2.into=t1.insert) as aaa from "join" t1 order by t1.insert;

drop table "join", "like";
