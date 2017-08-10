-- [er]create class with timestamp and insert a error timestamp


CREATE CLASS c_d (
  c1 timestamp
);

INSERT INTO c_d VALUES (TIMESTAMP '01/31/1994 6:61:00 pm');
DROP c_d;