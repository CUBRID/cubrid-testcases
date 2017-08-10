drop  if exists y;

create table y(i int ,s numeric(6,2));

insert INTO y values(1,50.00),(2,71.43),(3,64.29),(4,50.00),(5,64.29 );

insert INTO y values(1,50.00),(2,71.43),(3,64.29),(4,50.00),(5,64.29 );

SELECT AVG(s) ,i FROM y GROUP BY i;

SELECT TO_CHAR(AVG(s),'990.00') ,i FROM y GROUP BY i;

drop y;

drop if exists y;

create table y(i int ,s numeric(4,2));

insert INTO y values(1,50.00),(2,71.43),(3,64.29),(4,50.00),(5,64.29 );

insert INTO y values(1,50.00),(2,71.43),(3,64.29),(4,50.00),(5,64.29 );

SELECT AVG(s) ,i FROM y GROUP BY i;

SELECT TO_CHAR(AVG(s),'990.00') ,i FROM y GROUP BY i;

drop y;

drop if exists y;

create table y(i int ,s double);

insert INTO y values(1,50.00),(2,71.43),(3,64.29),(4,50.00),(5,64.29 );

insert INTO y values(1,50.00),(2,71.43),(3,64.29),(4,50.00),(5,64.29 );

SELECT AVG(s) ,i FROM y GROUP BY i;

SELECT TO_CHAR(AVG(s),'990.00') ,i FROM y GROUP BY i;

drop y;

drop if exists y;

create table y(i int ,s numeric(3,1));

insert INTO y values(1,10.1),(2,21.2),(3,3.5),(4,4.8),(5,20 ),(6,3);

insert INTO y values(1,10.1),(2,21.2),(3,3.5),(4,4.8),(5,20 ),(6,3);

SELECT AVG(s) ,i FROM y GROUP BY i;

SELECT TO_CHAR(AVG(s),'990.00') ,i FROM y GROUP BY i;

drop y;

drop if exists y;

create table y(i int ,s numeric(5,3));

insert INTO y values(1,10.1),(2,21.2),(3,3.5),(4,4.8),(5,20 ),(6,3);

insert INTO y values(1,10.3),(2,21.4),(3,3.9),(4,4.6),(5,10 ),(6,5);

SELECT AVG(s) ,i FROM y GROUP BY i;

SELECT TO_CHAR(AVG(s),'990.00') ,i FROM y GROUP BY i;

drop y;

drop if exists y;

create table y(i int ,s int);

insert INTO y values(1,10.1),(2,21.2),(3,3.5),(4,4.8),(5,20 ),(6,3);

insert INTO y values(1,10.3),(2,21.4),(3,3.9),(4,4.6),(5,10 ),(6,5);

SELECT AVG(s) ,i FROM y GROUP BY i;

SELECT TO_CHAR(AVG(s),'990.00') ,i FROM y GROUP BY i;

drop y;



