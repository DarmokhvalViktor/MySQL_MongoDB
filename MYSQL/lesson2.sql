# 1.Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
#
# 2.Вибрати львівські відділення банку.
#
# 3.Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
#
# 4.Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
#
# 5.Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
#
# 6.Вивести клієнтів банку, які обслуговуються київськими відділеннями.
#
# 7.Знайти унікальні імена клієнтів.
#
# 8.Вивести дані про клієнтів, які мають кредит більше ніж на 5000 гривень.
#
# 9.Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
#
# 10.Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
#
# 11. Визначити кількість заявок на крдеит для кожного клієнта.
#
# 12. Визначити найбільший та найменший кредити.
#
# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
#
# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
#
# 15. Вивести відділення, яке видало в кредити найбільше грошей
#
# 16. Вивести відділення, яке видало найбільший кредит.
#
# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
#
# 18. Усіх клієнтів київських відділень пересилити до Києва.
#
# 19. Видалити усі кредити, які є повернені.
#
# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
#
# 21.Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
#
# 22.Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
#
# 23.Знайти максимальний неповернений кредит.
#
# 24.Знайти клієнта, сума кредиту якого найменша
#
# 25.Знайти кредити, сума яких більша за середнє значення усіх кредитів
#
# 26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів
#
# 27. Місто клієнта з найбільшою кількістю кредитів
#
# 1.Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.

select * from client where length(firstName) < 6;

#
# 2.Вибрати львівські відділення банку.
select * from department where DepartmentCity = 'lviv';
#
# 3.Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select * from client where Education = 'high' order by LastName;
#
# 4.Виконати сортування у зворотньому порядку над таблицею Заявка
# і вивести 5 останніх елементів.
select * from application order by idApplication desc limit 5;
#
# 5.Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
select * from client where LastName like '%OV' or LastName like '%OVA';
#
# 6.Вивести клієнтів банку, які обслуговуються київськими відділеннями.
select * from client join department d on client.Department_idDepartment = d.idDepartment
where DepartmentCity = 'kyiv';
#
# 7.Знайти унікальні імена клієнтів.
select distinct FirstName from client;

# 8.Вивести дані про клієнтів, які мають кредит більше ніж на 5000 гривень.
select distinct client.*
from client
         join application a on client.idClient = a.Client_idClient
where Sum > 5000;


#
# 9.Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
(select count(*) from client)
union
(select count(*) from client join department d on d.idDepartment = client.Department_idDepartment
 where DepartmentCity = 'lviv');

select count(*) as all_lviv
from client
         join department d on d.idDepartment = client.Department_idDepartment;

select count(*)
from client
         join department d2 on d2.idDepartment = client.Department_idDepartment
where DepartmentCity = 'lviv';


#
# 10.Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.

select max(Sum) as max_credit, client.*
from client
         join application a on client.idClient = a.Client_idClient
group by idClient;

select max(sum) as maxCredit, c.* from application
                                           left join client c on application.Client_idClient = c.idClient
where Client_idClient in(select idClient from client)
group by Client_idClient;

select max(sum) from application group by Client_idClient;

#
# 11. Визначити кількість заявок на крдеит для кожного клієнта.

select count(*), idClient, FirstName, LastName
from client
         join application a on client.idClient = a.Client_idClient
group by idClient;

select count(Client_idClient) as amountOfCredits, c.* from application
                                                               left join client c on c.idClient = application.Client_idClient
where Client_idClient in (select idClient from client)
group by Client_idClient;
#
# 12. Визначити найбільший та найменший кредити.
select min(Sum) as min, max(Sum) as max
from application;

(select * from application order by Sum desc limit 1)
union
(select * from application order by Sum limit 1);
#
# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
select count(Client_idClient) from application
where Client_idClient in(select idClient from client where Education = 'high');

select count(*), Education
from client
         join application a on client.idClient = a.Client_idClient
where Education = 'high';

select count(*), idClient, FirstName, LastName, Education
from client
         join application a on client.idClient = a.Client_idClient
where Education = 'high'
group by idClient;


# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
select * from client where idClient = (select Client_idClient from application
                                       group by Client_idClient order by max(sum) desc limit 1);

select avg(Sum) as avg, client.*
from client
         join application a on client.idClient = a.Client_idClient
group by idClient
order by avg desc
limit 1;
#
# 15. Вивести відділення, яке видало в кредити найбільше грошей
select sum(sum) as MaxSum, DepartmentCity
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
group by DepartmentCity
limit 1;

select sum(Sum) as sum, idDepartment, DepartmentCity
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
group by idDepartment
order by sum desc
limit 1;

#
# 16. Вивести відділення, яке видало найбільший кредит.
select max(sum) as MaxSum, DepartmentCity
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
group by DepartmentCity
limit 1;

select max(Sum) as max_sum, department.*
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
group by idDepartment
order by max_sum desc
limit 1;

#
# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
update application join client c on c.idClient = application.Client_idClient
set Sum=6000,
    Currency='Gryvnia'
where Education = 'high';

update application join client c on c.idClient = application.Client_idClient
set Sum=6000
where Education = 'high';
#
# 18. Усіх клієнтів київських відділень пересилити до Києва.
update department join client c on department.idDepartment = c.Department_idDepartment
set City='kyiv'
where DepartmentCity = 'kyiv';

update client join department d on d.idDepartment = client.Department_idDepartment
set City='Kyiv'
where DepartmentCity = 'kyiv';

# 19. Видалити усі кредити, які є повернені.
delete
from application
where CreditState = 'returned';

delete application
from application
where CreditState = 'Returned';

#
# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
delete
from application
where Client_idClient in (select idClient from client where substring(LastName, 2, 1) in ('a', 'e', 'i', 'o', 'u'));

delete application
from application
         join client c on c.idClient = application.Client_idClient
where
        LastName like '_e%' or
        LastName like '_y%' or
        LastName like '_u%' or
        LastName like '_o%' or
        LastName like '_a%';

delete application
from application
         join client c on c.idClient = application.Client_idClient
where LastName regexp '^.[eyuoa].*';


# 21.Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
select sum(Sum) as sum, DepartmentCity,idDepartment
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
where DepartmentCity = 'lviv'
group by idDepartment
having sum(Sum) > 5000;
#
# 22.Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000

select idClient, FirstName, LastName, CreditState, Sum
from client
         join application a on client.idClient = a.Client_idClient
where CreditState = 'Returned'
  and Sum > 5000;
#
# 23.Знайти максимальний неповернений кредит.

select application.*
from application
where CreditState = 'Not returned'
order by Sum desc
limit 1;
#
# 24.Знайти клієнта, сума кредиту якого найменша

select client.*, Sum
from client
         join application a on client.idClient = a.Client_idClient
order by Sum
limit 1;
#
# 25.Знайти кредити, сума яких більша за середнє значення усіх кредитів
select *
from application
where Sum > (select avg(sum) from application);

#
# 26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів

select * from client
where City = (select City from application join client c
                                                on c.idClient = application.Client_idClient group by Client_idClient order by count(sum) desc limit 1);

select *
from client
where City = (
    select c.City
    from client c
             join application a on c.idclient = a.client_idclient
    group by idclient
    order by count(*) desc
    limit 1
);

#
# 27. Місто клієнта з найбільшою кількістю кредитів
select City from client
where idClient = (select Client_idClient from application group by Client_idClient order by count(sum) desc limit 1);


select c.City
from client c
         join application a on c.idclient = a.client_idclient
group by idclient
order by count(*) desc
limit 1;