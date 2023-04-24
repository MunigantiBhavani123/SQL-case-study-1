CREATE SCHEMA dannys_diner;

drop table if 
CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sale
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
1: What is the total amount each customer spent at the restaurant?
 select s.customer_id,sum(m.price) as total_amnt from menu m inner join sale s
 on m.product_id=s.product_id
 group by s.customer_id
 
2:How many days has each customer visited the restaurant?
select customer_id,count(distinct order_date) as days_visited from sale
group by customer_id

3:What was the first item from the menu purchased by each customer?
select s.customer_id,m.product_name,min(s.order_date) as first_purchased from menu m
inner join sale s on m.product_id=s.product_id
group by s.customer_id

4:What is the most purchased item on the menu and how many times was it purchased by all customers?
select product_name,count(order_date) as orders from sale s
inner join menu m on s.product_id=m.product_id
group by product_name
order by orders desc
limit 1

5:Which item was the most popular for each customer?
with cte as (
select product_name,customer_id,count(order_date) as orders,
rank() over(partition by customer_id order by count(order_date) desc) as  rnk,
row number() over(partition by customer_id order by count(order_date) desc) as rn
from sale as s
inner join menu as m on s.product_id=m.product_id
group by product_name,customer_id
)
select customer_id,product_name from cte
where rnk=1
6:Which item was purchased first by the customer after they became a member?
select mb.customer_id,m.product_name,s.order_date from members mb 
inner join sale s on mb.customer_id=s.customer_id
inner join menu m on s.product_id=m.product_id
where s.order_date>=mb.join_date
group by mb.customer_id
order by order_date 

7:Which item was purchased just before the customer became a member?
select mb.customer_id,m.product_name,s.order_date from members mb 
inner join sale s on mb.customer_id=s.customer_id
inner join menu m on s.product_id=m.product_id
where s.order_date<mb.join_date
group by mb.customer_id
order by order_date desc
8:What is the total items and amount spent for each member before they became a member?
select mb.customer_id,count(m.product_name) as total_items,sum(m.price) from members mb
inner join sale s on mb.customer_id=s.customer_id
inner join menu m on s.product_id=m.product_id
where order_date<join_date
group by mb.customer_id

9:If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select customer_id,
sum(case when product_name='sushi' then price*10*2
else price*10
end ) as points
from menu as m
inner join sale as s on s.product_id=m.product_id
group by customer_id


 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  