require "pry"

def consolidate_cart(cart)
  cons_hash = {}
  cart.each do |index|
    index.each do |item, hash_one|
      if !cons_hash[item]
        cons_hash[item] = hash_one
        cons_hash[item][:count] = 1
      else
        cons_hash[item][:count] += 1
      end
    end
  end
  cons_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each do |item, hash_one|
    if hash_one[:clearance]
      disc_price = (hash_one[:price] * 0.8).round(2)
      hash_one[:price] = disc_price
    end
  end
end

def checkout(cart, coupons)
  cons_cart = consolidate_cart(cart)
  coup_cart = apply_coupons(cons_cart, coupons)
  clear_cart = apply_clearance(coup_cart)
  total = 0
  clear_cart.each do |item, hash_one|
    total += (hash_one[:price] * hash_one[:count]).round(2)
  end
  if total >= 100
    total = (total * 0.9).round(2)
  end
  total
end
