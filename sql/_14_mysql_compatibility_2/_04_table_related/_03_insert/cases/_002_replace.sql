create table was_success(id int auto_increment, bef_ins int default 0, aft_ins int default 0, bef_upd int default 0, aft_upd int default 0, bef_del int default 0, aft_del int default 0);

create table a (id integer unique, str varchar(255));
insert into a values(1,'1');
insert into a values(2,'2');
insert into a values(3,'3');

create trigger bef_ins_a before insert on a execute insert into was_success(bef_ins) values(1);
create trigger aft_ins_a after insert on a execute insert into was_success(aft_ins) values(1);
create trigger bef_upd_a before update on a execute insert into was_success(bef_upd) values(1);
create trigger aft_upd_a after update on a execute insert into was_success(aft_upd) values(1);
create trigger bef_del_a before delete on a execute insert into was_success(bef_del) values(1);
create trigger aft_del_a after delete on a execute insert into was_success(aft_del) values(1);

replace into a(id, str) values(3,'3');

select * from was_success order by id;

truncate table was_success;
replace into a (id, str) values(3,'deleted');

select * from a order by id, str;

select * from was_success order by id;

create view v(id, str) as SELECT id, str FROM a WHERE id<10 with check option;

truncate table was_success;

create unique index uni_a_str on a(str);
replace into v values(10,'deleted');

select * from was_success order by id;

truncate table was_success;

replace into v values(9,'deleted');

select * from was_success order by id;

drop view v;

drop trigger bef_ins_a;
drop trigger aft_ins_a;
drop trigger bef_upd_a;
drop trigger aft_upd_a;
drop trigger bef_del_a;
drop trigger aft_del_a;
drop table a;


create table a(id int);
create table b(i int,obj a unique);
create trigger bef_ins_b before insert on b execute insert into was_success(bef_ins) values(1);
create trigger aft_ins_b after insert on b execute insert into was_success(aft_ins) values(1);
create trigger bef_upd_b before update on b execute insert into was_success(bef_upd) values(1);
create trigger aft_upd_b after update on b execute insert into was_success(aft_upd) values(1);
create trigger bef_del_b before delete on b execute insert into was_success(bef_del) values(1);
create trigger aft_del_b after delete on b execute insert into was_success(aft_del) values(1);

insert into b values(1, insert into a values(1));
insert into b values(2, insert into a values(2));
insert into b values(3, insert into a values(3));

truncate table was_success;

replace into b values(4, insert into a values(4));

select * from was_success order by id;
truncate table was_success;

select a into :y from a where id = 3;
replace into b values(4, :y);

select * from was_success order by id;
truncate table was_success;

select a into :y from a where id = 2;
replace into b values(4, :y);

select * from b order by i;

select * from was_success order by id;
truncate table was_success;


drop trigger bef_ins_b;
drop trigger aft_ins_b;
drop trigger bef_upd_b;
drop trigger aft_upd_b;
drop trigger bef_del_b;
drop trigger aft_del_b;
drop table b;
drop table a;

create table a(i int);
create table b(i int unique);
create trigger bef_ins_b before insert on b execute insert into was_success(bef_ins) values(1);
create trigger aft_ins_b after insert on b execute insert into was_success(aft_ins) values(1);
create trigger bef_upd_b before update on b execute insert into was_success(bef_upd) values(1);
create trigger aft_upd_b after update on b execute insert into was_success(aft_upd) values(1);
create trigger bef_del_b before delete on b execute insert into was_success(bef_del) values(1);
create trigger aft_del_b after delete on b execute insert into was_success(aft_del) values(1);


insert into a values(1),(2),(3),(3),(4);

truncate table was_success;

replace into b select i from a order by i;

select * from b order by i;

select * from was_success order by id;


drop trigger bef_ins_b;
drop trigger aft_ins_b;
drop trigger bef_upd_b;
drop trigger aft_upd_b;
drop trigger bef_del_b;
drop trigger aft_del_b;
drop table b;
drop table a;

