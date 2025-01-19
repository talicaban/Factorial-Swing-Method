-- Swing Method
local modf = math.modf
local band = bit32.band
local exp = math.exp
local inf = math.huge
local Y = 0.5772156649015329

local function product(start, goto, fn, ...)
	local n = 1
	for i = start, goto do
		n *= fn(i,...)
	end
	return n
end
local function swing(n)
	local d = n%4
	local z = ((d==1) and n//2 + 1) or ((d==2) and 2) or ((d==3) and 2 * (n//2 + 2)) or 1
	local b = z
	z = 2 * (n - band(n+1, 1))
	for i = 1, n//4 do
		b = (b * z) / i
		z -= 4
	end
	return b
end
local function recproduct(n)
	if(n < 2) then
		return 1
	end
	return recproduct(n // 2)^2 * swing(n)
end
local function gamma(z, iters)
	return exp(-Y*z) / z * product(1, iters or 2e4, function(k) return  (1/(1 + z/k)) * exp(z/k)  end) 
end

return function(n)
	local _,f = modf(n)
	if(n == 0) or (n == 1) then
		return 1
	elseif(n == 2) then
		return 2
	end
	if(f == 0) and (n < 0) then
		return inf
	elseif(f == 0) then
		return recproduct(n)
	else
		return gamma(n + 1)
	end
end