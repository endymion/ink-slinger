module TopicsHelper

  def setup_topic(topic)
    returning(topic) do |p|
      p.panels.build
    end
  end

end