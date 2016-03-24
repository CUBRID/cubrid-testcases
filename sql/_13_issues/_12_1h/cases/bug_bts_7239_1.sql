autocommit on; 
create class t1(name date); 
create class t2(id int); 
create trigger trig1 after insert on t2 execute insert into t1(name) values(obj.id); 
commit; 
insert into t2(id) values(1);
commit; 
select * from t2; 
select * from t1;
drop trigger trig1;
drop t1;
drop t2;


create class t2(id int); 
create trigger trig1 after insert on t2 execute truncate t2; 
drop trigger trig1;
drop t2;

