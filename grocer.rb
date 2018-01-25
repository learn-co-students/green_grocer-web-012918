require 'pry'
def consolidate_cart(cart)
  # code here
  consolidated = {}

  cart.each do |hash|
    hash.each do |item, information|
      if !consolidated.keys.include?(item)
        consolidated[item] = information
        consolidated[item][:count] = 1
      else
        consolidated[item][:count] += 1
      end
    end
  end

  consolidated

end

def apply_coupons(cart, coupons)

  updated_cart={}

  if coupons.size == 0
    return cart
  end

  cart.each do |item, info|

    coupons.each do |coupon|
      if item == coupon[:item]
        if info[:count] == coupon[:num]

          if !updated_cart.keys.include?("#{item} W/COUPON")
            updated_cart["#{item} W/COUPON"] = Hash[info]
            updated_cart["#{item} W/COUPON"][:count] = 1
            updated_cart["#{item} W/COUPON"][:price] = coupon[:cost]

          else
            updated_cart["#{item} W/COUPON"][:count] += 1
            updated_cart[item] -= coupon[:num]

          end

          cart[item][:count] -= coupon[:num]
          # binding.pry
        elsif info[:count] > coupon[:num]
          if !updated_cart.keys.include?("#{item} W/COUPON")
            updated_cart[item] = Hash[info]
            updated_cart[item][:count] = info[:count] - coupon[:num]
            updated_cart["#{item} W/COUPON"] = Hash[info]
            updated_cart["#{item} W/COUPON"][:count] = 1
            updated_cart["#{item} W/COUPON"][:price] = coupon[:cost]
          else
            updated_cart[item][:count] -= coupon[:num]
            updated_cart["#{item} W/COUPON"][:count] += 1
          end
          cart[item][:count] -= coupon[:num]
        end
      end


    end

    if !updated_cart.keys.include?(item)
      updated_cart[item] = info
    end
  end

  # binding.pry
  updated_cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance] == true
      cart[item][:price] = (cart[item][:price]*0.8).round(1)
    end
  end
  cart
end

def checkout(cart, coupons)
  updated_cart = consolidate_cart(cart)
  updated_cart = apply_coupons(updated_cart, coupons)
  updated_cart = apply_clearance(updated_cart)


  total = 0
  updated_cart.each do |item, info|
    if info[:count] > 0
      info[:count].times do
        total += info[:price]
      end

    end
  end

  if total > 100
    return (total*0.9).round(1)
  else
    return total
  end

end
