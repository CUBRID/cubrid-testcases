-- [er]create table ddl_0001, create serial no named ddl_0001_01,create an active trigger based on AFTER INSERT ON ddl_0001 event and use new object , serial no

CREATE CLASS ddl_0001(
        col1 int unique,
        col2 varchar(100) default '???' not null,
        col3 varchar(100),
        col4 char(100)
);

CREATE SERIAL ddl_0001_01
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 10000000000
NOCYCLE;

CREATE TRIGGER ddl_0001_02
STATUS ACTIVE
AFTER INSERT ON ddl_0001
IF new.col1 IS NULL
        EXECUTE INSERT INTO ddl_0001 VALUES( ddl_0001_01.next_value, new.col2, new.col3, new.col4 );




drop serial ddl_0001_01;
drop ddl_0001;
drop trigger ddl_0001_02;