use Bankloananalysis;


*1. Total loan applications *

	select count(id) as Total_loan_applications from financial_loan;

*2. MTD loan applications*
	
	select count(id) as MTD_loan_applications from financial_loan 
	where month(issue_date)=12;

*3. PMTD loan applications*
	
	select count(id) as PMTD_loan_applications from financial_loan 
	where month(issue_date)=11;

*4. total funded amount*

	SELECT SUM(loan_amount) AS Total_Funded_Amount FROM financial_loan;

*5. MTD total funded amount*
	select sum(loan_amount) as MTD_Funded_Amount from financial_loan 
	where month(issue_date)=12;

*6. PMTD total funded amount*
	select sum(loan_amount) as PMTD_Funded_Amount from financial_loan 
	where month(issue_date)=11;

*7. Total amount received*
	select sum(total_payment) as Total_amount_received from financial_loan;

*8. MTD Total amount received*
	select sum(total_payment) as MTD_Total_amount_received from financial_loan
	where month(last_payment_date)=12;

*9. PMTD Total amount received*
	select sum(total_payment) as MTD_Total_amount_received from financial_loan
	where month(last_payment_date)=11;

*10. Average interest rate*
	select AVG(int_rate)*100.0 as avg_interest_rate from financial_loan

*11. MTD Average interest rate*
	select AVG(int_rate)*100.0 as MTD_avg_interest_rate from financial_loan 
	where MONTH(issue_date) = 12;

*12. PMTD Average interest rate*
	select AVG(int_rate)*100.0 as PMTD_avg_interest_rate from financial_loan 
	where MONTH(issue_date) = 11;	

*13. avg debt to income ratio*
	select AVG(dti)*100.0 as Average_DTI from financial_loan;

*14. MTD avg debt to income ratio*
	select AVG(dti)*100.0 as MTD_Average_DTI from financial_loan
	where month(issue_date)=12;

*15. PMTD avg debt to income ratio*
	select AVG(dti)*100.0 as PMTD_Average_DTI from financial_loan
	where month(issue_date)=11;

*16. good loan applications*
	select COUNT(id) as Good_loan_applications from financial_loan where loan_status !='Charged Off';

*17. good loan applications percentage*
	select count(CASE when loan_status !='Charged Off' then id end )*100.0 /COUNT(id)as Good_loan_applications_percentage from financial_loan;


*18. good loan funded amount*
	select sum(loan_amount) as good_loan_funded_amount  from financial_loan where loan_status !='Charged Off';	

*19. good loan total received amount*
	select sum(total_payment) as good_loan_received_amount  from financial_loan where loan_status !='Charged Off';
	
*20. bad loan applications*
	select COUNT(id) as bad_loan_applications from financial_loan where loan_status ='Charged Off';

*21. bad loan applications percentage*
	select COUNT(case when loan_status='Charged Off' then id end)*100.0 /count(id) as bad_loan_applications from financial_loan;
*22. bad loan funded amount*
	select sum(loan_amount) as bad_loan_funded_amount  from financial_loan where loan_status ='Charged Off';

*23. good loan total received amount*
	select sum(total_payment) as bad_loan_recieved_amount  from financial_loan where loan_status ='Charged Off';


*24. regional analysis by state*
	select 
	address_state as State,
	count(id) as Total_loan_applications,
	sum(loan_amount) as Total_Funded_amount,
	sum(total_payment) as Total_amount_received from financial_loan group by address_state order by address_state;

*25. monthly trends by issue date*
	select 
	MONTH(issue_date)as month_number,DATENAME(MONTH,issue_date) as month_name,
	count(id) as Total_loan_applications,
	sum(loan_amount) as Total_Funded_amount,
	sum(total_payment) as Total_amount_received from financial_loan group by month(issue_date), DATENAME(month,issue_date) order by MONTH(issue_date) ;

*26. loan term analysis*
	select 
	term,
	count(id) as Total_loan_applications,
	sum(loan_amount) as Total_Funded_amount,
	sum(total_payment) as Total_amount_received from financial_loan group by term order by term;

*27. employee length analysis*
	select 
	emp_length,
	count(id) as Total_loan_applications,
	sum(loan_amount) as Total_Funded_amount,
	sum(total_payment) as Total_amount_received from financial_loan group by emp_length order by emp_length;

*28. loan purpose breakdown analysis*
	select 
	purpose,
	count(id) as Total_loan_applications,
	sum(loan_amount) as Total_Funded_amount,
	sum(total_payment) as Total_amount_received from financial_loan group by purpose order by purpose;

*29. home ownership analysis*
	select 
	home_ownership,
	count(id) as Total_loan_applications,
	sum(loan_amount) as Total_Funded_amount,
	sum(total_payment) as Total_amount_received from financial_loan group by home_ownership order by count(id);