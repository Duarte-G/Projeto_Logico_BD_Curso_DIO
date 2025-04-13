-- Apaga orders e clients e reinicia as sequences
TRUNCATE TABLE orders, clients RESTART IDENTITY CASCADE;
TRUNCATE TABLE seller RESTART IDENTITY CASCADE;

-- 1. Inserir produtos primeiro
INSERT INTO product (Pname, classification_kids, category, rating, size)
VALUES 
    ('Smartphone', FALSE, 'Eletrônico', 4.5, NULL),
    ('Camiseta', FALSE, 'Vestimenta', 4.0, 'M'),
    ('Boneca', TRUE, 'Brinquedos', 4.8, NULL),
    ('Microondas', FALSE, 'Eletrônico', 3.9, NULL),
    ('Sofá', FALSE, 'Moveis', 4.2, '3m');

-- 2. Insere clientes
INSERT INTO clients (
    Fname, Minit, Lname, CPF, Address, clientType, CNPJ
) VALUES 
    ('Maria', 'M', 'Silva',  '12345678901', 'Rua das Flores 123', 'PF', NULL),
    ('João',  'P', 'Santos','98765432109', 'Av Brasil 456',    'PF', NULL),
    ('Ana',   'C', 'Oliveira','11122233344','Rua Alegria, 789', 'PF', NULL);

-- Verificar
-- SELECT * FROM clients;

-- Verificar
-- SELECT * FROM orders;

-- 3. Inserir fornecedores
INSERT INTO supplier (SocialName, CNPJ, contact)
VALUES 
    ('Tech Supplies', '12345678901234', '11987654321'),
    ('Moda Têxtil', '23456789012345', '11976543210'),
    ('Brinquedos Kids', '34567890123456', '11965432109');

-- 4. Inserir vendedores
INSERT INTO seller (SocialName, AbstName, CNPJ, CPF, location, contact)
VALUES 
    ('Tech Shop', 'TS', '98765432109876', NULL, 'São Paulo', '11912345678'),
    ('Fashion Store', 'FS', '87654321098765', NULL, 'Rio de Janeiro', '21912345678'),
    ('Toy World', 'TW', '76543210987654', NULL, 'Belo Horizonte', '31912345678');

-- 5. Inserir estoque
INSERT INTO productStorage (storageLocation, quantity)
VALUES 
    ('Galpão A', 100),
    ('Galpão B', 150),
    ('Galpão C', 200);

-- 6. Inserir pedidos
INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue)
VALUES 
    (1, 'Confirmado', 'Pedido de smartphone', 15.5),
    (2, 'Em processamento', 'Pedido de vestuário', 10.0),
    (3, 'Confirmado', 'Presentes infantis', 12.5),
    (1, 'Confirmado', 'Pedido de eletrodomésticos', 20.0);

-- 7. Inserir pagamentos
INSERT INTO payments (idClient, idPayment, typePayment, limitAvailable)
VALUES 
    (1, 1, 'Cartão', 1000.0),
    (1, 2, 'Boleto', 5000.0),
    (2, 1, 'Dois cartões', 2000.0),
    (3, 1, 'Cartão', 3000.0);

-- 8. Inserir relacionamentos product-seller
INSERT INTO productSeller (idPseller, idPproduct, prodQuantity)
VALUES 
    (1, 1, 10),  -- Tech Shop (id 1) vende Smartphone (id 1)
    (1, 4, 5),   -- Tech Shop vende Microondas
    (2, 2, 20),  -- Fashion Store vende Camiseta
    (3, 3, 15),  -- Toy World vende Boneca
    (3, 5, 8);   -- Toy World vende Sofá

-- 9. Inserir relacionamentos de storage-location
INSERT INTO storageLocation (idLproduct, idLstorage, location)
VALUES 
    (1, 1, 'Prateleira 5'),  -- Smartphone no Galpão A
    (2, 1, 'Prateleira 3'),  -- Camiseta no Galpão A
    (3, 2, 'Prateleira 8'),  -- Boneca no Galpão B
    (4, 3, 'Prateleira 2'),  -- Microondas no Galpão C
    (5, 3, 'Setor Móveis');  -- Sofá no Galpão C

-- 10. Inserir product-order
INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus)
VALUES 
    (1, 1, 1, 'Disponível'),  -- Smartphone no pedido 1
    (2, 2, 3, 'Disponível'),  -- Camiseta no pedido 2
    (3, 3, 2, 'Disponível'),  -- Boneca no pedido 3
    (4, 4, 1, 'Disponível'),  -- Microondas no pedido 4
    (1, 4, 1, 'Disponível');  -- Smartphone também no pedido 4

-- 11. Inserir relacionamentos entre fornecedores e produtos
INSERT INTO productSupplier (idPSupplier, idProduct, quantity)
VALUES
    (1, 1, 50),   -- Tech Supplies fornece 50 Smartphones (idProduct = 1)
    (1, 4, 30),   -- Tech Supplies fornece 30 Microondas  (idProduct = 4)
    (1, 5, 20),   -- Tech Supplies fornece 20 Sofás       (idProduct = 5)
    (2, 2, 100),  -- Moda Têxtil fornece 100 Camisetas   (idProduct = 2)
    (3, 3, 75);   -- Brinquedos Kids fornece 75 Bonecas   (idProduct = 3)