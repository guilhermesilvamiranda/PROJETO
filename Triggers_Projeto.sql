Use projeto

CREATE TABLE log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_tabela VARCHAR(50) NOT NULL,
    operacao VARCHAR(10) NOT NULL CHECK (operacao IN ('INSERT', 'UPDATE', 'DELETE')),
    valor_atual VARCHAR(500) NULL,
    valor_novo VARCHAR(500) NULL
);
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

DELIMITER $$

CREATE TRIGGER trg_usuarios_insert
AFTER INSERT ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO log (nome_tabela, operacao, valor_atual, valor_novo)
    VALUES ('usuarios', 'INSERT', NULL, 
            CONCAT('id: ', NEW.id, ', nome: ', NEW.nome, ', email: ', NEW.email));
END$$

DELIMITER ;




DELIMITER $$

CREATE TRIGGER trg_usuarios_update
AFTER UPDATE ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO log (nome_tabela, operacao, valor_atual, valor_novo)
    VALUES (
        'usuarios',
        'UPDATE',
        CONCAT('id: ', OLD.id, ', nome: ', OLD.nome, ', email: ', OLD.email),
        CONCAT('id: ', NEW.id, ', nome: ', NEW.nome, ', email: ', NEW.email)
    );
END$$

DELIMITER ;




DELIMITER $$

CREATE TRIGGER trg_usuarios_delete
AFTER DELETE ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO log (nome_tabela, operacao, valor_atual, valor_novo)
    VALUES (
        'usuarios',
        'DELETE',
        CONCAT('id: ', OLD.id, ', nome: ', OLD.nome, ', email: ', OLD.email),
        NULL
    );
END$$

DELIMITER ;


INSERT INTO usuarios (nome, email) VALUES ('João Silva', 'joao@email.com');
UPDATE usuarios SET nome = 'João Pedro' WHERE id = 1;
DELETE FROM usuarios WHERE id = 1;

SELECT * FROM log;