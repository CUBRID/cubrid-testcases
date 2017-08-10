drop table if exists z2; 

create table z2 (a int, b int);
insert into z2 values (1,1);
insert into z2 values (1,2);
insert into z2 values (2,1);

SELECT a, b, avg(a+100) over (partition by a order by b) c11 FROM z2 order by c11;

SELECT a, b, avg(a+100) over (partition by a) c11 FROM z2 order by c11;

SELECT a, b, max(100) over (partition by a order by b) c11 FROM z2 order by c11;

SELECT a, b, max(a) over (partition by a ) c11 FROM z2 order by c11;

SELECT a, b, max(100) over (partition by a ) c11 FROM z2 order by c11;

SELECT a, b, max(a) over (partition by b ) c11 FROM z2 order by c11;

prepare stmt from 'SELECT a, b, avg(a+?) over (partition by a order by b) c11 FROM z2 order by c11';
execute stmt using 100;
deallocate prepare stmt;

prepare stmt from 'SELECT a, b, avg(?) over (partition by a order by b) c11 FROM z2 order by c11';
execute stmt using 100;
deallocate prepare stmt;

prepare stmt from 'SELECT a, b, avg(a+?) over (partition by a order by b) c11 FROM z2 order by c11';
execute stmt using 100;
deallocate prepare stmt;

prepare stmt from 'SELECT a, b, avg(?+?) over (partition by a order by b) c11 FROM z2 order by c11';
execute stmt using 100,100;
deallocate prepare stmt;

drop table z2; 

create table z2 (a int, b int) partition by hash(a) partitions 3 ;
insert into z2 values (1,1);
insert into z2 values (1,2);
insert into z2 values (2,1);


SELECT a, b, avg(a+100) over (partition by a order by b) c11 FROM z2 order by c11;

SELECT a, b, avg(a+100) over (partition by a) c11 FROM z2 order by c11;

SELECT a, b, max(100) over (partition by a order by b) c11 FROM z2 order by c11;

SELECT a, b, max(a) over (partition by a ) c11 FROM z2 order by c11;

SELECT a, b, max(100) over (partition by a ) c11 FROM z2 order by c11;

SELECT a, b, max(a) over (partition by b ) c11 FROM z2 order by c11;

prepare stmt from 'SELECT a, b, avg(a+?) over (partition by a order by b) c11 FROM z2 order by c11';
execute stmt using 100;
deallocate prepare stmt;

prepare stmt from 'SELECT a, b, avg(?) over (partition by a order by b) c11 FROM z2 order by c11';
execute stmt using 100;
deallocate prepare stmt;

prepare stmt from 'SELECT a, b, avg(a+?) over (partition by a order by b) c11 FROM z2 order by c11';
execute stmt using 100;
deallocate prepare stmt;

prepare stmt from 'SELECT a, b, avg(?+?) over (partition by a order by b) c11 FROM z2 order by c11';
execute stmt using 100,100;
deallocate prepare stmt;

drop table z2; 