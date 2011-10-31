$(document).ready(function(){
  $(".upvote").click(function(){
    var id = $(this).attr('id').split("_")[1];
    $(this).hide();
    $.ajax({
      url: '/vote/create/'+id,
      type: 'POST',
      dataType: 'json',
      success: function(data){
        $("#votes_"+id).html(data.votes+" votes");
      }
    });
  });
});
