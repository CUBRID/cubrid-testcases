--+ holdcas off;

create table t1 (i int, j int);


CREATE INDEX idx1 ON t1 (i);

CREATE  INDEX idx2 on t1(j);

ALTER  INDEX idx1 on t1(j) REBUILD;

update statistics on t1;
show indexes from t1;

drop  table t1 ;

--+ holdcas on;

create table t1 (i int, j int);

CREATE INDEX idx1 ON t1 (i);

CREATE  INDEX idx2 on t1(j);

ALTER  INDEX idx1 on t1(j) REBUILD;

update statistics on t1;
show indexes from t1;

drop  table t1 ;

commit;

--+ holdcas off;

create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));

insert into t1 value('yin', 'jian ye',31,'M');

CREATE INDEX first_name_lower ON t1 (LOWER(FirstName));

create  INDEX first_name_lower1 on t1(firstname) WHERE LOWER(FirstName)='yin';

ALTER  INDEX first_name_lower on t1(firstname) WHERE LOWER(FirstName)='yin' REBUILD;

update statistics on t1;
show indexes from t1;

alter  INDEX first_name_lower1 on t1(firstname) REBUILD;

ALTER  INDEX first_name_lower on t1(FirstName) REBUILD;

ALTER  INDEX first_name_lower on t1(FirstName desc) REBUILD;

drop  table t1 ;

--+ holdcas on;

create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));

insert into t1 value('yin', 'jian ye',31,'M');


CREATE INDEX first_name_lower ON t1 (LOWER(FirstName));

create  INDEX first_name_lower1 on t1(firstname) WHERE LOWER(FirstName)='yin';

ALTER  INDEX first_name_lower on t1(firstname) WHERE LOWER(FirstName)='yin' REBUILD;

update statistics on t1;
show indexes from t1;

alter  INDEX first_name_lower1 on t1(firstname) REBUILD;

ALTER  INDEX first_name_lower on t1(FirstName) REBUILD;

ALTER  INDEX first_name_lower on t1(FirstName desc) REBUILD;

drop  table t1 ;

commit;

--+ holdcas off;
