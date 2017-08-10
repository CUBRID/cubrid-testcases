--TEST: [Multi-table Update] System error occurs when updating 2 tables with right outer join.


create table t (i int not null, s string);
create table u (i int not null, s string);
create table v (i int not null, s string);

insert into t values (1, 'a');
insert into u values (1, 'a');

insert into t values (2, 'b');
insert into u values (2, 'b');

insert into v values (1, 'a'), (2, 'b');

-- 1 to 1; all update joins should work
select * from t inner join u on t.i = u.i order by 1;
update t inner join u on t.i = u.i set t.i = u.i, t.s = u.s;

select * from t left outer join u on t.i = u.i order by 1;
update t left outer join u on t.i = u.i set t.i = u.i, t.s = u.s;

select * from t right outer join u on t.i = u.i order by 1;
update t right join u on t.i = u.i set u.i = t.i, u.s = t.s;

-- left outer join should fail
insert into t values (3, 'c');

select * from t inner join u on t.i = u.i order by 1;
update t inner join u on t.i = u.i set t.i = u.i, t.s = u.s;

select * from t left outer join u on t.i = u.i order by 1;
update t left outer join u on t.i = u.i set t.i = u.i, t.s = u.s;

select * from t right outer join u on t.i = u.i order by 1;
update t right join u on t.i = u.i set u.i = t.i, u.s = t.s;

-- right outer join should fail
insert into u values (3, 'c');
insert into u values (4, 'd');

select * from t inner join u on t.i = u.i order by 1;
update t inner join u on t.i = u.i set t.i = u.i, t.s = u.s;

select * from t left outer join u on t.i = u.i order by 1;
update t left outer join u on t.i = u.i set t.i = u.i, t.s = u.s;

select * from t right outer join u on t.i = u.i order by 1;
update t right join u on t.i = u.i set u.i = t.i, u.s = t.s;

-- multiple specs in join (first should fail, second should not)
select * from t left outer join u on t.i = u.i left outer join v on u.i = v.i order by 1 asc;
update t left outer join u on t.i = u.i left outer join v on u.i = v.i set t.i = v.i;
update t left outer join u on t.i = u.i left outer join v on u.i = v.i set v.i = t.i;
update t left outer join u on t.i = u.i left outer join v on u.i = v.i set v.i = t.i, t.i = u.i;

-- should fail
update t right outer join u on t.i = u.i left outer join v on u.i = v.i set v.i = t.i, t.i = u.i, u.i=t.i;

-- cleanup
drop table t, u, v;


--client side
create table t (i int not null, s string);
create table u (i int not null, s string);
create table v (i int not null, s string);

insert into t values (1, 'a'), (2, 'b'), (3, 'c');
insert into u values (1, 'a'), (2, 'b'), (3, 'c'), (4, 'd');
insert into v values (1, 'a'), (2, 'b');

create table t_action(a int auto_increment, b char(10));
create trigger t1 before update on t execute insert into t_action(b) values('t');
create trigger t2 before update on u execute insert into t_action(b) values('u');
create trigger t3 before update on v execute insert into t_action(b) values('v');

-- multiple specs in join (first should fail, second should not)
select * from t left outer join u on t.i = u.i left outer join v on u.i = v.i order by 1;
update t left outer join u on t.i = u.i left outer join v on u.i = v.i set t.i = v.i;
update t left outer join u on t.i = u.i left outer join v on u.i = v.i set v.i = t.i;
update t left outer join u on t.i = u.i left outer join v on u.i = v.i set v.i = t.i, t.i = u.i;

-- should fail
update t right outer join u on t.i = u.i left outer join v on u.i = v.i set v.i = t.i, t.i = u.i, u.i=t.i;

-- cleanup
drop trigger t1, t2, t3;
drop table t, u, v, t_action;

