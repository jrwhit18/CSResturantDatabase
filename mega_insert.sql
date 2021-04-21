drop table if exists t;
create temporary table if not exists t(
    index int,
    order_id int, 
    order_type varchar(255),
    order_date date, 
    time_placed varchar(20), 
    time_expected varchar(20), 
    customer_name varchar(255), 
    product_id int, 
    product_name varchar(255), 
    product_price numeric(4,2), 
    quantity int, 
    order_address varchar(255), 
    phone_number varchar(25), 
    email varchar(255), 
    order_status varchar(255)
);

\copy t from 'newest_test_data2.csv' with (format csv, header true);

-- sanitize janky times from data gen
delete from t where time_placed = '01:60' or time_placed = '02:60' or time_placed = '03:60' or time_placed = '04:60' or time_placed = '05:60'
or time_placed = '06:60' or time_placed = '07:60' or time_placed = '08:60' or time_placed = '09:60' or time_placed = '10:60' or time_placed = '11:60' or time_placed = '12:60';

-- -- status / order types / units
INSERT INTO Order_Status values ('Accepted');
INSERT INTO Order_Status values ('In-progress');
INSERT INTO Order_Status values ('Completed');
INSERT INTO Order_Status values ('Canceled');

INSERT INTO Order_types values ('Stay');
INSERT INTO Order_types values ('Pickup');
INSERT INTO Order_types values ('Delivery');

INSERT INTO Units values ('cup');
INSERT INTO Units values ('ounce');
INSERT INTO Units values ('pound');
INSERT INTO Units values ('pint');
INSERT INTO Units values ('head');
INSERT INTO Units values ('cloves');
INSERT INTO Units values ('loaf');

--insert customers
insert into customers(customer_name, phone_number)
select distinct
    customer_name, phone_number
from 
    t
where
    customer_name is not null;

-- insert orders
insert into orders (order_id, order_date, time_placed, time_expected, order_address, order_status, order_type, phone_number)
select distinct
    order_id, order_date, time_placed::time, time_expected::time, order_address, order_status, order_type, phone_number 
from t;

insert into restaurant values (1, 'Bistro de Ed', 'Italian', true);
INSERT INTO locations values (1, 'Kazakhstan', 'New York', 'Kuzcek', '23 Romoda Drive', 'G7P2I3');

insert into products(product_id, product_name, product_price, restaurant_id)
select distinct
    product_id, product_name, product_price, 1
from t;

insert into product_orders (order_id, product_id, quantity)
select
    order_id, product_id, quantity
from 
    t;

-- Ingredients

INSERT INTO Ingredients values ('yeast', 1.00);
INSERT INTO Ingredients values ('flour', 0.25);
INSERT INTO Ingredients values ('olive oil', 1.50);
INSERT INTO Ingredients values ('salt', 0.05);
INSERT INTO Ingredients values ('sugar', 0.75);
INSERT INTO Ingredients values ('tomatoes', 2.00);
INSERT INTO Ingredients values ('cheese', 2.50);
INSERT INTO Ingredients values ('garlic', 1.50);
INSERT INTO Ingredients values ('onions', 1.50);
INSERT INTO Ingredients values ('sausage', 3.00);
INSERT INTO Ingredients values ('bell peppers', 2.00);
INSERT INTO Ingredients values ('mushrooms', 4.00);
INSERT INTO Ingredients values ('butter', 5.00);
INSERT INTO Ingredients values ('shrimp', 6.00);
INSERT INTO Ingredients values ('chicken', 4.00);
INSERT INTO Ingredients values ('pasta', 1.25);
INSERT INTO Ingredients values ('bread', 0.75);
INSERT INTO Ingredients values ('veal', 10.00);
INSERT INTO Ingredients values ('lettuce', 1.00);
INSERT INTO Ingredients values ('gelato', 6.50);
INSERT INTO Ingredients values ('buffalo sauce', 1.00);
INSERT INTO Ingredients values ('olives', 10.50);
INSERT INTO Ingredients values ('ham', 3.50);
INSERT INTO Ingredients values ('salami', 1.00);
INSERT INTO Ingredients values ('meatball', 2.50);
INSERT INTO Ingredients values ('pepperoni', 1.00);
INSERT INTO Ingredients values ('cucumber', 2.00);
INSERT INTO Ingredients values ('vegetables', 0.05);
INSERT INTO Ingredients values ('cream', 1.50);

