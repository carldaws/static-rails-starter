require 'fileutils'

namespace :static do
  desc "Generate static pages"
  task build: :environment do
    # Clean the output directory
    output_dir = 'site'
    FileUtils.remove_dir(output_dir, force = true)
    FileUtils.mkdir(output_dir)

    # Precompile assets, copy the public directory to the output directory
    Rake::Task["assets:precompile"].invoke
    FileUtils.cp_r 'public/.', 'site' 

    # Require all controllers (needed in development because of lazy loading)
    Dir["./app/controllers/*.rb"].each { |file| require file }

    ApplicationController.descendants.each do |controller|
      controller_name = controller.controller_name
      singularized_controller_name = controller_name.singularize
      model = controller_name.classify
      collection_name = model.downcase.pluralize
      collection = Object.const_get(model).all 

      # Process the index action for the controller
      index_action_path = File.join(output_dir, Rails.application.routes.url_helpers.send("#{controller_name}_path"))
      FileUtils.mkdir_p(index_action_path)
      index_action_target = File.join(index_action_path, "index.html")
      File.open(index_action_target, "w") do |f| 
        f.write controller.render :index, assigns: { collection_name => collection }, locals: { static: true }
      end

      # Process the show action for each object in the collection
      collection.each do |object|
        show_action_path = File.join(output_dir, Rails.application.routes.url_helpers.send("#{singularized_controller_name}_path", object.to_param))
        FileUtils.mkdir_p(show_action_path)
        show_action_target = File.join(show_action_path, "index.html")
        File.open(show_action_target, "w") do |f|
          f.write controller.render :show, assigns: { model.downcase => object}, locals: { static: true }
        end
      end
    end
  end
end