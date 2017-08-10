create serial s1;
create serial s2;
create table t(id varchar(10),cnt int);
insert into t values('SN001',102);
select * from t where id=s1.next_value;
select * from t where id=s1.next_value and cnt=s2.next_value;
select * from t where  cnt=s2.next_value and id=s1.next_value;
select * from t where id=s1.next_value or cnt=s2.next_value;

alter table t add column d date,t timestamp,c char(20);
alter table t add constraint primary key (id);
create reverse index ri on t(cnt);
update t set d=sys_date,t=sys_timestamp,c=id;
select * from t where d=s1.next_value;
select * from t where t=s1.next_value;
select * from t where c=s1.next_value;
select * from t where d=s1.next_value and cnt=s2.next_value;
select * from t where t=s1.next_value or cnt=s2.next_value;
select * from t where c=s1.next_value and cnt=s2.next_value;
select * from t where c=s1.next_value or cnt=s2.next_value;

drop serial s1;
drop serial s2;
drop t;
