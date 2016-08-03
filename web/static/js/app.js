import "phoenix_html"

export var App = {
  run: function(){
    // display user mentions and hashtags as links
    var mentionPattern = /\B@(\w+)/;
    var tagPattern = /\S*#(?:\[[^\]]+\]|[a-zA-Z0-9]+)/;
    Array.forEach(document.getElementsByClassName("text"), function(elem) {
      elem.innerHTML = Array.map(elem.innerText.split(" "), function(word) {
        var mentionMatch = mentionPattern.exec(word);
        var tagMatch = tagPattern.exec(word);
        if (mentionMatch) {
          var mention = mentionMatch[0];
          return word.replace(mention, "<a href=\"/login/" + mention.substring(1) + "\">" + mention + "</a>");
        } else if (tagMatch) {
          var tag = tagMatch[0];
          return word.replace(tag, "<a href=\"/hashtag/" + tag.substring(1) + "\">" + tag + "</a>");
        } else
          return word;
      }).join(" ");
    });
  }
}
