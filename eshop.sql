create database galariaeshop;

use galariaeshop;

CREATE TABLE `role` (
	role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(20)
);

INSERT INTO `role` VALUES (NULL, "Administrator");
INSERT INTO `role` VALUES (NULL, "Customer");

create table customer (
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR (50) UNIQUE NOT NULL,
    email VARCHAR(60) UNIQUE NOT NULL,
    `password` VARCHAR(60) NOT NULL,
    role_id INT DEFAULT 2,
    CONSTRAINT fk_customer_role_customer FOREIGN KEY (role_id) REFERENCES `role` (role_id)
);

create table chat (
	chat_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    message VARCHAR(800) NOT NULL,
    time_message datetime,
    CONSTRAINT fk_chat FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
);

create table customer_information (
	customer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR (50),
    last_name VARCHAR (50),
    country VARCHAR (50),
    state VARCHAR (50),
    city VARCHAR (50),
    street VARCHAR (50),
    zip VARCHAR (12),
    phone VARCHAR (15),
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE
);

DELIMITER $$

CREATE TRIGGER galariaeshop.customer_trigger
AFTER INSERT
ON galariaeshop.customer
FOR EACH ROW
BEGIN
 INSERT INTO galariaeshop.customer_information(customer_id) VALUES (NEW.customer_id);
END $$

DELIMITER ;

create table customer_credit_card (
	card_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	customer_id INT NOT NULL,
    owner_first_name VARCHAR (50),
    owner_last_name VARCHAR (50),
    card_number VARCHAR (60),
    card_number_last_digits VARCHAR(4),
    cvv VARCHAR (60),
    expiration_date VARCHAR (4),
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE
);

DELIMITER $$

CREATE TRIGGER galariaeshop.customer_card_trigger
AFTER INSERT
ON galariaeshop.customer
FOR EACH ROW
BEGIN
 INSERT INTO galariaeshop.customer_credit_card (customer_id) VALUES (NEW.customer_id);
END $$

DELIMITER ;

create table category (
	category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR (50) UNIQUE NOT NULL,
    category_image_filepath VARCHAR(200)
);

create table subcategory (
	subcategory_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    subcategory_name VARCHAR (50) UNIQUE NOT NULL,
    subcategory_image_filepath VARCHAR(200),
    FOREIGN KEY (category_id) REFERENCES category (category_id) ON DELETE CASCADE
);

create table color (
	color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR (20),
    color_image_filepath VARCHAR(200) 
);

create table product_size (
	size_id INT AUTO_INCREMENT PRIMARY KEY,
    size_name VARCHAR (5)
);

create table material (
	material_id INT AUTO_INCREMENT PRIMARY KEY,
    material_name VARCHAR (30)
);

create table gender (
	gender_id INT AUTO_INCREMENT PRIMARY KEY,
    gender_name VARCHAR (15)
);

create table product (
	product_id INT AUTO_INCREMENT PRIMARY KEY,
    subcategory_id INT NOT NULL,
    product_name VARCHAR (60) NOT NULL,
    color_id INT NOT NULL,
    size_id INT NOT NULL,
    material_id INT NOT NULL,
    gender_id INT NOT NULL,
    product_stock INT NOT NULL,
    product_price DECIMAL(7,2),
    FOREIGN KEY (subcategory_id) REFERENCES subcategory (subcategory_id) ON DELETE CASCADE,
    FOREIGN KEY (size_id) REFERENCES product_size (size_id) ON DELETE CASCADE,
    FOREIGN KEY (color_id) REFERENCES color (color_id) ON DELETE CASCADE,
    FOREIGN KEY (material_id) REFERENCES material (material_id) ON DELETE CASCADE,
    FOREIGN KEY (gender_id) REFERENCES gender (gender_id) ON DELETE CASCADE
);

create table product_image (
	product_image_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_filepath VARCHAR(500),
    product_id INT NOT NULL,
	FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE CASCADE
);

create table payment (
	payment_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_name VARCHAR (30) UNIQUE NOT NULL
);

insert into payment values (1, "Credit/Debit Card");
insert into payment values (2, "Pay on delivery");

create table shopping_cart (
	shopping_cart_id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE CASCADE
);

create table order_status (
	order_status_id INT AUTO_INCREMENT PRIMARY KEY,
    order_status_name VARCHAR(50) NOT NULL
);

create table customer_order (
	order_number INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME,
    order_status_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE,
    FOREIGN KEY (order_status_id) REFERENCES order_status (order_status_id) ON DELETE CASCADE
);

create table shipping_information (
	shipping_information_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	shipping_country VARCHAR (50) NOT NULL,
    shipping_state VARCHAR (50) NOT NULL,
    shipping_city VARCHAR (50) NOT NULL,
    shipping_street VARCHAR (50) NOT NULL,
    shipping_zip VARCHAR (12) NOT NULL,
    recipient_first_name VARCHAR (50) NOT NULL,
    recipient_last_name VARCHAR (50) NOT NULL,
    recipient_phone VARCHAR (15) NOT NULL
);

create table order_details (
	order_details_id INT AUTO_INCREMENT PRIMARY KEY,
    shipping_information_id INT NOT NULL,
    order_number INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(7,2),
    payment_id INT NOT NULL,
    FOREIGN KEY (order_number) REFERENCES customer_order (order_number) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES payment (payment_id) ON DELETE CASCADE,
    FOREIGN KEY (shipping_information_id) REFERENCES shipping_information (shipping_information_id) ON DELETE CASCADE
);

insert into customer values (NULL, "admin", "admin@gmail.com", "adminadmin", 1);

insert into order_status values (NULL, "In Progress");
insert into order_status values (NULL, "Package has been sent");
insert into order_status values (NULL, "Order Completed");

INSERT into product_size VALUES (1, "XS");
INSERT into product_size VALUES (2, "S");
INSERT into product_size VALUES (3, "M");
INSERT into product_size VALUES (4, "L");
INSERT into product_size VALUES (5, "XL");
INSERT into product_size VALUES (6, "XLL");

INSERT INTO gender VALUES (1, "Male");
INSERT INTO gender VALUES (2, "Female");
INSERT INTO gender VALUES (3, "Unisex");

INSERT INTO material VALUES(1, "Cotton");
INSERT INTO material VALUES(2, "Polyester");
INSERT INTO material VALUES(3, "Leather");
INSERT INTO material VALUES(4, "Wood");
INSERT INTO material VALUES(5, "Metal");
INSERT INTO material VALUES(6, "Αluminum");

INSERT INTO category VALUES (1, "Clothes", "https://i.imgur.com/Vlcpdxi.png");
INSERT INTO category VALUES (2, "Accessories", "https://i.imgur.com/UxsMKyy.png");
INSERT INTO category VALUES (3, "Board Games", "");
INSERT INTO category VALUES (4, "Other", "");

INSERT INTO subcategory VALUES (1, 1, "TShirt", "https://i.ibb.co/R3jGHb9/tshirt-white-1.jpg");
INSERT INTO subcategory VALUES (2, 1, "Sweatshirt", "https://i.ibb.co/3c3LzBW/Basic-Hoodie-Blue.png");
INSERT INTO subcategory VALUES (3, 1, "Jacket", "https://i.ibb.co/5vvF0zH/12165161-Light-Grey-Melange-001-Product-Large.jpg");
INSERT INTO subcategory VALUES (4, 2, "Keychain", "https://i.ibb.co/WnG3F5s/queen-keychain-1.jpg");
INSERT INTO subcategory VALUES (5, 4, "Mousepad", "https://i.ibb.co/mc424QS/design-mouse-pad-1.jpg");
INSERT INTO subcategory VALUES (6, 3, "Chess Board Game", "https://i.ibb.co/M1LZSL7/21-staunton-ebony-chess-1.jpg");

INSERT INTO color VALUES (1, "black", "");
INSERT INTO color VALUES (2, "white", "");
INSERT INTO color VALUES (3, "blue", "");
INSERT INTO color VALUES (4, "skyblue", "");
INSERT INTO color VALUES (5, "navy", "");
INSERT INTO color VALUES (6, "red", "");
INSERT INTO color VALUES (7, "pink", "");
INSERT INTO color VALUES (8, "fuchsia", "");
INSERT INTO color VALUES (9, "purple", "");
INSERT INTO color VALUES (10, "grey", "");
INSERT INTO color VALUES (11, "dimgray", "");

