@base_width = 960
@font_size = 18
@line_height = 24

def columns_at(width)
  case width
  when 0..512 then 2
  when 513..768 then 3
  else 4
  end
end

def column_width_at(width)
  width / columns_at(width)
end

def scss_for(width)
  puts <<EOS
@media screen and (min-width: #{width}px) {
  html > body {
    font-size: #{(column_width_at(width) * @font_size.to_f / column_width_at(@base_width.to_f)).round}px;
    line-height: #{(column_width_at(width) * @line_height.to_f / column_width_at(@base_width.to_f)).round}px;
  }
}
EOS
end

namespace :scss do

  desc "Generate SCSS code for responsive font style rules"
  task :generate_fonts do

    # Step down to the smallest width supported.
    current_width = @base_width
    while current_width > 360
      current_width = current_width - @font_size
    end

    # Step up through the widest width supported.
    while current_width < 2048
      scss_for(current_width)
      current_width = current_width + @font_size
    end

  end

end