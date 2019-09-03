require 'pry'
def consolidate_cart(cart)
  consolidated = {}

  cart.each do |item|
    item.each do |name, details|
      if consolidated[name].nil?
        consolidated[name] = details
        consolidated[name][:count] = 1
      else
        consolidated[name][:count] += 1
      end
    end
  end

  consolidated
end

def apply_coupons(cart, coupons)

  coupons.each do |coupon|
    bundled = {}
    cart.each do |item, details|
      if coupon[:item] == item
        if details[:count] >= coupon[:num]
          details[:count] -= coupon[:num]
          bundled["#{item} W/COUPON"] = {:price => coupon[:cost], :clearance => details[:clearance], :count => 1}
        end
      end
    end
    bundled.each { |item, details| !cart[item] ? cart[item] = details : cart[item][:count] += 1}
  end

  cart
end

def apply_clearance(cart)
  cart.each do |name, details|
    if details[:clearance] == true
      details[:price] = (details[:price] * 0.80).round(1)
    end
  end
end

def checkout(cart, coupons)
  total = 0

  consolidated = consolidate_cart(cart)
  bundled = apply_coupons(consolidated, coupons)
  final_cart = apply_clearance(bundled)

  final_cart.each do |item, details|
    total += details[:price] * details[:count]
  end

  total > 100.00 ? total *= 0.90 : total
end
