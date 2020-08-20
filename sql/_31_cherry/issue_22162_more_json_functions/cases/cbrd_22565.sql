set system parameters 'create_table_reuseoid=no';
drop view if exists tree;
drop table if exists tree1;

CREATE TABLE tree1(ID INT, MgrID INT, Name VARCHAR(32),sort int);

create view tree as select * from tree1 order by 1, 2, 3, 4;

INSERT INTO tree VALUES (1,0,'Kim',1);
INSERT INTO tree VALUES (2,0,'Moy',1);
INSERT INTO tree VALUES (3,1,'Jonas',3);
INSERT INTO tree VALUES (4,1,'Smith',3);
INSERT INTO tree VALUES (5,2,'Verma',2);
INSERT INTO tree VALUES (6,2,'Foster',2);
INSERT INTO tree VALUES (7,6,'Brown',1);

--test: system error for below query:
select * from json_table(
    (select  json_objectagg(id,id||':'||mgrid) from tree connect by prior id=mgrid ORDER SIBLINGS BY sort,id),
    '$.*' COLUMNS (a VARCHAR(100) PATH '$')
) as t1 order by 1;

select id,mgrid from tree connect by prior id=mgrid ORDER SIBLINGS BY sort,id;

--expected error
select  json_arrayagg(id,mgrid) from tree connect by prior id=mgrid ORDER SIBLINGS BY sort,id;

select * from json_table(
    (select  json_arrayagg(id) from tree connect by prior id=mgrid ORDER SIBLINGS BY sort,id),
    '$[*]' COLUMNS (a VARCHAR(100) PATH '$')
) as t1 order by 1;

select * from json_table(
    (select  json_arrayagg(mgrid) from tree connect by prior id=mgrid ORDER SIBLINGS BY sort,id),
    '$[*]' COLUMNS (a VARCHAR(100) PATH '$')
) as t1 order by 1;


INSERT INTO tree VALUES (NULL,NULL,'null', null);

--expected error
select  json_objectagg(id,mgrid) from tree connect by prior id=mgrid ORDER SIBLINGS BY sort,id;

select id,mgrid from tree connect by prior id=mgrid ORDER SIBLINGS BY sort,id;

select * from json_table(
    (select  json_arrayagg(id) from tree connect by prior id=mgrid ORDER SIBLINGS BY sort,id),
    '$[*]' COLUMNS (a VARCHAR(100) PATH '$')
) as t1 order by 1;

select * from json_table(
    (select  json_arrayagg(mgrid) from tree connect by prior id=mgrid ORDER SIBLINGS BY sort,id),
    '$[*]' COLUMNS (a VARCHAR(100) PATH '$')
) as t1 order by 1;

drop view if exists tree;
drop table if exists tree1;
set system parameters 'create_table_reuseoid=yes';