create table a (i int, str string, primary key(i, str)) 
	partition by range(i)(
		partition p0 values less than (10),
		partition p1 values less than (100),
		partition p2 values less than (1000)
	);
	
insert into a values(2,'2'),(3,'3'), (101,'4');
create trigger bef_ins_a before insert on a execute insert into was_success(bef_ins) values(1);
create trigger aft_ins_a after insert on a execute insert into was_success(aft_ins) values(1);
create trigger bef_upd_a before update on a execute insert into was_success(bef_upd) values(1);
create trigger aft_upd_a after update on a execute insert into was_success(aft_upd) values(1);
create trigger bef_del_a before delete on a execute insert into was_success(bef_del) values(1);
create trigger aft_del_a after delete on a execute insert into was_success(aft_del) values(1);

select * from a order by i;
truncate table was_success;
replace into a (i, str) values (101,'replaced');
select * from a order by i;
select * from was_success order by id;

truncate table was_success;
$varchar, $'replaced'
replace into a (i, str) values (3,?);
select * from a order by i;
select * from was_success order by id;

create unique index uni_p_i on a(i);

replace into a (i, str) values (101,'replaced');
select * from a order by i;
select * from was_success order by id;

drop trigger bef_ins_a;
drop trigger aft_ins_a;
drop trigger bef_upd_a;
drop trigger aft_upd_a;
drop trigger bef_del_a;
drop trigger aft_del_a;
drop table a;

create table a(i int auto_increment, str string, d double default 0);
create unique index uni_idx_i on a(i);
create unique index uni_idx_multiple on a(str,d);
insert into a(str) values('0');

create trigger bef_ins_a before insert on a execute insert into was_success(bef_ins) values(1);
create trigger aft_ins_a after insert on a execute insert into was_success(aft_ins) values(1);
create trigger bef_upd_a before update on a execute insert into was_success(bef_upd) values(1);
create trigger aft_upd_a after update on a execute insert into was_success(aft_upd) values(1);
create trigger bef_del_a before delete on a execute insert into was_success(bef_del) values(1);
create trigger aft_del_a after delete on a execute insert into was_success(aft_del) values(1);

truncate table was_success;
replace into a (i,str) values(1,'updated');
select * from a order by i;
select * from was_success order by id;

truncate table a;
truncate table was_success;

insert into a(i,str,d) values(1,'1',1);

truncate table was_success;
replace into a(str,d) values('1',1);

select * from a order by i;
select * from was_success order by id;

truncate table was_success;
replace into a(str,d) values('1',1);

select * from a order by i;
select * from was_success order by id;

drop trigger bef_ins_a;
drop trigger aft_ins_a;
drop trigger bef_upd_a;
drop trigger aft_upd_a;
drop trigger bef_del_a;
drop trigger aft_del_a;
drop table a;

create table a(id int unique);

insert into a values(1),(2);

create trigger bef_ins_a before insert on a execute insert into was_success(bef_ins) values(new.id);
create trigger aft_ins_a after insert on a execute insert into was_success(aft_ins) values(obj.id);
create trigger bef_upd_a before update on a execute insert into was_success(bef_upd) values(new.id);
create trigger aft_upd_a after update on a execute insert into was_success(aft_upd) values(old.id);
create trigger bef_del_a before delete on a execute insert into was_success(bef_del) values(obj.id);
create trigger aft_del_a after delete on a execute insert into was_success(aft_del) values(1);

truncate table was_success;

replace into a values(2);
select * from was_success order by id;

drop trigger bef_ins_a;
drop trigger aft_ins_a;
drop trigger bef_upd_a;
drop trigger aft_upd_a;
drop trigger bef_del_a;
drop trigger aft_del_a;
drop table a;

create table parent (i int unique);
create table child under parent(s string);
insert into parent values(1),(2),(3);

