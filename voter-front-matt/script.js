const url = "https://agile-ridge-67293.herokuapp.com";
var list_id = null;

$(document).ready(function(){
  $("#listOptionsGo").click(function(){
    createNewList(processCreatedList);
  });

  bindRemoveOptionLinks();

  $("#add_option").click(function () {
    var html = '<input type="text" class="option"> <div class="remove_option">X</div><br>'
    $(this).before(html);
    bindRemoveOptionLinks();
  });
});

function http(method, path, data, callback) {
  data = data || {};
  data.session_id = data.session_id || document.cookie.split("=")[1];
  $.ajax({
    url: url + path,
    dataType: "json",
    data: data,
    method: method,
    success: callback,
    error: function (jq, text_status, error) {
      console.log(jq, text_status, error);
    }
  })
}

function bindRemoveOptionLinks () {
  $(".remove_option").click(function (i, $el) {
    $(this).prev("input").remove();
    $(this).prev("br").remove();
    $(this).remove();
  });
};

function createNewList(callback) {
  http("post", "/lists.json", readListDataFromForm(), callback, 'json');
}

function fetchList(callback) {
  http("get", "/lists/" + list_id + ".json", null, callback);
}

function processCreatedList(data, status) {
  console.log(data);
  console.log(status);
  list_id = data.id;
  remaining_face_offs = data.face_offs;
  current_face_off = remaining_face_offs.pop();
  displayVotingOptions(current_face_off, remaining_face_offs);
  $("#new_list_form").hide();
}

function displayResults(list) {
  $("#cast_vote_form").hide();
  $("#results").show();
  $.each(list.rankings, function(i, options) {
    console.log(i);
    $rank = $("#results").append("<div class='result'><h2>" + i + "</h2></div>");
    $.each(options, function(_, option) {
      console.log(option);
      $rank.append("<div>" + option.label + "</div>");
    });
  });
}

function displayVotingOptions(currentFaceOff, remaining_face_offs) {
  var transitionForm = function (data) {
    console.log(data);
    current_face_off = remaining_face_offs.pop();
    if (current_face_off !== undefined) {
      displayVotingOptions(current_face_off , remaining_face_offs);
    } else {
      fetchList(displayResults);
    }
  }

  var option1 = currentFaceOff[0];
  var option2 = currentFaceOff[1];
  $("#option_1").attr("data-id", option1.id);
  $("#option_2").attr("data-id", option2.id);
  $("#option_1").html(option1.label);
  $("#option_2").html(option2.label);
  $("#option_1").unbind("click").click(function () {
    var winner = $("#option_1").attr("data-id");
    var loser = $("#option_2").attr("data-id");
    castVote(winner, loser, remaining_face_offs, transitionForm);
  });
  $("#option_2").unbind("click").click(function () {
    var winner = $("#option_2").attr("data-id");
    var loser = $("#option_1").attr("data-id");
    castVote(winner, loser, remaining_face_offs, transitionForm);
  });

  $("#cast_vote_form").show();
}

function castVote(winner, loser, remaining_face_offs, callback) {
  var payload = {
    face_off: {
      winner_id: winner,
      loser_id: loser,
    }
  };
  http("post", "/face_offs.json", payload, callback);
}

function readListDataFromForm() {
  var optionsArray = [];
  $("input.option").each(function (i, el) {
    if (el.value !== undefined) {
      optionsArray.push({label: el.value});
    }
  });
  return {
    list : {
      name : document.getElementById("titleOfForm").value,
      options : optionsArray
    }
  }
}