-- Recipes

-- pizza
INSERT INTO Recipe values (2, 'flour', 'cup', 4.5);
INSERT INTO Recipe values (2, 'yeast', 'cup', .25);
INSERT INTO Recipe values (2, 'sugar', 'cup', 0.75);
INSERT INTO Recipe values (2, 'salt', 'cup', 0.15);
INSERT INTO Recipe values (2, 'tomatoes', 'ounce', 1.0);
INSERT INTO Recipe values (2, 'cheese', 'cup', 2.5);

-- bread
INSERT INTO Recipe values (25, 'bread', 'loaf', 1.0);

-- antipasta
INSERT INTO Recipe values (23, 'lettuce', 'head', 0.5);
INSERT INTO Recipe values (23, 'tomatoes', 'ounce', 1.0);
INSERT INTO Recipe values (23, 'olives', 'cup', .1);
INSERT INTO Recipe values (23, 'onions', 'head', 1.0);
INSERT INTO Recipe values (23, 'ham', 'pound', 0.15);
INSERT INTO Recipe values (23, 'salami', 'pound', 0.15);
INSERT INTO Recipe values (23, 'cheese', 'cup', 1.0);

-- garlic knots
INSERT INTO Recipe values (17, 'flour', 'cup', 1.0);
INSERT INTO Recipe values (17, 'yeast', 'cup', 0.10);
INSERT INTO Recipe values (17, 'sugar', 'cup', 0.35);
INSERT INTO Recipe values (17, 'salt', 'cup', 0.15);
INSERT INTO Recipe values (17, 'butter', 'cup', 1.0);
INSERT INTO Recipe values (17, 'garlic', 'cloves', 0.15);

-- wings
INSERT INTO Recipe values (4, 'chicken', 'pound', 1.0);
INSERT INTO Recipe values (4, 'flour', 'cup', 2.0);

-- mozz sticks
INSERT INTO Recipe values (16, 'cheese', 'cup', 2.15);
INSERT INTO Recipe values (16, 'bread', 'loaf', 1.0);

-- chicken parm
INSERT INTO Recipe values (12, 'chicken', 'pound', 0.5);
INSERT INTO Recipe values (12, 'bread', 'loaf', 1.0);
INSERT INTO Recipe values (12, 'tomatoes', 'ounce', 0.5);
INSERT INTO Recipe values (12, 'cheese', 'cup', 0.5);

-- shrimp parm
INSERT INTO Recipe values (15, 'shrimp', 'pound', 0.5);
INSERT INTO Recipe values (15, 'bread', 'loaf', 1.0);
INSERT INTO Recipe values (15, 'tomatoes', 'ounce', 0.5);
INSERT INTO Recipe values (15, 'cheese', 'cup', 0.5);

-- veal parm
INSERT INTO Recipe values (14, 'veal', 'pound', 0.5);
INSERT INTO Recipe values (14, 'bread', 'loaf', 1.0);
INSERT INTO Recipe values (14, 'tomatoes', 'ounce', 0.5);
INSERT INTO Recipe values (14, 'cheese', 'cup', 0.5);

-- meat parm
INSERT INTO Recipe values (13, 'meatball', 'pound', 0.5);
INSERT INTO Recipe values (13, 'bread', 'loaf', 1.0);
INSERT INTO Recipe values (13, 'tomatoes', 'ounce', 0.5);
INSERT INTO Recipe values (13, 'cheese', 'cup', 0.5);

-- italian hero
INSERT INTO Recipe values (24, 'lettuce', 'head', 0.50);
INSERT INTO Recipe values (24, 'bread', 'loaf', 1.0);
INSERT INTO Recipe values (24, 'tomatoes', 'ounce', 0.5);
INSERT INTO Recipe values (24, 'cheese', 'cup', 0.5);
INSERT INTO Recipe values (24, 'onions', 'cup', 0.5);
INSERT INTO Recipe values (24, 'ham', 'pound', 0.35);
INSERT INTO Recipe values (24, 'salami', 'pound', 0.35);

