drop database if exists finalproject_will_james_arman;
create database finalproject_will_james_arman;

\c finalproject_will_james_arman


CREATE TABLE IF NOT EXISTS Restaurant (
	id serial NOT NULL,
	name varchar(255) NOT NULL,
	theme varchar(255) NOT NULL,
	delivery boolean NOT NULL,
	primary key (id));

CREATE TABLE IF NOT EXISTS Locations (
	restaurant_id serial NOT NULL,
	country varchar(255) NOT NULL,	
	state_province varchar(255) NOT NULL,
	city varchar(255) NOT NULL,
	street_address varchar(255) NOT NULL,
	postal_code varchar(255) NOT NULL,
	primary key (restaurant_id),
	foreign key (restaurant_id) references Restaurant (id));


CREATE TABLE IF NOT EXISTS Units (
	unit_type varchar(255) NOT NULL,
	primary key(unit_type));

CREATE TABLE IF NOT EXISTS Order_types(
	order_type varchar(255) NOT NULL,
	primary key (order_type));

CREATE TABLE IF NOT EXISTS Order_Status(
	order_status varchar(255) NOT NULL,
	primary key (order_status));

CREATE TABLE IF NOT EXISTS Dietary_restrictions(
	dietary_restriction_id serial NOT NULL,
	restriction_name varchar(255) NOT NULL,
	primary key (dietary_restriction_id));

CREATE TABLE IF NOT EXISTS Products (
	product_id serial NOT NULL,
	product_name varchar(255) NOT NULL,
	product_price numeric(4,2),
	product_availability boolean,
	restaurant_id serial,
	foreign key (restaurant_id) references Restaurant (id),
	primary key (product_id));

CREATE TABLE IF NOT EXISTS Dietary_restriction_products(
	dietary_restriction_id int NOT NULL,
	product_id serial NOT NULL,
	primary key (product_id, dietary_restriction_id),
	foreign key (product_id) references Products (product_id),
	foreign key (dietary_restriction_id) references Dietary_restrictions (dietary_restriction_id));

CREATE TABLE IF NOT EXISTS Employee(
	employee_id serial NOT NULL,
	position varchar(20),
	full_name varchar(30),
	weekly_hours int,
	hourly_wage numeric(4,2),
	restaurant_id serial NOT NULL,
	primary key (employee_id),
	foreign key (restaurant_id) references Restaurant (id));

CREATE TABLE IF NOT EXISTS monthly_cost(
	month int NOT NULL,
	cost_description varchar(35),
	restaurant_id serial NOT NULL,
	expense numeric(10,2),
	primary key (restaurant_id, month),
	foreign key (restaurant_id) references Restaurant(id));


CREATE TABLE IF NOT EXISTS Ingredients ( 
	ingredient_name varchar(255) NOT NULL,
	unit_cost numeric(10,2),
	primary key (ingredient_name));

CREATE TABLE IF NOT EXISTS Current_stock (
	ingredient_name varchar(255) NOT NULL,
	unit_type varchar(255) NOT NULL,
	quantity int,
	restaurant_id int NOT NULL,
	primary key (ingredient_name, restaurant_id),
	foreign key (restaurant_id) references restaurant(id),
	foreign key (ingredient_name) references Ingredients (ingredient_name),
	foreign key (unit_type) references Units (unit_type));

CREATE TABLE IF NOT EXISTS Recipe(
	product_id serial NOT NULL,
	ingredient_name varchar(255) NOT NULL,
	unit_type varchar(255) NOT NULL,
	quantity numeric(10,2),
	primary key (product_id, ingredient_name),
	foreign key (product_id) references Products (product_id),
	foreign key (ingredient_name) references Ingredients (ingredient_name),
	foreign key (unit_type) references Units (unit_type));
	
CREATE TABLE IF NOT EXISTS Customers (
	customer_name varchar(255),
	phone_number varchar(25) NOT NULL,
	email varchar(255),
	primary key (phone_number));

CREATE TABLE Orders (
	order_id serial NOT NULL,
	order_date date NOT NULL,
	time_placed time,
	time_expected time,
	order_address varchar(255),
	order_status varchar(255) NOT NULL,
	order_type varchar(255) NOT NULL,
	phone_number varchar(25),
	primary key (order_id),
	foreign key (order_status) references Order_Status (order_status),
	foreign key (order_type) references Order_types (order_type),
	foreign key (phone_number) references Customers (phone_number));

CREATE TABLE IF NOT EXISTS Product_orders(
	order_id serial not null,
	product_id int not null,
	quantity int,
	primary key (order_id, product_id),
	foreign key (order_id) references Orders (order_id),
	foreign key (product_id) references Products (product_id)
);

grant all on table current_stock, customers, dietary_restriction_products,dietary_restrictions, employee, ingredients, locations, monthly_cost, order_status, order_types, orders, product_orders, products, recipe, restaurant, units to atava17;
grant all on table current_stock, customers, dietary_restriction_products,dietary_restrictions, employee, ingredients, locations, monthly_cost, order_status, order_types, orders, product_orders, products, recipe, restaurant, units to jrwhit18;
grant all on table current_stock, customers, dietary_restriction_products,dietary_restrictions, employee, ingredients, locations, monthly_cost, order_status, order_types, orders, product_orders, products, recipe, restaurant, units to cslabtes;


	

