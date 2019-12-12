drop table if exists foo5;

create table foo5 ( a integer auto_increment );
select foo5_ai_a.next_value;
drop table foo5;
create serial foo5_ai_a;
select foo5_ai_a.next_value;

drop serial foo5_ai_a;

create table foo5 ( a integer auto_increment, b int);
select foo5_ai_a.next_value;
alter table foo5 drop attribute a;
create serial foo5_ai_a;
select foo5_ai_a.next_value;

drop foo5;
drop serial foo5_ai_a;
