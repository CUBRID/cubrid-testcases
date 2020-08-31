set system parameters 'create_table_reuseoid=no';

-- create classes,alter these classes,drop these classes

CREATE CLASS ddl_0001;
CREATE CLASS ddl_0002;
CREATE CLASS ddl_0003;
CREATE CLASS ddl_0004;
CREATE CLASS ddl_0005;
ALTER ddl_0001 add col1 ddl_0002;
ALTER ddl_0001 add col2 ddl_0003;
ALTER ddl_0001 add col3 ddl_0004;
ALTER ddl_0001 add col4 ddl_0005;





drop ddl_0001;
DROP ddl_0002;
DROP ddl_0003;
DROP ddl_0004;
DROP ddl_0005;

set system parameters 'create_table_reuseoid=yes';
