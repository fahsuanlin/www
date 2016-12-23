




/*
     FILE ARCHIVED ON 20:28:27 Aug 1, 2016 AND RETRIEVED FROM THE
     INTERNET ARCHIVE ON 9:00:35 Dec 23, 2016.
     JAVASCRIPT APPENDED BY WAYBACK MACHINE, COPYRIGHT INTERNET ARCHIVE.

     ALL OTHER CONTENT MAY ALSO BE PROTECTED BY COPYRIGHT (17 U.S.C.
     SECTION 108(a)(3)).
*/
(function($) {
$.fn.preloader = function(options){
	
	var defaults = {
		             delay:50,
					 preload_parent:"a",
					 check_timer:300,
					 ondone:function(){ },
					 oneachload:function(image){  },
					 fadein:300 
					};
	
	// variables declaration and precaching images and parent container
	 var options = $.extend(defaults, options),
	 root = $(this) , images = root.find("img").not('.no-preload') ,  timer ,  counter = 0, i=0 , checkFlag = [] , delaySum = options.delay ,
	 
	 init = function(){
	 
		timer = setInterval(function(){
			
			images = root.find("img").not('.no-preload');
			$.makeArray(images);
			
			if(counter>=images.length)
			{
			clearInterval(timer);
			options.ondone();
			return;
			}
			
			counter = 0;
			for(i=0;i<images.length;i++)
			{
				if(images[i].complete==true)
				{
					checkFlag[i] = true;
					options.oneachload(images[i]);
					counter++;
					
					delaySum = delaySum + options.delay;
					
					$(images[i]).css("visibility","visible").delay(delaySum).animate({opacity:1},options.fadein,
					function(){ $(this).parent().removeClass("preloader"); });

				}
			}
		
			},options.check_timer) 
		 
		 
		 } ;
	images.each(function(){
		if(this.complete==true){
			checkFlag[i++] = true;
		}else{
			$(this).css({"visibility":"hidden",opacity:0})
		
			if($(this).parent(options.preload_parent).length==0)
			$(this).wrap("<a class='preloader' />");
			else
			$(this).parent().addClass("preloader");
			
			checkFlag[i++] = false;
		}		
		}); 
	
	images = $.makeArray(images); 
	
	var icon = jQuery("<img />",{id : 'loadingicon', 
		src : URL.goodlayers + '/images/loading.gif'}).hide().appendTo("body");
	
	timer = setInterval(function(){
		
		if(icon[0].complete==true)
		{
			clearInterval(timer);
			init();
			icon.remove();
			return;
		}
		
	},100);
	
	}

})(jQuery);	

jQuery(document).ready(function(){
	// Prepare preload
	jQuery(".content-wrapper").filter(":first").preloader();
});