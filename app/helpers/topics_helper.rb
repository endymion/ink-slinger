module TopicsHelper

  def new_image(topic)
    returning(topic) do |p|
      p.images.build
    end
  end

  def new_panel(topic)
    returning(topic) do |p|
      unless topic.panels.size > 0
        p.panels << Panel.new(:topic => topic, :image => topic.images.first)
      end
    end
  end
  
  def id_or_new_count(object)
    if object.id.blank?
      @new_count = 0 if @new_count.nil?
      @new_count += 1
      '-new-' + @new_count.to_s
    else
      '-' + object.id.to_s
    end
  end

end