-- Black TShirt all sizes
insert into product values (NULL, 1, "Simple TShirt", 1, 1, 1, 1, 8, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 1, 2, 1, 1, 5, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 1, 3, 1, 1, 1, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 1, 4, 1, 1, 2, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 1, 5, 1, 1, 2, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 1, 6, 1, 1, 8, 19.99);

-- Charcoal TShirt no M
insert into product values (NULL, 1, "Simple TShirt", 11, 1, 1, 1, 8, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 11, 2, 1, 1, 5, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 11, 3, 1, 1, 0, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 11, 4, 1, 1, 2, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 11, 5, 1, 1, 2, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 11, 6, 1, 1, 8, 19.99);

-- White TShirt no XLL
insert into product values (NULL, 1, "Simple TShirt", 2, 1, 1, 1, 5, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 2, 2, 1, 1, 3, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 2, 3, 1, 1, 1, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 2, 4, 1, 1, 1, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 2, 5, 1, 1, 2, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 2, 6, 1, 1, 0, 19.99);

-- Skyblue TShirt only in S
insert into product values (NULL, 1, "Simple TShirt", 4, 1, 1, 1, 0, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 4, 2, 1, 1, 2, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 4, 3, 1, 1, 0, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 4, 4, 1, 1, 0, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 4, 5, 1, 1, 0, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 4, 6, 1, 1, 0, 19.99);

-- Navy TShirt all sizes
insert into product values (NULL, 1, "Simple TShirt", 5, 1, 1, 1, 2, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 5, 2, 1, 1, 4, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 5, 3, 1, 1, 2, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 5, 4, 1, 1, 1, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 5, 5, 1, 1, 5, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 5, 6, 1, 1, 3, 19.99);

-- Red TShirt all sizes
insert into product values (NULL, 1, "Simple TShirt", 6, 1, 1, 1, 2, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 6, 2, 1, 1, 4, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 6, 3, 1, 1, 2, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 6, 4, 1, 1, 1, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 6, 5, 1, 1, 5, 19.99);
insert into product values (NULL, 1, "Simple TShirt", 6, 6, 1, 1, 3, 19.99);

-- Black TShirt
insert into product_image values (NULL, "https://i.ibb.co/DVyNFmW/tshirt-black-1.jpg", 1);
insert into product_image values (NULL, "https://i.ibb.co/dWzVsTm/tshirt-black-2.jpg", 1);
insert into product_image values (NULL, "https://i.ibb.co/DVyNFmW/tshirt-black-1.jpg", 2);
insert into product_image values (NULL, "https://i.ibb.co/dWzVsTm/tshirt-black-2.jpg", 2);
insert into product_image values (NULL, "https://i.ibb.co/DVyNFmW/tshirt-black-1.jpg", 3);
insert into product_image values (NULL, "https://i.ibb.co/dWzVsTm/tshirt-black-2.jpg", 3);
insert into product_image values (NULL, "https://i.ibb.co/DVyNFmW/tshirt-black-1.jpg", 4);
insert into product_image values (NULL, "https://i.ibb.co/dWzVsTm/tshirt-black-2.jpg", 4);
insert into product_image values (NULL, "https://i.ibb.co/DVyNFmW/tshirt-black-1.jpg", 5);
insert into product_image values (NULL, "https://i.ibb.co/dWzVsTm/tshirt-black-2.jpg", 5);
insert into product_image values (NULL, "https://i.ibb.co/DVyNFmW/tshirt-black-1.jpg", 6);
insert into product_image values (NULL, "https://i.ibb.co/dWzVsTm/tshirt-black-2.jpg", 6);
insert into product_image values (NULL, "https://i.ibb.co/DVyNFmW/tshirt-black-1.jpg", 7);
insert into product_image values (NULL, "https://i.ibb.co/dWzVsTm/tshirt-black-2.jpg", 7);

-- Charcoal TShirt
insert into product_image values (NULL, "https://i.ibb.co/k6XhrQD/tshirt-charcoal-1.jpg", 7);
insert into product_image values (NULL, "https://i.ibb.co/vk3HbN3/tshirt-charcoal-2.jpg", 7);
insert into product_image values (NULL, "https://i.ibb.co/k6XhrQD/tshirt-charcoal-1.jpg", 8);
insert into product_image values (NULL, "https://i.ibb.co/vk3HbN3/tshirt-charcoal-2.jpg", 8);
insert into product_image values (NULL, "https://i.ibb.co/k6XhrQD/tshirt-charcoal-1.jpg", 9);
insert into product_image values (NULL, "https://i.ibb.co/vk3HbN3/tshirt-charcoal-2.jpg", 9);
insert into product_image values (NULL, "https://i.ibb.co/k6XhrQD/tshirt-charcoal-1.jpg", 10);
insert into product_image values (NULL, "https://i.ibb.co/vk3HbN3/tshirt-charcoal-2.jpg", 10);
insert into product_image values (NULL, "https://i.ibb.co/k6XhrQD/tshirt-charcoal-1.jpg", 11);
insert into product_image values (NULL, "https://i.ibb.co/vk3HbN3/tshirt-charcoal-2.jpg", 11);
insert into product_image values (NULL, "https://i.ibb.co/k6XhrQD/tshirt-charcoal-1.jpg", 12);
insert into product_image values (NULL, "https://i.ibb.co/vk3HbN3/tshirt-charcoal-2.jpg", 12);

-- White TShirt
insert into product_image values (NULL, "https://i.ibb.co/R3jGHb9/tshirt-white-1.jpg", 13);
insert into product_image values (NULL, "https://i.ibb.co/PgHN31w/tshirt-white-2.jpg", 13);
insert into product_image values (NULL, "https://i.ibb.co/R3jGHb9/tshirt-white-1.jpg", 14);
insert into product_image values (NULL, "https://i.ibb.co/PgHN31w/tshirt-white-2.jpg", 14);
insert into product_image values (NULL, "https://i.ibb.co/R3jGHb9/tshirt-white-1.jpg", 15);
insert into product_image values (NULL, "https://i.ibb.co/PgHN31w/tshirt-white-2.jpg", 15);
insert into product_image values (NULL, "https://i.ibb.co/R3jGHb9/tshirt-white-1.jpg", 16);
insert into product_image values (NULL, "https://i.ibb.co/PgHN31w/tshirt-white-2.jpg", 16);
insert into product_image values (NULL, "https://i.ibb.co/R3jGHb9/tshirt-white-1.jpg", 17);
insert into product_image values (NULL, "https://i.ibb.co/PgHN31w/tshirt-white-2.jpg", 17);
insert into product_image values (NULL, "https://i.ibb.co/R3jGHb9/tshirt-white-1.jpg", 18);
insert into product_image values (NULL, "https://i.ibb.co/PgHN31w/tshirt-white-2.jpg", 18);

-- Skyblue TShirt
insert into product_image values (NULL, "https://i.ibb.co/94sMn2k/tshirt-skyblue-1.jpg", 19);
insert into product_image values (NULL, "https://i.ibb.co/rpCpnKT/tshirt-skyblue-2.jpg", 19);
insert into product_image values (NULL, "https://i.ibb.co/94sMn2k/tshirt-skyblue-1.jpg", 20);
insert into product_image values (NULL, "https://i.ibb.co/rpCpnKT/tshirt-skyblue-2.jpg", 20);
insert into product_image values (NULL, "https://i.ibb.co/94sMn2k/tshirt-skyblue-1.jpg", 21);
insert into product_image values (NULL, "https://i.ibb.co/rpCpnKT/tshirt-skyblue-2.jpg", 21);
insert into product_image values (NULL, "https://i.ibb.co/94sMn2k/tshirt-skyblue-1.jpg", 22);
insert into product_image values (NULL, "https://i.ibb.co/rpCpnKT/tshirt-skyblue-2.jpg", 22);
insert into product_image values (NULL, "https://i.ibb.co/94sMn2k/tshirt-skyblue-1.jpg", 23);
insert into product_image values (NULL, "https://i.ibb.co/rpCpnKT/tshirt-skyblue-2.jpg", 23);
insert into product_image values (NULL, "https://i.ibb.co/94sMn2k/tshirt-skyblue-1.jpg", 24);
insert into product_image values (NULL, "https://i.ibb.co/rpCpnKT/tshirt-skyblue-2.jpg", 24);

