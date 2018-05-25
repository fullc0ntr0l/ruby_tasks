require 'yaml'
require 'tmpdir'

# TodoList class
class TodoList
  TODO_LIST_PATH = File.join(Dir.tmpdir, '.todo_list.yaml')

  def initialize(todo_list_path = File.join(Dir.tmpdir, '.todo_list.yaml'))
    @todo_list_path = todo_list_path
  end

  def add(todo)
    todos[:todos] = [] unless todos.key?(:todos)

    todos[:todos] << todo
  end

  def remove(id_number)
    todos[:todos].slice!(id_number)
  end

  def clear
    @todos = empty_todos
  end

  def list
    todos[:todos] || []
  end

  def save
    File.open(@todo_list_path, 'w') { |f| f.write todos.to_yaml }
  end

  private

  def todos
    @todos ||= begin
      YAML.load_file(@todo_list_path)
    rescue StandardError
      empty_todos
    end
  end

  def empty_todos
    { todos: [] }
  end
end
