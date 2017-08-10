create table t(id int, val int, fk int);
create table u(id int, val int);
create index _t_id on t(id);
create index _t_val on t(val);
create index _u_id on u(id);
create index _u_val on u(val);

insert into t values (1, 1, 1);
insert into u values (1, 1);

--------------------------------
-- SINGLE INDEX TEST
--------------------------------
select id from t use index (_t_id) where id < 2;
update t use index (_t_id) set val = 0 where id > 10;
delete from t use index (_t_id) where id > 10;

--------------------------------
-- INDEX LIST TEST
--------------------------------
select id from t use index (_t_id, _t_val) where id < 2;
update t use index (_t_id, _t_val) set val = 0 where id > 10;
delete from t use index (_t_id, _t_val) where id > 10;

--------------------------------
-- FORCE/IGNORE TEST
--------------------------------
select id from t force index (_t_id) where id < 2;
select id from t ignore index (_t_id) where id < 2;

update t force index (_t_id) set id = 10 where id > 10;
update t ignore index (_t_id) set id = 10 where id > 10;

delete from t force index (_t_id) where id > 10;
delete from t ignore index (_t_id) where id > 10;

--------------------------------
-- {INDEX | KEY} TEST
--------------------------------
select id from t use key (_t_id) where id < 2;
update t use key (_t_id) set id = 10 where id > 10;
delete from t use key (_t_id) where id > 10;

--------------------------------
-- JOIN TEST
--------------------------------
select t.id from t use index (_t_id) inner join u use index (_u_id) on t.fk = u.id where t.id < 2;

--------------------------------
-- INVALID INDEX TEST
--------------------------------
select id from t use index (xx) where id < 2;
update t use index (xx) set id = 10 where id > 10;
delete from t use index (xx) where id > 10;

--------------------------------
-- USE INDEX + USING INDEX TEST
--------------------------------
select * from t use index (_t_id) where id < 2 using index _t_id;

select id from t ignore index (_t_id) where id > 10 using index all except _t_id;
select id from t ignore index (_t_id, _t_val) where id > 10 using index all except _t_id;
select id from t ignore index (_t_id, _t_val) where id > 10 using index all except _t_id, _t_val;

select * from t ignore index (_t_id) where id > 10 using index none;
select * from t ignore index (_t_id, _t_val) where id > 10 using index none;
select * from t ignore index (_t_id) inner join u ignore index (_u_id) on t.fk = u.id using index none;

select * from t ignore index (_t_id) where id > 10 using index t.none;
select * from t ignore index (_t_id, _t_val) where id > 10 using index t.none;
select * from t ignore index (_t_id) inner join u use index (_u_id) on t.fk = u.id using index t.none;

select id from t where id > 10 using index t.none, _t_id(-);
select id from t where id > 10 using index _t_id(-), t.none;
select id from t where id > 10 using index t.none, _t_id(-), _t_val(-);
select id from t where id > 10 using index _t_id(-), t.none, _t_val(-);
select id from t where id > 10 using index _t_id(-), _t_val(-), t.none;

select * from t use index (_t_id) inner join u on t.fk = u.id using index u.none;

select * from t use index (_t_id) inner join u on t.fk = u.id using index all except t.none;
select * from t force index (_t_id) inner join u on t.fk = u.id using index all except t.none;
select * from t ignore index (_t_id) inner join u on t.fk = u.id using index all except t.none;


update t use index (_t_id) set val = 0 where id > 10 using index _t_id;

update t ignore index (_t_id) set val = 0 where id > 10 using index all except _t_id;
update t ignore index (_t_id, _t_val) set val = 0 where id > 10 using index all except _t_id;
update t ignore index (_t_id, _t_val) set val = 0 where id > 10 using index all except _t_id, _t_val;

update t ignore index (_t_id) set val = 0 where id > 10 using index none;
update t ignore index (_t_id, _t_val) set val = 0 where id > 10 using index none;

update t ignore index (_t_id) set val = 0 where id > 10 using index t.none;
update t ignore index (_t_id, _t_val) set val = 0 where id > 10 using index t.none;

update t set val = 0 where id > 10 using index t.none, _t_id(-);
update t set val = 0 where id > 10 using index _t_id(-), t.none;
update t set val = 0 where id > 10 using index t.none, _t_id(-), _t_val(-);
update t set val = 0 where id > 10 using index _t_id(-), t.none, _t_val(-);
update t set val = 0 where id > 10 using index  _t_id(-), _t_val(-), t.none;

update t use index (_t_id) set val = 0 where id > 10 using index all except t.none;
update t force index (_t_id) set val = 0 where id > 10 using index all except t.none;
update t ignore index (_t_id) set val = 0 where id > 10 using index all except t.none;


delete from t use index (_t_id) where id > 10 using index _t_id;

delete from t ignore index (_t_id) where id > 10 using index all except _t_id;
delete from t ignore index (_t_id, _t_val) where id > 10 using index all except _t_id;
delete from t ignore index (_t_id, _t_val) where id > 10 using index all except _t_id, _t_val;

