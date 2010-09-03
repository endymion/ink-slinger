module Paperclip  
  class Cropper < Thumbnail  
    def transformation_command  
      if crop_command
        commands = super
        if crop_index = commands.rindex('-crop')
          2.times { commands.delete_at(crop_index) }
        end
        commands = [crop_command, commands]
        commands.flatten
      else  
        super  
      end  
    end  
  
    def crop_command  
      target = @attachment.instance  
      if target.cropping? &&
        !options[:original_width].blank? && !options[:original_height].blank?
        [
          '-crop',
          ["#{target.crop_w.to_f * options[:original_width]}x",
          "#{target.crop_h.to_f * options[:original_height]}+",
          "#{target.crop_x.to_f * options[:original_width]}+",
          "#{target.crop_y.to_f * options[:original_height]}"].join
        ]
      end  
    end  
  end  
end