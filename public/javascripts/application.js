$(document).ready(function() {
  setUpColorButtons()
  setUpResetDbButton()
});

function setUpColorButtons(){
  $('.color-button').on('click', function(){
    var color = $(this).attr('id')
    $.ajax({
      type: "POST",
      url: "/add_click",
      data: { color: color }
    }).done(function(){
      redirect()
    })
  })
}

function setUpResetDbButton(){
  $('#reset').on('click', function(){
    confirm("Are you sure you want to delete our hard-earned data?")
    $.ajax({
      type: "POST",
      url: "/reset_db"
    }).done(function(){
      redirect()
    })
  })
}

function redirect(){
  window.location = "/"
}