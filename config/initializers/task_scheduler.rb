require 'rubygems'
require 'rufus/scheduler'

task_scheduler = Rufus::Scheduler.start_new

#Every friday at 17:30
#task_scheduler.cron '27 18 * * 5' do
#Every 2 minutes
task_scheduler.every '2m' do
  puts "------ Scheduled Job ------"
  puts "Starting at " + Time.now.strftime("%H:%M - %m/%d/%Y.")
  #Clean old set_mood tables
  SetMood.clean_old_set_moods
  puts"All old mood sets were deleted from database."
  #Send mood request mail
  #Project.send_set_mood_to_all
  puts "All mood requests were sent to contacts."
  #Send activity list mail
  Client.send_activity_list_to_all
  puts "All activity list mails were sent to contacts."
  puts "Finished at " + Time.now.strftime("%H:%M - %m/%d/%Y.")
  puts "---------------------------"
end
