--modeling gyeonggi-do dataset

--make a table to import the population data
drop table if exists gyunggi_2059;

create table gyunggi_2059 (
	region text,
	population INTEGER
);
