/*
The use of synonyms is not allowed in the update statistics statement.
*/

drop synonym if exists s1;
drop table if exists t1;

create table t1 (c1 int);
create synonym s1 for t1;
update statistics on s1;

drop synonym s1;
drop table t1;
