--+ holdcas on;
drop table if exists `posts`;
CREATE TABLE `posts` (
  `id` int  NOT NULL AUTO_INCREMENT,
  `members_id` int  NOT NULL DEFAULT '0',
  `countries_id` int  NOT NULL DEFAULT '0',
  `cities_id` int NOT NULL DEFAULT '0',
  `categories_id` int NOT NULL DEFAULT '0',
  `subcategories_id` int  NOT NULL DEFAULT '0',
  `location` varchar(255) NOT NULL DEFAULT '',
  `price` int  NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '0',
  `hide_email` smallint NOT NULL DEFAULT '0',
  `phone` varchar(255) NOT NULL DEFAULT '',
  `date` date NOT NULL DEFAULT '0000-00-00',
  `post_count` int  NOT NULL DEFAULT '0',
  `active` smallint NOT NULL DEFAULT '0',
  `violation` int NOT NULL DEFAULT '0',
  `record_insert_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `record_posted_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `record_update_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `record_inserted_by` int  NOT NULL DEFAULT '0',
  `record_updated_by` int  NOT NULL DEFAULT '0',
  `record_deleted_by` int  NOT NULL DEFAULT '0',
  `record_delete_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `record_expiration_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deleted_by_member` int  NOT NULL DEFAULT '0',
  `number_of_times_reposted` int  NOT NULL DEFAULT '0',
  `mv_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `index_posts_members_id` (`members_id`),
  KEY `idx_del_exp_date` (`deleted_by_member`,`record_expiration_date`),
  KEY `rec_ins_dt_idx` (`record_insert_date`),
  KEY `rec_posted_dt_idx` (`record_posted_date`),
  KEY `rec_exp_dt_idx` (`record_expiration_date`),
  KEY `rec_del_dt_idx` (`record_delete_date`),
  KEY `idx_rec_upd_dt` (`record_update_date`),
  KEY `mv_ts` (`mv_ts`)
) ;
insert into `posts`(`id`) select rownum from db_root connect by level<=1672;
set @yp0=16724,@yp1=16724,@yp2=16724,@yp3=16724,@yp4=16724,@yp5=16724,@yp6='a',@yp7=16724,@yp8='a',@yp9='a',@yp10=16724,@yp11='a';
set @yp12=now(),@yp13=16724,@yp14=16724,@yp15=16724,@yp16=now(),@yp17=now(),@yp18=now();
UPDATE `posts` SET `id`=@yp0, `members_id`=@yp1,
`countries_id`=@yp2, `cities_id`=@yp3, `categories_id`=@yp4,
`subcategories_id`=@yp5, `location`=@yp6, `price`=@yp7, `title`=@yp8,
`description`=@yp9, `hide_email`=@yp10, `phone`=@yp11, `date`=@yp12,
`post_count`=@yp13, `active`=@yp14, `violation`=@yp15,
`record_insert_date`=@yp16, `record_posted_date`=@yp17,
`record_update_date`=@yp18, `record_inserted_by`=16724,
`record_updated_by`=16724, `record_deleted_by`=16724,
`record_delete_date`=now(), `record_expiration_date`=now(),
`deleted_by_member`=16724, `number_of_times_reposted`=16724 WHERE `posts`.`id`='1671';
--select * from `posts` where `posts`.`id`=16724;
select if(current_timestamp-`mv_ts`>=0 and current_timestamp-`mv_ts`<10,'ok','nok') from `posts` where `posts`.`id`=16724;
drop variable @yp0,@yp1,@yp2,@yp3,@yp4,@yp5,@yp6,@yp7,@yp8,@yp9;
drop variable @yp10,@yp11,@yp12,@yp13,@yp14,@yp15,@yp16,@yp17,@yp18,@yp19;
drop variable @y;
drop table if exists `posts`;

--+ holdcas off;
