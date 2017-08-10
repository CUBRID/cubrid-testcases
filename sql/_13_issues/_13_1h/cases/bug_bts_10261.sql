drop if exists s1__p__p1; 

create table s1__p__p1 (i int, j int);

insert into s1 partition(p1) values (1,1);

update s1 partition(p1) set i=99;

delete from s1 partition(p1);

truncate table s1 partition(p1);

drop s1__p__p1; 



drop if exists s1__p__p1024; 

create table s1__p__p1024 (i int, j int);

insert into s1 partition(p1024) values (1,1);

update s1 partition(p1024) set i=99;

delete from s1 partition(p1024);

truncate table s1 partition(p1024);

drop s1__p__p1024; 



drop if exists s1__p__p0; 

create table s1__p__p0 (i int, j int);

insert into s1 partition(p1024) values (1,1);

update s1 partition(p1024) set i=99;

delete from s1 partition(p1024);

truncate table s1 partition(p1024);

drop s1__p__p0; 
