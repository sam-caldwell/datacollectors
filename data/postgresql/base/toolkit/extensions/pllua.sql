create extension pllua
    schema pg_catalog
    version '2.0';
comment on extension pllua is 'PL/Lua (trusted) procedural language';

create extension hstore
    schema pg_catalog
    version '1.7';
comment on extension hstore is 'PL/hstore extension';

create extension hstore_pllua -- for hstore type in pllua
    schema pg_catalog
    version '1.0';
comment on extension pllua is 'PL/Lua (trusted) Hstore type language';
-- postgresql-14-pllua - Lua procedural language for PostgreSQL 14
