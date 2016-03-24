--test definition SET type column with the keywords default, not null, shared in create statement 
CREATE CLASS ddl_0001(
   col1         SET,
   col2         SET NOT NULL,
   col3         SET(integer) DEFAULT {1},   
   col4         SET(integer) DEFAULT {2} NOT NULL,
   col5         SET SHARED NULL,
   col6         SET SHARED {1} NOT NULL
);

drop ddl_0001;
