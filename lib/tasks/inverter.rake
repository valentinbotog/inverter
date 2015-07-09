namespace :inverter do

  desc "Reset all inverter objects to template defaults"
  task :reset => :environment do
    Inverter.model_class.available_for_sync.delete_all
    Inverter.model_class.sync_with_templates!

    inverter_objects = Inverter.model_class.available_for_sync
    inverter_objects.each do |o|
      ap " - #{ o._template_name }"
    end
    ap "#{ inverter_objects.size } objects created."
  end


  desc "Sync all inverter objects with template changes"
  task :sync => :environment do
    Inverter.model_class.sync_with_templates!
    ap "Objects has been updated."
  end

end
