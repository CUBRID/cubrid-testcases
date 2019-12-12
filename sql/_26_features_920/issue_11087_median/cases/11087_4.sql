-- median function in Hierarchical Queries: start with ... connect by
drop table if exists median_h;
create table median_h(id int, name varchar(255), pid int default 0);

INSERT INTO MEDIAN_H(ID,NAME,PID) VALUES('1','Bom','0');
INSERT INTO MEDIAN_H(ID,NAME,PID) VALUES('2','Kate','1');
INSERT INTO MEDIAN_H(ID,NAME,PID) VALUES('3','Lily','0');
INSERT INTO MEDIAN_H(ID,NAME,PID) VALUES('4','Lucy','1');
INSERT INTO MEDIAN_H(ID,NAME,PID) VALUES('5','Lilei','2');
INSERT INTO MEDIAN_H(ID,NAME,PID) VALUES('6','Meimei','3');

select * from median_h start with id=1 connect by prior id=pid order by 1,2,3;
select median(id) from median_h start with id=1 connect by prior id=pid order by 1;
select median(id) from median_h start with id=5 connect by prior pid=id order by 1;
select median(id) from median_h start with id=2 connect by prior id=pid order by 1;
select median(id) from median_h start with id=3 connect by prior id=pid order by 1;
select median(id) from median_h start with id=6 connect by prior pid=id order by 1;

drop table if exists median_h;
