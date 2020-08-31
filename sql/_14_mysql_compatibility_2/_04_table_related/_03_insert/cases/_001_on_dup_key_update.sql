set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
drop table if exists was_success;
create table was_success(id int auto_increment, bef_ins int default 0, aft_ins int default 0, bef_upd int default 0, aft_upd int default 0, bef_del int default 0, aft_del int default 0);

drop table if exists a;
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

insert into a(id, str) values(3,'3') on duplicate key update str = 'updated';

select * from was_success order by id;

truncate table was_success;
$varchar, $'3', $varchar, $'hostvar'
insert into a (id, str) values (3,?) on duplicate key update str = ?;
select * from a order by id;
select * from was_success order by id;

create view v(i, str) as SELECT id, str FROM a WHERE id<10 with check option;

truncate table was_success;

insert into v values(3,'3') on duplicate key update i = 10;

select * from was_success order by id;

truncate table was_success;

insert into v values(3,'3') on duplicate key update i = 9;

select * from was_success order by id;

drop trigger bef_ins_a;
drop trigger aft_ins_a;
drop trigger bef_upd_a;
drop trigger aft_upd_a;
drop trigger bef_del_a;
drop trigger aft_del_a;
drop view v;
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

insert into b values(4, insert into a values(4)) on duplicate key update obj = NULL;
select * from was_success order by id;
truncate table was_success;

select a into :y from a where id = 3;
insert into b values(4, :y) on duplicate key update obj = NULL;

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

insert into b select i from a order by i on duplicate key update i=5;

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

create table a (i int, str string, unique(i, str)) 
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
insert into a (i, str) values (101,'4') on duplicate key update str = '101';
select * from a order by i;
select * from was_success order by id;

drop trigger bef_ins_a;
drop trigger aft_ins_a;
drop trigger bef_upd_a;
drop trigger aft_upd_a;
drop trigger bef_del_a;
drop trigger aft_del_a;
drop table a;

create table a (i int , str string , primary key(i)) 
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

truncate table was_success;
insert into a (i, str) values (2,'1') on duplicate key update str = '101';
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
insert into a (str) values('0') on duplicate key update str = 'updated';
select * from a order by i;
select * from was_success order by id;

truncate table a;
truncate table was_success;

insert into a(i,str,d) values(1,'1',1);
truncate table was_success;
insert into a(str) values('2') on duplicate key update str='updated';

select * from a order by i, str, d;
select * from was_success order by id;

truncate table a;
truncate table was_success;

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

insert into a values(2) on duplicate key update id = 4;
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
insert into child(i) values(1) on duplicate key update i = 4;
select * from child;
select * from parent order by i;
select * from was_success order by id;

truncate table was_success;
insert into child(i) values(2) on duplicate key update s = 'updated';
select * from child;
select * from parent order by i;
select * from was_success order by id;

truncate table was_success;
insert into child(i) values(3) on duplicate key update all i = 100;
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

insert into a(i) values(2) on duplicate key update str = 'updated';
select * from a order by i, str, d;
select * from was_success order by id;

truncate table a;
create unique index uni_a_i on a(i);
create unique index uni_a_str_d on a(str,d);

insert into a(i, str, d) values (1, '1', 1.0);
truncate table was_success;

insert into a(i, str) values (2, '1') on duplicate key update str = 'updated';
select * from a order by i,str, d;
select * from was_success order by id;

insert into a(str, d) values('3', 3);
truncate table was_success;
insert into a(str,d) values('4',4) on duplicate key update i = 100;
select * from a order by i,str,d;
select * from was_success order by id;

truncate table was_success;
insert into a(i, str, d) values(200, '1', 1.0) on duplicate key update i = 1;
select * from a order by i,str,d;
select * from was_success order by id;

truncate table a;
truncate table was_success;
insert into a(i, str, d) values(1,'1',1),(2,'2',2),(1,'3',3) on duplicate key update str = 'updated';
select * from a order by i,str,d;
select * from was_success order by id;

drop trigger bef_ins_a;
drop trigger aft_ins_a;
drop trigger bef_upd_a;
drop trigger aft_upd_a;
drop trigger bef_del_a;
drop trigger aft_del_a;
drop table a;

create table a(i1 int, i2 int, i3 int, i4 int, i5 int, i6 int, i7 int);
create unique index uni_a_i1 on a(i1);
create unique index uni_a_i2i3 on a(i2,i3);
create unique index uni_a_i4i5i6 on a(i4,i5,i6);

insert into a values(1,1,1,1,1,1,1), (2,2,2,2,2,2,2), (3,3,3,3,3,3,3);
create trigger bef_ins_a before insert on a execute insert into was_success(bef_ins) values(1);
create trigger aft_ins_a after insert on a execute insert into was_success(aft_ins) values(1);
create trigger bef_upd_a before update on a execute insert into was_success(bef_upd) values(1);
create trigger aft_upd_a after update on a execute insert into was_success(aft_upd) values(1);
create trigger bef_del_a before delete on a execute insert into was_success(bef_del) values(1);
create trigger aft_del_a after delete on a execute insert into was_success(aft_del) values(1);

truncate table was_success;
insert into a values(1,2,2,3,3,3,1) on duplicate key update i7 = 100;
select * from a order by i7;
select * from was_success order by id;

truncate table a;
insert into a values(1,1,1,1,1,1,1), (2,2,2,2,2,2,2), (3,3,3,3,3,3,3);
truncate table was_success;
insert into a values(4,4,4,1,1,1,5) on duplicate key update i7 = 100;
select * from a order by i7;
select * from was_success order by id;
drop trigger bef_ins_a;
drop trigger aft_ins_a;
drop trigger bef_upd_a;
drop trigger aft_upd_a;
drop trigger bef_del_a;
drop trigger aft_del_a;
drop table a;

create table a(i int, s string);
--This is an intentional fail. The implementation of INSERT ... ON DUPLICATE KEY UPDATE should be modified when unique prefix indexes are available
create unique index uni_a_s on a(s(3));
insert into a values(1,'abcd');
create trigger bef_ins_a before insert on a execute insert into was_success(bef_ins) values(1);
create trigger aft_ins_a after insert on a execute insert into was_success(aft_ins) values(1);
create trigger bef_upd_a before update on a execute insert into was_success(bef_upd) values(1);
create trigger aft_upd_a after update on a execute insert into was_success(aft_upd) values(1);
create trigger bef_del_a before delete on a execute insert into was_success(bef_del) values(1);
create trigger aft_del_a after delete on a execute insert into was_success(aft_del) values(1);

truncate table was_success;
insert into a values(2,'abce') on duplicate key update s = 'updated';
select * from a order by i,s;
select * from was_success order by id;

drop trigger bef_ins_a;
drop trigger aft_ins_a;
drop trigger bef_upd_a;
drop trigger aft_upd_a;
drop trigger bef_del_a;
drop trigger aft_del_a;
drop table a;
drop table was_success;
commit;
--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
