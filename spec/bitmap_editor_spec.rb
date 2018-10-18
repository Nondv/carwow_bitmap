require 'spec_helper'
require 'bitmap_editor'

RSpec.describe BitmapEditor do
  subject(:editor) { BitmapEditor.new }

  describe '#execute_command' do
    it 'executes S command as #print_bitmap' do
      expect(editor).to receive(:print_bitmap).once
      editor.execute_command('S')
    end
  end
end
