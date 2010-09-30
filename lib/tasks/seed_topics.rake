namespace :db do

  namespace :seed do

    desc "Seed Topic records from flyers folder"
    task :topics => [:environment] do

      metadata = YAML.load(ERB.new(File.new(
        File.join(Rails.root, 'seed', 'flyers', 'metadata.yml')).read).result)

      puts "indexing all files in flyers folder"
      Dir.entries(File.join(Rails.root, 'seed', 'flyers')).each do |file|
        next if file =~ /\A\./ || file =~ /\.yml$/
        unless File.directory? File.join(Rails.root, 'seed', 'flyers', file)
          puts "creating a topic for flyers/#{file}"

          topic = Topic.new
          topic.images << (image = Image.create :t_1 =>
            File.new(File.join(Rails.root, 'seed', 'flyers', file)))

          if (file_metadata = metadata[file]).nil?
            topic.panels << Panel.create(:image => image)
          else
            topic.panels << Panel.create(
              :image => image,
              :arrangement => file_metadata['arrangement'],
              :crop_x => file_metadata['crop_x'],
              :crop_y => file_metadata['crop_y'],
              :crop_w => file_metadata['crop_w'],
              :crop_h => file_metadata['crop_h']
            )

            topic.title = file_metadata['title'] unless file_metadata['title'].blank?
            topic.panel = file_metadata['panel'] unless file_metadata['panel'].blank?
            topic.body = file_metadata['body'] unless file_metadata['body'].blank?

          end

          topic.save

        end
      end

    end

  end

end