module Paperclip  
  class Original < Thumbnail  

    def make
      # Only process if the file is larger than the maximum size.  Otherwise keep it intact.
      if Paperclip::Geometry.from_file(@file).width > options[:max_width]
        super
      else
        return @file
      end
    end

  end  
end