-- insert and query data which table to reference to the table of create range partition with int field having boundary values and maxvalue

create table ident (id int, 
name char(10), 
zzz varchar(50)) 
partition by range (id) ( 
partition p0 values less than (3), 
partition p1 values less than (5), 
partition p2 values less than MAXVALUE); 


create table test2 (id int, 
person ident, 
xxx int) ;

insert into test2 values(1, insert into ident values (1, 'kim','seoul'), 10); 
insert into test2 values(2,insert into ident values (2, 'lee','pusan'),20); 
insert into test2 values(10,insert into ident values (3, 'who','kangwon'),30); 
insert into test2 values(20,insert into ident values (4, 'aaa','inchon'),40); 
insert into test2 values(30,insert into ident values (5, 'fff','asdf'),50); 



select person.id from test2 order by 1;



drop table ident;
drop table test2;