-- Navy Blue
insert into product_image values (NULL, "https://i.ibb.co/dLzFwYp/tshirt-navy-blue.jpg", 25);
insert into product_image values (NULL, "https://i.ibb.co/0V0cTGF/tshirt-navy-blue-2.jpg", 25);
insert into product_image values (NULL, "https://i.ibb.co/dLzFwYp/tshirt-navy-blue.jpg", 26);
insert into product_image values (NULL, "https://i.ibb.co/0V0cTGF/tshirt-navy-blue-2.jpg", 26);
insert into product_image values (NULL, "https://i.ibb.co/dLzFwYp/tshirt-navy-blue.jpg", 27);
insert into product_image values (NULL, "https://i.ibb.co/0V0cTGF/tshirt-navy-blue-2.jpg", 27);
insert into product_image values (NULL, "https://i.ibb.co/dLzFwYp/tshirt-navy-blue.jpg", 28);
insert into product_image values (NULL, "https://i.ibb.co/0V0cTGF/tshirt-navy-blue-2.jpg", 28);
insert into product_image values (NULL, "https://i.ibb.co/dLzFwYp/tshirt-navy-blue.jpg", 29);
insert into product_image values (NULL, "https://i.ibb.co/0V0cTGF/tshirt-navy-blue-2.jpg", 29);
insert into product_image values (NULL, "https://i.ibb.co/dLzFwYp/tshirt-navy-blue.jpg", 30);
insert into product_image values (NULL, "https://i.ibb.co/0V0cTGF/tshirt-navy-blue-2.jpg", 30);

-- Red Tshirt
insert into product_image values (NULL, "https://i.ibb.co/MBgcQ3n/tshirt-red-1.jpg", 31);
insert into product_image values (NULL, "https://i.ibb.co/hWDSvsS/tshirt-red-2.jpg", 31);
insert into product_image values (NULL, "https://i.ibb.co/MBgcQ3n/tshirt-red-1.jpg", 32);
insert into product_image values (NULL, "https://i.ibb.co/hWDSvsS/tshirt-red-2.jpg", 32);
insert into product_image values (NULL, "https://i.ibb.co/MBgcQ3n/tshirt-red-1.jpg", 33);
insert into product_image values (NULL, "https://i.ibb.co/hWDSvsS/tshirt-red-2.jpg", 33);
insert into product_image values (NULL, "https://i.ibb.co/MBgcQ3n/tshirt-red-1.jpg", 34);
insert into product_image values (NULL, "https://i.ibb.co/hWDSvsS/tshirt-red-2.jpg", 34);
insert into product_image values (NULL, "https://i.ibb.co/MBgcQ3n/tshirt-red-1.jpg", 35);
insert into product_image values (NULL, "https://i.ibb.co/hWDSvsS/tshirt-red-2.jpg", 35);
insert into product_image values (NULL, "https://i.ibb.co/MBgcQ3n/tshirt-red-1.jpg", 36);
insert into product_image values (NULL, "https://i.ibb.co/hWDSvsS/tshirt-red-2.jpg", 36);

-- Black all sizes
insert into product values (NULL, 2, "Simple Hoodie", 1, 1, 1, 1, 8, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 1, 2, 1, 1, 5, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 1, 3, 1, 1, 1, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 1, 4, 1, 1, 2, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 1, 5, 1, 1, 2, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 1, 6, 1, 1, 8, 29.99);

-- White all sizes
insert into product values (NULL, 2, "Simple Hoodie", 2, 1, 1, 1, 5, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 2, 2, 1, 1, 3, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 2, 3, 1, 1, 1, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 2, 4, 1, 1, 1, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 2, 5, 1, 1, 2, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 2, 6, 1, 1, 2, 29.99);

-- Navy all sizes
insert into product values (NULL, 2, "Simple Hoodie", 5, 1, 1, 1, 2, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 5, 2, 1, 1, 15, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 5, 3, 1, 1, 3, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 5, 4, 1, 1, 3, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 5, 5, 1, 1, 3, 29.99);
insert into product values (NULL, 2, "Simple Hoodie", 5, 6, 1, 1, 2, 29.99);

-- Black Hoodie
insert into product_image values (NULL, "https://i.ibb.co/W00d2cp/Basic-Hoodie-Black-1.png", 37);
insert into product_image values (NULL, "https://i.ibb.co/5kqYgQN/Basic-Hoodie-Black-2.jpg", 37);
insert into product_image values (NULL, "https://i.ibb.co/W00d2cp/Basic-Hoodie-Black-1.png", 38);
insert into product_image values (NULL, "https://i.ibb.co/5kqYgQN/Basic-Hoodie-Black-2.jpg", 38);
insert into product_image values (NULL, "https://i.ibb.co/W00d2cp/Basic-Hoodie-Black-1.png", 39);
insert into product_image values (NULL, "https://i.ibb.co/5kqYgQN/Basic-Hoodie-Black-2.jpg", 39);
insert into product_image values (NULL, "https://i.ibb.co/W00d2cp/Basic-Hoodie-Black-1.png", 40);
insert into product_image values (NULL, "https://i.ibb.co/5kqYgQN/Basic-Hoodie-Black-2.jpg", 40);
insert into product_image values (NULL, "https://i.ibb.co/W00d2cp/Basic-Hoodie-Black-1.png", 41);
insert into product_image values (NULL, "https://i.ibb.co/5kqYgQN/Basic-Hoodie-Black-2.jpg", 41);
insert into product_image values (NULL, "https://i.ibb.co/W00d2cp/Basic-Hoodie-Black-1.png", 42);
insert into product_image values (NULL, "https://i.ibb.co/5kqYgQN/Basic-Hoodie-Black-2.jpg", 42);

-- White Hoodie
insert into product_image values (NULL, "https://i.ibb.co/1sM4G7j/Basic-Hoodie-White-1.jpg", 43);
insert into product_image values (NULL, "https://i.ibb.co/9p1pqxX/Basic-Hoodie-White-2.jpg", 43);
insert into product_image values (NULL, "https://i.ibb.co/1sM4G7j/Basic-Hoodie-White-1.jpg", 44);
insert into product_image values (NULL, "https://i.ibb.co/9p1pqxX/Basic-Hoodie-White-2.jpg", 44);
insert into product_image values (NULL, "https://i.ibb.co/1sM4G7j/Basic-Hoodie-White-1.jpg", 45);
insert into product_image values (NULL, "https://i.ibb.co/9p1pqxX/Basic-Hoodie-White-2.jpg", 45);
insert into product_image values (NULL, "https://i.ibb.co/1sM4G7j/Basic-Hoodie-White-1.jpg", 46);
insert into product_image values (NULL, "https://i.ibb.co/9p1pqxX/Basic-Hoodie-White-2.jpg", 46);
insert into product_image values (NULL, "https://i.ibb.co/1sM4G7j/Basic-Hoodie-White-1.jpg", 47);
insert into product_image values (NULL, "https://i.ibb.co/9p1pqxX/Basic-Hoodie-White-2.jpg", 47);
insert into product_image values (NULL, "https://i.ibb.co/1sM4G7j/Basic-Hoodie-White-1.jpg", 48);
insert into product_image values (NULL, "https://i.ibb.co/9p1pqxX/Basic-Hoodie-White-2.jpg", 48);

-- Blue Hoodie
insert into product_image values (NULL, "https://i.ibb.co/3c3LzBW/Basic-Hoodie-Blue.png", 49);
insert into product_image values (NULL, "https://i.ibb.co/StyjJkt/Basic-Hoodie-Blue.jpg", 49);
insert into product_image values (NULL, "https://i.ibb.co/3c3LzBW/Basic-Hoodie-Blue.png", 50);
insert into product_image values (NULL, "https://i.ibb.co/StyjJkt/Basic-Hoodie-Blue.jpg", 50);
insert into product_image values (NULL, "https://i.ibb.co/3c3LzBW/Basic-Hoodie-Blue.png", 51);
insert into product_image values (NULL, "https://i.ibb.co/StyjJkt/Basic-Hoodie-Blue.jpg", 51);
insert into product_image values (NULL, "https://i.ibb.co/3c3LzBW/Basic-Hoodie-Blue.png", 52);
insert into product_image values (NULL, "https://i.ibb.co/StyjJkt/Basic-Hoodie-Blue.jpg", 52);
insert into product_image values (NULL, "https://i.ibb.co/3c3LzBW/Basic-Hoodie-Blue.png", 53);
insert into product_image values (NULL, "https://i.ibb.co/StyjJkt/Basic-Hoodie-Blue.jpg", 53);
insert into product_image values (NULL, "https://i.ibb.co/3c3LzBW/Basic-Hoodie-Blue.png", 54);
insert into product_image values (NULL, "https://i.ibb.co/StyjJkt/Basic-Hoodie-Blue.jpg", 54);

