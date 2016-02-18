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

--Need a 'calculate_age' function, and union with mothers.

SELECT 	parent.name
FROM 	person AS child1, person AS parent 
WHERE	child1.father = parent.name
AND 	child1.dob<=ALL	(SELECT dob
			FROM person AS child2
			WHERE child2.father = parent.name
			)
;

-- Q5 returns (father,child,born)
SELECT 	dad.name AS father, child.name AS child, 
	RANK() OVER (PARTITION BY child.father ORDER BY child.dob) AS born
FROM person AS dad JOIN person AS child ON dad.name = child.father
;

-- Q6 returns (monarch,prime_minister)

;

