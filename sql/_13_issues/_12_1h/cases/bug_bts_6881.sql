create table x(a int);
prepare x from 'insert into x values(ifnull(?,1))';
execute x using 1;
drop table x;
