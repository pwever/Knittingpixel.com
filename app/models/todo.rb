class Todo < ActiveRecord::Base

  require 'chronic'

  belongs_to :project
  belongs_to :context
  before_save :parse
  has_many :todos_tags
  has_many :tags, :through => :todos_tags
  
  COLL_PATTERN = /\s+  (today|tonight|tomorrow) \s? (.*) /ix
  DATE_PATTERN = /\s+  (on|next|at|in|after|this)  \s  (\d|jan|feb|mar|apr|may|jun|jul|aug|sep|oct|dec|mon|tue|wed|thu|fri|sat|sun|week|month|year|afternoon|evening).*  $/ix
  # DATE_PATTERN = /\s+  (on|next|at|in|after|this|tomorrow)  \s  [\s\w]*  $/ix
  CONTEXT_PATTERN = /\s   (?: \@     (\w+)   |  [\@c]   (?:\w*)?  (?=['"\(\[\{])  ['"\(\[\{]  (.+)  ['"\)\}\}] )   /ix
  TAG_PATTERN = /\s#(\w+)/i

  def parse
    self.raw_input = self.label.clone
    
    matches = CONTEXT_PATTERN.match(self.label)
    if matches
      con_name = matches[1] || matches[2]
      con = Context.find(:first, :conditions => ['label LIKE ?',con_name]) if con_name
      if con.nil?
        con = Context.new({ :label => con_name })
        con.save
      end
      self.context_id = con.id
      self.label.gsub!(matches[0],'')
    end
    
    continue = true
    if TAG_PATTERN.match(self.label) then
      # clear previous tags, if one is specified now
      self.tags = []
    end
    
    while continue do
      match = TAG_PATTERN.match(self.label)
      if match
        tag_label = match[1]
        tag = Tag.find(:first, :conditions => ['label LIKE ?',tag_label]) if tag_label
        if tag.nil?
          tag = Tag.new()
          tag.label = tag_label
          tag.save
        end
        self.tags << tag
        self.label.gsub!(match[0],'')
      else
        continue = false
      end
    end
    self.tags.uniq!
    
    #self.label.gsub!('tomorrow','tomorrow morning')
    #matches = /\s tomorrow.* /ix.match(self.label)
    matches = COLL_PATTERN.match(self.label)
    matches = DATE_PATTERN.match(self.label) unless matches
    due = Todo.parseTime(matches[0]) if matches
    if due
      # set due date
      self.due_at = due
      # remove time reference from label
      self.label.gsub!(matches[0], '')
    end
    
  end
  
  def self.parseTime str
    str.gsub! /^\s*(on|at)\s+/i, ""
    p "date string::::" + str
    t = Chronic.parse(str, {:guess => false})
    t = t.first if t
    # some rare cases are only handled by Time.parse (for instance "at 8pm")
    t = Time.parse(str) unless t
    # Time.prase returns the current time, if it can not match anything
    t = nil if (t-Time.now).abs < 15
    t
  end
  
  def setdone=(state)
    logger.debug("custom done method was called.")
    toggleDone unless (state==self.done)
  end

  def toggleDone
    self.done = !self.done
    if self.done
      self.done_at = Time.now
    else
      self.done_at = nil
    end
  end

  def isDue?
    self.due_at && self.due_at < Time.now
  end
  
  def isCurrent?
    self.due_at==nil || (Time.now-self.due_at)<60*60*12
  end
  
  def <=>(other)
      if (self.due_at==nil) then
        return 1
      elsif (other.due_at==nil) then
        return -1
      else
        due_at<=>other.due_at
      end
  end

end
