--autocommit error when the semantic insert statement is run, lock doesn't released
@t1: autocommit on;
@t2: autocommit on;

@t1: create class xoo ( a int, b int);
@t1: insert into xoo values(1, 1);

@t1: insert into xoo values(1, '1');

@t2: insert into xoo values(1,1);

@t1: drop xoo;