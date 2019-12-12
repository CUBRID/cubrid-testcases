--SHOW INDEX

CREATE TABLE ioo(a int, b int not null, c char(10) unique);

CREATE INDEX i_ioo_a on ioo(a desc);
SHOW INDEX IN ioo;

CREATE INDEX i_ioo_b_c on ioo(b, c);
SHOW INDEX IN ioo;

DROP TABLE ioo;
