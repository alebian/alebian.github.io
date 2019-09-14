require_relative '../pascal_math'

describe PascalMath do
  subject(:pascal) { described_class.new }

  describe '#binomial_power' do
    let(:as) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
    let(:bs) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
    let(:powers) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }

    it 'returns the expected result' do
      as.each do |a|
        bs.each do |b|
          powers.each do |n|
            expect(pascal.binomial_power(a, b, n)).to eq((a + b)**n)
          end
        end
      end
    end
  end

  describe '#power_of_2' do
    let(:powers) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }

    it 'returns the expected file' do
      powers.each do |n|
        expect(pascal.power_of_2(n)).to eq(2**n)
      end
    end
  end

  describe '#power_of_11' do
    let(:powers) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }

    it 'returns the expected file' do
      powers.each do |n, expected|
        expect(pascal.power_of_11(n)).to eq(11**n)
      end
    end
  end

  describe '#fibonacci' do
    let(:fibonacci_series) do
      [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181]
    end

    it 'returns the expected result' do
      fibonacci_series.each_with_index do |expected, n|
        expect(pascal.fibonacci(n + 1)).to eq(expected)
      end
    end
  end

  describe '#natural_numbers' do
    let(:series) { pascal.natural_numbers }

    it 'returns the expected results' do
      (1..10).each do |n|
        expect(series.next).to eq(n)
      end
    end
  end

  describe '#n_hedral_series' do
    context 'when n is 4' do
      let(:series) { pascal.n_hedral_series(4) }

      it 'returns the expected results' do
        (1..10).each do |n|
          expect(series.next).to eq(((1 / 6.0) * n * (n + 1) * (n + 2)).ceil)
        end
      end
    end
  end

  describe '#perfect_squares' do
    let(:series) { pascal.perfect_squares }

    it 'returns the expected results' do
      (2..10).each do |n|
        expect(series.next).to eq(n**2)
      end
    end
  end

  describe '#binomial_coefficient' do
    let(:ns) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
    let(:ks) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }

    it 'returns the expected result' do
      ns.each do |n|
        ks.each do |k|
          next unless k <= n

          # Math.gamma(n + 1) == factorial(n)
          expect(pascal.binomial_coefficient(n, k))
            .to eq((Math.gamma(n + 1) / (Math.gamma(k + 1) * Math.gamma(n - k + 1))).ceil)
        end
      end
    end
  end
end
