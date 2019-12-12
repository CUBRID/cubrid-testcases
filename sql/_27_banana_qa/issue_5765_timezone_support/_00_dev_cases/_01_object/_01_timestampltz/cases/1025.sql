-- [er]create class with timestampltz and insert a error timestampltz


CREATE CLASS c_d (
  c1 timestampltz
);

INSERT INTO c_d VALUES (timestampltz '8:15:00 pm 01/31/0');
DROP c_d;