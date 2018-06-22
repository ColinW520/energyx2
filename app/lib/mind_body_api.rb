def self.fetch_mindbody_schedule(*opts)
   options = opts.extract_options!
   start_date = options[:start_date] || Date.today.beginning_of_week
   end_date = options[:end_date] || Date.today.end_of_week

   message = {
     'StartDateTime' => start_date,
     'EndDateTime' => end_date,
     'HideCanceledClasses' => true
   }
   message['ClientID'] = options[:user_id] unless options[:user_id].nil?
   res = ClassService.get_classes(message)
   classes =  res.result[:classes]
   classes.sort!{|a,b| a.start_date_time <=> b.start_date_time}
   return classes
end
