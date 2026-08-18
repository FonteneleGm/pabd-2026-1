--Inserir
INSERT INTO funcionario VALUES 
('11122233344', 'Joao', 'Silva', 'joao@tads.ifrn', 'Natal-RN', '9990', '2000-01-01', 'M', null ,null),
('22233344455', 'Joana', 'Sales', 'joana@tads.ifrn', 'Parnamirim-RN', '8990', '2001-11-01', 'M', null ,null),
('33344455566', 'Jose', 'Sousa', 'jose@tads.ifrn', 'Teresina-PI', '7990', '2002-12-01', 'M', null ,null);

INSERT INTO funcionario(cpf, pnome, unome, email, salario, data_nasc, sexo) VALUES
-- ('4445556677', 'Jobson', 'Soares', 'jobson@tads.ifrn', 'Extremoz-RN', 6990 '2003-03-03', 'M'); Está errado porque colocou dados a mais do que o especificado.
('4445556677', 'Jobson', 'Soares', 'jobson@tads.ifrn', '6990', '2003-03-03', 'M');

--Atualizar
UPDATE funcionario
SET sexo='F'
WHERE cpf='22233344455'
RETURNING cpf, pnome, unome, sexo; 
--Atualizar Bônus (meu mesmo)
UPDATE funcionario
SET cpf='44455566677'
WHERE cpf='4445556677'
RETURNING cpf, pnome, unome, sexo;

UPDATE funcionario
SET endereco='DEFAULT'
WHERE cpf='4445556677'
RETURNING cpf, pnome, unome, sexo; 

--Remover
DELETE FROM funcionario
WHERE cpf='44455566677'
RETURNING cpf, pnome, unome;