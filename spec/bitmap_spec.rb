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

  describe 'colors' do
    it 'are represented as capital letters' do
      subject.draw_point(1, 1, 'A')
      expect { subject.draw_point(1, 1, 'a') }.to raise_error(Bitmap::InvalidColorError)
      expect { subject.draw_point(1, 1, 1) }.to raise_error(Bitmap::InvalidColorError)
      expect { subject.draw_point(1, 1, :A) }.to raise_error(Bitmap::InvalidColorError)
      expect { subject.draw_point(1, 1, 'AB') }.to raise_error(Bitmap::InvalidColorError)
    end
  end

  describe '#draw_point' do
    it 'sets color of given point' do
      subject.draw_point(4, 1, 'B')
      subject.draw_point(5, 3, 'C')
      expect(subject[4, 1]).to eq 'B'
      expect(subject[5, 3]).to eq 'C'
      expect(subject[4, 3]).to eq 'O'
    end
  end

  describe '#draw_rectangle' do
    let(:width) { 15 }
    let(:height) { 12 }

    # creates lambda that checks if given point belongs to rectangle
    def rectangle_inclusion_lambda(x1, y1, x2, y2)
      # take top left point and bottom right one
      x1, x2 = x2, x1 if x1 > x2
      y1, y2 = y2, y1 if y1 > y2

      ->(x, y) { (x1..x2).cover?(x) && (y1..y2).cover?(y) }
    end

    # test helper method
    before(:all) do
      case1 = rectangle_inclusion_lambda(2, 2, 5, 5)
      expect(case1[2, 2]).to be true
      expect(case1[2, 5]).to be true
      expect(case1[3, 4]).to be true
      expect(case1[1, 1]).to be false
      expect(case1[3, 6]).to be false

      # same rectangle with different init points
      case2 = rectangle_inclusion_lambda(2, 5, 5, 2)
      expect(case2[2, 2]).to be true
      expect(case2[2, 5]).to be true
      expect(case2[3, 4]).to be true
      expect(case2[1, 1]).to be false
      expect(case2[3, 6]).to be false
    end

    it 'colors rectangle between two points: (x1; y1), (x2; y2)' do
      subject.draw_rectangle(3, 5, 11, 2, 'B')
      is_in_rectangle = rectangle_inclusion_lambda(3, 2, 11, 5)

      (1..width).each do |x|
        (1..height).each do |y|
          expected_color = is_in_rectangle.call(x, y) ? 'B' : 'O'
          expect(subject[x, y]).to eq(expected_color)
        end
      end
    end
  end
end
