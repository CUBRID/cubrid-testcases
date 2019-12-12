create table foo1 ( a integer, b time); 

---insert success
insert into foo1 values ( 50, '10:37:00 PM');
insert into foo1 values ( 51, '10:37:00asdf');
insert into foo1 values ( 52, '10:37:00   PM');
insert into foo1 values ( 53, '10:37:00 PM  ');

---insert fail
insert into foo1 values ( 54, '10:37:00 PPM');

---see result
SELECT * FROM foo1 order by 1,2;
drop foo1;

