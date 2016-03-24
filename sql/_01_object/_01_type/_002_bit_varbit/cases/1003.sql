--create table with bit type and  tests a create syntax with varchar data type and another constraint like unique,not null, shared and set default value


CREATE CLASS ddl_0001(
   col1       bit(1073741823),
   col2       bit(1) DEFAULT B'1',
   col3       bit(1) NOT NULL,
   col4       bit(1) DEFAULT B'1' NOT NULL,
   col5       bit(1) dEfaUlt B'1' nOt nUlL,
   col6       bit(1) UNIQUE,
   col7       bit(1) UNIQUE NOT NULL,
   col8       bit(1) SHARED NULL,
   col9       bit(1) SHARED B'1' NOT NULL,
   col10      bit PRIMARY KEY
);

drop ddl_0001;
