-- ##### Recuperações simples com SELECT Statement
-- Listar todos os produtos disponíveis
SELECT * FROM product;

-- Listar todos os clientes e seus tipos (PF ou PJ)
SELECT idClient, Fname, Lname, clientType, CPF, CNPJ FROM clients;

-- ##### Filtros com WHERE Statement
-- Listar apenas produtos para crianças
SELECT * FROM product WHERE classification_kids = TRUE;

-- Listar pedidos confirmados
SELECT * FROM orders WHERE orderStatus = 'Confirmado';

-- ##### Expressões para gerar atributos derivados
-- Calcular valor total de cada pedido (valor do envio + soma dos produtos)
SELECT 
    o.idOrder,
    o.orderDescription,
    o.sendValue,
    SUM(p.poQuantity * (SELECT COALESCE(AVG(rating) * 100, 0) FROM product WHERE idProduct = p.idPOproduct)) AS estimated_total_value,
    o.sendValue + SUM(p.poQuantity * (SELECT COALESCE(AVG(rating) * 100, 0) FROM product WHERE idProduct = p.idPOproduct)) AS total_with_shipping
FROM 
    orders o
JOIN 
    productOrder p ON o.idOrder = p.idPOorder
GROUP BY 
    o.idOrder, o.orderDescription, o.sendValue;

-- ##### Ordenações dos dados com ORDER BY
-- Listar produtos por avaliação (do melhor para o pior)
SELECT idProduct, Pname, category, rating 
FROM product
ORDER BY rating DESC;

-- ##### Condições de filtros aos grupos – HAVING Statement
-- Listar categorias de produtos com avaliação média superior a 4
SELECT 
    category,
    AVG(rating) AS average_rating,
    COUNT(*) AS product_count
FROM 
    product
GROUP BY 
    category
HAVING 
    AVG(rating) > 4;

-- ##### Junções entre tabelas para perspectiva mais complexa
-- Lista quantos pedidos foram feitos por cada cliente
SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS client_name,
    c.clientType,
    COUNT(o.idOrder) AS total_orders,
    SUM(o.sendValue) AS total_shipping_cost
FROM 
    clients c
LEFT JOIN 
    orders o ON c.idClient = o.idOrderClient
GROUP BY 
    c.idClient, client_name, c.clientType
ORDER BY 
    total_orders DESC;

-- Produtos mais vendidos (análise de vendas)
SELECT 
    p.idProduct,
    p.Pname AS product_name,
    p.category,
    COUNT(po.idPOorder) AS order_count,
    SUM(po.poQuantity) AS total_quantity_ordered
FROM 
    product p
JOIN 
    productOrder po ON p.idProduct = po.idPOproduct
GROUP BY 
    p.idProduct, p.Pname, p.category
ORDER BY 
    total_quantity_ordered DESC;