-- calzone
INSERT INTO Recipe values (3, 'cheese', 'cup', 2.5);
INSERT INTO Recipe values (3, 'flour', 'cup', 3.0);
INSERT INTO Recipe values (3, 'yeast', 'cup', 0.20);
INSERT INTO Recipe values (3, 'sugar', 'cup', 0.65);
INSERT INTO Recipe values (3, 'salt', 'cup', 0.10);

-- pepperoni
INSERT INTO Recipe values (7, 'pepperoni', 'cup', 1.0);

-- sausage
INSERT INTO Recipe values (11, 'sausage', 'cup', 1.0);

-- onions
INSERT INTO Recipe values (8, 'onions', 'cup', 1.0);

-- mushrooms
INSERT INTO Recipe values (9, 'mushrooms', 'cup', 1.0);

-- bell peppers
INSERT INTO Recipe values (10, 'bell peppers', 'cup', 1.0);

-- sauce
INSERT INTO Recipe values (18, 'tomatoes', 'ounce', 1.0);

-- buffalo chicken
INSERT INTO Recipe values (5, 'chicken', 'pound', 1.0);
INSERT INTO Recipe values (5, 'buffalo sauce', 'cup', 1.0);
INSERT INTO Recipe values (5, 'flour', 'cup', 2.0);

-- mild chicken
INSERT INTO Recipe values (6, 'chicken', 'pound', 1.0);
INSERT INTO Recipe values (6, 'buffalo sauce', 'cup', 0.1);
INSERT INTO Recipe values (6, 'flour', 'cup', 2.0);

-- tossed salad
INSERT INTO Recipe values (22, 'lettuce', 'head', 1.0);
INSERT INTO Recipe values (22, 'tomatoes', 'ounce', 0.50);
INSERT INTO Recipe values (22, 'onions', 'cup', 0.50);
INSERT INTO Recipe values (22, 'olives', 'cup', 0.10);
INSERT INTO Recipe values (22, 'vegetables', 'cup', 1.0);

-- greek salad
INSERT INTO Recipe values (21, 'lettuce', 'head', 1.0);
INSERT INTO Recipe values (21, 'tomatoes', 'ounce', 0.50);
INSERT INTO Recipe values (21, 'onions', 'cup', 0.50);
INSERT INTO Recipe values (21, 'olives', 'cup', 0.10);
INSERT INTO Recipe values (21, 'cheese', 'cup', 1.0);
INSERT INTO Recipe values (21, 'cucumber', 'cup', 0.5);

-- extra cheese
INSERT INTO Recipe values (26, 'cheese', 'cup', 2.0);

-- canoli
INSERT INTO Recipe values (20, 'cream', 'cup', 0.50);
INSERT INTO Recipe values (20, 'flour', 'cup', 1.0);

-- gelato
INSERT INTO Recipe values (19, 'gelato', 'pint', 0.25);


--employee
insert into employee values (0000000011, 'Manager', 'Will Schroeder',  40, 22.00, 1);
insert into employee values (0000000012, 'General Manager','James White', 40, 25.50, 1);
insert into employee values (0000000013, 'Chef', 'Arman Tavana',  15, 20.25, 1);
insert into employee values (0000000010,'Head Chef', 'Ed Harcourt', 60, 25.90, 1);
insert into employee values (0000000016, 'Waiter', 'Nick Austin',  40, 15.20, 1);
insert into employee values (0000000015, 'Waiter', 'Alec James', 60, 13.20, 1);
insert into employee values (0000000014, 'Waiter', 'Josh Hunter', 40, 14.80, 1);
insert into employee values (0000000017, 'Waiter', 'Emily James', 20, 12.20, 1);
insert into employee values (0000000018, 'Waiter', 'Kim Austin', 20, 12.20, 1);

-- misc costs

