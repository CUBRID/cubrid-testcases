-- [er] drop a non-exist attribute when data of table is exist

CREATE CLASS ddl_0001 (a1 int,a2 int);

insert into ddl_0001 values (1,2);

ALTER ddl_0001 drop a1;
ALTER ddl_0001 drop a3;


select * from ddl_0001;

drop ddl_0001;
