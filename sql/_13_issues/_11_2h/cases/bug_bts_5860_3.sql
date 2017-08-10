--test FIND_IN_SET() 
select find_in_set('a','a,b,c');

select find_in_set('a','b,a,c');

select find_in_set('a','b,c,a');

select find_in_set('a','a');

select find_in_set('b','a, b, c');

select find_in_set('c','a, b, c');

select find_in_set('c', 'a,b,c ');

select find_in_set('', 'a,b,c');

select find_in_set('abc','');

select find_in_set('a,b','a,b,c');

select find_in_set('a,b','1,a,b,c');

select find_in_set('a,b','1,c,a,b');

--nchar/varnchar
select find_in_set(n'a',n'a,b,c');

select find_in_set(n'a',n'b,a,c');

select find_in_set(n'a',n'b,c,a');

select find_in_set(n'a',n'a');

select find_in_set(n'b',n'a, b, c');

select find_in_set(n'c',n'a, b, c');

select find_in_set(n'c', n'a,b,c ');

select find_in_set(n'', n'a,b,c');

select find_in_set(n'abc',n'');

select find_in_set(n'abc', 'a,abc,aa');

select find_in_set('abc', n'a,abc,aa');

create table t(i int auto_increment);

insert into t values(NULL);

insert into t select NULL from t;

insert into t select NULL from t;

insert into t select NULL from t;

insert into t select NULL from t;

insert into t select NULL from t;

insert into t select NULL from t;

insert into t select NULL from t;

insert into t select NULL from t;

insert into t select NULL from t;

insert into t select NULL from t;

insert into t select NULL from t;

insert into t select NULL from t;

create table a(s string);

insert into a values('1');

update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where (i between 1 and 128) and i != 1));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 129 and 256));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 257 and 384));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 385 and 512));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 513 and 640));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 641 and 768));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 769 and 896));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 897 and 1024));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 1025 and 1152));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 1153 and 1280));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 1281 and 1408));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 1409 and 1536));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 1537 and 1664));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 1665 and 1792));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 1793 and 1920));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 1921 and 2048));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 2049 and 2176));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 2177 and 2304));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 2305 and 2432));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 2433 and 2560));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 2561 and 2688));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 2689 and 2816));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 2817 and 2944));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 2945 and 3072));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 3073 and 3200));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 3201 and 3328));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 3329 and 3456));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 3457 and 3584));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 3585 and 3712));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 3713 and 3840));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 3841 and 3968));
update a set s = concat(s, ',', (select group_concat(i order by i separator ',') from t where i between 3969 and 4096));

select i, find_in_set(i, (select s from a)) from t where (i > 2000 and i < 2100) or i = 1 or i = 4096 order by i;

select i, find_in_set(i, (select s from a)) from t where (i > 10 and i < 30) or i = 1 or i = 4096 order by i;

drop table t;

$varchar, $10, $int, $11
select find_in_set(?, s), find_in_set(?,s) from a;

drop table a;

prepare s from 'select find_in_set(''a'',?) from db_root';
execute s using 'a,b,c';
deallocate prepare s;

