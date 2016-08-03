import "phoenix_html"

export var App = {
  run: function(){
    // display user mentions and hashtags as links
    var mentionPattern = /\B@(\w+)/;
    var tagPattern = /\S*#(?:\[[^\]]+\]|\S+)/;
    Array.forEach(document.getElementsByClassName("text"), function(elem) {
      elem.innerHTML = Array.map(elem.innerText.split(" "), function(word) {
        if (mentionPattern.test(word))
          return "<a href=\"/login/"   + word.substring(1) + "\">" + word + "</a>";
        else if (tagPattern.test(word))
          return "<a href=\"/hashtag/" + word.substring(1) + "\">" + word + "</a>";
        else
          return word;
      }).join(" ");
    });
  }
}
