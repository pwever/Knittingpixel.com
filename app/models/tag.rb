class Tag < ActiveRecord::Base
  has_many :todos_tags
  has_many :todos, :through => :todos_tags
  
  def todays_todos
    due = todos.select { |t| \
      (t.done_at!=nil && t.done_at.to_date==Date.today) || \
      (t.done==false && \
      (t.due_at==nil || t.due_at.to_date<=Date.today) \
      )\
    }
    due.sort
  end
  
  def getColor
    sha1 = Digest::SHA1.hexdigest(self.label)
    return "#"+sha1.match("[0-9a-f]{6}")[0]
  end
  
end
