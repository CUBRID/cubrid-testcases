-- create class with date and insert data 


CREATE CLASS c_d (
  c1 DATE
);


INSERT INTO c_d VALUES (DATE '11/11/1994' );
INSERT INTO c_d VALUES (DATE '11/11' );
INSERT INTO c_d VALUES (DATE '11-11' );
INSERT INTO c_d VALUES (DATE '11-11-1994' );

INSERT INTO c_d VALUES (DATE '11-11/1994' );
DROP c_d;