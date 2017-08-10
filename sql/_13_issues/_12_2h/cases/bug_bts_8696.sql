drop table if exists t;
create table t(id int,employeename string,pname enum('bike','car','plane'),price monetary,salesamount int,d date);
insert into t values(1,'u1',2,120,3,sys_date);
insert into t values(1,'u1',1,12,10,sys_date);
insert into t values(2,'u2',2,48,6,sys_date);
insert into t values(2,'u2',3,12,110,sys_date);

select id,employeename,salesamount*price,max(salesamount*price) over (partition by employeename) as maxvalue from t order by 3;
select id,employeename,salesamount*price,max(salesamount*price) over (partition by employeename order by price*salesamount) as maxvalue from t;
select id,employeename,salesamount,max(salesamount) over (partition by employeename) as maxvalue from t order by 3;
select id,employeename,salesamount*price,sum(salesamount*price) over (partition by employeename) as s from t order by 3;
select id,employeename,salesamount*price,sum(salesamount*price) over (partition by employeename order by salesamount*price) as s from t;
select id,employeename,salesamount*price,sum(salesamount*price) over (partition by employeename order by salesamount*price desc) as s from t;
drop t;

create table t(id int,employeename string,pname enum('bike','car','plane'),price monetary,salesamount int,d date) partition by range(salesamount) (partition p0 values less than (10),partition p1 values less than (100),partition p2 values less than maxvalue);
insert into t values(1,'u1',2,120,3,sys_date);
insert into t values(1,'u1',1,12,10,sys_date);
insert into t values(2,'u2',2,48,6,sys_date);
insert into t values(2,'u2',3,12,110,sys_date);
select id,employeename,salesamount*price,max(salesamount*price) over (partition by employeename) as maxvalue from t order by 3;
select id,employeename,salesamount*price,max(salesamount*price) over (partition by employeename order by price*salesamount) as maxvalue from t;
select id,employeename,salesamount,max(salesamount) over (partition by employeename) as maxvalue from t order by 3;
select id,employeename,salesamount*price,sum(salesamount*price) over (partition by employeename) as s from t order by 3;
select id,employeename,salesamount*price,sum(salesamount*price) over (partition by employeename order by salesamount*price) as s from t;
select id,employeename,salesamount*price,sum(salesamount*price) over (partition by employeename order by salesamount*price desc) as s from t;
drop t;
