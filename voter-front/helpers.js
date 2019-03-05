function getUrlVars() {
  var vars = {};
  var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
    vars[key] = value;
  });
  return vars;
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
  var url = HOST + "/users/link.json";
  var payload = {name: username};
  $post(url, payload, function(data,status) {
  });
}

function $post(url, payload, callback) {
  payload.session_id = getSessionId();
  $.post(url, payload, callback);
}
