--Use decode function to transform class structure

create class t1(a char(6), b float);
insert into t1 values('200701', 1000);
insert into t1 values('200702', 1100);
insert into t1 values('200703', 10450);
insert into t1 values('200704', 100456);
insert into t1 values('200705', 100132);
insert into t1 values('200706', 102340);
insert into t1 values('200707', 102340);
insert into t1 values('200708', 123400);
insert into t1 values('200709', 102340);
insert into t1 values('200710', 10023);
insert into t1 values('200711', 104670);
insert into t1 values('200712', 10230);

select sum(decode(substr(a,5,2),'01',b,0)),
       sum(decode(substr(a,5,2),'02',b,0)),
       sum(decode(substr(a,5,2),'03',b,0)),
       sum(decode(substr(a,5,2),'04',b,0)),
       sum(decode(substr(a,5,2),'05',b,0)),
       sum(decode(substr(a,5,2),'06',b,0)),
       sum(decode(substr(a,5,2),'07',b,0)),
       sum(decode(substr(a,5,2),'08',b,0)),
       sum(decode(substr(a,5,2),'09',b,0)),
       sum(decode(substr(a,5,2),'10',b,0)),
       sum(decode(substr(a,5,2),'11',b,0)),
       sum(decode(substr(a,5,2),'12',b,0))
from t1 ;

drop class t1;     