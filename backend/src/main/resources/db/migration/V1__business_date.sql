-- The bank's single business date (ADR 0006). Exactly one row; advanced only by EOD.
create table business_date (
    id            smallint primary key default 1 check (id = 1),
    business_date date not null,
    eod_running   boolean not null default false
);

insert into business_date (business_date) values (current_date);