-- Grey in XS, S, XLL
insert into product values (NULL, 3, "Simple Jacket", 10, 1, 1, 1, 1, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 10, 2, 1, 1, 2, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 10, 3, 1, 1, 0, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 10, 4, 1, 1, 0, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 10, 5, 1, 1, 0, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 10, 6, 1, 1, 1, 49.99);

-- Black in XS, XLL
insert into product values (NULL, 3, "Simple Jacket", 1, 1, 1, 1, 1, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 1, 2, 1, 1, 0, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 1, 3, 1, 1, 0, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 1, 4, 1, 1, 0, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 1, 5, 1, 1, 0, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 1, 6, 1, 1, 1, 49.99);

-- Blue in XLL
insert into product values (NULL, 3, "Simple Jacket", 3, 1, 1, 1, 0, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 3, 2, 1, 1, 0, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 3, 3, 1, 1, 0, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 3, 4, 1, 1, 0, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 3, 5, 1, 1, 0, 49.99);
insert into product values (NULL, 3, "Simple Jacket", 3, 6, 1, 1, 1, 49.99);

-- Grey Jacket
insert into product_image values (NULL, "https://i.ibb.co/5vvF0zH/12165161-Light-Grey-Melange-001-Product-Large.jpg", 55);
insert into product_image values (NULL, "https://i.ibb.co/fF9ZCqc/12165161-Light-Grey-Melange-002-Product-Large.jpg", 55);
insert into product_image values (NULL, "https://i.ibb.co/5vvF0zH/12165161-Light-Grey-Melange-001-Product-Large.jpg", 56);
insert into product_image values (NULL, "https://i.ibb.co/fF9ZCqc/12165161-Light-Grey-Melange-002-Product-Large.jpg", 56);
insert into product_image values (NULL, "https://i.ibb.co/5vvF0zH/12165161-Light-Grey-Melange-001-Product-Large.jpg", 57);
insert into product_image values (NULL, "https://i.ibb.co/fF9ZCqc/12165161-Light-Grey-Melange-002-Product-Large.jpg", 57);
insert into product_image values (NULL, "https://i.ibb.co/5vvF0zH/12165161-Light-Grey-Melange-001-Product-Large.jpg", 58);
insert into product_image values (NULL, "https://i.ibb.co/fF9ZCqc/12165161-Light-Grey-Melange-002-Product-Large.jpg", 58);
insert into product_image values (NULL, "https://i.ibb.co/5vvF0zH/12165161-Light-Grey-Melange-001-Product-Large.jpg", 59);
insert into product_image values (NULL, "https://i.ibb.co/fF9ZCqc/12165161-Light-Grey-Melange-002-Product-Large.jpg", 59);
insert into product_image values (NULL, "https://i.ibb.co/5vvF0zH/12165161-Light-Grey-Melange-001-Product-Large.jpg", 60);
insert into product_image values (NULL, "https://i.ibb.co/fF9ZCqc/12165161-Light-Grey-Melange-002-Product-Large.jpg", 60);

-- Black Jacket
insert into product_image values (NULL, "https://i.ibb.co/MSSdv1w/12165161-Black-001-Product-Large-1-1.jpg", 61);
insert into product_image values (NULL, "https://i.ibb.co/9Vp0yRm/12165161-Black-001-Product-Large.jpg", 61);
insert into product_image values (NULL, "https://i.ibb.co/MSSdv1w/12165161-Black-001-Product-Large-1-1.jpg", 62);
insert into product_image values (NULL, "https://i.ibb.co/9Vp0yRm/12165161-Black-001-Product-Large.jpg", 62);
insert into product_image values (NULL, "https://i.ibb.co/MSSdv1w/12165161-Black-001-Product-Large-1-1.jpg", 63);
insert into product_image values (NULL, "https://i.ibb.co/9Vp0yRm/12165161-Black-001-Product-Large.jpg", 63);
insert into product_image values (NULL, "https://i.ibb.co/MSSdv1w/12165161-Black-001-Product-Large-1-1.jpg", 64);
insert into product_image values (NULL, "https://i.ibb.co/9Vp0yRm/12165161-Black-001-Product-Large.jpg", 64);
insert into product_image values (NULL, "https://i.ibb.co/MSSdv1w/12165161-Black-001-Product-Large-1-1.jpg", 65);
insert into product_image values (NULL, "https://i.ibb.co/9Vp0yRm/12165161-Black-001-Product-Large.jpg", 65);
insert into product_image values (NULL, "https://i.ibb.co/MSSdv1w/12165161-Black-001-Product-Large-1-1.jpg", 66);
insert into product_image values (NULL, "https://i.ibb.co/9Vp0yRm/12165161-Black-001-Product-Large.jpg", 66);

-- Blue Jacket
insert into product_image values (NULL, "https://i.ibb.co/d4h8ZCz/12165161-Surfthe-Web-001-Product-Large.jpg", 67);
insert into product_image values (NULL, "https://i.ibb.co/Fnjy6Bc/12165161-Surfthe-Web-002-Product-Large.jpg", 67);
insert into product_image values (NULL, "https://i.ibb.co/d4h8ZCz/12165161-Surfthe-Web-001-Product-Large.jpg", 68);
insert into product_image values (NULL, "https://i.ibb.co/Fnjy6Bc/12165161-Surfthe-Web-002-Product-Large.jpg", 68);
insert into product_image values (NULL, "https://i.ibb.co/d4h8ZCz/12165161-Surfthe-Web-001-Product-Large.jpg", 69);
insert into product_image values (NULL, "https://i.ibb.co/Fnjy6Bc/12165161-Surfthe-Web-002-Product-Large.jpg", 69);
insert into product_image values (NULL, "https://i.ibb.co/d4h8ZCz/12165161-Surfthe-Web-001-Product-Large.jpg", 70);
insert into product_image values (NULL, "https://i.ibb.co/Fnjy6Bc/12165161-Surfthe-Web-002-Product-Large.jpg", 70);
insert into product_image values (NULL, "https://i.ibb.co/d4h8ZCz/12165161-Surfthe-Web-001-Product-Large.jpg", 71);
insert into product_image values (NULL, "https://i.ibb.co/Fnjy6Bc/12165161-Surfthe-Web-002-Product-Large.jpg", 71);
insert into product_image values (NULL, "https://i.ibb.co/d4h8ZCz/12165161-Surfthe-Web-001-Product-Large.jpg", 72);
insert into product_image values (NULL, "https://i.ibb.co/Fnjy6Bc/12165161-Surfthe-Web-002-Product-Large.jpg", 72);

-- *************************************************************** Nikos
insert into color values (null, "yellow", "");
insert into color values (null, "purple", "");
insert into color values (null, "green", "");
insert into color values (null, "natural", "");
-- insert into color values (null, "nickel", "");
-- insert into color values (null, "bronze", "");
insert into color values (null, "turquoise","");
-- insert into color values (null, "silver","");

-- -- -- -- -- -- extra materials
INSERT INTO material VALUES(NULL, "gold");
INSERT INTO material VALUES(NULL, "silver");
INSERT INTO material VALUES(NULL, "nickel");
INSERT INTO material VALUES(NULL, "plastic");
INSERT INTO material VALUES(NULL, "bronze");


-- -- -- -- -- -- --   mousepads color=natural, all sizes 

