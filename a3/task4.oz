declare fun {Quadratic A B C} %The A B and C values for a quadratic polynomial
  fun {$ X} %The value for the X variable
    A * X * X + B * X + C 
  end
end

{System.showInfo {{Quadratic 3 2 1} 2}}