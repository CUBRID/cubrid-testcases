--create table with varchar data type and  tests a create syntax with varchar data type and another constraint like unique,not null, shared and set default value
autocommit on;

CREATE CLASS ddl_0001(
   col1       varchar(1073741823),
   col2       varchar(1073741823) DEFAULT 'varchar1',
   col3       varchar(1073741823) NOT NULL,
   col4       varchar(1073741823) DEFAULT 'varchar2' NOT NULL,
   col5       varchar(1073741823) dEfaUlt 'varchar2' nOt nUlL,
   col6       varchar(1073741823) UNIQUE,
   col7       varchar(1073741823) UNIQUE NOT NULL,
   col8       varchar(1073741823) SHARED NULL,
   col9       varchar(1073741823) SHARED 'a' NOT NULL
);

drop ddl_0001;
