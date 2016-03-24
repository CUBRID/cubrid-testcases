drop table if exists foo;
create table foo(id int unique) reuse_oid
partition by list (id)(
partition p0 values in (1,2,3),
partition p1 values in (4,5,6),
partition p2 values in (7,8,9)
);

insert into foo values (1);

insert into foo values (2);

insert into foo values (3);

select * from foo order by 1;

insert into foo values (9)
on duplicate key update id = 5;

select * from foo order by 1;

insert into foo values (9)
on duplicate key update id = 5;
select * from foo order by 1;
drop foo;

create table foo(id int primary key) reuse_oid
partition by list (id)(
partition p0 values in (1,2,3),
partition p1 values in (4,5,6),
partition p2 values in (7,8,9)
);

insert into foo values (1);

insert into foo values (2);

insert into foo values (3);

select * from foo order by id;

insert into foo values (9)
on duplicate key update id = 5;

select * from foo order by id;

insert into foo values (9)
on duplicate key update id = 5;
select * from foo order by 1;
drop foo;

create table foo(id int ) reuse_oid
partition by list (id)(
partition p0 values in (1,2,3),
partition p1 values in (4,5,6),
partition p2 values in (7,8,9)
);

insert into foo values (1);

insert into foo values (2);

insert into foo values (3);

select * from foo order by 1;

insert into foo values (9)
on duplicate key update id = 5;

select * from foo order by 1;

insert into foo values (9)
on duplicate key update id = 5;
select * from foo order by 1;
drop foo;

create table foo(id int unique) 
partition by list (id)(
partition p0 values in (1,2,3),
partition p1 values in (4,5,6),
partition p2 values in (7,8,9)
);

insert into foo values (1);

insert into foo values (2);

insert into foo values (3);

select * from foo order by 1;

insert into foo values (9)
on duplicate key update id = 5;

select * from foo order by 1;

insert into foo values (9)
on duplicate key update id = 5;
select * from foo order by 1;
drop foo;

create table foo(id int primary key) 
partition by list (id)(
partition p0 values in (1,2,3),
partition p1 values in (4,5,6),
partition p2 values in (7,8,9)
);

insert into foo values (1);

insert into foo values (2);

insert into foo values (3);

select * from foo order by 1;

insert into foo values (9)
on duplicate key update id = 5;

select * from foo order by 1;

insert into foo values (9)
on duplicate key update id = 5;
select * from foo order by 1;
drop foo;


create table foo(id int ) 
partition by list (id)(
partition p0 values in (1,2,3),
partition p1 values in (4,5,6),
partition p2 values in (7,8,9)
);

insert into foo values (1);

insert into foo values (2);

insert into foo values (3);

select * from foo order by 1;

insert into foo values (9)
on duplicate key update id = 5;

select * from foo order by 1;

insert into foo values (9)
on duplicate key update id = 5;
select * from foo order by 1;
drop foo;

