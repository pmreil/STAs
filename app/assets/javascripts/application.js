//= require jquery
//= require jquery_ujs
//= require_self
//= require_tree .
//= require FeedEk

// Loads all Bootstrap javascripts
//= require bootstrap

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
	//fix_flash();

	$("#search_button").click(function(){
		window.location.href = "/security/" + $('#search_symbol').val();
	});

	$("#search_symbol").keypress(function (e) {
	  if (e.which == 13) {
  	  $('#search_button').click();
  	}
	});

  $("a[href^='http']").attr('target','_blank');

	(function() {
		var UpdatePanel = {
			init : function(options) {
				this.options = $.extend({
					interval : 5000,
					number : 3,
					hijackTweet : false
				}, options);

				this.updater();
			},

			updater : function() {
				(function updateBox() {
					this.timer = setTimeout(function() {
						updateIt();
						updateBox();
					}, UpdatePanel.options.interval);
				})();

				// get the ball rolling
				updateIt();

				function updateIt() {
          $.ajax({
						type : 'GET',
						url : UpdatePanel.options.url,
						dataType : 'jsonp',

						error : function() {
							//alert('error'); 
						},

						success : function(results) {
							alert('success'); 

							var theTweets = '',
								 elem = UpdatePanel.options.elem.empty();

							$.each(results.results, function(index, tweet) {
								if ( index === UpdatePanel.options.number ) {
									return false;
								}
								else {

									theTweets += '<li>' + tweet.text + '</li>';
								}
							});
							elem.append(theTweets);
						}
					});
				}
			},

			clearUpdater : function() {
				clearTimeout(this.timer);
			}
		};
		window.UpdatePanel = UpdatePanel;
	})();


});

function fix_flash() {
    // loop through every embed tag on the site
    var embeds = document.getElementsByTagName('embed');
    for(i=0; i<embeds.length; i++)  {
        embed = embeds[i];
        var new_embed;
        // everything but Firefox & Konqueror
        if(embed.outerHTML) {
            var html = embed.outerHTML;
            // replace an existing wmode parameter
            if(html.match(/wmode\s*=\s*('|")[a-zA-Z]+('|")/i))
                new_embed = html.replace(/wmode\s*=\s*('|")window('|")/i,"wmode='transparent'");
            // add a new wmode parameter
            else
                new_embed = html.replace(/<embed\s/i,"<embed wmode='transparent' ");
            // replace the old embed object with the fixed version
            embed.insertAdjacentHTML('beforeBegin',new_embed);
            embed.parentNode.removeChild(embed);
        } else {
            // cloneNode is buggy in some versions of Safari & Opera, but works fine in FF
            new_embed = embed.cloneNode(true);
            if(!new_embed.getAttribute('wmode') || new_embed.getAttribute('wmode').toLowerCase()=='window')
                new_embed.setAttribute('wmode','transparent');
            embed.parentNode.replaceChild(new_embed,embed);
        }
    }
    // loop through every object tag on the site
    var objects = document.getElementsByTagName('object');
    for(i=0; i<objects.length; i++) {
        object = objects[i];
        var new_object;
        // object is an IE specific tag so we can use outerHTML here
        if(object.outerHTML) {
            var html = object.outerHTML;
            // replace an existing wmode parameter
            if(html.match(/<param\s+name\s*=\s*('|")wmode('|")\s+value\s*=\s*('|")[a-zA-Z]+('|")\s*\/?\>/i))
                new_object = html.replace(/<param\s+name\s*=\s*('|")wmode('|")\s+value\s*=\s*('|")window('|")\s*\/?\>/i,"<param name='wmode' value='transparent' />");
            // add a new wmode parameter
            else
                new_object = html.replace(/<\/object\>/i,"<param name='wmode' value='transparent' />\n</object>");
            // loop through each of the param tags
            var children = object.childNodes;
            for(j=0; j<children.length; j++) {
                if(children[j].getAttribute('name').match(/flashvars/i)) {
                    new_object = new_object.replace(/<param\s+name\s*=\s*('|")flashvars('|")\s+value\s*=\s*('|")[^'"]*('|")\s*\/?\>/i,"<param name='flashvars' value='"+children[j].getAttribute('value')+"' />");
                }
            }
            // replace the old embed object with the fixed versiony
            object.insertAdjacentHTML('beforeBegin',new_object);
            object.parentNode.removeChild(object);
        }
    }
}


function map_initialize() {
        var mapOptions = {
          center: new google.maps.LatLng(-34.397, 150.644),
          zoom: 8,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var map = new google.maps.Map(document.getElementById("map_canvas"),
            mapOptions);
      }


