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

select d.dnome
from departamento d, empregado e
where d.codigo = e.cdep
group by d.codigo
having avg(e.salario) >= all(select avg(salario) from empregado group by cdep)

select d.dnome, max(e.salario), min(e.salario), avg(e.salario)
from empregado e, departamento d
where e.cdep = d.codigo
group by d.codigo

select d.dnome, e.enome as gerente, t2.qtd_empregados, t3.qtd_projetos, t4.qtd_unidades
from (select count(*) as qtd_empregados, d.codigo from empregado e, departamento d where d.codigo = e.cdep group by d.codigo) as t2,
	 (select count(*) as qtd_projetos, d.codigo from projeto p, departamento d where d.codigo = p.cdep group by d.codigo) as t3,
	 (select count(*) as qtd_unidades, d.codigo from dunidade u, departamento d where d.codigo = u.dcodigo group by d.codigo) as t4,
	 departamento d, empregado e
where d.gerente = e.cpf and d.codigo = t2.codigo and d.codigo = t3.codigo and d.codigo = t4.codigo

select p.pnome
from projeto p, tarefa t
where p.pcodigo = t.pcodigo
group by p.pcodigo
having sum(t.horas) >= all(select sum(horas) from tarefa group by pcodigo)

select p.pnome
from projeto p, tarefa t, empregado e
where p.pcodigo = t.pcodigo and e.cpf = t.cpf
group by p.pcodigo
having sum(e.salario) >= all(select sum(e.salario) from tarefa t, empregado e where e.cpf = t.cpf group by t.pcodigo)

select p.pnome, e.enome, t1.total_horas, t2.qtd_empregados, t3.custo_mensal
from projeto p, departamento d, empregado e, 
	 (select sum(horas) as total_horas, pcodigo from tarefa group by pcodigo) as t1,
	 (select count(*) as qtd_empregados, pcodigo from tarefa group by pcodigo) as t2,
	 (select sum(e.salario) as custo_mensal, t.pcodigo from tarefa t, empregado e where e.cpf = t.cpf group by t.pcodigo) as t3
where p.cdep = d.codigo and d.gerente = e.cpf and p.pcodigo = t1.pcodigo and p.pcodigo = t2.pcodigo and p.pcodigo = t3.pcodigo	 

select e.enome
from empregado e, departamento d
where d.gerente = e.cpf and (e.enome like '% Silva %' or e.enome like '% Silva')

select distinct e.enome
from empregado e, departamento d, tarefa t
where t.cpf = d.gerente and d.gerente = e.cpf

select distinct e.enome
from empregado e, projeto p, tarefa t
where e.cpf = t.cpf and t.pcodigo = p.pcodigo and p.cdep != e.cdep

select e.enome
from empregado e, (select count(*) as total_projetos from projeto) as t1, (select count(*) as qtd_projetos, cpf from tarefa group by cpf) as t2
where t2.cpf = e.cpf and t2.qtd_projetos = t1.total_projetos

select e.enome, e.salario, d.dnome
from empregado e, departamento d
where e.cdep = d.codigo
order by salario desc

select e1.enome as funcionario, e2.enome as chefe, t.enome as gerente
from empregado e1, empregado e2, (select e.enome, d.codigo from empregado e, departamento d where e.cpf = d.gerente) as t
where e1.chefe = e2.cpf and e1.cdep = t.codigo

select d.dnome
from empregado e, departamento d
where e.cdep = d.codigo
group by d.codigo
having avg(salario) > (select avg(salario) from empregado)

select e.enome
from empregado e, (select cdep, avg(salario) as media_salario from empregado group by cdep) as t
where e.cdep = t.cdep and e.salario > t.media_salario

select e.enome
from empregado e, dunidade u
where e.cdep = u.dcodigo and u.dcidade = 'Fortaleza'

select d.dnome
from empregado e, (select cdep, avg(salario) as media_salario from empregado group by cdep) as t, departamento d
where e.cdep = t.cdep and e.salario > 2*t.media_salario and e.cdep = d.codigo

select enome
from empregado
where salario > 700.00 and salario < 2800.00

select d.dnome
from departamento d, projeto p, (select max(qtd_empregados) as maximo, min(qtd_empregados) as minimo, p.cdep from (select count(*) as qtd_empregados, pcodigo from tarefa group by pcodigo) as t, projeto p where p.pcodigo = t.pcodigo)
where t.pcodigo = p.pcodigo and p.cdep = d.codigo and t.qtd_empregados >
