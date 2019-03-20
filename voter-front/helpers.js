var HOST = "https://agile-ridge-67293.herokuapp.com";
var POLL_TIMEOUT = 5000;
// var HOST = "http://localhost:3000"

function getUrlVars() {
  var vars = {};
  var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
    vars[key] = value;
  });
  return vars;
}

function heartbeat(){
  $get("heartbeat", function(data) { });
}

function getListId() {
  return getUrlVars()["list_id"];
}

function getSessionId() {
  var cookie = document.cookie.split("=");
  if (cookie.length != 2) {
    var session_id = Math.random().toString(36).substring(7);
    console.log("session_id", session_id);
    document.cookie = "session_id=" + session_id;
    return session_id;
  } else {
    return cookie[1];
  }
}

function setUserName(username, callback) {
  var payload = {name: username};
  $post("users/link.json", payload, callback);
}

function getList(list_id, callback) {
  var path = "lists/" + list_id + ".json";
  $get(path, callback);
}

function pollForListUpdates(old_list, callback) {
  var poll = function () {
    getList(old_list["id"], function(new_list) {
      if (old_list["completed_voting_count"] < new_list["completed_voting_count"]) {
        old_list = new_list;
        callback(new_list);
      }
      setTimeout(poll, POLL_TIMEOUT);
    });
  }
  setTimeout(poll, POLL_TIMEOUT);
}

function $post(path, payload, callback) {
  payload.session_id = getSessionId();
  $.post(HOST + "/" + path, payload, callback);
}

function $get(path, callback) {
  path += "?session_id=" + getSessionId();
  console.log(HOST + path);
  $.get(HOST + "/" + path, callback);
}

function displayNarrative($div, list) {
  $div.html("");
  $.each(list["narrative"], function(index, line) {
    $div.append("<li>" + line + "</li>");
  });
}

heartbeat();
console.log(getSessionId());
