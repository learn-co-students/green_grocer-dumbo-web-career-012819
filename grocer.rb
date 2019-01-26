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

=begin
def apply_coupons(cart, coupons)
  final_hash = {}
  grouped_coupons = coupons.group_by {|coupon| coupon[:item]}
  binding.pry
  cart.each do |item, price_hash|
  	coupons.each do |coupon_hash|
  		if item == coupon_hash[:item]
  			price_hash[:count] = price_hash[:count] - coupon_hash[:num] unless price_hash[:count] < 1
  			final_hash[item] = price_hash
	  			final_hash["#{item} W/COUPON"] = {:price => coupon_hash[:cost], :clearance => price_hash[:clearance], :count => grouped_coupons[coupon_hash[:item]].length}
  		else 
  			final_hash[item] = price_hash
  		end
  	end
  end
  if coupons == []
  	return cart
  end
  final_hash
end
=end


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

=begin
def checkout(cart, coupons)
	final_amount = []
	consolidated = consolidate_cart(cart)
	coupons_applied = apply_coupons(consolidated, coupons)
	clearance_applied = apply_clearance(coupons_applied)
	cart.each do |item_hash|
		item_hash.each do |name, item_details|		
			if item_details[:clearance] == false && cart.length == 1
				coupons_applied = apply_coupons(consolidated, [])
				final_amount = item_details[:price]
				return final_amount
			elsif item_details[:clearance] == true
				final_amount = clearance_applied["#{name} W/COUPON"][:price]
				return final_amount		
			end
		end
	end
	clearance_applied.each do |discount_item, discount_hash|
		final_amount << discount_hash[:price]
	end
	if final_amount.sum > 100
		final_amount = final_amount.sum * 0.9
		return final_amount
	end
	final_amount.sum
end
=end


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
