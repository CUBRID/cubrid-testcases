
CREATE TABLE t1 (a VARCHAR (30) collate utf8_en_ci)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN (_euckr'A')
);
drop table t1;


CREATE TABLE t1 (a VARCHAR (30) collate utf8_en_ci)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN (_iso88591'A')
);
drop table t1;

CREATE TABLE t1 (a VARCHAR (30) collate utf8_en_ci)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN (_utf8'A')
);
drop table t1;