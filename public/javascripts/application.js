jQuery.fn.switchTo512 = function() {
  return this.each( function() {
    var src= jQuery(this).attr('src'); // Initial src.
    if (src.lastIndexOf('-512') != -1) return; // Abort if it's already there.
    var src_without_extension = src.substring(0, src.lastIndexOf('.'));
    jQuery(this).attr('src', src_without_extension + '-512.' + /[^.]+$/.exec(src));
  });
}
jQuery.fn.switchTo256 = function() {
  return this.each( function() {
    var src= jQuery(this).attr('src');
    if (src.lastIndexOf('-512') == -1) return; // Abort if it's not there.
    var src_without_extension = src.substring(0, src.lastIndexOf('-512'));
    jQuery(this).attr('src', src_without_extension + '.' + /[^.]+$/.exec(src));
  });
}

jQuery(window).resize(function() {
  var total_width = jQuery(window).width();
  var page_width = total_width;
  var left_offset = 0;
  
  var columns = 4; // Default is four columns.
  if (total_width <= 768) { columns = 12; }
  if (total_width <= 512) { columns = 2; }
  
  var width_mod = total_width % columns;
  
  if( width_mod > 0)
  {
      page_width = total_width + (columns - width_mod);
      left_offset = -((page_width - total_width)/2);
  }
  else
  {
      page_width = total_width;
      left_offset = 0;
  }

  jQuery('#content').width(page_width);
  jQuery('#content').css('max-width', page_width);
  jQuery('#content').css('left', left_offset);
  
  if ( total_width > 1024 ) {
    jQuery('.tile img.has512').switchTo512();
  } else {
    jQuery('.tile img.has512').switchTo256();
  }
});