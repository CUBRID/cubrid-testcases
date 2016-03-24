-- create class with int and insert data  

CREATE CLASS ddl_0001(
 col1            integer NOT NULL UNIQUE,
 col2 		     int DEFAULT 0
);

INSERT INTO ddl_0001 VALUES (1,1);
INSERT INTO ddl_0001 VALUES (19.3,1);
INSERT INTO ddl_0001 VALUES (-59.33333,null);
INSERT INTO ddl_0001 VALUES (2147483647,-2147483648);



SELECT * FROM ddl_0001;

DROP ddl_0001;