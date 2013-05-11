//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_self
//= require_tree .
//= require FeedEk

// Loads all Bootstrap javascripts
//= require bootstrap

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

  // this variable must be defined this way
  var YAHOO = {
    Finance: {
      SymbolSuggest: {}
    }
  };

$(document).ready(function() {
	$("#search_button").click(function(){
		window.location.href = "/security/" + $('#search_symbol').val();
	});

  $('#search_symbol').typeahead({
    source: function (request, process) {
      $.ajax({
        url: "http://autoc.finance.yahoo.com/autoc",
        type: 'get',
        dataType: 'jsonp',
        jsonp: "callback",
        jsonpCallback: "YAHOO.Finance.SymbolSuggest.ssCallback",
        data: {
            query: request
        },
        success: function (jsonResult) {
            console.log("in success");
            console.log(jsonResult);
            return typeof jsonResult == 'undefined' ? false : process(jsonResult);
        }
      });
      YAHOO.Finance.SymbolSuggest.ssCallback = function (jsonResult) {
        tickers = [];
        //console.log(JSON.stringify(jsonResult));
        //console.log(JSON.stringify(jsonResult.ResultSet.Result));
        $.each(jsonResult.ResultSet.Result, function() {
            //console.log(this.name);
            tickers.push(this.symbol+" - "+this.name);
        });
            return typeof jsonResult == 'undefined' ? false : process(tickers);
      }
    },

    updater: function (item) {
      //selectedState = map[item].stateCode;
      console.log(item);
      console.log(item.substring(0,item.indexOf(" -")));
      return item.substring(0,item.indexOf(" -"));
    }
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
      //  offset: {
      //    top: 100//function () { return $window.width() <= 980 ? 290 : 210 }
        //, bottom: 100
      //  }
      })
    }, 100);

});