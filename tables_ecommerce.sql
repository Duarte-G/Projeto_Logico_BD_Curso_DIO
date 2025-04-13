-- criação database ecommerce
--CREATE DATABASE ecommerce;

-- criar tabela cliente
CREATE TABLE clients(
    idClient SERIAL PRIMARY KEY,
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    Address VARCHAR(30),
    CONSTRAINT unique_cpf_client UNIQUE (CPF) 
);

-- criar tabela produto
CREATE TABLE product(
    idProduct SERIAL PRIMARY KEY,
    Pname VARCHAR(10) NOT NULL,
    classification_kids BOOLEAN DEFAULT FALSE,
    category VARCHAR(20) NOT NULL CHECK (category IN ('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Moveis')),
    rating FLOAT DEFAULT 0,
    size VARCHAR(10)
);

-- criar tabela pagamentos
CREATE TABLE payments(
    idClient INT,
    idPayment SERIAL,
    typePayment VARCHAR(20) CHECK (typePayment IN ('Boleto', 'Cartão', 'Dois cartões')),
    limitAvailable FLOAT,
    PRIMARY KEY(idClient, idPayment),
    CONSTRAINT fk_payment_client FOREIGN KEY (idClient) REFERENCES clients(idClient)
);

-- criar tabela pedido
CREATE TABLE orders(
    idOrder SERIAL PRIMARY KEY,
    idOrderClient INT,
    orderStatus VARCHAR(20) CHECK (orderStatus IN ('Cancelado', 'Confirmado', 'Em processamento')) NOT NULL,
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    CONSTRAINT fk_order_client FOREIGN KEY (idOrderClient) REFERENCES clients(idClient)
);

-- criar tabela estoque
CREATE TABLE productStorage(
    idProdStorage SERIAL PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

-- criar tabela fornecedor
CREATE TABLE supplier(
    idSupplier SERIAL PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- criar tabela vendedor
CREATE TABLE seller(
    idSeller SERIAL PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(14),
    CPF CHAR(11),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

-- criar tabela de produto vendido
CREATE TABLE productSeller(
    idPseller INT,
    idPproduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY(idPseller, idPproduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idPproduct) REFERENCES product(idProduct)
);

-- criar tabela ordem de produto
CREATE TABLE productOrder(
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus VARCHAR(20) CHECK (poStatus IN ('Disponível', 'Sem estoque')) DEFAULT 'Disponível',
    PRIMARY KEY(idPOproduct, idPOorder),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productorder_order FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
);

-- criar tabela local do armazem
CREATE TABLE storageLocation(
    idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_storage_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage)
);

-- ########## DESAFIOS ##############

-- Modificar a tabela clients para incluir o tipo (PF ou PJ)
ALTER TABLE clients 
ADD COLUMN clientType CHAR(2) CHECK (clientType IN ('PF', 'PJ')),
ADD COLUMN CNPJ CHAR(14) UNIQUE;

-- Adicionar a constraint para checar que apenas um dos documentos está preenchido
ALTER TABLE clients
ADD CONSTRAINT chk_doc_type CHECK (
  (clientType = 'PF' AND CPF IS NOT NULL AND CNPJ IS NULL) OR
  (clientType = 'PJ' AND CNPJ IS NOT NULL AND CPF IS NULL)
);

-- Criar tabela para entregas
CREATE TABLE delivery (
    idDelivery SERIAL PRIMARY KEY,
    idOrder INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Preparando', 'Enviado', 'Entregue', 'Cancelado')) NOT NULL,
    trackingCode VARCHAR(20),
    deliveryDate DATE,
    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- Criar tabela para relacionar produtos e fornecedores
CREATE TABLE productSupplier (
    idPSupplier INT,
    idProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPSupplier, idProduct),
    CONSTRAINT fk_prod_supplier FOREIGN KEY (idPSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_prod_product FOREIGN KEY (idProduct) REFERENCES product(idProduct)
);