delete from t ignore index (_t_id) where id > 10 using index none;
delete from t ignore index (_t_id, _t_val) where id > 10 using index none;

delete from t ignore index (_t_id) where id > 10 using index t.none;
delete from t ignore index (_t_id, _t_val) where id > 10 using index t.none;

delete from t where id > 10 using index t.none, _t_id(-);
delete from t where id > 10 using index _t_id(-), t.none;
delete from t where id > 10 using index t.none, _t_id(-), _t_val(-);
delete from t where id > 10 using index _t_id(-), t.none, _t_val(-);
delete from t where id > 10 using index _t_id(-), _t_val(-), t.none;

delete from t use index (_t_id) where id > 10 using index all except t.none;
delete from t force index (_t_id) where id > 10 using index all except t.none;
delete from t ignore index (_t_id) where id > 10 using index all except t.none;

--------------------------------
-- CONFLICT CASES
--------------------------------
select id from t use index (_t_id) where id > 10 using index none;
select id from t force index (_t_id) where id > 10 using index none;
select id from t use index (_t_id, _t_val) where id > 10 using index none;
select id from t force index (_t_id, _t_val) where id > 10 using index none;

select id from t use index (_t_id) where id > 10 using index t.none;
select id from t force index (_t_id) where id > 10 using index t.none;
select id from t use index (_t_id, _t_val) where id > 10 using index t.none;
select id from t force index (_t_id, _t_val) where id > 10 using index t.none;

select id from t where id > 10 using index t.none, _t_val;
select id from t where id > 10 using index t.none, _t_val(+);
select id from t where id > 10 using index _t_id, t.none, _t_val;

select id from t use index (_t_id) where id > 10 using index all except _t_id;
select id from t force index (_t_id) where id > 10 using index all except _t_id;

select id from t use index (_t_id, _t_val) where id > 10 using index all except _t_id;
select id from t force index (_t_id, _t_val) where id > 10 using index all except _t_id;

select *  from t use index(_t_id) where id > 10 using index all except _t_id(+);
select *  from t use index(_t_id) where id > 10 using index all except _t_id(-);

select *  from t use index (_t_id) inner join u on t.fk = u.id using index t.none;
select *  from t use index (_t_id) inner join u use index (_u_id) on t.fk = u.id using index t.none, u.none;
select *  from t use index (_t_id) inner join u use index (_u_id) on t.fk = u.id using index u.none, t.none;
select *  from t use index (_t_id) inner join u use index (_u_id) on t.fk = u.id using index none;


update t use index (_t_id) set val = 0 where id > 10 using index none;
update t force index (_t_id) set val = 0 where id > 10 using index none;
update t use index (_t_id, _t_val) set val = 0 where id > 10 using index none;
update t force index (_t_id, _t_val) set val = 0 where id > 10 using index none;

update t use index (_t_id) set val = 0 where id > 10 using index t.none;
update t force index (_t_id) set val = 0 where id > 10 using index t.none;
update t use index (_t_id, _t_val) set val = 0 where id > 10 using index t.none;
update t force index (_t_id, _t_val) set val = 0 where id > 10 using index t.none;

update t set val = 0 where id > 10 using index t.none, _t_val;
update t set val = 0 where id > 10 using index t.none, _t_val(+);
update t set val = 0 where id > 10 using index _t_id, t.none, _t_val;

update t use index (_t_id) set val = 0 where id > 10 using index all except _t_id;
update t force index (_t_id) set val = 0 where id > 10 using index all except _t_id;

update t use index (_t_id, _t_val) set val = 0 where id > 10 using index all except _t_id;
update t force index (_t_id, _t_val) set val = 0 where id > 10 using index all except _t_id;

update t use index (_t_id) set val = 0 where id > 10 using index all except _t_id(+);
update t use index (_t_id) set val = 0 where id > 10 using index all except _t_id(-);


delete from t use index (_t_id) where id > 10 using index none;
delete from t force index (_t_id) where id > 10 using index none;
delete from t use index (_t_id, _t_val) where id > 10 using index none;
delete from t force index (_t_id, _t_val) where id > 10 using index none;

delete from t use index (_t_id) where id > 10 using index t.none;
delete from t force index (_t_id) where id > 10 using index t.none;
delete from t use index (_t_id, _t_val) where id > 10 using index t.none;
delete from t force index (_t_id, _t_val) where id > 10 using index t.none;

delete from t where id > 10 using index t.none, _t_val;
delete from t where id > 10 using index t.none, _t_val(+);
delete from t where id > 10 using index _t_id, t.none, _t_val;

delete from t use index (_t_id) where id > 10 using index all except _t_id;
delete from t force index (_t_id) where id > 10 using index all except _t_id;

delete from t use index (_t_id, _t_val) where id > 10 using index all except _t_id;
delete from t force index (_t_id, _t_val) where id > 10 using index all except _t_id;

delete from t use index (_t_id) where id > 10 using index all except _t_id(+);
delete from t use index (_t_id) where id > 10 using index all except _t_id(-);


drop table t;
drop table u;
