-- [er]create class with timestamptz and insert a error timestamptz


CREATE CLASS c_d (
  c1 timestamptz
);

INSERT INTO c_d VALUES (timestamptz '01/31/1994 6:61:00 pm');
DROP c_d;