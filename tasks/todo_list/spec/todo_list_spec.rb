require 'securerandom'
require 'todo_list'

describe TodoList do # rubocop:disable Metrics/BlockLength
  let(:file_path) { File.join(Dir.tmpdir, SecureRandom.urlsafe_base64) }
  subject { TodoList.new(file_path) }

  describe '.add' do
    it 'should add todos' do
      subject.add('todo1')
      subject.add('todo2')

      expect(subject.list).to eq(%w[todo1 todo2])
    end
  end

  describe '.remove' do
    it 'should remove the right todo' do
      subject.add('todo1')
      subject.add('todo2')
      subject.add('todo3')

      todo = subject.remove(1)

      expect(todo).to eq('todo2')
      expect(subject.list).to eq(%w[todo1 todo3])
    end
  end

  describe '.clear' do
    it 'should clear the list' do
      subject.add('todo1')
      subject.add('todo2')
      subject.clear

      expect(subject.list).to be_empty
    end
  end

  describe '.list' do
    it 'should return empty list when there are no todos' do
      expect(subject.list).to be_empty
    end
  end

  describe '.save' do
    after { FileUtils.rm_rf file_path }

    it 'should create the file' do
      subject.save
      expect(File.exist?(file_path)).to be_truthy
    end
  end
end
