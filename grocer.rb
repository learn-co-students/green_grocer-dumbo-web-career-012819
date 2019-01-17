


require 'pry'
def consolidate_cart(cart)
  new_cart = {}

  cart.each do |hashes|
      hashes.each do |food,info_hash|
        if !new_cart[food]
          new_cart[food] = info_hash
          new_cart[food][:count] = 1
        else
          new_cart[food] = info_hash
          new_cart[food][:count] += 1
        end
      end
   end
      new_cart
end

def apply_coupons(cart, coupons)
 coupons.each do |coupon|
   food = coupon[:item]
   coupon_key = "#{food} W/COUPON"
   if cart.key?(food) && !cart.key?(coupon_key)
     while cart[food][:count] >= coupon[:num]
      if cart[coupon_key]
        cart[food][:count] = cart[food][:count] - coupon[:num]
        cart[coupon_key][:count] += 1
      #binding.pry
      else
       cart[coupon_key] = {}
       cart[coupon_key][:price] = coupon[:cost]
       cart[coupon_key][:clearance] = cart[food][:clearance]
       cart[food][:count] = cart[food][:count] - coupon[:num]
       cart[coupon_key][:count] = 1
       end
     end
   end
 end
 cart
end





def apply_clearance(cart)

cart.each do |food_key,hash_value|
  subtractor = hash_value[:price]*0.2
  if hash_value[:clearance]
     hash_value[:price] -= subtractor
   end
 end
 cart
end


def checkout(cart, coupons)
consolidated = consolidate_cart(cart)
couponed = apply_coupons(consolidated, coupons)
clearanced = apply_clearance(couponed)
total_cost = 0

    clearanced.each do |food, info_hash|
       total_cost += info_hash[:price]*info_hash[:count]
         if total_cost > 100
            total_cost = total_cost - (total_cost*0.1)
          else
            total_cost
    end
  end
  total_cost
end
