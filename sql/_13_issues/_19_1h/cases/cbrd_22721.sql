select if(benchmark(10,sum(2+2))>0, 'OK', 'NOK');
select if(benchmark(10,avg(2+2))>0, 'OK', 'NOK');
select if(benchmark(0,avg(2+2))>0, 'OK', 'NOK');
select if(benchmark(-1,avg(2+2))>0, 'OK', 'NOK');
select if(benchmark(1000000,avg(2+2))>0, 'OK', 'NOK');
select if(benchmark(10,now())>0, 'OK', 'NOK');
select if(benchmark(100,now())> benchmark(10,now()), 'OK', 'NOK');
select if(benchmark(10,avg(2000+2000))> benchmark(10,avg(2+2)), 'OK', 'NOK');
select if(benchmark(10,sum(2000+2000))> benchmark(10,sum(2+2)), 'OK', 'NOK');
