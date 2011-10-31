$(function(){
  if((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i)) || (navigator.userAgent.match(/iPad/i))) {
    $('.native-audio').show();
  } else {
    $('.flash-audio').show();
  }
});
