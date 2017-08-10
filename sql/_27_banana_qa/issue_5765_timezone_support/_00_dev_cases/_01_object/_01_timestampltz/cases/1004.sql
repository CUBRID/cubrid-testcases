-- [er]create class with timestampltz and insert a error timestampltz


CREATE CLASS c_d (
  c1 timestampltz
);

INSERT INTO c_d VALUES (timestampltz '13/31/1994 8:15:00 pm');
DROP c_d;