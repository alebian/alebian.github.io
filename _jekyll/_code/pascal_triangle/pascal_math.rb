require_relative 'pascal_triangle'

class PascalMath
  def initialize
    @triangle = PascalTriangle.new
  end

  def binomial_power(a, b, n)
    coefficients = @triangle.get_file(n)

    result = 0
    coefficients.each_with_index do |coefficient, idx|
      result += coefficient * a**(n - idx) * b**idx
    end

    result
  end

  def power_of_2(n)
    coefficients = @triangle.get_file(n)
    coefficients.sum
  end

  def power_of_11(param)
    coefficients = @triangle.get_file(param)

    if param <= 4
      coefficients.join.to_i
    else
      coefficients_with_carry = [0]
      coefficients.reverse_each.with_index do |coefficient, idx|
        coefficient_with_carry = coefficient + coefficients_with_carry[idx]

        if coefficient_with_carry < 10
          coefficients_with_carry[idx] = coefficient_with_carry
          coefficients_with_carry[idx + 1] = 0
        else
          coefficients_with_carry[idx] = coefficient_with_carry % 10
          coefficients_with_carry[idx + 1] = (coefficient_with_carry / 10.0).floor
        end
      end
      coefficients_with_carry.reverse.join.to_i
    end
  end

  def fibonacci(n)
    return 0 if n <= 1
    return 1 if n == 2

    result = 0
    (0..n).reverse_each.with_index do |n, idx|
      coefficients = @triangle.get_file(n - 2)
      next unless coefficients[idx]

      result += coefficients[idx]
    end
    result
  end

  def natural_numbers
    NHedralSeries.new(@triangle, 2)
  end

  def n_hedral_series(n)
    raise 'N must be greater than 2' if n < 3

    NHedralSeries.new(@triangle, n)
  end

  def binomial_coefficient(n, k)
    file = @triangle.get_file(n)
    file[k]
  end

  def perfect_squares
    PerfectSquaresSeries.new(@triangle)
  end

  private

  class NHedralSeries
    def initialize(triangle, n)
      @triangle = triangle
      @current_file = n - 1
      @n = n
    end

    def next
      file = @triangle.get_file(@current_file)
      @current_file += 1
      file[@n - 1]
    end
  end

  class PerfectSquaresSeries
    def initialize(triangle)
      @triangle = triangle
      @current_file = 3
    end

    def next
      previous_file = @triangle.get_file(@current_file - 1)
      file = @triangle.get_file(@current_file)
      @current_file += 1

      file[2] + previous_file[2]
    end
  end
end
