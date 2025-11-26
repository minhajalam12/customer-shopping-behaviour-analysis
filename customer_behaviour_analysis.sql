--Q1- what is the total revenue genrated by male vs female customers?

	 select 
	    gender,
		sum(purchase_amount)as total_revenue
	 from customer
	 group by gender
 
--Q2- which customers used a discount but still spent more than the avearge amount of purchase?

  select customer_id,
         discount_applied,
		 purchase_amount
  from customer 
  where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount)  from customer);

--Q3- which are the top 5 products with the heighest average review rating?

   select item_purchased,
          round(avg (review_rating:: numeric),2) as avg_review_rating
	 from customer
     group by 1 
	 order by avg_review_rating desc
  limit 5;

--Q4- compare the average amounts between standard and Express shipping?

    select shipping_type,
	       round(avg(purchase_amount),2) as avg_amounts
		 from customer
		 where shipping_type in('Express', 'Standard') 
		 group by shipping_type


--Q5- Do subscribed customers spend more? compare avg spend and total revenue between subscribers and non-subscribers. 

   select 
          subscription_status,
		  count(customer_id) as no_of_customer,
		  round(avg(purchase_amount),2) as avg_spend,
		  round(sum(purchase_amount),2) as total_revenue
	 from customer
	 group by 1


--Q6- which 5 products have the highest percentage of purchases with discount applied?


  select 
        item_purchased,
	    round(sum(case when discount_applied='Yes' then 1 else 0 end *100)/count(*),2) as discount_rate
  from customer
  group by 1
  order by discount_rate desc
  limit 5;

--Q7- segment customer into new, returning,and loyal based on their total number of previous purchases, 
--and show the count of each segment.

 with cte as (
    select 
	    customer_id,
		previous_purchases,
		case 
		   when previous_purchases = 1 then 'New'
		   when previous_purchases between 2 and 10 then 'Returning'
		   else 'Loyal'
		   end as customer_segment
	from customer 
 ) 
  select
  	 customer_segment,
     count(customer_id) as number_of_customer
    from cte 
	group by 1

--Q8- what are the top 3 must purchased  products within each category?

 with cte as (
 
   select  category,
         item_purchased,
		 count(customer_id) as total_order,
		 row_number() over(partition by category order by count(customer_id) desc) as item_rank
	from customer
    group by 1,2

	
  )
     select 
	       item_rank,  
	       category,
	       item_purchased,
		   total_order
	 from cte 
	 where item_rank <= 3


--Q9- Are customers who are repeate buyers (more than 5 previous purchases) also likely to subscribe?

 select 
        subscription_status,
		count(customer_id) as repeat_buyer
 from customer
 where previous_purchases >=5
 group by 1


--Q10- What is the revenue contribution of each category?

  select age_group,
         sum(purchase_amount) as total_revenue
  from customer
  group by 1
  order by total_revenue desc

  








  










		  










		