def consolidate_cart(cart)


  result  = {}
  count_arr = []
  cart.each do |item_hash|
    item_hash.each do |item, att|
      count_arr << item
    end
  end


  final_hash = {}

  cart.each do |item_hash|
    item_hash.each do |k,v|
    final_hash[k] = v
    end
  end
    count_arr.each do |el|
      final_hash[el][:count] = 0
    end
    count_arr.each do |el|
      final_hash[el][:count] += 1
    end

  final_hash
end

def apply_coupons(cart, coupons)
  final = {}
  cart.each do |food, info|
      coupons.each do |coupon|
        if food == coupon[:item] && info[:count] >= coupon[:num]
          info[:count] =  info[:count] - coupon[:num]
          if final["#{food} W/COUPON"]
            final["#{food} W/COUPON"][:count] += 1
          else
            final["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => info[:clearance], :count => 1}
          end
        end
      end
      final[food] = info
    end
    final
end

def apply_clearance(cart)
  final = {}
 cart.each do |food, info|
    final[food] = {}
    if info[:clearance] == true
      final[food][:price] = info[:price] * 4 / 5
    else
      final[food][:price] = info[:price]
    end
    final[food][:clearance] = info[:clearance]
    final[food][:count] = info[:count]
  end
  final
end

def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated, coupons)
  pre_discount = apply_clearance(couponed_cart)
  sub_total = 0
  print pre_discount
  pre_discount.each do |food, worth|
    if pre_discount[food][:count] > 0
      sub_total += (pre_discount[food][:price] * pre_discount[food][:count])
    end
  end

  if sub_total > 100
    return sub_total.to_f * 9/10.to_f
  else
    return sub_total
  end


end
