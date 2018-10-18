require 'spec_helper'
require 'bitmap_editor'

RSpec.describe BitmapEditor do
  class TestOutput
    attr_reader :result

    def puts(*args)
      @result ||= ''
      args.each { |a| @result << "#{a}\n" }
    end
  end

  subject(:editor) { BitmapEditor.new(output) }
  let(:output) { TestOutput.new }

  describe '#execute_command' do
    it 'executes S command as #print_bitmap' do
      expect(editor).to receive(:print_bitmap).once
      editor.execute_command('S')
    end

    it 'raises UnknownCommand when command is not recognized' do
      error = BitmapEditor::UnknownCommandError
      expect { editor.execute_command 'some command' }.to raise_error(error)
    end

    it 'executes I command as #init_bitmap' do
      expect(editor.bitmap).to be nil
      editor.execute_command('I 3 5')
      expect(editor.bitmap.width).to eq 3
      expect(editor.bitmap.height).to eq 5
      expect(editor.bitmap[1, 1]).to eq 'O'

      editor.execute_command('I 5 3 9')
      # ignores additional arguments
      expect(editor.bitmap.width).to eq 5
      expect(editor.bitmap.height).to eq 3

      err = BitmapEditor::BadArgumentsError
      expect { editor.execute_command('I x 5') }.to raise_error(err)
      expect { editor.execute_command('I') }.to raise_error(err)
      expect { editor.execute_command('I 5') }.to raise_error(err)
    end

    it 'executes L command as #color_pixel' do
      editor.init_bitmap([3, 3])
      expect(editor.bitmap[1, 2]).to eq 'O'
      editor.execute_command('L 1 2 B')
      expect(editor.bitmap[1, 2]).to eq 'B'
      expect(editor.bitmap[2, 2]).to eq 'O'

      err = BitmapEditor::BadArgumentsError
      expect { editor.execute_command('L 1 2') }.to raise_error(err)
      expect { editor.execute_command('L B 1 2') }.to raise_error(err)
      expect { editor.execute_command('L 1 y B') }.to raise_error(err)
    end

    it 'executes V command as #color_vertical_line' do
      editor.init_bitmap([10, 10])
      editor.execute_command('V 4 2 8 A')
      editor.execute_command('V 6 3 5 B')
      (2..8).each { |y| expect(editor.bitmap[4, y]).to eq 'A' }
      (3..5).each { |y| expect(editor.bitmap[6, y]).to eq 'B' }
      expect(editor.bitmap[5, 2]).to eq 'O'
      expect(editor.bitmap[4, 9]).to eq 'O'
      expect(editor.bitmap[4, 1]).to eq 'O'

      err = BitmapEditor::BadArgumentsError
      expect { editor.execute_command('V 1 2 3') }.to raise_error(err)
      expect { editor.execute_command('V B 1 2 3') }.to raise_error(err)
      expect { editor.execute_command('V 1 y 2 B') }.to raise_error(err)
    end

    it 'executes H command as #color_horizontal_line' do
      editor.init_bitmap([10, 10])
      editor.execute_command('H 2 8 4 A')
      editor.execute_command('H 5 3 6 B')
      (2..8).each { |x| expect(editor.bitmap[x, 4]).to eq 'A' }
      (3..5).each { |x| expect(editor.bitmap[x, 6]).to eq 'B' }
      expect(editor.bitmap[2, 5]).to eq 'O'
      expect(editor.bitmap[9, 4]).to eq 'O'
      expect(editor.bitmap[1, 4]).to eq 'O'

      err = BitmapEditor::BadArgumentsError
      expect { editor.execute_command('H 1 2 3') }.to raise_error(err)
      expect { editor.execute_command('H B 1 2 3') }.to raise_error(err)
      expect { editor.execute_command('H 1 y 2 B') }.to raise_error(err)
    end

    it 'executes C command as #clear_bitmap' do
      editor.init_bitmap([10, 10])
      editor.bitmap.draw_point(1, 2, 'A')
      editor.bitmap.draw_point(3, 4, 'B')
      editor.bitmap.draw_point(9, 9, 'C')
      editor.execute_command 'C'
      expect(editor.bitmap[1, 2]).to eq 'O'
      expect(editor.bitmap[3, 4]).to eq 'O'
      expect(editor.bitmap[9, 9]).to eq 'O'
    end

    it 'executes S command as #print_bitmap' do
      editor.init_bitmap([3, 3])
      editor.bitmap.draw_point(1, 1, 'A')
      editor.bitmap.draw_point(2, 2, 'B')
      editor.bitmap.draw_point(3, 3, 'C')
      editor.execute_command('S')
      expect(output.result).to eq "AOO\nOBO\nOOC\n"
    end
  end
end
