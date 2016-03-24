--inet_aton_ntoa_select_005.sql
select 16909060 into x;
select '1.2.3.4' into y;

select inet_ntoa(:x);
select inet_aton(:y);
select (inet_aton(inet_ntoa(:x))=x);
select (inet_ntoa(inet_aton(:y))=y);
