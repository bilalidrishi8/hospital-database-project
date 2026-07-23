CREATE TABLE hospital (
    appointment_id TEXT,
    patient_id TEXT,
    doctor_id TEXT,
    appointment_date TEXT,
    appointment_time TEXT,
    department TEXT,
    appointment_status TEXT,
    consultation_fee TEXT,
    payment_status TEXT
);

SELECT * FROM hospital
SELECT count(*) FROM hospital


-- 1. Find the total number of appointments for each doctor.
SELECT * FROM hospital

SELECT doctor_id, COUNT(*) AS total_appointments
FROM hospital
GROUP BY doctor_id
ORDER BY total_appointments DESC;

-- 2. Find doctors who handled more than 50 appointments.
SELECT * FROM hospital

SELECT doctor_id, COUNT(*) AS appointments
FROM hospital
GROUP BY doctor_id
HAVING COUNT(*) > 50;

-- 3. Find total consultation fees collected by each department.
SELECT * FROM hospital

SELECT department,
SUM(consultation_fee) AS total_revenue
FROM hospital
GROUP BY department
ORDER BY total_revenue DESC;



-- 4. Count appointments by status.
SELECT * FROM hospital

SELECT appointment_status,
COUNT(*) AS total
FROM  hospital
GROUP BY appointment_status;

-- 5. Find the average consultation fee by department.
SELECT * FROM hospital

SELECT department,
ROUND(AVG(consultation_fee),2) AS avg_fee
FROM hospital
GROUP BY department;

SELECT department,
ROUND(COUNT(consultation_fee),2) AS avg_fee
FROM hospital
GROUP BY department;

-- 6. Find appointments scheduled today.
SELECT * FROM hospital

SELECT *
FROM hospital
WHERE appointment_date = CURRENT_DATE;

-- 7. Find the top 10 highest consultation fees.
SELECT * FROM hospital

SELECT *
FROM hospital
ORDER BY consultation_fee DESC
LIMIT 10;

-- 8. Find patients with multiple appointments.
SELECT * FROM hospital

SELECT patient_id,
COUNT(*) AS total_visits
FROM hospital
GROUP BY patient_id
HAVING COUNT(*) > 1;

-- 9. Find departments with the highest number of appointments.
SELECT * FROM hospital

SELECT department,
COUNT(*) AS appointments
FROM hospital
GROUP BY department
ORDER BY appointments DESC;

-- 10. Find unpaid appointments.
SELECT * FROM hospital

-- ONE METHOD --

SELECT distinct payment_status
FROM hospital

-- SECOND METHOD -- 

SELECT patient_id,
    doctor_id,
COUNT(payment_status) AS unpaid_appointments
FROM hospital
WHERE payment_status = 'Scheduled'
GROUP BY patient_id, doctor_id
ORDER BY unpaid_appointments DESC

-- THIRD METHOD -- 

SELECT *  
FROM hospital
WHERE payment_status = 'Scheduled'

-- 11. Rank doctors based on appointments.
SELECT * FROM hospital

SELECT doctor_id,
COUNT(*) AS total_appointments,
RANK() OVER(ORDER BY COUNT(*) DESC) AS doctor_rank
FROM hospital
GROUP BY doctor_id;
-- 12. Find the running total of consultation fees.
SELECT * FROM hospital

SELECT appointment_date,
consultation_fee,
COUNT(consultation_fee)
OVER(ORDER BY appointment_date) AS running_total
FROM hospital;

-- 13. Find the busiest day.
SELECT * FROM hospital

SELECT appointment_date,
COUNT(*) AS appointments
FROM hospital
GROUP BY appointment_date
ORDER BY appointments DESC
LIMIT 1;
-- 14. Find each department's percentage contribution to total revenue.
SELECT * FROM hospital

SELECT department,
ROUND(
COUNT(consultation_fee)*100.0/
COUNT(COUNT(consultation_fee)) OVER(),
2
) AS revenue_percentage
FROM hospital
GROUP BY department;

-- 15. Find the second highest consultation fee.
SELECT * FROM hospital

SELECT DISTINCT consultation_fee
FROM hospital
ORDER BY consultation_fee DESC
OFFSET 1
LIMIT 1;

-- 16. Find appointments where the consultation fee is above the department average.
SELECT * FROM hospital

SELECT *
FROM hospital a
WHERE consultation_fee >
(
    SELECT AVG(consultation_fee)
    FROM hospital b
    WHERE a.department = b.department
);
--------------                 --------------

SELECT *
FROM hospital a
WHERE consultation_fee >
(
SELECT count(consultation_fee)
FROM hospital b
WHERE a.department=b.department
);
-- 17. Find the doctor generating the highest revenue.
SELECT * FROM hospital

SELECT doctor_id,
count(consultation_fee) AS highest_revenue
FROM hospital
GROUP BY doctor_id
ORDER BY highest_revenue DESC
LIMIT 1;

-- 18. Find each patient's latest appointment.
SELECT * FROM hospital

SELECT
    patient_id,
    MAX(appointment_date::DATE) AS latest_appointment
FROM hospital
GROUP BY patient_id
ORDER BY patient_id;

--------------                 --------------

SELECT *
FROM
(
SELECT *,
ROW_NUMBER() OVER
(PARTITION BY patient_id
ORDER BY appointment_date DESC) rn
FROM hospital
)t
WHERE rn=1;
-- 19. Find the revenue generated each month.
SELECT * FROM hospital

SELECT appointment_date,
DATE_TRUNC('month',appointment_date) AS month,
COUNT(consultation_fee) AS revenue
FROM hospital
GROUP BY appointment_date
ORDER BY month;

--------------                 --------------

SELECT
    TO_CHAR(DATE_TRUNC('month', appointment_date), 'YYYY-MM') AS month,
    COUNT(payment_amount) AS total_revenue
FROM hospital
WHERE appointment_status = 'Completed'
GROUP BY DATE_TRUNC('month', appointment_date)
ORDER BY DATE_TRUNC('month', appointment_date);

-- 20. Find the top 3 doctors in each department by appointment count.
SELECT * FROM hospital

SELECT *
FROM
(
SELECT
department,
doctor_id,
COUNT(*) AS total_appointments,
DENSE_RANK() OVER
(
PARTITION BY department
ORDER BY COUNT(*) DESC
) AS ranking
FROM hospital
GROUP BY department,doctor_id
)t
WHERE ranking<=3;

--END THE PROJECT--
