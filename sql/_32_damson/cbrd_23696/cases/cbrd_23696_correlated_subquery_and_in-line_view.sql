drop table if exists tb_rdrecord;
drop table if exists tb_rdfolder;

CREATE TABLE tb_rdfolder (folder_id CHARACTER VARYING(14) NOT NULL, record_center_id CHARACTER VARYING(7) NOT NULL, org_cd CHARACTER VARYING(7) NOT NULL, creat_yyyy CHARACTER VARYING(4) NOT NULL, CONSTRAINT pk_tb_rdfolder_folder_id PRIMARY KEY (folder_id), INDEX idx (record_center_id, org_cd), INDEX idx6 (record_center_id, creat_yyyy));
CREATE TABLE tb_rdrecord (record_id CHARACTER VARYING(14) NOT NULL, folder_id CHARACTER VARYING(14) NOT NULL, record_center_id CHARACTER VARYING(7) NOT NULL, orign_id CHARACTER VARYING(19), org_cd CHARACTER VARYING(7) NOT NULL, CONSTRAINT pk_tb_rdrecord_record_id PRIMARY KEY(record_id), INDEX idx1 (orign_id), INDEX idx4 (record_center_id, folder_id), INDEX idx3 (record_center_id, org_cd), INDEX idx5 (record_center_id, orign_id), CONSTRAINT fk FOREIGN KEY (folder_id) REFERENCES tb_rdfolder (folder_id) ON DELETE NO ACTION ON UPDATE NO ACTION);

insert into tb_rdfolder values('20200000127156', '0000001', 'abcd', '2019');
insert into tb_rdfolder values('20200000127157', '0000001', 'abcd', '2018');
insert into tb_rdfolder values('20200000127158', '0000001', 'abcd', '2018');
insert into tb_rdrecord values('20200007233326',      '20200000127156',      '0000001',             'OR20200511110061544',  'abcd'); 
insert into tb_rdrecord values('20200007233327',      '20200000127156',      '0000001',             'OR20200511110061544',  'abcd'); 
insert into tb_rdrecord values('20200007233328',      '20200000127157',      '0000001',             'OR20200511110061544',  'abcd'); 
insert into tb_rdrecord values('20200007233329',      '20200000127157',      '0000001',             'OR20200511110061545',  'abcd');

SELECT /*+ recompile */ E.record_center_id
FROM TB_RDRECORD R
, TB_RDFOLDER F
, (
SELECT G.record_center_id, G.org_cd, G.folder_id, G.record_id
FROM (
select Z.*, '2018' creat_yyyy, F.org_cd
from (
SELECT R.record_center_id, R.folder_id, R.record_id
FROM TB_RDRECORD R, TB_RDRECORD A
) Z
) G
GROUP BY G.record_center_id, G.org_cd, G.folder_id, G.record_id
) E
WHERE R.record_center_id = F.record_center_id
AND R.record_center_id = E.record_center_id
AND F.org_cd = E.org_cd
AND R.folder_id = F.folder_id
AND R.folder_id = E.folder_id
AND R.record_id = E.record_id
AND R.record_center_id = '0000001';

drop table tb_rdrecord;
drop table tb_rdfolder;

CREATE TABLE tb_rdfolder (folder_id CHARACTER VARYING(14) NOT NULL, record_center_id CHARACTER VARYING(7) NOT NULL, org_cd CHARACTER VARYING(7) NOT NULL, creat_yyyy CHARACTER VARYING(4) NOT NULL, CONSTRAINT pk_tb_rdfolder_folder_id PRIMARY KEY (folder_id), INDEX idx (record_center_id, org_cd), INDEX idx6 (record_center_id, creat_yyyy));
CREATE TABLE tb_rdrecord (record_id CHARACTER VARYING(14) NOT NULL, folder_id CHARACTER VARYING(14) NOT NULL, record_center_id CHARACTER VARYING(7) NOT NULL, orign_id CHARACTER VARYING(19), org_cd CHARACTER VARYING(7) NOT NULL, CONSTRAINT pk_tb_rdrecord_record_id PRIMARY KEY(record_id), INDEX idx1 (orign_id), INDEX idx4 (record_center_id, folder_id), INDEX idx3 (record_center_id, org_cd), INDEX idx5 (record_center_id, orign_id), CONSTRAINT fk FOREIGN KEY (folder_id) REFERENCES tb_rdfolder (folder_id) ON DELETE NO ACTION ON UPDATE NO ACTION);

insert into tb_rdfolder values('20200000127156', '0000001', 'abcd', '2019');
insert into tb_rdfolder values('20200000127157', '0000001', 'abcd', '2018');
insert into tb_rdfolder values('20200000127158', '0000001', 'abcd', '2018');
insert into tb_rdrecord values('20200007233326',      '20200000127156',      '0000001',             'OR20200511110061544',  'abcd'); 
insert into tb_rdrecord values('20200007233327',      '20200000127156',      '0000001',             'OR20200511110061544',  'abcd'); 
insert into tb_rdrecord values('20200007233328',      '20200000127157',      '0000001',             'OR20200511110061544',  'abcd'); 
insert into tb_rdrecord values('20200007233329',      '20200000127157',      '0000001',             'OR20200511110061545',  'abcd');

SELECT /*+ recompile */ E.record_center_id
FROM TB_RDRECORD R
, TB_RDFOLDER F
, (
SELECT G.record_center_id, G.org_cd, G.folder_id, G.record_id
FROM (
select Z.*, '2018' creat_yyyy, 'abcd' org_cd
from (
SELECT R.record_center_id, R.folder_id, R.record_id
FROM TB_RDRECORD R, TB_RDRECORD A
) Z
) G
GROUP BY G.record_center_id, G.org_cd, G.folder_id, G.record_id
) E
WHERE R.record_center_id = F.record_center_id
AND R.record_center_id = E.record_center_id
AND F.org_cd = E.org_cd
AND R.folder_id = F.folder_id
AND R.folder_id = E.folder_id
AND R.record_id = E.record_id
AND R.record_center_id = '0000001';

drop table tb_rdrecord;
drop table tb_rdfolder;

