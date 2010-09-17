class HomeController < ApplicationController

  include ActionController::Caching::PagesS3
  caches_page_to_s3 :news

  before_filter :generate_layout_pattern
  def generate_layout_pattern
    @layout_pattern = # A series of .racks
      [ # Two sections per rack
        [ # Two mounts per section
          [
            { # Mount
              :type => :flexible,
              :panels => [
                # Multiple panels per mount
                  { :arrangement => :square },
                  { :arrangement => :square }
                ]
            },
            { # Mount
              :type => :square,
              :panels => [
                  { :arrangement => :landscape },
                  {
                    :arrangement => :landscape,
                    :id => :header
                  }
                ]
            }
          ],
          [
            { # Mount
              :type => :square,
              :panels => [
                  { :arrangement => :portrait },
                  {
                    :arrangement => :portrait,
                  }
                ]
            },
            { # Mount
              :type => :flexible,
              :panels => [ # Multiple panels per mount
                  { :arrangement => :square },
                  { :arrangement => :square }
                ]
            }
          ]
        ],
        [ # Second section
          [ # Two mounts per section
            { # Mount
              :type => :flexible,
              :panels => [ # Multiple panels per mount
                  { :arrangement => :square },
                  { :arrangement => :square }
                ]
            },
            { # Mount
              :type => :square,
              :panels => [
                  { :arrangement => :landscape },
                  { :arrangement => :landscape }
                ]
            }
          ],
          [
            { # Mount
              :type => :square,
              :panels => [
                  { :arrangement => :portrait },
                  {
                    :arrangement => :portrait
                  }
                ]
            },
            { # Mount
              :type => :flexible,
              :panels => [ # Multiple panels per mount
                  { :arrangement => :square },
                  { :arrangement => :square }
                ]
            }
          ]
        ],
        [ # Third section
          [ # Two mounts per section
            { # Mount
              :type => :flexible,
              :panels => [ # Multiple panels per mount
                  { :arrangement => :square },
                  { :arrangement => :square }
                ]
            },
            { # Mount
              :type => :square,
              :panels => [
                  { :arrangement => :landscape },
                  { :arrangement => :landscape }
                ]
            }
          ],
          [
            { # Mount
              :type => :square,
              :panels => [
                  { :arrangement => :portrait },
                  { :arrangement => :portrait }
                ]
            },
            { # Mount
              :type => :flexible,
              :panels => [ # Multiple panels per mount
                  { :arrangement => :square },
                  {
                    :arrangement => :square,
                    :id => :footer
                  }
              ]
            }
          ]
        ]
      ]
  end

  before_filter :get_content
  def get_content
    @square_panels = Panel.square.all.sort &:updated_at
    @landscape_panels = Panel.landscape.all.sort &:updated_at
    @portrait_panels = Panel.portrait.all.sort &:updated_at
    @text_topics = Topic.text_topics.sort &:updated_at

    # Used for keeping track of which Topics have already been placed in the layout.
    @placed_topics = {}
  end

  before_filter :place_panels
  def place_panels
    [
      [landscape_slots, @landscape_panels],
      [portrait_slots, @portrait_panels],
      [square_slots, @square_panels]
    ].each do |layout_slots, panels|
      assign_panels_to_slots layout_slots, panels
    end
    
    # Assign text items after images have been placed.
    assign_topics_to_slots empty_slots, @text_topics
  end
  
  private

  def assign_panels_to_slots(layout_slots, panels)
    layout_slots.each do |layout_slot|
      panels.each do |panel|
        next if @placed_topics[panel.topic.id] # Don't use the same topic twice.
        next unless layout_slot[:id].blank?
        layout_slot[:id] = panel.id
        layout_slot[:type] = :panel
        @placed_topics[panel.topic.id] = true
        break
      end
    end
  end

  def assign_topics_to_slots(layout_slots, topics)
    layout_slots.each do |layout_slot|
      topics.each do |topic|
        next if @placed_topics[topic.id] # Don't use the same topic twice.
        layout_slot[:id] = topic.id
        layout_slot[:type] = :topic
        @placed_topics[topic.id] = true
        break
      end
    end
  end

  def empty_slots
    layout_slots.select { |panel| panel[:id].blank? }
  end

  def square_slots
    @square_slots ||= layout_slots.select { |panel| panel[:arrangement].eql? :square }
  end
  
  def landscape_slots
    @landscape_slots ||= layout_slots.select { |panel| panel[:arrangement].eql? :landscape }
  end

  def portrait_slots
    @portrait_slots ||= layout_slots.select { |panel| panel[:arrangement].eql? :portrait }
  end

  def layout_slots
    @layout_pattern.inject([]) { |panels, rack|
      rack.inject(panels) { |panels, section|
        section.inject(panels) { |panels, mount|
          panels << mount[:panels].flatten
        }
      }
    }.flatten
  end

end
