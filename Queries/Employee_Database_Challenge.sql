-- Retrieve from employee table
SELECT e.emp_no,
	e.first_name,
	e.last_name
FROM employees as e;

-- Total no. of employees by title
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	ti.title
INTO total_emp
FROM employees as e
INNER JOIN titles as ti ON (e.emp_no = ti.emp_no);

SELECT COUNT (te.emp_no), te.title
FROM total_emp as te
GROUP BY te.title ORDER BY te.count DESC;

-- Retrieve from titles table
SELECT ti.title,
	ti.from_date,
	ti.to_date
FROM titles as ti;

-- Create a retirement title table
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no
;
	

-- Create Unique titles
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE rt.to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.to_date DESC;

-- Soon to retire employee count
SELECT COUNT(ut.emp_no), ut.title
--INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title ORDER BY ut.count DESC;

-- Create mentorship_eligibility table
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
	ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- Total no. of employees by department
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	de.dept_no,
	d.dept_name
INTO total_emp_dept
FROM employees as e
INNER JOIN dept_emp as de ON (e.emp_no = de.emp_no)
INNER JOIN departments as d ON (de.dept_no = d.dept_no);

SELECT COUNT (ted.emp_no), ted.dept_name
INTO total_emp_dept_count
FROM total_emp_dept as ted
GROUP BY ted.dept_name ORDER BY ted.count DESC;

-- Retiring employee per department
SELECT COUNT (ec.emp_no), d.dept_name
-- INTO total_emp_dept_count
FROM emp_count as ec
INNER JOIN departments as d
ON ec.dept_no = d.dept_no
GROUP BY ec.dept_name ORDER BY ec.count DESC;