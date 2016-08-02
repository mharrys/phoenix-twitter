import "phoenix_html"

export var App = {
  run: function(){
    // display hashtags as links
    var pattern = /\S*#(?:\[[^\]]+\]|\S+)/;
    Array.forEach(document.getElementsByClassName("text"), function(elem) {
      elem.innerHTML = Array.map(elem.innerText.split(" "), function(word) {
        if (pattern.test(word))
          return "<a href=\"/hashtag/" + word.substring(1) + "\">" + word + "</a>";
        else
          return word;
      }).join(" ");
    });
  }
}
