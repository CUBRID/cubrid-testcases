create table t(a int not null,b int);

create index idx on t(a) where b>0;

show index in t;

alter table t change a a  int;

--We expect there is no index in t;
show index in t;

drop table t;


