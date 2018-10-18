require 'spec_helper'
require 'bitmap_editor'

RSpec.describe BitmapEditor do
  subject(:editor) { BitmapEditor.new }

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
  end
end