insert into product values (NULL, 4, "design-mouse-pad-1", 1, 1, 2, 3, 12, 18.99);
insert into product values (NULL, 4, "design-mouse-pad-1", 1, 2, 2, 3, 12, 18.99);
insert into product values (NULL, 4, "design-mouse-pad-1", 1, 3, 2, 3, 12, 18.99);
insert into product values (NULL, 4, "design-mouse-pad-1", 1, 4, 2, 3, 12, 18.99);
insert into product values (NULL, 4, "design-mouse-pad-1", 1, 5, 2, 3, 12, 18.99);
insert into product values (NULL, 4, "design-mouse-pad-1", 1, 6, 2, 3, 12, 18.99);

insert into product values (NULL, 4, "simple-mouse-pad-2", 1, 1, 2, 3, 12, 8.99);
insert into product values (NULL, 4, "simple-mouse-pad-2", 1, 2, 2, 3, 12, 8.99);
insert into product values (NULL, 4, "simple-mouse-pad-2", 1, 3, 2, 3, 12, 8.99);
insert into product values (NULL, 4, "simple-mouse-pad-2", 1, 4, 2, 3, 12, 8.99);
insert into product values (NULL, 4, "simple-mouse-pad-2", 1, 5, 2, 3, 12, 8.99);
insert into product values (NULL, 4, "simple-mouse-pad-2", 1, 6, 2, 3, 12, 8.99);

-- -- -- -- -- -- --  mousepad imgs 

insert into product_image values (NULL, "https://i.ibb.co/mc424QS/design-mouse-pad-1.jpg", 73);
insert into product_image values (NULL, "https://i.ibb.co/99kYhPG/design-mouse-pad-2.jpg", 73);
insert into product_image values (NULL, "https://i.ibb.co/mc424QS/design-mouse-pad-1.jpg", 74);
insert into product_image values (NULL, "https://i.ibb.co/99kYhPG/design-mouse-pad-2.jpg", 74);
insert into product_image values (NULL, "https://i.ibb.co/mc424QS/design-mouse-pad-1.jpg", 75);
insert into product_image values (NULL, "https://i.ibb.co/99kYhPG/design-mouse-pad-2.jpg", 75);
insert into product_image values (NULL, "https://i.ibb.co/mc424QS/design-mouse-pad-1.jpg", 76);
insert into product_image values (NULL, "https://i.ibb.co/99kYhPG/design-mouse-pad-2.jpg", 76);
insert into product_image values (NULL, "https://i.ibb.co/mc424QS/design-mouse-pad-1.jpg", 77);
insert into product_image values (NULL, "https://i.ibb.co/99kYhPG/design-mouse-pad-2.jpg", 77);
insert into product_image values (NULL, "https://i.ibb.co/mc424QS/design-mouse-pad-1.jpg", 78);
insert into product_image values (NULL, "https://i.ibb.co/99kYhPG/design-mouse-pad-2.jpg", 78);
insert into product_image values (NULL, "https://i.ibb.co/8syjX9t/simple-mouse-pad-1.jpg", 79);
insert into product_image values (NULL, "https://i.ibb.co/8xL7pp2/simple-mouse-pad-2.jpg", 79);
insert into product_image values (NULL, "https://i.ibb.co/8syjX9t/simple-mouse-pad-1.jpg", 80);
insert into product_image values (NULL, "https://i.ibb.co/8xL7pp2/simple-mouse-pad-2.jpg", 80);
insert into product_image values (NULL, "https://i.ibb.co/8syjX9t/simple-mouse-pad-1.jpg", 81);
insert into product_image values (NULL, "https://i.ibb.co/8xL7pp2/simple-mouse-pad-2.jpg", 81);
insert into product_image values (NULL, "https://i.ibb.co/8syjX9t/simple-mouse-pad-1.jpg", 82);
insert into product_image values (NULL, "https://i.ibb.co/8xL7pp2/simple-mouse-pad-2.jpg", 82);
insert into product_image values (NULL, "https://i.ibb.co/8syjX9t/simple-mouse-pad-1.jpg", 83);
insert into product_image values (NULL, "https://i.ibb.co/8xL7pp2/simple-mouse-pad-2.jpg", 83);
insert into product_image values (NULL, "https://i.ibb.co/8syjX9t/simple-mouse-pad-1.jpg", 84);
insert into product_image values (NULL, "https://i.ibb.co/8xL7pp2/simple-mouse-pad-2.jpg", 84);

-- -- -- -- -- -- -- keychains 

insert into product values (NULL, 3, "couple-keychain", 15, 1, 4, 3, 7, 4.99);
insert into product values (NULL, 3, "king-keychain", 15, 2, 5, 3, 4, 4.99);
insert into product values (NULL, 3, "queen-keychain", 15, 3, 5, 3, 9, 4.99);
insert into product values (NULL, 3, "rosewood-keychain", 15, 4, 5, 3, 1, 4.99);
insert into product values (NULL, 3, "weapon-keychain", 12, 5, 6, 3, 3, 4.99);

-- -- -- -- -- -- keychain imgs

insert into product_image values (NULL, "https://i.ibb.co/Y7t8QKx/couple-keychain-1.jpg", 85);
insert into product_image values (NULL, "https://i.ibb.co/FwJc6Qh/couple-keychain-2.jpg", 85);
insert into product_image values (NULL, "https://i.ibb.co/jb8nWfB/king-keychain-1.jpg", 86);
insert into product_image values (NULL, "https://i.ibb.co/939p4Gm/king-keychain-2.jpg", 86);
insert into product_image values (NULL, "https://i.ibb.co/WnG3F5s/queen-keychain-1.jpg", 87);
insert into product_image values (NULL, "https://i.ibb.co/mNrzkbD/queen-keychain-2.jpg", 87);
insert into product_image values (NULL, "https://i.ibb.co/zH7TcFX/rosewood-keychain-1.jpg", 88);
insert into product_image values (NULL, "https://i.ibb.co/v1nQgy3/rosewood-keychain-2.jpg", 88);
insert into product_image values (NULL, "https://i.ibb.co/fQkfrZ7/weapon-keychain-1.jpg", 89);
insert into product_image values (NULL, "https://i.ibb.co/q91Q8Hk/weapon-keychain-2.jpg", 89);


-- -- -- -- -- -- chessboard
insert into product values (NULL, 5, "bauhaus-chess", 15, 4, 4, 3, 3, 673.54);
insert into product values (NULL, 5, "staunton-ebony-chess", 15, 3, 4, 3, 4, 415.27);
insert into product values (NULL, 5, "magnetic-storage-chess", 15, 2, 4, 3, 1, 32.79);
insert into product values (NULL, 5, "man-ray-chess", 15, 4, 4, 3, 3, 727.39);
insert into product values (NULL, 5, "gold-and-silver-egyptian-chess", 15, 3, 4, 3, 1, 583);
insert into product values (NULL, 5, "designer-chess", 15, 5, 4, 3, 4, 396);
insert into product values (NULL, 5, "crusades-chess", 15, 2, 8, 3, 13, 1415.99);

-- -- -- -- -- -- chessboard imgs
insert into product_image values (NULL, "https://i.ibb.co/YRTxDp8/bauhaus-chess-1.jpg", 90);
insert into product_image values (NULL, "https://i.ibb.co/bKrmj2F/bauhaus-chess-2.jpg", 90);
insert into product_image values (NULL, "https://i.ibb.co/M1LZSL7/21-staunton-ebony-chess-1.jpg", 91);
insert into product_image values (NULL, "https://i.ibb.co/GR8bJxV/21-staunton-ebony-chess-2.jpg", 91);
insert into product_image values (NULL, "https://i.ibb.co/88qLWxQ/7-5-magnetic-storage-chess-1.png", 92);
insert into product_image values (NULL, "https://i.ibb.co/rF8H0xB/7-5-magnetic-storage-chess-2.png", 92);
insert into product_image values (NULL, "https://i.ibb.co/BVYxgVJ/man-ray-chess-1.jpg", 93);
insert into product_image values (NULL, "https://i.ibb.co/Khb5HW1/man-ray-chess-2.jpg", 93);
insert into product_image values (NULL, "https://i.ibb.co/2Pcm7mf/gold-and-silver-egyptian-chess-1.jpg", 94);
insert into product_image values (NULL, "https://i.ibb.co/FHxT0yX/gold-and-silver-egyptian-chess-2.jpg", 94);
insert into product_image values (NULL, "https://i.ibb.co/mc424QS/design-mouse-pad-1.jpg", 95);
insert into product_image values (NULL, "https://i.ibb.co/99kYhPG/design-mouse-pad-2.jpg", 95);
insert into product_image values (NULL, "https://i.ibb.co/Js2DQBb/crusades-chess-1.jpg", 96);
insert into product_image values (NULL, "https://i.ibb.co/WDN953J/crusades-chess-2.jpg", 96);


