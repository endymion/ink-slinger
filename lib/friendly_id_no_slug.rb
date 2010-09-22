module FriendlyId
  module ActiveRecordAdapter
    module SluggedModel

      def build_a_slug
        return if @no_slug
        return unless new_slug_needed?
        @slug = slugs.build :name => slug_text.to_s, :scope => friendly_id_config.scope_for(self),
          :sluggable => self
        @new_friendly_id = @slug.to_friendly_id
      end

    end
  end
end