-- [er]create class with timestamp and insert a error timestamp


CREATE CLASS c_d (
  c1 timestamp
);

INSERT INTO c_d VALUES (TIMESTAMP '01/31/1994 18:15:00 am');
DROP c_d;