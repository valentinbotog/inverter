namespace :inverter do

  desc "Reset all inverter objects to template defaults"
  task :reset => :environment do
    Inverter.model_class.delete_all
    Inverter.model_class.sync_with_templates!

    inverter_objects = Inverter.model_class.all
    inverter_objects.each do |o|
      puts " - #{ o._template_name }"
    end
    puts "\n#{ inverter_objects.size } objects created."
  end


  desc "Sync all inverter objects with template changes"
  task :sync => :environment do
    Inverter.model_class.sync_with_templates!
    puts "Objects has been updated."
  end

end
