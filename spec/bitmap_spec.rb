require 'spec_helper'
require 'bitmap'

RSpec.describe Bitmap do
  subject { Bitmap.new(width, height) }
  let(:width) { 5 }
  let(:height) { 3 }

  it { is_expected.to respond_to(:[]) }
  it { is_expected.not_to respond_to(:[]=) }

  describe 'coordinate system' do
    it 'starts from X' do
      expect(subject[5, 3]).to eq 'O'
      expect { subject[3, 5] }.to raise_error ArgumentError
    end

    it 'starts from 1,1' do
      expect { subject[0, 0] }.to raise_error ArgumentError
      expect(subject[1, 1]).to eq 'O'
      expect(subject[5, 3]).to eq 'O'
    end

    it 'raises ArgumentError when out of boundaries' do
      expect { subject[3, 4] }.to raise_error ArgumentError
      expect { subject[6, 1] }.to raise_error ArgumentError
      expect { subject[1, 0] }.to raise_error ArgumentError
      expect(subject[5, 3]).to eq 'O'
    end
  end

  describe 'size limits' do
    it 'requires width and height to be integer' do
      expect { Bitmap.new(1.1, 3) }.to raise_error(ArgumentError)
      expect { Bitmap.new(1, '3') }.to raise_error(ArgumentError)
    end

    it 'allows sizes in range 1..250' do
      Bitmap.new(250, 250)
      expect { Bitmap.new(251, 250) }.to raise_error(ArgumentError)
      expect { Bitmap.new(0, 250) }.to raise_error(ArgumentError)
      expect { Bitmap.new(3, 0) }.to raise_error(ArgumentError)
    end
  end
end
