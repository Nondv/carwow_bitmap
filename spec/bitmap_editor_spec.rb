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
  end
end
