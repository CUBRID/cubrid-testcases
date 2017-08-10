create table ad (
 pk                int(11) AUTO_INCREMENT,
 col_int_nokey       int(11) ,
 col_int_key         int(11) ,
 col_date_key        date default sysdate,
 col_date_nokey      date default '2011-01-01',
 col_time_key        time default '09:10:10',
 col_time_nokey      time default '09:10:11',
 col_datetime_key    datetime default '2011-01-01 09:10:11',
 col_datetime_nokey  datetime default systimestamp,
 col_varchar_key     varchar(1),
 col_varchar_nokey   varchar(1) default '5',
 primary key(pk,col_int_nokey)
)
partition by range (col_int_nokey)
(
    partition p400 values less than (400),
    partition p800 values less than (800),
    partition pmax values less than MAXVALUE
);
insert into ad(pk,col_int_nokey) values(10000,10000);
update ad inner join ad__p__pmax as newtable on ad.col_int_nokey=newtable.col_int_nokey set ad.pk=ad.pk+10000;
select pk,col_int_nokey from ad;

insert into ad(pk,col_int_nokey,col_int_key) values(1,10001,3);
insert into ad(pk,col_int_nokey,col_int_key) values(2,1,3);
select pk,col_int_nokey,col_int_key from ad;
update ad inner join ad__p__pmax as newtable on ad.col_int_key=newtable.col_int_key set ad.pk=ad.pk+10000;
select pk,col_int_nokey,col_int_key from ad;
drop ad;
