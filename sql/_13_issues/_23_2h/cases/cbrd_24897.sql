-- This issue verifies CBRD-24897.
-- Query rewriter can lose parent paths of a name in qo_collect_name_spec().
-- Rewritten query should include commented phrase. 

-- au.grantee.[name]
select /*+ recompile */ sum (set {[au].[class_of]}) from [_db_auth] as [au] where {[au].[grantee].[name]} subseteq (select set {current_user});

-- au.grantee.[name]
select /*+ recompile */ sum (set {[au].[class_of]}) from [_db_auth] as [au] where {[au].[grantee].[name]} subseteq (select set {current_user}) and au.auth_type= 'SELECT';

-- c.[owner].[name]
select /*+ recompile */ count (*) from _db_class c where c.owner.name = 'DBA' and class_type = 0 using index none;

-- c.class_name
select /*+ recompile */ count (*) from _db_class c where nvl (c.class_name, '') = '_db_class' and class_type = 0 using index none;

-- c.[owner].[name]
select /*+ recompile */ count (*) from _db_class c where {c.owner.name} = {'DBA'} and class_type = 0 using index none;

-- c.[owner].[name]
select /*+ recompile */ count (*) from _db_class c where nvl (c.owner.name, '') = 'DBA' and class_type = 0 using index none;

-- t.a.attr_name
select /*+ recompile */ count (*) from _db_class c, table (c.inst_attrs) t (a) where nvl (t.a.attr_name, '') = 'class_name' and class_type = 0 using index none;
