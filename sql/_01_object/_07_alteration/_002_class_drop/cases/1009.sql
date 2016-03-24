-- drop class attribute

CREATE CLASS ddl_0001 (a1 int,a2 int);

insert into ddl_0001 values (1,2);

ALTER ddl_0001 add CLASS ATTRIBUTE qwe STRING;


ALTER ddl_0001 drop CLASS qwe;

SELECT * FROM db_attribute WHERE  class_name = 'ddl_0001' order by 1,2;

select * from ddl_0001;

drop ddl_0001;
