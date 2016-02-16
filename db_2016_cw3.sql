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
SELECT monarch.house, COUNT(	SELECT monarch.house
				FROM monarch
				WHERE accession <= 1700-12-31
				AND accession >= 1601-01-01
				) AS seventeenth,
COUNT(	SELECT monarch.house
	FROM monarch
	WHERE accession <= 1800-12-31
	AND accession >= 1701-01-01
	) AS eighteenth,
COUNT(	SELECT monarch.house
	FORM monarch
	WHERE accession <= 1900-12-31
	AND accession >= 1801-01-01
	) AS nineteenth,
COUNT(	SELECT monarch.house
	FROM monarch
	WHERE accession <= 2000-12-31
	AND accession >= 1901-01-01
	) AS twentieth
FROM monarch
GROUP BY house
ORDER BY house
; 

-- Q4 returns (name,age)

;

-- Q5 returns (father,child,born)

;

-- Q6 returns (monarch,prime_minister)

;