-- -- -- -- -- -- --  Pink TShirt all sizes
insert into product values (NULL, 1, "pink-tshirt", 7, 1, 1, 2, 8, 23.99);
insert into product values (NULL, 1, "pink-tshirt", 7, 2, 1, 2, 5, 23.99);
insert into product values (NULL, 1, "pink-tshirt", 7, 3, 1, 2, 1, 23.99);
insert into product values (NULL, 1, "pink-tshirt", 7, 4, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "pink-tshirt", 7, 5, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "pink-tshirt", 7, 6, 1, 2, 8, 23.99);

-- -- -- -- -- -- --  fuchsia TShirt all sizes
insert into product values (NULL, 1, "fuchsia-tshirt", 8, 1, 1, 2, 8, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 8, 2, 1, 2, 5, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 8, 3, 1, 2, 1, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 8, 4, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 8, 5, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 8, 6, 1, 2, 8, 23.99);

-- -- -- -- -- -- --  black TShirt all sizes
insert into product values (NULL, 1, "fuchsia-tshirt", 1, 1, 1, 2, 8, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 1, 2, 1, 2, 5, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 1, 3, 1, 2, 1, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 1, 4, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 1, 5, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 1, 6, 1, 2, 8, 23.99);

-- -- -- -- -- -- --  green TShirt all sizes
insert into product values (NULL, 1, "fuchsia-tshirt", 14, 1, 1, 2, 8, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 14, 2, 1, 2, 5, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 14, 3, 1, 2, 1, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 14, 4, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 14, 5, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 14, 6, 1, 2, 8, 23.99);

-- -- -- -- -- -- --  red TShirt all sizes
insert into product values (NULL, 1, "fuchsia-tshirt", 6, 1, 1, 2, 8, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 6, 2, 1, 2, 5, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 6, 3, 1, 2, 1, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 6, 4, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 6, 5, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 6, 6, 1, 2, 8, 23.99);

-- -- -- -- -- -- --  blue TShirt all sizes
insert into product values (NULL, 1, "fuchsia-tshirt", 3, 1, 1, 2, 8, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 3, 2, 1, 2, 5, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 3, 3, 1, 2, 1, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 3, 4, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 3, 5, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 3, 6, 1, 2, 8, 23.99);

-- -- -- -- -- -- --  white TShirt all sizes
insert into product values (NULL, 1, "fuchsia-tshirt", 2, 1, 1, 2, 8, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 2, 2, 1, 2, 5, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 2, 3, 1, 2, 1, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 2, 4, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 2, 5, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 2, 6, 1, 2, 8, 23.99);

-- -- -- -- -- -- -- yellow TShirt all sizes
insert into product values (NULL, 1, "fuchsia-tshirt", 12, 1, 1, 2, 8, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 12, 2, 1, 2, 5, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 12, 3, 1, 2, 1, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 12, 4, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 12, 5, 1, 2, 2, 23.99);
insert into product values (NULL, 1, "fuchsia-tshirt", 12, 6, 1, 2, 8, 23.99);

-- -- -- -- -- --  Purple sweathirt all sizes
insert into product values (NULL, 1, "purple-hoodie", 13, 1, 1, 2, 8, 33.99);
insert into product values (NULL, 1, "purple-hoodie", 13, 2, 1, 2, 5, 33.99);
insert into product values (NULL, 1, "purple-hoodie", 13, 3, 1, 2, 1, 33.99);
insert into product values (NULL, 1, "purple-hoodie", 13, 4, 1, 2, 2, 33.99);
insert into product values (NULL, 1, "purple-hoodie", 13, 5, 1, 2, 2, 33.99);
insert into product values (NULL, 1, "purple-hoodie", 13, 6, 1, 2, 8, 33.99);

-- -- -- -- -- -- --  Pink sweathirt all sizes
insert into product values (NULL, 1, "pink-hoodie", 7, 1, 1, 2, 8, 33.99);
insert into product values (NULL, 1, "pink-hoodie", 7, 2, 1, 2, 5, 33.99);
insert into product values (NULL, 1, "pink-hoodie", 7, 3, 1, 2, 1, 33.99);
insert into product values (NULL, 1, "pink-hoodie", 7, 4, 1, 2, 2, 33.99);
insert into product values (NULL, 1, "pink-hoodie", 7, 5, 1, 2, 2, 33.99);
insert into product values (NULL, 1, "pink-hoodie", 7, 6, 1, 2, 8, 33.99);

-- -- -- -- -- -- --  Red sweathirt all sizes

insert into product values (NULL, 1, "red-hoodie", 6, 1, 1, 2, 8, 33.99);
insert into product values (NULL, 1, "red-hoodie", 6, 2, 1, 2, 5, 33.99);
insert into product values (NULL, 1, "red-hoodie", 6, 3, 1, 2, 1, 33.99);
insert into product values (NULL, 1, "red-hoodie", 6, 4, 1, 2, 2, 33.99);
insert into product values (NULL, 1, "red-hoodie", 6, 5, 1, 2, 2, 33.99);
insert into product values (NULL, 1, "red-hoodie", 6, 6, 1, 2, 8, 33.99);

-- -- -- -- -- -- --  blue sweathirt all sizes

insert into product values (NULL, 1, "blue-hoodie", 3, 1, 1, 2, 8, 33.99);
insert into product values (NULL, 1, "blue-hoodie", 3, 2, 1, 2, 5, 33.99);
insert into product values (NULL, 1, "blue-hoodie", 3, 3, 1, 2, 1, 33.99);
insert into product values (NULL, 1, "blue-hoodie", 3, 4, 1, 2, 2, 33.99);
insert into product values (NULL, 1, "blue-hoodie", 3, 5, 1, 2, 2, 33.99);
insert into product values (NULL, 1, "blue-hoodie", 3, 6, 1, 2, 8, 33.99);

-- -- -- -- -- pink tshirt imgs
insert into product_image values (NULL, "https://i.ibb.co/YW1pWyn/F-pink-tshirt-1.jpg", 97);
insert into product_image values (NULL, "https://i.ibb.co/YtJ232p/F-pink-tshirt-2.jpg", 97);
insert into product_image values (NULL, "https://i.ibb.co/YW1pWyn/F-pink-tshirt-1.jpg", 98);
insert into product_image values (NULL, "https://i.ibb.co/YtJ232p/F-pink-tshirt-2.jpg", 98);
insert into product_image values (NULL, "https://i.ibb.co/YW1pWyn/F-pink-tshirt-1.jpg", 99);
insert into product_image values (NULL, "https://i.ibb.co/YtJ232p/F-pink-tshirt-2.jpg", 99);
insert into product_image values (NULL, "https://i.ibb.co/YW1pWyn/F-pink-tshirt-1.jpg", 100);
insert into product_image values (NULL, "https://i.ibb.co/YtJ232p/F-pink-tshirt-2.jpg", 100);
insert into product_image values (NULL, "https://i.ibb.co/YW1pWyn/F-pink-tshirt-1.jpg", 101);
insert into product_image values (NULL, "https://i.ibb.co/YtJ232p/F-pink-tshirt-2.jpg", 101);
insert into product_image values (NULL, "https://i.ibb.co/YW1pWyn/F-pink-tshirt-1.jpg", 102);
insert into product_image values (NULL, "https://i.ibb.co/YtJ232p/F-pink-tshirt-2.jpg", 102);

