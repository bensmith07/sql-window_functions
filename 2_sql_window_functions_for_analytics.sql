###############################################################
###############################################################
-- Guided Project: SQL Window Functions for Analytics
###############################################################
###############################################################

use wind_func_proj_db;

#############################
-- Task One: Getting Started
-- In this task, we will get started with the project
-- by retrieving all the data in the projectdb database
#############################

-- 1.1: Retrieve all the data in the projectdb database
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM regions;
SELECT * FROM customers;
SELECT * FROM sales;

#############################
-- Task Two: Window Functions - Refresher
-- In this task, we will refresh our understanding
-- of using window functions in SQL
#############################

-- 2.1: Retrieve a list of employee_id, first_name, hire_date, 
-- and department of all employees ordered by the hire date
SELECT employee_id
       , first_name
       , department
       , hire_date
       , ROW_NUMBER() OVER (ORDER BY hire_date) AS row_num
  FROM employees;

#############################
-- Task Three: Ranking
-- In this task, we will learn how to rank the
-- rows of a result set
#############################

-- 3.1: Recall the use of ROW_NUMBER()
SELECT first_name
       , email
       , department
       , salary
       , ROW_NUMBER() OVER(PARTITION BY department
						   ORDER BY salary DESC
						  )
  FROM employees;

-- 3.2: Let's use the RANK() function

-- Exercise 3.1: Retrieve the hire_date. Return details of
-- employees hired on or before 31st Dec, 2005 and are in
-- First Aid, Movies and Computers departments 
	
SELECT employee_id
	   , department
	   , salary
	   , hire_date
	   , RANK() OVER(
					 PARTITION BY department
					 ORDER BY salary DESC
					) 
					 AS dept_salary_rank
  FROM employees
  WHERE hire_date <=  '2005-12-31'
	AND department IN (
						 'First Aid'
					   , 'Movies'
					   , 'Computers'
					  )

-- 3.3: Return the fifth ranked salary for each department

WITH dept_salary_ranks AS (
						   SELECT employee_id
								  , department
                                  , salary
                                  , RANK() OVER(
												PARTITION BY department
                                                ORDER BY salary DESC
											   )
										AS dept_salary_rank
						     FROM employees
						  )
	SELECT employee_id
          , department
          , salary
          , dept_salary_rank
	  FROM dept_salary_ranks
      WHERE dept_salary_rank = 5
;

#############################
-- Task Four: Paging: NTILE()
-- In this task, we will learn how break/page
-- the result set into groups
#############################

-- 4.1: Group the employees table into five groups
-- based on the order of their salaries


-- 4.2: Group the employees table into five groups for 
-- each department based on the order of their salaries
SELECT first_name
       , email
       , department
       , salary
       , NTILE(5) OVER(PARTITION BY department
			           ORDER BY salary DESC
					  )
  FROM employees
;

-- Create a CTE that returns details of an employee
-- and group the employees into five groups
-- based on the order of their salaries
WITH salary_ranks AS (
					  SELECT first_name
							 , email
                             , department
                             , salary
                             ,NTILE(5) OVER(ORDER BY salary DESC) AS rank_of_salary
						 FROM employees
					 )
-- 4.3: Find the average salary for each group of employees
  SELECT rank_of_salary, AVG(salary)
    FROM salary_ranks
    GROUP BY rank_of_salary
;

#############################
-- Task Five: Aggregate Window Functions - Part One
-- In this task, we will learn how to use
-- aggregate window functions in SQL
#############################

-- 5.1: This returns how many employees are in each department
SELECT department
	   , COUNT(*) AS dept_count
  FROM employees
  GROUP BY department
  ORDER BY department;

-- 5.2: Retrieve the first names, department and 
-- number of employees working in that department
SELECT first_name
       , department
       , (SELECT COUNT(*) AS dept_count 
            FROM employees e1 
            WHERE e1.department = e2.department
		 )
  FROM employees e2
  GROUP BY department
           , first_name
  ORDER BY department
;

-- The solution with Window Functions

SELECT first_name
	   , department
       , COUNT(*) OVER(PARTITION BY department)
  FROM employees
;

-- 5.3: Total Salary for all employees
SELECT employee_id
	   , SUM(salary) OVER() AS total_salary
  FROM employees
