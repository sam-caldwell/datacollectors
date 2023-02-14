create extension if not exists postgres_fdw
    schema pg_catalog
    version '1.1';

comment on extension postgres_fdw is 'postgresql foreign data wrapper (FDW)';