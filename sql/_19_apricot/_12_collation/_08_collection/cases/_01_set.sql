
create table ts (s set (string collate 'utf8_en_cs'));
alter table ts add s2 set (string collate 'utf8_en_ci');
alter table ts add s3 set (string collate 'utf8_en_cs');

insert into ts values ({'Ab'},{'Ab'},{'Ab'});
insert into ts values ({'aa'},{'aa'},{'aa'});

insert into ts values ({'Ab','aad'},{'Ab'}, {'Ab','aad'});
insert into ts values ({'aa','Aad'},{'aa'},{'aa','Aad'});


select * from ts order by 1;

select * from ts where {'aa'} seteq s order by 1;

select * from ts where s2 subseteq s order by 1;

select * from ts where s3 subseteq s order by 1;

select * from ts where s3 subseteq {'aad','Ab'} order by 1;

select * from ts where s2 subseteq {'aad','Ab'} order by 1;

select * from ts where s subseteq {'aad','Ab'} order by 1;

prepare s from 'select * from ts where s subseteq ? order by 1';
execute s using {'aad','Ab'};
deallocate prepare s;

prepare s from 'select * from ts where s2 subseteq ? order by 1';
execute s using {'aad','Ab'};
deallocate prepare s;

prepare s from 'select * from ts where ? superseteq s2 order by 1';
execute s using {'aad','Ab'};
deallocate prepare s;

prepare s from 'select * from ts where ? subseteq s2 order by 1';
execute s using {'Ab'};
deallocate prepare s;


drop table ts;
