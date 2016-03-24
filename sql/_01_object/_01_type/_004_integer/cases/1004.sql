-- [er]create class with int and that of length

CREATE CLASS ddl_0001(
 col1            integer NOT NULL UNIQUE,
 col2 		     int(2)
);

SELECT * FROM ddl_0001;

DROP ddl_0001;
