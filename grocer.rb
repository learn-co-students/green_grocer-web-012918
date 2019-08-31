def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |item|
    item.each do |type, stats|
      if !cart_hash.has_key?(type)
        count = {count:1}
        cart_hash[type] = stats.merge(count)
      else
        cart_hash[type][:count] += 1
      end
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)
  applied_cart = {}
  cart.each do |item, stats|
    if coupons.length > 0
      coupons.each do |coupon|
        if !coupon.has_value?(item)
          applied_cart[item] = stats
        else
          if applied_cart.has_key?("#{item} W/COUPON")
          else
            div_array = stats[:count].divmod(coupon[:num])
            applied_cart[item] = {price: stats[:price], clearance: stats[:clearance], count: div_array[1]}
            applied_cart["#{item} W/COUPON"] = {price: coupon[:cost], clearance: stats[:clearance], count: div_array[0]}
            stats[:count] = div_array[1]
          end
        end
      end
    else
      applied_cart = cart
    end
  end
  applied_cart
end

def apply_clearance(cart)
  cart.collect do |item, stats|
    if stats[:clearance]
      stats[:price] = stats[:price] - (0.2 * stats[:price])
    end
  end
  cart
end

def checkout(cart, coupons)
  total_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total_cost = 0.00
  total_cart.each do |item, stats|
    total_cost += stats[:price] * stats[:count]
  end
  if total_cost > 100.00
    total_cost -= 0.1 * total_cost
  end
  total_cost
end
