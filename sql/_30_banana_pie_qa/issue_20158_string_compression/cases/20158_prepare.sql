--+ holdcas on;

--- prepare 
drop table if exists t1;

create table t1(s1 string,s2 char(300),primary key(s1,s2));

prepare st from 'insert into t1 values(?,?);';

execute st using 'abc','def';

execute st using 'Hierarchical Query is used to obtain a set of data organized in a hierarchy.The START WITH ... CONNECT BY clause is used in combination with the SELECT clause in the following form.You can execute the queries by changing the order of two clauses like CONNECT BY ... START WITH.The START WITH clause will filter the rows from which the hierarchy will start. The rows that satisfy the START WITH condition will be the root nodes of the hierarchy. If START WITH is omitted, then all the rows will be considered as root nodes.If a CONNECT BY statement causes a cycle at runtime and the NOCYCLE keyword is not specified, CUBRID will return an error and the statement will be canceled. When specifying the NOCYCLE keyword, if CUBRID detects a cycle while processing a hierarchy node, it will set the CONNECT_BY_ISCYCLE attribute for that node to the value of 1 and it will stop further expansion of that branch.',
'Hierarchical Query is used to obtain a set of data organized in a hierarchy.The START WITH ... CONNECT BY clause is used in combination with the SELECT clause in the following form.You can execute the queries by changing the order of two clauses like CONNECT BY ... START WITH.The START WITH clause will filter the rows from which the hierarchy will start. The rows that satisfy the START WITH condition will be the root nodes of the hierarchy. If START WITH is omitted, then all the rows will be considered as root nodes.If a CONNECT BY statement causes a cycle at runtime and the NOCYCLE keyword is not specified, CUBRID will return an error and the statement will be canceled. When specifying the NOCYCLE keyword, if CUBRID detects a cycle while processing a hierarchy node, it will set the CONNECT_BY_ISCYCLE attribute for that node to the value of 1 and it will stop further expansion of that branch.';

select * from t1 order by 1;

select disk_size(s1),length(s1),disk_size(s2),length(s2) from t1 order by 1;

drop table t1;

deallocate prepare st;


drop table if exists t2;

create table t2(s1 string);

insert into t2 values(repeat('a',300));

prepare st1 from 'select s1 into :result from t2';

execute st1;

select length(:result),disk_size(:result),:result;

deallocate prepare st1;

drop table t2;


drop table if exists t;

create table t (b varchar, c char(1000)); 

create index i_t_c_b  on t(c,b);

insert into t values(repeat('abc',200),repeat('def',200));

insert into t values(repeat('f',200),repeat('m',200));

PREPARE stmt FROM 'select b,c from t where b > ? and c > ? using index i_t_c_b keylimit ?,? order by 1';

EXECUTE stmt using 'd','e',0,1;

PREPARE stmt1 FROM 'select disk_size(b),disk_size(c) from t order by 1;';

EXECUTE stmt1;

drop table t;

DEALLOCATE PREPARE stmt;

DEALLOCATE PREPARE stmt1;

--+ holdcas off;