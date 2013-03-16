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
	$("#search_button").click(function(){
		window.location.href = "/security/" + $('#search_symbol').val();
	});

	$("#search_symbol").keypress(function (e) {
	  if (e.which == 13) {
  	  $('#search_button').click();
  	}
	});

    var $window = $(window)

    // side bar
    setTimeout(function () {
      $('.bs-docs-sidenav').affix({
        offset: {
          top: function () { return $window.width() <= 980 ? 290 : 210 }
        , bottom: 270
        }
      })
    }, 100)


});
