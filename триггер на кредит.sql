-- ФУНКЦИЯ: изменяет значение в столбце remaining_amount таблицы loan и добавление записи в Transaction и изменение баланса в таблице Account
CREATE OR REPLACE FUNCTION update_remaining_amount()
RETURNS TRIGGER AS $$
BEGIN
     UPDATE loan 
	 SET remaining_amount = remaining_amount - NEW.amount
	 WHERE loan_id = NEW.loan_id;
	 
     UPDATE Account
	 SET account_balance = account_balance - NEW.amount
	 WHERE account_id = (select Account.account_id
	 from loan
	 JOIN Account ON Account.account_id = loan.account_id
	 WHERE loan_id = NEW.loan_id); 
	 
	 INSERT INTO Monetary_Transactions (transaction_type, amount, account_id)
     VALUES 
     ('Кредит', NEW.amount,(Select account_id FROM loan WHERE loan_id = NEW.loan_id));
	  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ТРИГГЕР: триггер на добавление новой строки в таблицу loan_payment
CREATE TRIGGER insert_loan_payment
AFTER INSERT ON loan_payment
FOR EACH ROW
EXECUTE FUNCTION update_remaining_amount();

-- ПРОВЕРКА РАБОТЫ 
INSERT INTO Loan_Payment (amount, loan_id)
VALUES 
(50000, 402)

--УДАЛЕНИЕ ТРИГГЕРА
DROP TRIGGER insert_loan_payment ON loan_payment;