CREATE TABLE public.departamento
(dnome varchar(30) not null,
 codigo integer not null,
 gerente integer not null,
 primary key (codigo)
)

CREATE TABLE public.empregado
(enome varchar(30) not null,
 cpf integer not null,
 endereco varchar(30) not null,
 nasc varchar(8) not null,
 sexo varchar(1) not null,
 salario numeric(7,2) not null,
 chefe integer,
 cdep integer,
 primary key (cpf),
 foreign key (cdep) references public.departamento
)

CREATE TABLE public.projeto
(pnome varchar(30) not null,
 pcodigo varchar(10) not null,
 cidade varchar(30) not null,
 cdep integer,
 primary key (pcodigo),
 foreign key (cdep) references public.departamento
)

CREATE TABLE public.tarefa
(cpf integer,
 pcodigo varchar(10),
 horas numeric(3,1) not null,
 primary key(cpf, pcodigo),
 foreign key (cpf) references public.empregado,
 foreign key (pcodigo) references public.projeto
)

CREATE TABLE public.dunidade
(dcodigo integer,
 dcidade varchar(30) not null,
 primary key (dcodigo, dcidade),
 foreign key (dcodigo) references public.departamento
)

INSERT INTO public.departamento
VALUES ('Pesquisa', 3, 1234);

INSERT INTO public.departamento
VALUES ('Marketing', 2, 6543);

INSERT INTO public.departamento
VALUES ('Administração', 4, 8765);

INSERT INTO public.empregado
VALUES ('Chiquin', '1234', 'rua 1, 1', '02/02/62', 'M', 10000.00, 8765, 3);

INSERT INTO public.empregado
VALUES ('Helenita', '4321', 'rua 2, 2', '03/03/63', 'F', 12000.00, 6543, 2);

INSERT INTO public.empregado
VALUES ('Pedrin', '5678', 'rua 3, 3', '04/04/64', 'M', 9000.00, 6543, 2);

INSERT INTO public.empregado
VALUES ('Valtin', '8765', 'rua 4, 4', '05/05/65', 'M', 15000.00, Null, 4);

INSERT INTO public.empregado
VALUES ('Zulmira', '3456', 'rua 5, 5', '06/06/66', 'F', 12000.00, 8765, 3);

INSERT INTO public.empregado
VALUES ('Zefinha', '6543', 'rua 6, 6', '07/07/67', 'F', 10000.00, 8765, 2);

INSERT INTO public.projeto
VALUES ('ProdutoA', 'PA', 'Cumbuco', 3);

INSERT INTO public.projeto
VALUES ('ProdutoB', 'PB', 'Icapuí', 3);

INSERT INTO public.projeto
VALUES ('Informatização', 'Inf', 'Fortaleza', 4);

INSERT INTO public.projeto
VALUES ('Divulgação', 'Div', 'Morro Branco', 2);

INSERT INTO public.tarefa
VALUES (1234, 'PA', 30.0);

INSERT INTO public.tarefa
VALUES (1234, 'PB', 10.0);

INSERT INTO public.tarefa
VALUES (4321, 'PA', 5.0);

INSERT INTO public.tarefa
VALUES (4321, 'Div', 35.0);

INSERT INTO public.tarefa
VALUES (5678, 'Div', 40.0);

INSERT INTO public.tarefa
VALUES (8765, 'Inf', 32.0);

INSERT INTO public.tarefa
VALUES (8765, 'Div', 8.0);

INSERT INTO public.tarefa
VALUES (3456, 'PA', 10.0);

INSERT INTO public.tarefa
VALUES (3456, 'PB', 25.0);

INSERT INTO public.tarefa
VALUES (3456, 'Div', 5.0);

INSERT INTO public.tarefa
VALUES (6543, 'PB', 40.0);

INSERT INTO public.dunidade
VALUES (2, 'Morro Branco');

INSERT INTO public.dunidade
VALUES (3, 'Cumbuco');

INSERT INTO public.dunidade
VALUES (3, 'Prainha');

INSERT INTO public.dunidade
VALUES (3, 'Taíba');

INSERT INTO public.dunidade
VALUES (3, 'Icapuí');

INSERT INTO public.dunidade
VALUES (4, 'Fortaleza');

-- Consultas

create view v1 (nome_empregado, sexo_empregado, salario_empregado) as
select enome, sexo, salario from empregado

select nome_empregado from v1 where salario_empregado = (select max(salario_empregado) from v1)

update v1 set salario_empregado = 1.1*salario_empregado
-- Permitido
create view v2 (nome_departamento, nome_gerente) as 
select d.dnome, e.enome from departamento d, empregado e where d.gerente = e.cpf

update v2 set nome_gerente = 'Zezin' where nome_departamento = 'Informática'
-- Não pode atualizar visões que utilizam mais de uma tabela

update v2 set nome_departamento = 'Baderna' where nome_gerente = 'Chiquim'
-- Não pode atualizar visões que utilizam mais de uma tabela

create view v3 (nome_empregado, sexo_empregado, salario_empregado) as
select enome, sexo, salario from empregado where salario < 500

update v3 set salario_empregado = salario_empregado + 600
-- Permitido, mas podem ter tuplas que saiam da view

delete from v3 where salario_empregado > 1000 and salario_empregado < 2000
-- Permitido, mas não vai fazer nada

insert into v3 values ('Davi', 'M', 2000.00)
-- Não é permitido, pois a visão não possui todos os dados de empregado

create view v4 (codigo, nome, cpf_gerente, nome_gerente) as
select d.codigo, d.dnome, d.gerente, e.enome
from departamento d, empregado e
where d.gerente = e.cpf

update v4 set codigo = '9029' where nome = 'Informática'
-- Não pode atualizar visões que utilizam mais de uma tabela

update v4 set cpf_gerente = '9029' where nome_gerente = 'Chiquim'
-- Não pode atualizar visões que utilizam mais de uma tabela

update v4 set nome_gerente = 'Doidin' where nome_gerente = 'Chiquim'
-- Não pode atualizar visões que utilizam mais de uma tabela

create view v5 (codigo_departamento, nome_departamento, qtd_empregados, max_salario, min_salario, avg_salario) as
select d.codigo, d.dnome, t.qtd_empregados, t.max_salario, t.min_salario, t.avg_salario 
from (select count(*) as qtd_empregados, max(salario) as max_salario, min(salario) as min_salario, avg(salario) as avg_salario, cdep from empregado group by cdep) as t, departamento d 
where d.codigo = t.cdep

update v5 set avg_salario = 7 where codigo_departamento = 1
-- Não pode atualizar visões que utilizam mais de uma tabela

update v5 set qtd_empregados = 7 where codigo_departamento = 1
-- Não pode atualizar visões que utilizam mais de uma tabela

delete from v5 where codigo_departamento = 1
-- Não pode atualizar visões que utilizam mais de uma tabela

insert into v5 values (1234, 'informática', 3, 500, 100, 300)
-- Não pode atualizar visões que utilizam mais de uma tabela

update v5 set nome_departamento = 'Informática' where codigo_departamento = 1
-- Não pode atualizar visões que utilizam mais de uma tabela
