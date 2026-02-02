--validation using SQL

--To know all the types of columns 
pragma table_info(academy_info);

--count the number of rows
SELECT
	count(*) as num_rows
from academy_info;

--find the null value in major columns
SELECT
	sum(case when 학원명 is null or trim(학원명) = '' then 1 else 0 end) as null_name,
	sum(case when 시도교육청명 is null or trim(시도교육청명) = '' then 1 else 0 end) as null_sido,
	sum(case when 등록상태명 is null or trim(등록상태명) = '' then 1 else 0 end) as null_enroll,
	sum(case when 분야명 is null or trim(분야명) = '' then 1 else 0 end) as null_subject
from academy_info;

--check currently not operates academy status
SELECT 
	count(*)
from academy_info
where 휴원시작일자 is not null
	and 휴원종료일자 is not NULL
	and 휴원시작일자 > 휴원종료일자;

-- To find out the number of current non-running academies
SELECT
	count(*) as num_휴원
from academy_info
WHERE 휴원시작일자 is not NULL
	and 휴원시작일자 <=20260202
	and (휴원종료일자 is null or 휴원종료일자 >= 20260202);

