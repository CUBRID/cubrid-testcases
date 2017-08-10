-- [er]create class with timestampltz and insert a error timestampltz


CREATE CLASS c_d (
  c1 timestampltz
);

INSERT INTO c_d VALUES (timestampltz '18:15:00 am 01/31/1994');
DROP c_d;