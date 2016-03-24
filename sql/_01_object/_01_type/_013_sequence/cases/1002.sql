--test definition SEQUENCE type column with the keywords default, not null, shared in create statement 
CREATE CLASS ddl_0001(
   col1         SEQUENCE,
   col2         SEQUENCE NOT NULL,
   col3         SEQUENCE(integer) DEFAULT {1},   
   col4         SEQUENCE(integer) DEFAULT {2} NOT NULL,
   col5         SEQUENCE SHARED NULL,
   col6         SEQUENCE SHARED {1} NOT NULL
);

drop ddl_0001;