-- -- -- -- -- fuchsia  TShirt imgs
insert into product_image values (NULL, "https://i.ibb.co/vJvnr0v/F-fuchsia-tshirt-1.jpg", 103);
insert into product_image values (NULL, "https://i.ibb.co/YTbSrCB/F-fuchsia-tshirt-2.jpg", 103);
insert into product_image values (NULL, "https://i.ibb.co/vJvnr0v/F-fuchsia-tshirt-1.jpg", 104);
insert into product_image values (NULL, "https://i.ibb.co/YTbSrCB/F-fuchsia-tshirt-2.jpg", 104);
insert into product_image values (NULL, "https://i.ibb.co/vJvnr0v/F-fuchsia-tshirt-1.jpg", 105);
insert into product_image values (NULL, "https://i.ibb.co/YTbSrCB/F-fuchsia-tshirt-2.jpg", 105);
insert into product_image values (NULL, "https://i.ibb.co/vJvnr0v/F-fuchsia-tshirt-1.jpg", 106);
insert into product_image values (NULL, "https://i.ibb.co/YTbSrCB/F-fuchsia-tshirt-2.jpg", 106);
insert into product_image values (NULL, "https://i.ibb.co/vJvnr0v/F-fuchsia-tshirt-1.jpg", 107);
insert into product_image values (NULL, "https://i.ibb.co/YTbSrCB/F-fuchsia-tshirt-2.jpg", 107);
insert into product_image values (NULL, "https://i.ibb.co/vJvnr0v/F-fuchsia-tshirt-1.jpg", 108);
insert into product_image values (NULL, "https://i.ibb.co/YTbSrCB/F-fuchsia-tshirt-2.jpg", 108);


-- -- -- -- -- black  TShirt imgs
insert into product_image values (NULL, "https://i.ibb.co/s2fbpgT/F-black-tshirt-1.jpg", 109);
insert into product_image values (NULL, "https://i.ibb.co/GpP5c08/F-black-tshirt-2.jpg", 109);
insert into product_image values (NULL, "https://i.ibb.co/s2fbpgT/F-black-tshirt-1.jpg", 110);
insert into product_image values (NULL, "https://i.ibb.co/GpP5c08/F-black-tshirt-2.jpg", 110);
insert into product_image values (NULL, "https://i.ibb.co/s2fbpgT/F-black-tshirt-1.jpg", 111);
insert into product_image values (NULL, "https://i.ibb.co/GpP5c08/F-black-tshirt-2.jpg", 111);
insert into product_image values (NULL, "https://i.ibb.co/s2fbpgT/F-black-tshirt-1.jpg", 112);
insert into product_image values (NULL, "https://i.ibb.co/GpP5c08/F-black-tshirt-2.jpg", 112);
insert into product_image values (NULL, "https://i.ibb.co/s2fbpgT/F-black-tshirt-1.jpg", 113);
insert into product_image values (NULL, "https://i.ibb.co/GpP5c08/F-black-tshirt-2.jpg", 113);
insert into product_image values (NULL, "https://i.ibb.co/s2fbpgT/F-black-tshirt-1.jpg", 114);
insert into product_image values (NULL, "https://i.ibb.co/GpP5c08/F-black-tshirt-2.jpg", 114);

-- -- -- -- -- green  TShirt imgs
insert into product_image values (NULL, "https://i.ibb.co/5XQMt8m/F-green-tshirt-1.jpg", 115);
insert into product_image values (NULL, "https://i.ibb.co/vvGzrKV/F-green-tshirt-2.jpg", 115);
insert into product_image values (NULL, "https://i.ibb.co/5XQMt8m/F-green-tshirt-1.jpg", 116);
insert into product_image values (NULL, "https://i.ibb.co/vvGzrKV/F-green-tshirt-2.jpg", 116);
insert into product_image values (NULL, "https://i.ibb.co/5XQMt8m/F-green-tshirt-1.jpg", 117);
insert into product_image values (NULL, "https://i.ibb.co/vvGzrKV/F-green-tshirt-2.jpg", 117);
insert into product_image values (NULL, "https://i.ibb.co/5XQMt8m/F-green-tshirt-1.jpg", 118);
insert into product_image values (NULL, "https://i.ibb.co/vvGzrKV/F-green-tshirt-2.jpg", 118);
insert into product_image values (NULL, "https://i.ibb.co/5XQMt8m/F-green-tshirt-1.jpg", 119);
insert into product_image values (NULL, "https://i.ibb.co/vvGzrKV/F-green-tshirt-2.jpg", 119);
insert into product_image values (NULL, "https://i.ibb.co/5XQMt8m/F-green-tshirt-1.jpg", 120);
insert into product_image values (NULL, "https://i.ibb.co/vvGzrKV/F-green-tshirt-2.jpg", 120);

-- -- -- -- -- red  TShirt imgs
insert into product_image values (NULL, "https://i.ibb.co/X23vwV9/F-red-tshirt-1.jpg", 121);
insert into product_image values (NULL, "https://i.ibb.co/0BwvyM0/F-red-tshirt-2.jpg", 121);
insert into product_image values (NULL, "https://i.ibb.co/X23vwV9/F-red-tshirt-1.jpg", 122);
insert into product_image values (NULL, "https://i.ibb.co/0BwvyM0/F-red-tshirt-2.jpg", 122);
insert into product_image values (NULL, "https://i.ibb.co/X23vwV9/F-red-tshirt-1.jpg", 123);
insert into product_image values (NULL, "https://i.ibb.co/0BwvyM0/F-red-tshirt-2.jpg", 123);
insert into product_image values (NULL, "https://i.ibb.co/X23vwV9/F-red-tshirt-1.jpg", 124);
insert into product_image values (NULL, "https://i.ibb.co/0BwvyM0/F-red-tshirt-2.jpg", 124);
insert into product_image values (NULL, "https://i.ibb.co/X23vwV9/F-red-tshirt-1.jpg", 125);
insert into product_image values (NULL, "https://i.ibb.co/0BwvyM0/F-red-tshirt-2.jpg", 125);
insert into product_image values (NULL, "https://i.ibb.co/X23vwV9/F-red-tshirt-1.jpg", 126);
insert into product_image values (NULL, "https://i.ibb.co/0BwvyM0/F-red-tshirt-2.jpg", 126);

-- -- -- -- -- skyblue TShirt imgs
insert into product_image values (NULL, "https://i.ibb.co/8PRwr5B/F-skyblue-tshirt-1.jpg", 127);
insert into product_image values (NULL, "https://i.ibb.co/0m2BqD1/F-skyblue-tshirt-2.jpg", 127);
insert into product_image values (NULL, "https://i.ibb.co/8PRwr5B/F-skyblue-tshirt-1.jpg", 128);
insert into product_image values (NULL, "https://i.ibb.co/0m2BqD1/F-skyblue-tshirt-2.jpg", 128);
insert into product_image values (NULL, "https://i.ibb.co/8PRwr5B/F-skyblue-tshirt-1.jpg", 129);
insert into product_image values (NULL, "https://i.ibb.co/0m2BqD1/F-skyblue-tshirt-2.jpg", 129);
insert into product_image values (NULL, "https://i.ibb.co/8PRwr5B/F-skyblue-tshirt-1.jpg", 130);
insert into product_image values (NULL, "https://i.ibb.co/0m2BqD1/F-skyblue-tshirt-2.jpg", 130);
insert into product_image values (NULL, "https://i.ibb.co/8PRwr5B/F-skyblue-tshirt-1.jpg", 131);
insert into product_image values (NULL, "https://i.ibb.co/0m2BqD1/F-skyblue-tshirt-2.jpg", 131);
insert into product_image values (NULL, "https://i.ibb.co/8PRwr5B/F-skyblue-tshirt-1.jpg", 132);
insert into product_image values (NULL, "https://i.ibb.co/0m2BqD1/F-skyblue-tshirt-2.jpg", 132);

-- -- -- -- -- white  TShirt imgs
insert into product_image values (NULL, "https://i.ibb.co/7N7kHzM/F-white-tshirt-1.jpg", 133);
insert into product_image values (NULL, "https://i.ibb.co/CVs2rgn/F-white-tshirt-2.jpg", 133);
insert into product_image values (NULL, "https://i.ibb.co/7N7kHzM/F-white-tshirt-1.jpg", 134);
insert into product_image values (NULL, "https://i.ibb.co/CVs2rgn/F-white-tshirt-2.jpg", 134);
insert into product_image values (NULL, "https://i.ibb.co/7N7kHzM/F-white-tshirt-1.jpg", 135);
insert into product_image values (NULL, "https://i.ibb.co/CVs2rgn/F-white-tshirt-2.jpg", 135);
insert into product_image values (NULL, "https://i.ibb.co/7N7kHzM/F-white-tshirt-1.jpg", 136);
insert into product_image values (NULL, "https://i.ibb.co/CVs2rgn/F-white-tshirt-2.jpg", 136);
insert into product_image values (NULL, "https://i.ibb.co/7N7kHzM/F-white-tshirt-1.jpg", 137);
insert into product_image values (NULL, "https://i.ibb.co/CVs2rgn/F-white-tshirt-2.jpg", 137);
insert into product_image values (NULL, "https://i.ibb.co/7N7kHzM/F-white-tshirt-1.jpg", 138);
insert into product_image values (NULL, "https://i.ibb.co/CVs2rgn/F-white-tshirt-2.jpg", 138);

