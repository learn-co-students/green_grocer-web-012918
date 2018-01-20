def consolidate_cart(cart)
  new_hash = {}
  cart.each do |grocery_items|
    grocery_items.each do |item, facts|
      if new_hash[item] == nil
        new_hash[item] = facts
        new_hash[item][:count] = 1
      else
        new_hash[item][:count] += 1
      end
    end
  end

  return new_hash
 end

def apply_coupons(cart, coupons)
  # cart =  {"AVOCADO" => {:price => 3.0, :clearance => true, :count => 3}
  # coupons = {:item => "AVOCADO", :num => 2, :cost => 5.0}
  cart_with_coupons = cart

  coupons.each do |c_hash|
    item = c_hash[:item]
    if cart_with_coupons.keys.include?(item) && cart_with_coupons[item][:count] >= c_hash[:num]
      new_price = c_hash[:cost]
      new_clearance = cart_with_coupons[item][:clearance]
      new_count = (cart_with_coupons[item][:count]/c_hash[:num]).floor
      cart_with_coupons["#{item} W/COUPON"] = {:price => new_price, :clearance => new_clearance, :count => new_count}
      cart_with_coupons[item][:count] = cart_with_coupons[item][:count] % c_hash[:num]
    end
  end
  return cart_with_coupons
end

def apply_clearance(cart)
  # cart = "PEANUTBUTTER" => {:price => 3.00, :clearance => true,  :count => 2}
  cart.map do |item, data|
    data.map do |key, value|
      if key == :clearance && value == true
        new_price = cart[item][:price] * 0.8
        cart[item][:price] = new_price.round(2)
      else
        cart[item] = data
      end
    end
  end
  return cart
end

def checkout(cart, coupons)

  #consolidate the cart
  cart = consolidate_cart(cart)

  #apply discounts
  discounted_cart = apply_coupons(cart, coupons)

  #apply clearance
  clearanced_cart = apply_clearance(discounted_cart)

  #get total
  cart_sum = 0
  clearanced_cart.each do |item, data|
    item_price = data[:price] * data[:count]
    cart_sum += item_price
  end

  #check 100
  if cart_sum > 100
    return cart_sum * 0.9
  else
    return cart_sum
  end

end
