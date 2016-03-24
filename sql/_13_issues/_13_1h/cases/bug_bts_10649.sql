create table t1 (i1 int, s_upper varchar collate iso88591_bin, s_lower varchar collate iso88591_bin);



insert into t1 values (65, chr (65 using iso88591), chr (97 using iso88591));
insert into t1 values (66, chr (66 using iso88591), chr (98 using iso88591));
insert into t1 values (67, chr (67 using iso88591), chr (99 using iso88591));
insert into t1 values (68, chr (68 using iso88591), chr (100 using iso88591));
insert into t1 values (69, chr (69 using iso88591), chr (101 using iso88591));
insert into t1 values (70, chr (70 using iso88591), chr (102 using iso88591));
insert into t1 values (71, chr (71 using iso88591), chr (103 using iso88591));
insert into t1 values (72, chr (72 using iso88591), chr (104 using iso88591));
insert into t1 values (73, chr (73 using iso88591), chr (105 using iso88591));
insert into t1 values (74, chr (74 using iso88591), chr (106 using iso88591));
insert into t1 values (75, chr (75 using iso88591), chr (107 using iso88591));
insert into t1 values (76, chr (76 using iso88591), chr (108 using iso88591));
insert into t1 values (77, chr (77 using iso88591), chr (109 using iso88591));
insert into t1 values (78, chr (78 using iso88591), chr (110 using iso88591));
insert into t1 values (79, chr (79 using iso88591), chr (111 using iso88591));
insert into t1 values (80, chr (80 using iso88591), chr (112 using iso88591));
insert into t1 values (81, chr (81 using iso88591), chr (113 using iso88591));
insert into t1 values (82, chr (82 using iso88591), chr (114 using iso88591));
insert into t1 values (83, chr (83 using iso88591), chr (115 using iso88591));
insert into t1 values (84, chr (84 using iso88591), chr (116 using iso88591));
insert into t1 values (85, chr (85 using iso88591), chr (117 using iso88591));
insert into t1 values (86, chr (86 using iso88591), chr (118 using iso88591));
insert into t1 values (87, chr (87 using iso88591), chr (119 using iso88591));
insert into t1 values (88, chr (88 using iso88591), chr (120 using iso88591));
insert into t1 values (89, chr (89 using iso88591), chr (121 using iso88591));
insert into t1 values (90, chr (90 using iso88591), chr (122 using iso88591));





insert into t1 values (192, chr (192 using iso88591), chr (224 using iso88591));
insert into t1 values (193, chr (193 using iso88591), chr (225 using iso88591));
insert into t1 values (194, chr (194 using iso88591), chr (226 using iso88591));
insert into t1 values (195, chr (195 using iso88591), chr (227 using iso88591));
insert into t1 values (196, chr (196 using iso88591), chr (228 using iso88591));
insert into t1 values (197, chr (197 using iso88591), chr (229 using iso88591));
insert into t1 values (198, chr (198 using iso88591), chr (230 using iso88591));
insert into t1 values (199, chr (199 using iso88591), chr (231 using iso88591));
insert into t1 values (200, chr (200 using iso88591), chr (232 using iso88591));
insert into t1 values (201, chr (201 using iso88591), chr (233 using iso88591));
insert into t1 values (202, chr (202 using iso88591), chr (234 using iso88591));
insert into t1 values (203, chr (203 using iso88591), chr (235 using iso88591));
insert into t1 values (204, chr (204 using iso88591), chr (236 using iso88591));
insert into t1 values (205, chr (205 using iso88591), chr (237 using iso88591));
insert into t1 values (206, chr (206 using iso88591), chr (238 using iso88591));
insert into t1 values (207, chr (207 using iso88591), chr (239 using iso88591));


insert into t1 values (208, chr (208 using iso88591), chr (240 using iso88591));
insert into t1 values (209, chr (209 using iso88591), chr (241 using iso88591));
insert into t1 values (210, chr (210 using iso88591), chr (242 using iso88591));
insert into t1 values (211, chr (211 using iso88591), chr (243 using iso88591));
insert into t1 values (212, chr (212 using iso88591), chr (244 using iso88591));
insert into t1 values (213, chr (213 using iso88591), chr (245 using iso88591));
insert into t1 values (214, chr (214 using iso88591), chr (246 using iso88591));
insert into t1 values (215, chr (215 using iso88591), chr (247 using iso88591));
insert into t1 values (216, chr (216 using iso88591), chr (248 using iso88591));
insert into t1 values (217, chr (217 using iso88591), chr (249 using iso88591));
insert into t1 values (218, chr (218 using iso88591), chr (250 using iso88591));
insert into t1 values (219, chr (219 using iso88591), chr (251 using iso88591));
insert into t1 values (220, chr (220 using iso88591), chr (252 using iso88591));
insert into t1 values (221, chr (221 using iso88591), chr (253 using iso88591));
insert into t1 values (222, chr (222 using iso88591), chr (254 using iso88591));
                            

-- only 215 should be the exception
select i1 from t1 where s_upper != upper (s_lower);
select i1 from t1 where s_lower != lower (s_upper);


create table t2 (i1 int, s_upper varchar collate iso88591_bin, s_lower varchar collate iso88591_bin);

insert into t2 select i1, concat ('10/10/1999 ', s_upper), concat ('DD/MM/YYYY "',s_lower,'"') from t1 where i1 != 215;

select to_date (s_upper, s_lower) from t2;


create table t3 (i1 int, s_lower varchar collate iso88591_bin, s_upper varchar collate iso88591_bin);

insert into t3 select i1, concat ('10:11 ', s_lower), concat ('HH24:MI "',s_upper,'"') from t1 where i1 != 215;

select to_time (s_lower, s_upper) from t3;

drop table t1;
drop table t2;
drop table t3;





