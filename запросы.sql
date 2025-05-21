--Описание запроса: вывести всю информацию о клиентах с общим кол-вом счетов (count_account) и отсортировать по customer_id
--SQL запрос
SELECT DISTINCT Customer.customer_id, Customer.customer_first_name, Customer.customer_last_name, Customer.dob, Customer.mobile_no,
       COUNT(Account.account_id) OVER(PARTITION BY Customer.customer_id) count_account
FROM Customer
JOIN Account ON Customer.customer_id = Account.customer_id
ORDER BY Customer.customer_id


--Описание запроса: найти клиента со счетом типа "Сберегательный". Вывести customer_id, account_id, customer_first_name, customer_last_name
--SQL запрос
SELECT Customer.customer_id, Account.account_id, Customer.customer_first_name, Customer.customer_last_name
FROM Customer
JOIN Account ON Customer.customer_id = Account.customer_id
WHERE account_type = 'Сберегательный'

--Описание запроса: вывести имена клиентов которые сделали погашения кредита. Вывести customer_id, customer_first_name, account_id. Отсортировать по account_id
--SQL запрос
WITH r AS(SELECT  Customer.customer_id, Customer.customer_first_name, Account.account_id,
                  Monetary_Transactions.transaction_type
FROM Customer
LEFT OUTER JOIN Account ON Customer.customer_id = Account.customer_id
LEFT OUTER JOIN Monetary_Transactions ON Monetary_Transactions.account_id = Account.account_id
WHERE Monetary_Transactions.transaction_type = 'Кредит'
ORDER BY Account.account_id)

Select  DISTINCT customer_id, customer_first_name, account_id
from r
ORDER BY account_id


--Описание запроса: найти общую сумму сбережений (amount_money) на счету у каждого пользователя, а также кол-во счета. Вывести account_id, customer_first_name, customer_last_name, customer_id.
--SQL запрос
SELECT DISTINCT customer.customer_id, customer.customer_first_name, customer.customer_last_name, 
       SUM(account.account_balance) OVER(PARTITION BY customer.customer_id) amount_money,
	   COUNT(Account.account_id) OVER(PARTITION BY customer.customer_id)
FROM account
JOIN customer ON account.customer_id = customer.customer_id
ORDER BY Customer.customer_id

--Описание запроса: найти средний возрас клиентов, кототорые оформляют кредит. Вывести account_id, customer_first_name, customer_last_name,age,  avg_age
--SQL запрос
WITH t_age AS(SELECT account.account_id, customer.customer_first_name, customer.customer_last_name, date_part('year',age(dob::date)) age
from customer
JOIN account ON account.customer_id = customer.customer_id),

t_avg_age AS(SELECT t_age.account_id, t_age.customer_first_name, t_age.customer_last_name, t_age.age, loan.loan_id,
       AVG(t_age.age) OVER() avg_age
from t_age
JOIN loan ON loan.account_id = t_age.account_id
)

SELECT customer_first_name, customer_last_name, age, ROUND(avg_age::numeric , 0) avg_age
from t_avg_age 













