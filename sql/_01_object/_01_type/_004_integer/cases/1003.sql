-- [er]create class with int and insert data unaccepted

CREATE CLASS ddl_0001(
 col1            integer NOT NULL UNIQUE,
 col2 		     int DEFAULT 0
);


INSERT INTO ddl_0001 VALUES (2147483647.1,-2147483648.1);



SELECT * FROM ddl_0001;

DROP ddl_0001;