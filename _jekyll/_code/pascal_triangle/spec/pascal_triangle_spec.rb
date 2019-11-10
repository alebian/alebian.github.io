require_relative '../pascal_triangle'

describe PascalTriangle do
  describe '#get_file' do
    subject(:triangle) { described_class.new }

    let(:expected_files) do
      [
        [0,  [1]],
        [1,  [1, 1]],
        [2,  [1, 2, 1]],
        [3,  [1, 3, 3, 1]],
        [4,  [1, 4, 6, 4, 1]],
        [5,  [1, 5, 10, 10, 5, 1]],
        [6,  [1, 6, 15, 20, 15, 6, 1]],
        [7,  [1, 7, 21, 35, 35, 21, 7, 1]],
        [8,  [1, 8, 28, 56, 70, 56, 28, 8, 1]],
        [9,  [1, 9, 36, 84, 126, 126, 84, 36, 9, 1]],
        [10, [1, 10, 45, 120, 210, 252, 210, 120, 45, 10, 1]]
      ]
    end

    it 'returns the expected file' do
      expected_files.each do |n, expected_file|
        expect(subject.get_file(n)).to eq(expected_file)
      end
    end
  end
end
