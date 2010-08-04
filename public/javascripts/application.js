jQuery.fn.switchToHD = function() {
  return this.each( function() {
    var src= jQuery(this).attr('src'); // Initial src.
    if (src.lastIndexOf('-512') != -1) return; // Abort if it's already there.
    var src_without_extension = src.substring(0, src.lastIndexOf('.'));
    jQuery(this).attr('src', src_without_extension + '-512.' + /[^.]+$/.exec(src));
  });
}
jQuery.fn.switchToSD = function() {
  return this.each( function() {
    var src= jQuery(this).attr('src');
    if (src.lastIndexOf('-512') == -1) return; // Abort if it's not there.
    var src_without_extension = src.substring(0, src.lastIndexOf('-512'));
    jQuery(this).attr('src', src_without_extension + '.' + /[^.]+$/.exec(src));
  });
}

jQuery(window).resize(function() {
  if ( jQuery(window).width() > 1024 ) {
    jQuery('li img').switchToHD();
  } else {
    jQuery('li img').switchToSD();
  }
});