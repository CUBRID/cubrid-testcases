--create two tables ddl_0001,ddl_0002 and ddl_0003 inherited from ddl_0001 , ddl_0004 inherited from ddl_0002,drop all tables at last

CREATE CLASS ddl_0001(
col1    int Unique Not Null,
col2    varchar(100),
col3    varchar(100),
colCreateTm    timestamp Not NULL
);
CREATE CLASS ddl_0002(
col1    int Unique Not Null,
col2    varchar(100),
col3    varchar(100),
colCreateTm    timestamp Not Null
);
CREATE CLASS ddl_0003 UNDER ddl_0001(
col4    varchar(100),
col5    varchar(100)
);
CREATE CLASS ddl_0004 UNDER ddl_0002(
col4    varchar(100),
col5    varchar(100)
);




drop class ddl_0001;
drop class ddl_0002;
drop class ddl_0003;
drop class ddl_0004;