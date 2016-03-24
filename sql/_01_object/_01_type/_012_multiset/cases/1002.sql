--test definition MULTISET type column with the keywords default, not null, shared in create statement 
CREATE CLASS ddl_0001(
   col1         MULTISET,
   col2         MULTISET NOT NULL,
   col3         MULTISET(integer) DEFAULT {1},   
   col4         MULTISET(integer) DEFAULT {2} NOT NULL,
   col5         MULTISET SHARED NULL,
   col6         MULTISET SHARED {1} NOT NULL
);

drop ddl_0001;