-- -- -- -- -- yellow  TShirt imgs
insert into product_image values (NULL, "https://i.ibb.co/By6VVdd/F-yellow-tshirt-1.jpg", 139);
insert into product_image values (NULL, "https://i.ibb.co/nmD3scc/F-yellow-tshirt-2.jpg", 139);
insert into product_image values (NULL, "https://i.ibb.co/By6VVdd/F-yellow-tshirt-1.jpg", 140);
insert into product_image values (NULL, "https://i.ibb.co/nmD3scc/F-yellow-tshirt-2.jpg", 140);
insert into product_image values (NULL, "https://i.ibb.co/By6VVdd/F-yellow-tshirt-1.jpg", 141);
insert into product_image values (NULL, "https://i.ibb.co/nmD3scc/F-yellow-tshirt-2.jpg", 141);
insert into product_image values (NULL, "https://i.ibb.co/By6VVdd/F-yellow-tshirt-1.jpg", 142);
insert into product_image values (NULL, "https://i.ibb.co/nmD3scc/F-yellow-tshirt-2.jpg", 142);
insert into product_image values (NULL, "https://i.ibb.co/By6VVdd/F-yellow-tshirt-1.jpg", 143);
insert into product_image values (NULL, "https://i.ibb.co/nmD3scc/F-yellow-tshirt-2.jpg", 143);
insert into product_image values (NULL, "https://i.ibb.co/By6VVdd/F-yellow-tshirt-1.jpg", 144);
insert into product_image values (NULL, "https://i.ibb.co/nmD3scc/F-yellow-tshirt-2.jpg", 144);

-- -- -- -- -- purple sweatshirt imgs
insert into product_image values (NULL, "https://i.ibb.co/724pGxL/F-purple-hoodie-1.jpg", 145);
insert into product_image values (NULL, "https://i.ibb.co/S7YH6vY/F-purple-hoodie-2.jpg", 145);
insert into product_image values (NULL, "https://i.ibb.co/724pGxL/F-purple-hoodie-1.jpg", 146);
insert into product_image values (NULL, "https://i.ibb.co/S7YH6vY/F-purple-hoodie-2.jpg", 146);
insert into product_image values (NULL, "https://i.ibb.co/724pGxL/F-purple-hoodie-1.jpg", 147);
insert into product_image values (NULL, "https://i.ibb.co/S7YH6vY/F-purple-hoodie-2.jpg", 147);
insert into product_image values (NULL, "https://i.ibb.co/724pGxL/F-purple-hoodie-1.jpg", 148);
insert into product_image values (NULL, "https://i.ibb.co/S7YH6vY/F-purple-hoodie-2.jpg", 148);
insert into product_image values (NULL, "https://i.ibb.co/724pGxL/F-purple-hoodie-1.jpg", 149);
insert into product_image values (NULL, "https://i.ibb.co/S7YH6vY/F-purple-hoodie-2.jpg", 149);
insert into product_image values (NULL, "https://i.ibb.co/724pGxL/F-purple-hoodie-1.jpg", 150);
insert into product_image values (NULL, "https://i.ibb.co/S7YH6vY/F-purple-hoodie-2.jpg", 150);

-- -- -- -- -- pink sweatshirt imgs
insert into product_image values (NULL, "https://i.ibb.co/vxGmTTq/F-pink-hoodie-1.jpg", 151);
insert into product_image values (NULL, "https://i.ibb.co/WHLWFBT/F-pink-hoodie-2.jpg", 151);
insert into product_image values (NULL, "https://i.ibb.co/vxGmTTq/F-pink-hoodie-1.jpg", 152);
insert into product_image values (NULL, "https://i.ibb.co/WHLWFBT/F-pink-hoodie-2.jpg", 152);
insert into product_image values (NULL, "https://i.ibb.co/vxGmTTq/F-pink-hoodie-1.jpg", 153);
insert into product_image values (NULL, "https://i.ibb.co/WHLWFBT/F-pink-hoodie-2.jpg", 153);
insert into product_image values (NULL, "https://i.ibb.co/vxGmTTq/F-pink-hoodie-1.jpg", 154);
insert into product_image values (NULL, "https://i.ibb.co/WHLWFBT/F-pink-hoodie-2.jpg", 154);
insert into product_image values (NULL, "https://i.ibb.co/vxGmTTq/F-pink-hoodie-1.jpg", 155);
insert into product_image values (NULL, "https://i.ibb.co/WHLWFBT/F-pink-hoodie-2.jpg", 155);
insert into product_image values (NULL, "https://i.ibb.co/vxGmTTq/F-pink-hoodie-1.jpg", 156);
insert into product_image values (NULL, "https://i.ibb.co/WHLWFBT/F-pink-hoodie-2.jpg", 156);

-- -- -- -- -- red sweatshirt imgs
insert into product_image values (NULL, "https://i.ibb.co/g7MFzGw/F-red-hoodie-1.jpg", 157);
insert into product_image values (NULL, "https://i.ibb.co/4pVYX2C/F-red-hoodie-2.jpg", 157);
insert into product_image values (NULL, "https://i.ibb.co/g7MFzGw/F-red-hoodie-1.jpg", 158);
insert into product_image values (NULL, "https://i.ibb.co/4pVYX2C/F-red-hoodie-2.jpg", 158);
insert into product_image values (NULL, "https://i.ibb.co/g7MFzGw/F-red-hoodie-1.jpg", 159);
insert into product_image values (NULL, "https://i.ibb.co/4pVYX2C/F-red-hoodie-2.jpg", 159);
insert into product_image values (NULL, "https://i.ibb.co/g7MFzGw/F-red-hoodie-1.jpg", 160);
insert into product_image values (NULL, "https://i.ibb.co/4pVYX2C/F-red-hoodie-2.jpg", 160);
insert into product_image values (NULL, "https://i.ibb.co/g7MFzGw/F-red-hoodie-1.jpg", 161);
insert into product_image values (NULL, "https://i.ibb.co/4pVYX2C/F-red-hoodie-2.jpg", 161);
insert into product_image values (NULL, "https://i.ibb.co/g7MFzGw/F-red-hoodie-1.jpg", 162);
insert into product_image values (NULL, "https://i.ibb.co/4pVYX2C/F-red-hoodie-2.jpg", 162);

-- -- -- -- -- blue sweatshirt imgs
insert into product_image values (NULL, "https://i.ibb.co/273y0k1/F-blue-hoodie-1.jpg", 163);
insert into product_image values (NULL, "https://i.ibb.co/59zgQT3/F-blue-hoodie-2.jpg", 163);
insert into product_image values (NULL, "https://i.ibb.co/273y0k1/F-blue-hoodie-1.jpg", 164);
insert into product_image values (NULL, "https://i.ibb.co/59zgQT3/F-blue-hoodie-2.jpg", 164);
insert into product_image values (NULL, "https://i.ibb.co/273y0k1/F-blue-hoodie-1.jpg", 165);
insert into product_image values (NULL, "https://i.ibb.co/59zgQT3/F-blue-hoodie-2.jpg", 165);
insert into product_image values (NULL, "https://i.ibb.co/273y0k1/F-blue-hoodie-1.jpg", 166);
insert into product_image values (NULL, "https://i.ibb.co/59zgQT3/F-blue-hoodie-2.jpg", 166);
insert into product_image values (NULL, "https://i.ibb.co/273y0k1/F-blue-hoodie-1.jpg", 167);
insert into product_image values (NULL, "https://i.ibb.co/59zgQT3/F-blue-hoodie-2.jpg", 167);
insert into product_image values (NULL, "https://i.ibb.co/273y0k1/F-blue-hoodie-1.jpg", 168);
insert into product_image values (NULL, "https://i.ibb.co/59zgQT3/F-blue-hoodie-2.jpg", 168);
