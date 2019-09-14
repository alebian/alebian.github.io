class PascalTriangle
  def initialize
    @triangle = [[1]]
  end

  def get_file(param)
    return @triangle[param] if @triangle[param]

    previous_file = get_file(param - 1)
    @triangle << calculate_new(previous_file)

    @triangle[param]
  end

  private

  def calculate_new(previous_file)
    current_file = [1]
    (0..(previous_file.size - 1)).each do |idx|
      next if idx == previous_file.size - 1

      current_file << previous_file[idx] + previous_file[idx + 1]
    end
    current_file << 1

    current_file
  end
end
