-- [er]create class with timestamp and insert a error timestamp


CREATE CLASS c_d (
  c1 timestamp
);

INSERT INTO c_d VALUES (TIMESTAMP '8:15:00 pm 01/32/1994');
DROP c_d;