class Task
  attr_reader(:description, :due, :list_id)

  define_method(:initialize) do |attributes|
    @description = attributes.fetch(:description)
    @due = attributes.fetch(:due)
    @list_id = attributes.fetch(:list_id)
  end

  define_method(:==) do |another_task|
    self.description().==(another_task.description()).&(self.due().==(another_task.due())).&(self.list_id().==(another_task.list_id()))
  end

  define_singleton_method(:all) do
    returned_tasks = DB.exec("SELECT * FROM tasks ORDER BY due ASC;")
    tasks = []
    returned_tasks.each() do |task|
      description = task.fetch("description")
      due = task.fetch("due")
      list_id = task.fetch("list_id").to_i
      tasks.push(Task.new({:description => description, :due => due, :list_id => list_id}))
    end
    tasks
  end

  define_method(:save) do
    DB.exec("INSERT INTO tasks (description, due, list_id) VALUES ('#{@description}', '#{@due}', #{@list_id});")
  end
end
