--+ holdcas on;

drop table if exists dcl1;
drop table if exists dcl2;
drop table if exists dcl3;

CREATE CLASS DCL1 (s string) collate utf8_en_cs;
INSERT INTO DCL1(s) VALUES('a');
CREATE CLASS DCL2 UNDER DCL1 (s string);
INSERT INTO DCL2(s) VALUES('a');
CREATE CLASS DCL3 UNDER DCL1 (s string);
INSERT INTO DCL3(s) VALUES(1);

show full columns from DCL1;
show full columns from DCL2;
show full columns from DCL3;

DROP CLASS ALL DCL1;


CREATE CLASS DCL1 (s string) collate utf8_en_cs;
INSERT INTO DCL1(s) VALUES('a');
CREATE CLASS DCL2 UNDER DCL1 (s string) collate utf8_en_cs;
INSERT INTO DCL2(s) VALUES('a');
CREATE CLASS DCL3 UNDER DCL1 (s string) collate utf8_en_cs;
INSERT INTO DCL3(s) VALUES(1);

show full columns from DCL1;
show full columns from DCL2;
show full columns from DCL3;

DROP CLASS ALL DCL1;


CREATE CLASS DCL1 (s string) collate utf8_en_cs;
INSERT INTO DCL1(s) VALUES('a');
CREATE CLASS DCL2 UNDER DCL1 (s string collate utf8_en_ci);
INSERT INTO DCL2(s) VALUES('a');
CREATE CLASS DCL3 UNDER DCL1 (s string);
INSERT INTO DCL3(s) VALUES(1);

show full columns from DCL1;
show full columns from DCL2;
show full columns from DCL3;

DROP CLASS ALL DCL1;


CREATE CLASS DCL1 (s string) collate utf8_en_cs;
INSERT INTO DCL1(s) VALUES('a');
CREATE CLASS DCL2 UNDER DCL1 (s string);
INSERT INTO DCL2(s) VALUES('a');
CREATE CLASS DCL3 UNDER DCL1 (s string collate utf8_en_ci);
INSERT INTO DCL3(s) VALUES(1);

show full columns from DCL1;
show full columns from DCL2;
show full columns from DCL3;

DROP CLASS ALL DCL1;

CREATE CLASS DCL1 (s string) collate utf8_en_cs;
INSERT INTO DCL1(id) VALUES('a');
CREATE CLASS DCL2 UNDER DCL1 (s string charset utf8);
INSERT INTO DCL2(id) VALUES('a');
CREATE CLASS DCL3 UNDER DCL1 (s string charset iso88591);
INSERT INTO DCL3(id) VALUES(1);

show full columns from DCL1;
show full columns from DCL2;
show full columns from DCL3;

DROP CLASS ALL DCL1;

commit;
--+ holdcas off;
