--TEST: Select result of range partition table is incorrect when auto_commit mode is off.

--+ holdcas on;


create table foo(id1 bigint)
partition by range(id1) (
	partition p1 values less than (3),
	partition p2 values less than (5),
	partition p3 values less than (8)
);

insert into foo values(1);
select * from foo order by 1;

insert into foo values(1);
insert into foo values(1);
select * from foo order by 1;

update foo set id1=4 order by id1 limit 2;
select * from foo order by 1;
select * from foo__p__p2 order by 1;

insert into foo values(2), (2), (2);
select * from foo order by 1;
select * from foo__p__p1 order by 1;

update foo set id1=7 where id1 in (2) limit 2;
select * from foo where id1 < 5 order by 1;
select * from foo__p__p3 order by 1;
select * from foo__p__p1 order by 1;

delete from foo where id1 < 3;
select * from foo where id1 < 3 order by 1;
select * from foo__p__p1 order by 1;
select * from foo__p__p2 order by 1;
select * from foo__p__p3 order by 1;
commit;

select * from foo order by 1;

drop table foo;

commit;

--+ holdcas off;
