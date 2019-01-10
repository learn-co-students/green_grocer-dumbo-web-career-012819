def consolidate_cart(cart)
  groceries = {}

  cart.each do |grocery|
    grocery.each do |item, info|
      if groceries[item] == nil
        groceries[item] = info
        groceries[item][:count] = 1
      else
        groceries[item][:count] += 1
      end
    end
  end

  return groceries
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    default_key = "#{item} W/COUPON"

    if cart.key?(item) && cart[item][:count] >= coupon[:num]
      if cart[default_key] == nil
        cart[default_key] = {}
      end

      cart[default_key][:price] = coupon[:cost]
      cart[default_key][:clearance] = cart[item][:clearance]
      cart[item][:count] -= coupon[:num]

      if cart[default_key][:count] == nil
        cart[default_key][:count] = 1
      else
        cart[default_key][:count] += 1
      end
    end
  end

  return cart
end

def apply_clearance(cart)
  percent = 0.2

  cart.each do |item, info|
    discount = info[:price] * percent

    if info[:clearance]
      info[:price] -= discount
    end
  end

  return cart
end

def checkout(cart, coupons)
  total = 0
  sorted = consolidate_cart(cart)
  after_coupons = apply_coupons(sorted, coupons)
  after_clearance = apply_clearance(after_coupons)

  after_clearance.each do |item, info|
    price = info[:price]

    while info[:count] > 0
      total += price
      info[:count] -= 1
    end
  end

  if total > 100
    percent = 0.1
    discount = total * percent

    return total - discount
  else
    return total
  end
end