$(document).on("change", "#post_image_upload", function(e) {
  if(e.target.files.length) {
    let reader = new FileReader;
    reader.onload = function(e) {
      $(".hidden").removeClass();
      $("#post_img").remove();
      $("#post_img_prev").attr('src', e.target.result);
      let elem = document.getElementById("post_img_prev");
      elem.style.display = "block";
      };
    return reader.readAsDataURL(e.target.files[0]);
  };
});
