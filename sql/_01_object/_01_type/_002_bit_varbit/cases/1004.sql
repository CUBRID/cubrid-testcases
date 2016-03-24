--create table with BIT VARYING type and  tests a create syntax with varchar data type and another constraint like unique,not null, shared and set default value


CREATE CLASS ddl_0001(
   col1       BIT VARYING(1073741823),
   col2       BIT VARYING(1) DEFAULT B'1',
   col3       BIT VARYING(1) NOT NULL,
   col4       BIT VARYING(1) DEFAULT B'1' NOT NULL,
   col5       BIT VARYING(1) dEfaUlt B'1' nOt nUlL,
   col6       BIT VARYING(1) UNIQUE,
   col7       BIT VARYING(1) UNIQUE NOT NULL,
   col8       BIT VARYING(1) SHARED NULL,
   col9       BIT VARYING(1) SHARED B'1' NOT NULL,
   col10      BIT VARYING PRIMARY KEY
);

drop ddl_0001;
