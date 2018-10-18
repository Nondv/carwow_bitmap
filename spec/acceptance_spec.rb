CLI_PATH = File.expand_path('../bin/bitmap_editor', __dir__)

RSpec.describe 'CLI' do
  def execute_test(file_suffix)
    input = File.expand_path("files/acceptance#{file_suffix}.in", __dir__)
    output = File.expand_path("files/acceptance#{file_suffix}.out", __dir__)
    result = `#{CLI_PATH} #{input}`
    expect(result).to eq(File.read(output))
  end

  it 'passes test 1 (from google doc)' do
    execute_test(1)
  end

  it 'passes test 2 (with some wrong input, which is supposed to be alerted)' do
    execute_test(2)
  end
end
