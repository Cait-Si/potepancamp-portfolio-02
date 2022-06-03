$(document).on("change", "#profile_photo_upload", function(e) {
  if(e.target.files.length) {
    let reader = new FileReader;
    reader.onload = function(e) {
      $(".hidden").removeClass();
      $("#profile_photo_prev").attr('src', e.target.result);
      let elem = document.getElementById("profile_photo_prev");
      elem.style.display = "block";
    };
    return reader.readAsDataURL(e.target.files[0]);
  };
});
