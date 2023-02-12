create extension if not exists pllua
    schema pg_catalog
    version '2.0';
comment on extension if not exists pllua is 'PL/Lua (trusted) procedural language';

create extension if not exists hstore
    schema pg_catalog
    version '1.7';
comment on extension hstore is 'PL/hstore extension';

create extension if not exists hstore_pllua -- for hstore type in pllua
    schema pg_catalog
    version '1.0';
comment on extension pllua is 'PL/Lua (trusted) Hstore type language';
-- postgresql-14-pllua - Lua procedural language for PostgreSQL 14