;

-- 5.4: Total Salary for each department
SELECT employee_id
       , department
       , SUM(salary) 
		   OVER(PARTITION BY department)
           AS dept_total_salary
  FROM employees
;

-- Exercise 5.1: Running Total Salary for each department and
-- order by the hire date. Call the new column running_total
SELECT first_name
       , hire_date
       , department
       , salary
       , SUM(salary)
           OVER(PARTITION BY department
                ORDER BY hire_date
			   )
		   AS dept_running_total_salary
  FROM employees
;

#############################
-- Task Six: Aggregate Window Functions - Part Two
-- In this task, we will learn how to use
-- aggregate window functions in SQL
#############################

-- 6.1: Retrieve the first names, department and 
-- number of employees working in that department and region

SELECT first_name
       , department
       , region_id
       , COUNT(*) 
           OVER(PARTITION BY department
                             , region_id
			    )
		   AS n_employees
  FROM employees
;

-- Exercise 6.1: Retrieve the first names, department and 
-- number of employees working in that department and in region 2
SELECT first_name
       , department
       , COUNT(*)
           OVER(PARTITION BY department)
		   AS n_employees
  FROM employees
  WHERE region_id = 2
;

-- vvvvvvvvvvvvvvvvv --















-- Create a common table expression to retrieve the customer_id, 
-- ship_mode, and how many times the customer has purchased from the mall
WITH purchase_count AS (
SELECT customer_id, ship_mode, COUNT(sales) AS purchase
FROM sales
GROUP BY customer_id, ship_mode
ORDER BY purchase DESC
)

-- Exercise 6.2: Calculate the cumulative sum of customers purchase
-- for the different ship mode
SELECT customer_id, ship_mode, purchase, 
___(___) OVER(___ ___
				   ORDER BY customer_id ASC) AS sum_of_sales
FROM purchase_count;


#############################
-- Task Seven: Window Frames - Part One
-- In this task, we will learn how to
-- order data in window frames in the result set
#############################

-- 7.1: Calculate the running total of salary

-- Retrieve the first_name, hire_date, salary
-- of all employees ordered by the hire date
SELECT first_name, hire_date, salary
FROM employees
ORDER BY hire_date;

-- The solution


-- 7.2: Add the current row and previous row


-- 7.3: Find the running average


-- What do you think the result of the query will be?
SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date 
				 ROWS BETWEEN
				 3 PRECEDING AND CURRENT ROW) AS running_total
FROM employees;

#############################
-- Task Eight: Window Frames - Part Two
-- In this task, we will learn how to
-- order data in window frames in the result set
#############################

-- 8.1: Review of the FIRST_VALUE() function
SELECT department, division,
FIRST_VALUE(department) OVER(ORDER BY department ASC) first_department
FROM departments;

-- 8.2: Retrieve the last department in the departments table


-- Create a common table expression to retrieve the customer_id, 
-- ship_mode, and how many times the customer has purchased from the mall
WITH purchase_count AS (
SELECT customer_id, COUNT(sales) AS purchase
FROM sales
GROUP BY customer_id
ORDER BY purchase DESC
)

-- What do you think this will return?
SELECT customer_id, purchase, 
MAX(purchase) OVER(ORDER BY customer_id ASC) AS max_of_sales,
MAX(purchase) OVER(ORDER BY customer_id ASC
				  ROWS BETWEEN
				  CURRENT ROW AND 1 FOLLOWING) AS next_max_of_sales
FROM purchase_count;

#############################
-- Task Nine: GROUPING SETS, ROLLUP() & CUBE()
-- In this task, we will learn how the GROUPING SETS, 
-- ROLLUP, and CUBE clauses work in SQL
#############################

-- 9.1: Find the sum of the quantity for different ship modes
SELECT ship_mode, SUM(quantity) 
FROM sales
GROUP BY ship_mode;

-- 9.2: Find the sum of the quantity for different categories
SELECT category, SUM(quantity) 
FROM sales
GROUP BY category;

-- 9.3: Find the sum of the quantity for different subcategories
SELECT sub_category, SUM(quantity) 
FROM sales
GROUP BY sub_category;

-- 9.4: Use the GROUPING SETS clause


--9.5: Use the ROLLUP clause


--9.6: Use the CUBE clause