

function grabTweets () {

  userHandle = $('h1 span').text();

  $.ajax({
    url: '/grabTweets',
    type: 'Post',
    dataType: "JSON",
    data: {user: userHandle},
    beforeSend: function () {
      $('.container #tweets img').addClass('visible');
      domTweets = $('.container #tweets ul li').hide();
    }
  })
  .done(function(response) {
    console.log("success");

    domTweets.remove();
    $('.container #tweets img').removeClass('visible');

    $.each(response,function() {
      // console.log(this);
      // console.log(this.tweet.content);
      $('<li>'+this.tweet.content+'</li>').appendTo('#tweets ul');
    });

  })
  .fail(function() {
    console.log("error");

    domTweets.show();

  })
  .always(function() {
    console.log("complete");
  });
  
}


function sendTweet () {

  tweet = $('form textarea').val();

  $.ajax({
    url: '/tweet',
    type: 'POST',
    data: {user: tweet, handle: userHandle},
    beforeSend: function (data) {
      $('.container #tweets img').addClass('visible');
      domTweets.hide();
      console.log(data);
    }
  })
  .done(function() {
    console.log("success");
    tweet = $('form textarea').val("");
    grabTweets();
  })
  .fail(function() {
    console.log("error");
    domTweets.show();
  })
  .always(function() {
    console.log("complete");
  });
  

}






$(document).ready(function() {
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them

  grabTweets();


  $('#tweet').click(function(event) {
    event.preventDefault();
    sendTweet();
  });


});
