def consolidate_cart(cart)
  # code here
  cart_items = {}

  cart.each do |hash|
  	hash.each do |item, inner_hash|
  		if cart_items[item] == nil
  			cart_items[item] = inner_hash
  			cart_items[item][:count] = 1
  		else
  			cart_items[item][:count] += 1
  		end
  		end
  	end
  cart_items
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each do |hash|
  	item = hash[:item]
  	if cart.has_key?(item)
  		cart_qty = cart[item][:count]
  		coupon_qty = cart_qty / hash[:num]
  		remaining = cart_qty % hash[:num]

  			if coupon_qty > 0
  				cart[item][:count] = remaining
  				cart["#{item} W/COUPON"] = {
  					price: hash[:cost],
  					clearance: cart[item][:clearance],
  					count: coupon_qty
  				}
  			end 
  		end
  	end
  	cart
end


def apply_clearance(cart)
  # code here
  cart.each do |item, hash|
  	if cart[item][:clearance]
  		cart[item][:price] = (cart[item][:price] * 0.80).round(2)
  	end
  end
end

def checkout(cart, coupons)
  # code here
  total = 0
 
  consolidated = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated, coupons)
  clearance_cart = apply_clearance(coupon_cart)

  array = consolidated.collect do |item, properties|
    properties[:price] * properties[:count]
  end

  array.each do |x| 
    	total += x 
  end

  if total >= 100
    total = (total * 0.9).round(2)
  end
  total
end
