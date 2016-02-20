-- Q1 returns (first_name)
SELECT	CASE
	WHEN POSITION(' ' IN person.name) = 0
	THEN person.name
	ELSE SUBSTRING(person.name FROM 1 FOR (POSITION(' ' IN person.name) -1))
	END AS first_name
FROM person
ORDER BY first_name ASC
;

-- Q2 returns (born_in,popularity)
SELECT person.born_in, COUNT(person.born_in) AS popularity
FROM person
GROUP BY person.born_in
ORDER BY popularity DESC
;

-- Q3 returns (house,seventeenth,eighteenth,nineteenth,twentieth)
SELECT 	monarch.house, 
	COUNT(CASE WHEN accession <= '1700-12-31'
	AND accession >= '1601-01-01'
	THEN monarch.name ELSE NULL END) AS seventeenth,
	COUNT(CASE WHEN accession <= '1800-12-31'
	AND accession >= '1701-01-01'
	THEN monarch.name ELSE NULL END) AS eighteenth,
	COUNT(CASE WHEN accession <= '1900-12-31'
	AND accession >= '1801-01-01'
	THEN monarch.name ELSE NULL END) AS nineteenth,
	COUNT(CASE WHEN accession <= '2000-12-31'
	AND accession >= '1901-01-01'
	THEN monarch.name ELSE NULL END) AS twentieth
FROM monarch
WHERE monarch.house IS NOT NULL
GROUP BY house
ORDER BY house ASC
; 


-- Q4 returns (name,age)
SELECT 	dad.name,
	DATE_PART('year', AGE(child1.dob, dad.dob)) AS age
FROM 	person AS child1, person AS dad
WHERE	child1.father = dad.name
AND 	child1.dob<=ALL	(SELECT dob
			FROM person AS child2
			WHERE child2.father = dad.name
			)
UNION
SELECT 	mum.name,
	DATE_PART('year', AGE(child1.dob, mum.dob)) AS age
FROM 	person AS child1, person AS mum
WHERE	child1.mother = mum.name
AND 	child1.dob<=ALL (SELECT dob
			FROM person AS child2
			WHERE child2.mother = mum.name
			)
ORDER BY name
;

-- Q5 returns (father,child,born)
SELECT 	dad.name AS father, child.name AS child, 
	CASE WHEN child.name IS NULL THEN NULL
	     ELSE RANK() OVER (PARTITION BY child.father ORDER BY child.dob) 
	     END AS born
FROM person AS dad LEFT JOIN person AS child 
	ON dad.name = child.father
WHERE dad.gender = 'M'
ORDER BY father, born
;

-- Q6 returns (monarch,prime_minister)

--CREATE TEMP TABLE pastPMs AS
SELECT 	pm1.name AS prime_minister,
	pm1.entry,
	pm2.entry AS departure
FROM 	prime_minister AS pm1 LEFT JOIN prime_minister AS pm2
ON 	pm2.entry > pm1.entry
WHERE 	pm2.entry<= ALL(SELECT pm3.entry
			FROM prime_minister AS pm3
			WHERE pm3.entry::DATE > pm1.entry::DATE
			)
ORDER BY pm1.entry DESC
;

--CREATE TEMP TABLE pastMons AS
SELECT 	mon1.name AS monarch,
	mon1.accession,
	mon2.accession AS deccession
FROM 	monarch AS mon1 LEFT JOIN monarch AS mon2
ON 	mon2.accession > mon1.accession
WHERE 	mon2.accession <= ALL(	SELECT mon3.accession
				FROM monarch AS mon3
				WHERE mon3.accession > mon1.accession
				)
ORDER BY mon1.accession DESC
