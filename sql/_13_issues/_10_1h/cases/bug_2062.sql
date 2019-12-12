CREATE TABLE "hyhmt_imfj"(
"hyhmt_ahr" integer NOT NULL UNIQUE,
"imatwmnh_ahr" integer,
"name" character varying(20)
);

CREATE TABLE "imatwmnh_imfj"(
"imatwmnh_ahr" integer NOT NULL UNIQUE,
"ayn_ahr" integer,
"name" character varying(20)
);

CREATE TABLE "ayn_imfj"(
"ayn_ahr" integer NOT NULL UNIQUE,
"name" character varying(20)
);

insert into ayn_imfj (ayn_ahr, "name") values (1, 'svc_name1');
insert into ayn_imfj (ayn_ahr, "name") values (2, 'svc_name2');
insert into ayn_imfj (ayn_ahr, "name") values (3, 'svc_name3');

insert into imatwmnh_imfj (imatwmnh_ahr , "ayn_ahr", "name") values (1, 1, 'instance_name1');
insert into imatwmnh_imfj (imatwmnh_ahr , "ayn_ahr", "name") values (2, 0, 'instance_name2');
insert into imatwmnh_imfj (imatwmnh_ahr , "ayn_ahr", "name") values (3, 0, 'instance_name3');

insert into hyhmt_imfj (hyhmt_ahr , "imatwmnh_ahr", "name") values (1, 1, 'event_name1');
insert into hyhmt_imfj (hyhmt_ahr , "imatwmnh_ahr", "name") values (2, 2, 'event_name2');
insert into hyhmt_imfj (hyhmt_ahr , "imatwmnh_ahr", "name") values (3, 0, 'event_name3');

select event.hyhmt_ahr, instance.imatwmnh_ahr, svc.ayn_ahr
from hyhmt_imfj event
left outer join imatwmnh_imfj instance on event.imatwmnh_ahr = instance.imatwmnh_ahr
left outer join ayn_imfj svc on instance.ayn_ahr = svc.ayn_ahr
where svc.ayn_ahr = 1;

select event.hyhmt_ahr, instance.imatwmnh_ahr, svc.ayn_ahr
from hyhmt_imfj event
join imatwmnh_imfj instance on event.imatwmnh_ahr = instance.imatwmnh_ahr
join ayn_imfj svc on instance.ayn_ahr = svc.ayn_ahr
where svc.ayn_ahr = 1;

select event.hyhmt_ahr, instance.imatwmnh_ahr, svc.ayn_ahr
from hyhmt_imfj event
right outer join imatwmnh_imfj instance on event.imatwmnh_ahr = instance.imatwmnh_ahr
right outer join ayn_imfj svc on instance.ayn_ahr = svc.ayn_ahr
where svc.ayn_ahr = 1;

drop table hyhmt_imfj;
drop table imatwmnh_imfj;
drop table ayn_imfj;


