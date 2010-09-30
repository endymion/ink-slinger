jQuery.fn.switchTo512 = function() {
  return this.each( function() {
    var src= jQuery(this).attr('src'); // Initial src.
    if (src.lastIndexOf('t_1') == -1) return; // Abort if it's not there.
    jQuery(this).attr('src', src.replace(/t_1/, 't_2'));
  });
}
jQuery.fn.switchTo256 = function() {
  return this.each( function() {
    var src= jQuery(this).attr('src');
    if (src.lastIndexOf('t_2') == -1) return; // Abort if it's not there.
    jQuery(this).attr('src', src.replace(/t_2/, 't_1'));
  });
}

jQuery.periodic = function (callback, options) {
      callback = callback || (function() { return false; });

      options = jQuery.extend({ },
                              { frequency : 10,
                                allowParallelExecution : false},
                              options);

      var currentlyExecuting = false;
      var timer;

      var controller = {
         stop : function () {
           if (timer) {
             window.clearInterval(timer);
             timer = null;
           }
         },
         currentlyExecuting : false,
         currentlyExecutingAsync : false
      };

      timer = window.setInterval(function() {
         if (options.allowParallelExecution || !
(controller.currentlyExecuting || controller.currentlyExecutingAsync))
{
            try {
                 controller.currentlyExecuting =
true;
                 if (!(callback(controller))) {
                     controller.stop();
                 }
             } finally {
              controller.currentlyExecuting = false;
            }
         }
      }, options.frequency * 1000);
};

function layout_respond() {
  var total_width = jQuery(window).width();
  var page_width = total_width;
  var left_offset = 0;

  var columns = 4; // Default is four columns.
  if (total_width <= 768) { columns = 12; } // 12%3 = 12%4 = 0
  if (total_width <= 512) { columns = 2; }
  
  var width_mod = total_width % columns;
  
  // For layouts with potential gaps in the center, ensure an even-number px width.
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

  // Stretch width by 2px for layouts where sub-pixel rounding gaps will be at the edges.
  if (total_width > 512 && total_width <= 768)
  {
    left_offset -= 1;
    page_width += 3;
  }

  jQuery('#content').width(page_width);
  jQuery('#content').css('max-width', page_width);
  jQuery('#content').css('margin-left', left_offset);
  
  if ( total_width > 1024 ) {
    jQuery('.panel img.has512').switchTo512();
  } else {
    jQuery('.panel img.has512').switchTo256();
  }
  
  return true; // Continue periodic responding.
}

jQuery(window).bind('load resize', function() {
  layout_respond();
});
// iPhone does not reliably send a resize event, so polling fixes that problem.
jQuery.periodic(layout_respond, {frequency: 3});