create table t1 (code char(900));
 create index idx on t1(code desc);

 insert into t1 values('00000');
 insert into t1 values('00001');
 insert into t1 values('00002');
 insert into t1 values('00003');
 insert into t1 values('00004');
 insert into t1 values('00005');
 insert into t1 values('00006');
 insert into t1 values('00007');
 insert into t1 values('00008');
 insert into t1 values('00009');

 insert into t1 values('00010');
 insert into t1 values('00011');
 insert into t1 values('00012');
 insert into t1 values('00013');
 insert into t1 values('00014');
 insert into t1 values('00015');
 insert into t1 values('00016');
 insert into t1 values('00017');
 insert into t1 values('00018');
 insert into t1 values('00019');

 insert into t1 values('00020');
 insert into t1 values('00021');
 insert into t1 values('00022');
 insert into t1 values('00023');
 insert into t1 values('00024');
 insert into t1 values('00025');
 insert into t1 values('00026');
 insert into t1 values('00027');
 insert into t1 values('00028');
 insert into t1 values('00029');

 insert into t1 values('00030');
 insert into t1 values('00031');
 insert into t1 values('00032');
 insert into t1 values('00033');
 insert into t1 values('00034');
 insert into t1 values('00035');
 insert into t1 values('00036');
 insert into t1 values('00037');
 insert into t1 values('00038');
 insert into t1 values('00039');

select count(*) from t1;
select trim(code) from t1 where code > '00010' and code < '00035'; 

drop table t1;
