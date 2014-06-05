$(document).ready( function(){
  $( ".tag" ).mouseover( function() {
      $.get( "/tag/" + this.innerText, function( response ) {
        $.notify(response, "info");
      });
  });
});