create trigger bef_ins_child before insert on child execute insert into was_success(bef_ins) values(1);
create trigger aft_ins_child after insert on child execute insert into was_success(aft_ins) values(1);
create trigger bef_upd_child before update on child execute insert into was_success(bef_upd) values(1);
create trigger aft_upd_child after update on child execute insert into was_success(aft_upd) values(1);
create trigger bef_del_child before delete on child execute insert into was_success(bef_del) values(1);
create trigger aft_del_child after delete on child execute insert into was_success(aft_del) values(1);

truncate table was_success;
replace into child(i) values(1);
select * from child order by s;
select * from parent order by i;
select * from was_success order by id;

truncate table was_success;
replace into child(i) values(2);
select * from child order by s;
select * from parent order by i;
select * from was_success order by id;

drop trigger bef_ins_child;
drop trigger aft_ins_child;
drop trigger bef_upd_child;
drop trigger aft_upd_child;
drop trigger bef_del_child;
drop trigger aft_del_child;

drop table child;
drop table parent;

create table a(i int, str string, d double);
insert into a(i, str) values(1,'1'), (2,'2'), (3,'3');
create trigger bef_ins_a before insert on a execute insert into was_success(bef_ins) values(1);
create trigger aft_ins_a after insert on a execute insert into was_success(aft_ins) values(1);
create trigger bef_upd_a before update on a execute insert into was_success(bef_upd) values(1);
create trigger aft_upd_a after update on a execute insert into was_success(aft_upd) values(1);
create trigger bef_del_a before delete on a execute insert into was_success(bef_del) values(1);
create trigger aft_del_a after delete on a execute insert into was_success(aft_del) values(1);

truncate table was_success;

replace into a(i,str) values(2,'updated');
select * from a order by i;
select * from was_success order by id;

truncate table a;
create unique index uni_a_i on a(i);
create unique index uni_a_str_d on a(str,d);

insert into a(i, str, d) values (1, '1', 1.0);
truncate table was_success;

replace into a(i, str) values (2, '1');
select * from a order by i;
select * from was_success order by id;

insert into a(str, d) values('3', 3);
truncate table was_success;
replace into a(i,str,d) values(100,'4',4);
select * from a order by i;
select * from was_success order by id;

truncate table was_success;
replace into a(i, str, d) values(1, '1', 1.0);
select * from a order by i;
select * from was_success order by id;

truncate table a;
truncate table was_success;
replace into a(i, str, d) values(1,'1',1),(2,'2',2),(1,'3',3);
select * from a order by i;
select * from was_success order by id;

drop trigger bef_ins_a;
drop trigger aft_ins_a;
drop trigger bef_upd_a;
drop trigger aft_upd_a;
drop trigger bef_del_a;
drop trigger aft_del_a;
drop table a;

create table a(i int, s string);
--This is an intentional fail. The implementation of REPLACE should be modified when unique prefix indexes are available
create unique index uni_a_s on a(s(3));
insert into a values(1,'abcd');
create trigger bef_ins_a before insert on a execute insert into was_success(bef_ins) values(1);
create trigger aft_ins_a after insert on a execute insert into was_success(aft_ins) values(1);
create trigger bef_upd_a before update on a execute insert into was_success(bef_upd) values(1);
create trigger aft_upd_a after update on a execute insert into was_success(aft_upd) values(1);
create trigger bef_del_a before delete on a execute insert into was_success(bef_del) values(1);
create trigger aft_del_a after delete on a execute insert into was_success(aft_del) values(1);

truncate table was_success;
replace into a values(2,'abce');
select * from a order by i;
select * from was_success order by id;

drop trigger bef_ins_a;
drop trigger aft_ins_a;
drop trigger bef_upd_a;
drop trigger aft_upd_a;
drop trigger bef_del_a;
drop trigger aft_del_a;
drop table a;

drop table was_success;
