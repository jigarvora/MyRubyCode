#http://rubylearning.com/blog/2009/11/26/rpcfn-rubyfun-4/

class Polynomial
   def initialize(coeffs)
	
	if(coeffs.nil? || !coeffs.kind_of?(Array) || coeffs.size < 2)
	  raise ArgumentError, "Need at least 2 arguments", caller
	end

	@polynomial = ""
	degree = coeffs.size()-1
	coeffs.each do |a|
	  @polynomial = @polynomial + cleanupCoeff(a,degree)
	  degree = degree-1
	end
	@polynomial.sub!(/^\+/,"")
  
  end

  def cleanupCoeff(coeff, deg)
	firstPart = ""

	if(coeff == 0)
	  return ""
	elsif(coeff < 0)
	  firstPart = "#{coeff}"
	elsif(coeff == 1) 
	  firstPart = "+"
	elsif(coeff > 0)
	  firstPart = "+#{coeff}"
	end

	secondPart = "x^#{deg}"
	if(deg == 1)
	  secondPart = "x"
	elsif(deg == 0)
	  secondPart = ""
	end

	return firstPart + secondPart
  end
  
  def to_s
	return @polynomial
  end


  # Optimal Solution! 
  def to_s2
    power = @coefs.size
    parts = @coefs.map do |coef| # Map returns a new list which is a modified version of the list
      power -= 1
      coef   = coef.to_i
      unless coef == 0
        part   = (power == 0 || coef.abs != 1) ? coef.to_s : (coef > 0 ? '' : '-')
        part  += (power == 0) ? '' : (power == 1) ? 'x' : "x^#{power}"
      end
    end.compact # Compact removes all the nil elents from the list
    
    return parts.empty? ? '0' : (parts.compact.join '+').gsub('+-', '-')
  end
  
  
end

	
