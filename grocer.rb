require 'pry'

def consolidate_cart(cart)
  hash = {}
	count = 1
  cart.each do |h|
		h.each do |k, v|
  		if hash[k]
  			count +=1
  			v[:count] = count
			else
        v[:count] = 1
        hash[k] = v
  		end
    end
	end
  hash
end


def apply_coupons(cart, coupons)
  hash ={}
  coupons.each do |coupon|
    name = coupon[:item]
        if cart[name] && (cart[name][:count] >= coupon[:num])
          binding.pry
          coupons_to_use = cart[name][:count] / coupon[:num]
          new_count =  cart[name][:count] - (coupon[:num] * coupons_to_use).to_f.ceil
          if new_count >= 0
            cart[name][:count] = new_count
            hash[name] = cart[name]
          end
          hash["#{name} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[name][:clearance], :count =>  coupons_to_use}
        end
        if !hash[name]
          hash[name] = cart[name]
        end
      end
  hash
end

def apply_clearance(cart)
  cart.collect do |name, details|
    if details[:clearance] == true
      price = details[:price] * 0.8
      details[:price] = price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  prices = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart.each do |k, v|
    price = v[:price] * v[:count]
    prices += price
  end
  if prices > 100
    prices = prices * 0.9
  end
  prices
end
