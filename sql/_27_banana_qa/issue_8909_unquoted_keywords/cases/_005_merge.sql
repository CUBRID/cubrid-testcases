--test rw column used in merge statements

create table "in"(
	"hour" int,
	"do" char(10),
	"execute" time
);

create table "out"(
	"false" int,
	"drop" char(10),
	"add" enum('aa', 'bb', 'cc')
);

insert into "in" values(1, 'a', '1:1:1');
insert into "in" values(2, 'b', '1:1:1');
insert into "in" values(3, 'c', '1:1:1');
insert into "in" values(4, 'd', '1:1:1');

insert into "out" values(1, 'aaa', 'aa');
insert into "out" values(2, 'bbb', 2);
insert into "out" values(4, 'ddd', 3);
insert into "out" values(5, 'eee', 1);


--test: used in merge statements
merge into "in" tt
using "out" st
on (st.false=tt.hour)
when matched then
update set tt.do='updated'
when not matched then
insert values(st.false, st.drop, '12:12:12');

select * from "in" t order by t.hour;
select * from "out" t order by t.false;


drop table "in", "out";
