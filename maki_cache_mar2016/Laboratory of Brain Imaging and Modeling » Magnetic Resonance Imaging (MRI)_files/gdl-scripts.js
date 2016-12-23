




/*
     FILE ARCHIVED ON 20:28:27 Aug 1, 2016 AND RETRIEVED FROM THE
     INTERNET ARCHIVE ON 8:50:06 Dec 23, 2016.
     JAVASCRIPT APPENDED BY WAYBACK MACHINE, COPYRIGHT INTERNET ARCHIVE.

     ALL OTHER CONTENT MAY ALSO BE PROTECTED BY COPYRIGHT (17 U.S.C.
     SECTION 108(a)(3)).
*/
jQuery(document).ready(function(){

	// Menu Navigation
	jQuery('#main-superfish-wrapper ul.sf-menu').supersubs({
		minWidth: 14.5,
		maxWidth: 27,
		extraWidth: 1
	}).superfish({
		delay: 100,
		speed: 'fast',
		animation: {opacity:'show',height:'show'}
	});
	
	// Accordion
	jQuery("ul.gdl-accordion li").each(function(){
		if(jQuery(this).index() > 0){
			jQuery(this).children(".accordion-content").css('display','none');
		}else{
			jQuery(this).find(".accordion-head-image").addClass('active');
		}
		
		jQuery(this).children(".accordion-head").bind("click", function(){
			jQuery(this).children().addClass(function(){
				if(jQuery(this).hasClass("active")) return "";
				return "active";
			});
			jQuery(this).siblings(".accordion-content").slideDown();
			jQuery(this).parent().siblings("li").children(".accordion-content").slideUp();
			jQuery(this).parent().siblings("li").find(".active").removeClass("active");
		});
	});
	
	// Toggle Box
	jQuery("ul.gdl-toggle-box li").each(function(){
		jQuery(this).children(".toggle-box-content").not(".active").css('display','none');
		
		jQuery(this).children(".toggle-box-head").bind("click", function(){
			jQuery(this).children().addClass(function(){
				if(jQuery(this).hasClass("active")){
					jQuery(this).removeClass("active");
					return "";
				}
				return "active";
			});
			jQuery(this).siblings(".toggle-box-content").slideToggle();
		});
	});
	
	// Social Hover
	jQuery(".social-icon").hover(function(){
		jQuery(this).animate({ opacity: 1 }, 150);
	}, function(){
		jQuery(this).animate({ opacity: 0.55 }, 150);
	});
	
	// Scroll Top
	jQuery('div.scroll-top').click(function() {
		  jQuery('html, body').animate({ scrollTop:0 }, '1000');
		  return false;
	});
	
	// Blog Hover
	jQuery(".blog-thumbnail-image img").hover(function(){
		jQuery(this).animate({ opacity: 0.55 }, 150);
	}, function(){
		jQuery(this).animate({ opacity: 1 }, 150);
	});
	
	// Gallery Hover
	jQuery(".gallery-thumbnail-image img, .slideshow-image img").hover(function(){
		jQuery(this).animate({ opacity: 0.55 }, 150);
	}, function(){
		jQuery(this).animate({ opacity: 1 }, 150);
	});
	jQuery(".gdl-hover").hover(function(){
		jQuery(this).animate({ opacity: 1 }, 100);
	}, function(){
		jQuery(this).animate({ opacity: 0.8 }, 100);
	});
	
	// Port Hover
	jQuery("#portfolio-item-holder .portfolio-thumbnail-image-hover").hover(function(){
		jQuery(this).animate({ opacity: 0.55 }, 400, 'easeOutExpo');
		jQuery(this).find('span').animate({ left: '50%'}, 300, 'easeOutExpo');
	}, function(){
		jQuery(this).find('span').animate({ left: '150%'}, 300, 'easeInExpo', function(){
			jQuery(this).css('left','-50%');
		});
		jQuery(this).animate({ opacity: 0 }, 400, 'easeInExpo');
	});
	
	// Price Table
	jQuery(".gdl-price-item").each(function(){
		var max_height = 0;
		jQuery(this).find('.price-item').each(function(){
			if( max_height < jQuery(this).height()){
				max_height = jQuery(this).height();
			}
		});
		jQuery(this).find('.price-item').height(max_height);
		
	});
	
	jQuery('#search-text input, #search-course-text input').setBlankText();
	jQuery('#searchsubmit, #search-course-submit').click(function(){
		var search_value = jQuery(this).siblings('#search-text, #search-course-text').find('input[type="text"]');
		if( search_value.val() == search_value.attr('data-default') ){
			return false;
		}
	});
	
	// Change the style of <select>
	if (!jQuery.browser.opera) {
        jQuery('.gdl-combobox select').each(function(){
            var title = jQuery(this).attr('title');
            if( jQuery('option:selected', this).val() != ''  ) title = jQuery('option:selected',this).text();
            jQuery(this)
                .css({'z-index':10,'-khtml-appearance':'none'})
                .after(function(){
                    val = jQuery('option:selected',this).text();
                    jQuery(this).next().html(val + '<div class="gdl-combobox-button"></div>');				
					})
				.change(function(){
                    val = jQuery('option:selected',this).text();
                    jQuery(this).next().html(val + '<div class="gdl-combobox-button"></div>');
                    })
        });
    };	

});

jQuery(window).load(function(){
	// Set Portfolio Max Height
	var port_item_holder = jQuery('div#portfolio-item-holder');
	port_item_holder.equalHeights();
	jQuery(window).resize(function(){
		port_item_holder.children().css('min-height','0');
		port_item_holder.equalHeights();
	});
});


/* Tabs Activiation
================================================== */
jQuery(document).ready(function() {

	var tabs = jQuery('ul.tabs');

	tabs.each(function(i) {
		//Get all tabs
		var tab = jQuery(this).find('> li > a');
		var tab_content = jQuery(this).next('ul.tabs-content')
		tab.click(function(e) {
			//Get Location of tab's content
			var contentLocation = jQuery(this).attr('data-href');
			//Let go if not a hashed one
			if(contentLocation.charAt(0)=="#") {
				e.preventDefault();
				//Make Tab Active
				tab.removeClass('active');
				jQuery(this).addClass('active');
				//Show Tab Content & add active class
				tab_content.children(contentLocation).show().addClass('active').siblings().hide().removeClass('active');
			}
		});
	});
});

/* Equal Height Function
================================================== */
(function($) {
	$.fn.equalHeights = function(px) {
		$(this).each(function(){
			var currentTallest = 0;
			$(this).children().each(function(i){
				if ($(this).height() > currentTallest) { currentTallest = $(this).height(); }
			});
			$(this).children().css({'min-height': currentTallest}); 
		});
		return this;
	};
	
	$.fn.setBlankText = function(){
		this.live("blur", function(){
			var default_value = $(this).attr("data-default");
			if ($(this).val() == ""){
				$(this).val(default_value);
			}
			
		}).live("focus", function(){
			var default_value = $(this).attr("data-default");
			if ($(this).val() == default_value){
				$(this).val("");
			}
		});
	}	
})(jQuery);

