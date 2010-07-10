class Reminder < ActionMailer::Base
  
  # run as a cron or launchd job:
  # /path/to/app/script/runner -e production Reminder.deliver_today
  # /Users/pwever/Sites/KP/script/runner -e production Reminder.deliver_today
  
  def today
    todos = Todo.find(:all, :conditions => ['done=? AND due_at NOT NULL AND DATE("now")>=DATE(due_at)', false])
    # # note the deliver_ prefix, this is IMPORTANT
    # Reminder.deliver_today
    
    mail_settings = YAML.load(File.read(File.join(RAILS_ROOT, 'config', 'mail.yml')))
    subject    "Due Today"
    recipients mail_settings['recipient']
    from       mail_settings['email_address']
    sent_on    Time.now
    body       "todos"
  end
  
end