insert into monthly_cost values (1, 'opening costs' , 1, 25000.00);
insert into monthly_cost values (2, 'rent/utility/CC fees' ,1, 5003.00);
insert into monthly_cost values (3, 'rent/utility/CC fees' ,1, 6054.00);
insert into monthly_cost values (4, 'rent/utility/CC fees' ,1, 5083.00);
insert into monthly_cost values (5, 'rent/utility/CC fees + gas leak' ,1, 8054.00);
insert into monthly_cost values (6, 'rent/utility/CC fees' ,1, 5003.00);
insert into monthly_cost values (7, 'rent/utility/new front glass' ,1, 9003.00);
insert into monthly_cost values (8, 'rent/utility/CC fees' ,1, 4023.00);
insert into monthly_cost values (9, 'rent/utility/CC fees' ,1, 7103.00);
insert into monthly_cost values (10, 'rent/utility/CC fees' ,1, 5285.00);
insert into monthly_cost values (11, 'rent/utility/CC fees' ,1, 5809.00);
insert into monthly_cost values (12, 'rent/utility/CC fees/cesspool' ,1, 8063.00);
-- Dietary Restrictions

INSERT INTO Dietary_restrictions values (0000000000, 'milk');
INSERT INTO Dietary_restrictions values (0000000001, 'egg');
INSERT INTO Dietary_restrictions values (0000000002, 'shellfish');
INSERT INTO Dietary_restrictions values (0000000003, 'peanut');
INSERT INTO Dietary_restrictions values (0000000004, 'tree nut');
INSERT INTO Dietary_restrictions values (0000000005, 'gluten');
INSERT INTO Dietary_restrictions values (0000000006, 'soy');
INSERT INTO Dietary_restrictions values (0000000007, 'vegetarian');
INSERT INTO Dietary_restrictions values (0000000008, 'vegan');
INSERT INTO Dietary_restrictions values (0000000009, 'kosher');
INSERT INTO Dietary_restrictions values (0000000010, 'pork');
INSERT INTO Dietary_restrictions values (0000000011, 'alcohol');
INSERT INTO Dietary_restrictions values (0000000012, 'fish');
INSERT INTO Dietary_restrictions values (0000000013, 'nuts');

INSERT INTO Current_stock values ('yeast', 'cup', 10000);
INSERT INTO Current_stock values ('flour', 'cup', 10000);
INSERT INTO Current_stock values ('olive oil', 'cup', 10000);
INSERT INTO Current_stock values ('salt', 'cup', 10000);
INSERT INTO Current_stock values ('sugar', 'cup', 10000);
INSERT INTO Current_stock values ('tomatoes', 'ounce', 10000);
INSERT INTO Current_stock values ('cheese', 'cup', 10000);
INSERT INTO Current_stock values ('garlic', 'cloves', 10000);
INSERT INTO Current_stock values ('onions', 'cup', 10000);
INSERT INTO Current_stock values ('sausage', 'cup', 10000);
INSERT INTO Current_stock values ('bell peppers', 'cup', 10000);
INSERT INTO Current_stock values ('mushrooms', 'cup', 10000);
INSERT INTO Current_stock values ('butter', 'cup', 10000);
INSERT INTO Current_stock values ('shrimp', 'pound', 10000);
INSERT INTO Current_stock values ('chicken', 'pound', 10000);
INSERT INTO Current_stock values ('pasta', 'cup', 10000);
INSERT INTO Current_stock values ('bread', 'loaf', 10000);
INSERT INTO Current_stock values ('veal', 'pound', 10000);
INSERT INTO Current_stock values ('lettuce', 'head', 10000);
INSERT INTO Current_stock values ('gelato', 'pint', 10000);
INSERT INTO Current_stock values ('buffalo sauce', 'cup', 10000);
INSERT INTO Current_stock values ('olives', 'cup', 10000);
INSERT INTO Current_stock values ('ham', 'pound', 10000);
INSERT INTO Current_stock values ('salami', 'pound', 10000);
INSERT INTO Current_stock values ('meatball', 'pound', 10000);
INSERT INTO Current_stock values ('pepperoni', 'cup', 10000);
INSERT INTO Current_stock values ('cucumber', 'cup', 10000);
INSERT INTO Current_stock values ('vegetables', 'cup', 10000);
INSERT INTO Current_stock values ('cream', 'cup', 10000);
