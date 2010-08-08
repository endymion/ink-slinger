@base_width = 1024
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

def widths_in_range(start, stop)
  width = start
  widths = []
  while width <= stop
    widths << [width]
    width = width + 16
  end
  widths
end

def scss_for(width)
  return <<EOS
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

    scss = open(File.join(Rails.root, 'app', 'stylesheets', '_font_adjustments.scss'), 'w')

    # Step up through the widest width supported.
    [
      widths_in_range(360,511), 512, 513,
      widths_in_range(532, 767), 768, 769,
      widths_in_range(780, 959), 960, 961,
      widths_in_range(980, 1023), 1024, 1225
    ].flatten.each do |current_width|
      scss << scss_for(current_width)
    end

    scss.close

  end

end