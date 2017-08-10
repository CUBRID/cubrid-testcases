-- [er]create class with date and insert a error date


CREATE CLASS c_d (
  c1 DATE
);

INSERT INTO c_d VALUES (DATE '12/32/1994' );
DROP c_d;