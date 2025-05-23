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
VALUES ('Pesquisa', 3, 1234)

INSERT INTO public.departamento
VALUES ('Marketing', 2, 6543)

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

select enome, salario
from empregado
where cdep = (select codigo from departamento where dnome='Marketing')

select cpf
from empregado
where cdep = (select codigo from departamento where dnome='Pesquisa') 
UNION
select chefe
from empregado
where cdep = (select codigo from departamento where dnome='Pesquisa')

select pnome, cidade
from projeto
where pcodigo in (select pcodigo from tarefa where horas > 30.0)

select enome, nasc
from empregado
where cpf in (select gerente from departamento)

select enome, endereco
from empregado
where cdep = (select codigo from departamento where dnome='Pesquisa') 

select p.pcodigo, d.dnome, d.gerente
from projeto p, departamento d
where p.cdep = d.codigo and p.cidade = 'Icapuí'

select enome, sexo
from empregado
where cpf in (select cpf from empregado EXCEPT select gerente from departamento)
