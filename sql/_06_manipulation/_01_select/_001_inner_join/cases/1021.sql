--test multiple rows select using and, or keyword in where clause

create class aa ( a int, b int, c int );
insert into aa values ( 1,2,3);
select * from aa
where
(a =1 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =2 and b=2 and c=3) or
(a =3 and b=2 and c=3) or
(a =4 and b=2 and c=3) or
(a =5 and b=2 and c=3) or
(a =6 and b=2 and c=3) or
(a =7 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =2 and b=2 and c=3) or
(a =3 and b=2 and c=3) or
(a =4 and b=2 and c=3) or
(a =5 and b=2 and c=3) or
(a =6 and b=2 and c=3) or
(a =7 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =2 and b=2 and c=3) or
(a =3 and b=2 and c=3) or
(a =4 and b=2 and c=3) or
(a =5 and b=2 and c=3) or
(a =6 and b=2 and c=3) or
(a =7 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =1 and b=2 and c=3) or
(a =2 and b=2 and c=3) or
(a =3 and b=2 and c=3) or
(a =4 and b=2 and c=3) or
(a =5 and b=2 and c=3) or
(a =6 and b=2 and c=3) or
(a =7 and b=2 and c=3) or
(a =1 and b=1 and c=3) or
(a =1 and b=2 and c=3) or
(a =1 and b=3 and c=3) or
(a =1 and b=4 and c=3) or
(a =1 and b=5 and c=3) or
(a =1 and b=6 and c=3) or
(a =1 and b=7 and c=3) or
(a =1 and b=8 and c=3) or
(a =1 and b=9 and c=3) or
(a =1 and b=0 and c=3) or
(a =1 and b=2 and c=1) or
(a =1 and b=2 and c=2);


drop class aa;
