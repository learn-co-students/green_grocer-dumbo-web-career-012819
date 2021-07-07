require "pry"

def consolidate_cart(cart)
  new_cart = {}
  grouped = cart.group_by {|x| x.keys}
  grouped.each do |item_name, amount_of_items|
  	amount_of_items.each do |item_hash|
  		item_hash.each do |name, price_hash|
  			price_hash[:count] = amount_of_items.length
  			new_cart[name] ||= {}
  			new_cart[name] = price_hash
  		end
  	end
  end
  new_cart
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
  cart.each do |item_name, item_hash|
  	if item_hash[:clearance] == true
  		item_hash[:price] = (item_hash[:price] * 0.8).round(2)
  	end
  end
  cart
end

def checkout(cart, coupons)
	final_amount = 0
	consolidated = consolidate_cart(cart)
	coupons_applied = apply_coupons(consolidated, coupons)
	clearance_applied = apply_clearance(coupons_applied)
	clearance_applied.each do |discount_item, discount_hash|
		final_amount += discount_hash[:price] * discount_hash[:count]
	end
	if final_amount > 100
		final_amount = final_amount * 0.9
	end
	final_amount
end
