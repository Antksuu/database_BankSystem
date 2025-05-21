--ФУНКЦИЯ: добавляет в таблицу новую строку о транзакции Monetary_Transactions
CREATE OR REPLACE FUNCTION insert_monetary_transactions()
RETURNS TRIGGER AS $$
BEGIN
      INSERT INTO Monetary_Transactions (transaction_type, amount, account_id)
     VALUES 
     ('Дебет', NEW.account_balance - OLD.account_balance, NEW.account_id);
	  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ТРИГГЕР: триггер на изменения колонки account_balance
CREATE TRIGGER update_account_balance
AFTER UPDATE ON Account
FOR EACH ROW
EXECUTE FUNCTION insert_monetary_transactions();


-- ПРОВЕРКА РАБОТЫ (клиенту со счетом 1003 добавили сумму 20500)
UPDATE Account 
SET account_balance = account_balance + 20500
WHERE account_id = 1003;

--УДАЛЕНИЕ ТРИГГЕРА
DROP TRIGGER update_account_balance ON Account;