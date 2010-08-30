module TopicsHelper

  def setup_topic(topic)
    returning(topic) do |p|
      p.images.build
    end
  end

end