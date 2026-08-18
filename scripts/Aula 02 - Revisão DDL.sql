DROP TABLE IF EXISTS funcionario cascade;
DROP TABLE IF EXISTS departamento cascade;

CREATE TABLE funcionario(
    cpf CHAR(11) PRIMARY KEY,
    pnome VARCHAR(50) NOT NULL,
    unome VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE,
    endereco VARCHAR(100) DEFAULT 'Macau-RN',
    salario NUMERIC(7,2),
    data_nasc DATE,
    sexo CHAR(1),
    cpf_supervisor  CHAR(11),
    numero_departamento SMALLINT,

    CONSTRAINT funcionario_salario_check
    CHECK (salario >=2000 and salario <=15000)
);

CREATE TABLE departamento(
    numero SMALLINT PRIMARY KEY,
    nome VARCHAR(50) UNIQUE,
    cpf_gerente CHAR(11),
    data_ini DATE NOT NULL
);
/*
-- Adicionar um novo atributo
ALTER TABLE departamento
ADD COLUMN data_ini date;

-- Excluir um atributo
ALTER TABLE departamento
DROP COLUMN data_ini;

-- Adicionar um valor DEFAULT
ALTER TABLE funcionario
ALTER COLUMN endereco SET DEFAULT 'Macau-RN';

-- Excluir o valor padrão DEFAULT
ALTER TABLE funcionario
ALTER COLUMN endereco DROP DEFAULT;

-- Adicionar restrição (constraint) CHECK
ALTER TABLE funcionario
ADD CONSTRAINT funcionario_sexo_check
CHECK (LOWER(sexo) in ('n', 'f', 'o'))

-- Excluir restrição 
ALTER TABLE funcionario
DROP CONSTRAINT IF EXISTS funcionario_sexo_check;

-- Adicionar restrição FOREIGN KEY
ALTER TABLE funcionario
ADD CONSTRAINT funcionario_num_dep_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento(numero)
-- NO ACTION, SET NULL, RESTRICT, CASCADE, SET DEFAULT
ON DELETE NO ACTION
ON UPDATE CASCADE;

-- TO DO: adicionar restrições para cpf_supervisor e cpf_gerente
-- Inicio Aula 03
ALTER TABLE funcionario
ADD CONSTRAINT funcionario_cpf_sup_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES funcionario(cpf)

ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE departamento
ADD CONSTRAINT departamento_cpf_gerente_fk
FOREIGN KEY (cpf_gerente)
REFERENCES funcionario(cpf)

ON DELETE SET NULL
ON UPDATE CASCADE;
*/