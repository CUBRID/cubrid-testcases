-- [er]add various type's attribute with several constraints 


CREATE CLASS ddl_0001;
CREATE CLASS ddl_0002;

ALTER CLASS ddl_0001 ADD ATTRIBUTE col1 integer;
ALTER CLASS ddl_0001 ADD CLASS ATTRIBUTE col1 integer;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col2 varchar(100) default 'hello' nOt nUlL unique;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col3 varchar(100) default 'hello' unique NOT NULL;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col4 varchar(100) default 'hello' NoT NuLl unique;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col5 varchar(100) default 'hello' not null unique;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col6 numeric(10,5);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col7 numeric(10,5);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col8 numeric(10,5);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col9 integer;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col10 integer;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col11 char(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col12 char(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col13 numeric(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col14 numeric(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col15 char(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col16 char(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col17 char(10);
ALTER CLASS ddl_0001 ADD ATTRIBUTE col18 timestamp;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col19 timestamp;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col20 timestamp;


ALTER CLASS ddl_0002 ADD SUPERCLASS ddl_0001;
ALTER CLASS ddl_0002 ADD ATTRIBUTE      col21 integer,
                                        col22 varchar(100) nOt nUlL unique,
                                        col23 varchar(100) unique NOT NULL,
                                        col24 varchar(100) NoT NuLl unique,
                                        col25 varchar(100) default 'hello' not null,
                                        col26 numeric(10,5),
                                        col27 numeric(10,5),
                                        col28 numeric(10,5),
                                        col29 integer,
                                        col30 integer,
                                        col31 char(10),
                                        col32 char(10),
                                        col33 numeric(10),
                                        col34 numeric(10),
                                        col35 char(10),
                                        col36 char(10),
                                        col37 char(10),
                                        col38 timestamp,
                                        col39 timestamp,
                                        col40 timestamp;
ALTER CLASS ddl_0002 ADD ATTRIBUTE col41 varchar(100) not null default 'hello';



drop class ddl_0001;
drop class ddl_0002;