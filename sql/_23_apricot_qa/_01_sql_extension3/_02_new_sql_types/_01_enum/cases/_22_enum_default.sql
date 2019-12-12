--test with enum default values



--TEST: [er] invalid default values
create table def(t enum('a', 'b', 'c', 'd') default 'e');
create table def(t enum('a', 'b', 'c', 'd') default -1);
create table def(t enum('a', 'b', 'c', 'd') default 10);


--TEST: create with default value
create table def(
	id int primary key auto_increment, 
	t1 enum('aaa', 'bbb', 'ccc') default 'bbb',
	t2 enum('a', 'b', 'c', 'd', 'e') default 5,
	t3 enum('aa', 'bb', 'cc', 'dd')
);

show columns in def;

--TEST: insert with default value
insert into def default;
insert into def values(default, default, default, 'aa');
insert into def(id, t3) values(default, 'bb');
insert into def(t1, t2) values(default, default);
insert into def(t1) values(default);

select * from def order by 1;

--TEST: add default value
alter table def alter column t3 set default 3;
show columns in def;

insert into def(t3) values (default);
select * from def order by 1;

--TEST: update with default
update def set t3=default where id < 3;
select * from def order by 1;


--TEST: add column with default value
alter table def add column t4 enum('aaaa', 'bbbb', 'cccc', 'dddd') default 'cccc';
show columns in def;
insert into def default;
select * from def order by 1;



--TEST: alter default value
alter table def alter column t2 set default 2;
show columns in def;
insert into def(t2) values(default);
select * from def order by 1;

alter table def alter t3 set default null;
show columns in def;
insert into def(t3) values(default);
select * from def order by 1;


drop table def;

