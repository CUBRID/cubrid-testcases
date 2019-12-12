drop table if exists A;
drop table if exists B;
drop table if exists C;
drop table if exists D;


create table A(i int);
insert into A values(1),(2);

create table B(j int,i int);
insert into B values(1,1),(2,1),(3,2);

create table C(k int,j int);
insert into C values(1,NULL),(2,NULL),(3,1),(4,1),(5,2),(6,3);

create table D(k int);
insert into D values(1),(2),(3),(4),(5),(6);

select *
from A left join B on A.i=B.i
left join C on C.j=B.j
left join D on D.k=C.k
where D.k=4;

select * 
from D right join C on D.k=C.k
right join B on B.j=C.j
right join A on A.i=B.i
where D.k=4;


select * 
from A right join B on A.i=B.i
right join C on C.j=B.j
right join D on D.k=C.k
where D.k <>4 order by 6;

select * 
from B right join C on B.j=C.j
right join D on D.k=C.k
right join A on A.i=B.i
where A.i>1 or C.j=2 order by 1 desc; 

select A.i,count(*)
from A left join B on A.i=B.i
left join C on C.j=B.j
left join D on D.k=C.k where D.k>3 group by A.i ;

drop A,B,C,D;

create table A(i varchar(10) primary key);
insert into A values('i1'),('i2');

create table B(j varchar(10) primary key,i varchar(10));
insert into B values('j1','i1'),('j2','i1'),('j3','i2');

create table C(k varchar(10) primary key,j varchar(10));
insert into C values('k1',NULL),('k2',NULL),('k3','j1'),('k4','j1'),('k5','j2'),('k6','j3');

create table D(k varchar(10));
insert into D values('k1'),('k2'),('k3'),('k4'),('k5'),('k6');

alter table B add constraint foreign key(i) references A(i);
alter table C add constraint foreign key(j) references B(j);
alter table D add constraint foreign key(k) references C(k);


select *
from A left join B on A.i=B.i
left join C on C.j=B.j
left join D on D.k=C.k
where D.k='k4';

select * 
from D right join C on D.k=C.k
right join B on B.j=C.j
right join A on A.i=B.i
where D.k='k4';


select * 
from A right join B on A.i=B.i
right join C on C.j=B.j
right join D on D.k=C.k
where D.k <>'k4' order by 6;

select * 
from B right join C on B.j=C.j
right join D on D.k=C.k
right join A on A.i=B.i
where A.i>'i1' or C.j='j2' order by 1 desc; 

select A.i,count(*)
from A left join B on A.i=B.i
left join C on C.j=B.j
left join D on D.k=C.k where D.k>'k3' group by A.i ;

drop D,C,B,A;
