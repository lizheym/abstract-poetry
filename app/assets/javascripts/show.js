function showHideOriginalPoem() {
  var original = document.getElementById("originalPoem");
  var button = document.getElementById("showOriginalPoem")
  if (original.style.display === "none") {
    original.style.display = "block";
    button.innerHTML = "Hide Original"
  } else {
    original.style.display = "none";
    button.innerHTML = "Show Original"
  }
}