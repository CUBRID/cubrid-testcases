autocommit off;
--set optimization: level 257;
create table med2 (a int, a2 int, b char(20));
insert into med2 select a+1, a, b from public.med;
select count(*) from public.med x,med2 y where x.a+1+y.a = y.a+y.a
	and x.a < 10 ;
select count(*) from public.med x,med2 y where x.a+1+y.a2+1 = y.a+y.a
	and x.a < 10;
select count(*) from public.med x,med2 y where x.a+1 = y.a
	and x.a < 10 ;
select count(*) from public.med x,med2 y where x.a+1 = y.a;
select count(*) from public.med x,med2 y where x.a+1+x.a+1 = y.a+y.a;
select count(*) from med2 x,med2 y where x.a = y.a;
select count(*) from public.med x,med2 y where x.b = y.b;
select count(*) from public.med x,public.med y where x.b = y.b;
rollback;
