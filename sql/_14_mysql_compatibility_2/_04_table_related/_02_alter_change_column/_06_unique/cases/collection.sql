---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : constraints  : add UNIQUE KEY on collection (SET) columns 
-- ordering : no order defined
-- name : same or different
-- type : changed


--------------------- UNIQUE keys

------- type the same, name changed - only one unique on 2 columns
create table t1 (s1 set (int, varchar(10)));
insert into t1 values ({12,'abc'}),({12,'1234','abcde'})({12,5,'1234a'})({'00'});


select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 s1 set(int, varchar(10)) unique;

select * from t1 order by 1;
show columns in t1;

drop table t1;



