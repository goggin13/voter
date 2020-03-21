var list_id = getListId();

function setUpLinkSharer (id) {
  var windowlink = window.location.href;
  $("#sharableLink").val(windowlink);
  $(".share").click(function(){
    var copyText = document.getElementById(id);
    copyText.select();
    document.execCommand("copy");
    $("#copyLink").val("URL Copied!");
  });
}

$(document).ready(function(){
  setUpLinkSharer("sharableLink");
});

$(document).ready(function(){
  $("#backtostart").click(function(){
    window.location.href='create_list.html';
  });
});

$(document).ready(function(){
  getList(list_id, function(data,status) {
    var faceOffs = data["face_offs"];
    var listName = data["name"];
    $("#enterNameInstructions").append(" "+listName+"!");
    $("#faceOffTitle").append(listName);
    $(".rank-table-title").append(" "+listName+"!");
    console.log("faceoff length: "+faceOffs.length);
    if(faceOffs.length == 0) {
      listRankings(data);
      $(document.getElementById("nameSection")).hide();
    }
    else {
      $(document.getElementById("nameSection")).show();
      $("#listOptionsGo").click(function(){
        if($('#userName').val() == ''){
          alert('You must enter a name');
        } else {
          const userName = document.getElementById("userName").value;
          setUserName(userName, function () {
            $(document.getElementById("nameSection")).hide();
            $(document.getElementById("FaceOffSection")).fadeIn();
            faceOffGo(faceOffs);
          });
        };
      });
    };
  });
});


function faceOffGo(faceOffs) {
  let face1 = faceOffs[0][0]["label"];
  let face1id = faceOffs[0][0]["id"];
  var face1Button = document.getElementById('face1');
  face1Button.value = face1;
  let face2 = faceOffs[0][1]["label"];
  let face2id = faceOffs[0][1]["id"];
  var face2Button = document.getElementById('face2');
  face2Button.value = face2;

  $(face1Button).off();
  $(face1Button).on("click", function listen1() {
    setWinner(face1id,face2id,faceOffs);
    setProgress(faceOffs.length);
  });
  $(face2Button).off();
  $(face2Button).on("click", function listen2() {
    setWinner(face2id,face1id,faceOffs);
    setProgress(faceOffs.length);
   });
};  // end faceOffGo function

function setProgress(numberOfFaceOffsLeft) {
  var totalwidth = $("#progress").width();
  var progresswidth = $("#my-bar").width();
  var remainingwidth = totalwidth - progresswidth;
  var increment = remainingwidth/numberOfFaceOffsLeft;
  var newwidth = progresswidth + increment;
  $("#my-bar").width(newwidth);
}

function setWinner(face1id, face2id, face_offs) {
  sendWinnersToServer(face1id, face2id, function () {
    face_offs.shift();
    if (face_offs.length > 0) {
      faceOffGo(face_offs);
    } else {
      $(document.getElementById("FaceOffSection")).hide();
      getList(list_id, function(list, status) {
        listRankings(list);
      });
    }
  });
};

function sendWinnersToServer(winner, loser, callback) {
  const faceoffurl = "lists/" + list_id + "/face_offs.json";
  const payload = {
    face_off : {
      winner_id : winner,
      loser_id : loser
    }
  }
  $post(faceoffurl, payload, callback);
}


function listRankings(list) {
  var rankings = list["rankings"];
  setUpLinkSharer("sharableLink2");
  if (rankings && Object.keys(rankings).length > 0) {
    displayResults(list);
    pollForListUpdates(list, function(updated_list) {
      $("#header_text").fadeOut(300).html("Results Updated").fadeIn(300).fadeOut(200).fadeIn(200)
      displayResults(updated_list);
    });
  };
}

function displayResults(list) {
  var rankings = list["rankings"];
  var qty_of_winners = Object.keys(rankings["1"]).length;

  $(".voterQty").html("");
  $(".voterQty").append("Number of Voters: " + list["completed_voting_count"]);
  if (qty_of_winners > 1) {
    $("#result").html("There was a " + qty_of_winners + "-way tie!");
  }
  else {
   var first_choice = rankings["1"][0]
   $("#result").html(first_choice);
  }

  $(".rt-option").html("");
  $(".rt-rank").html("");
  $.each(rankings, function (rank,options) {
    var r = rank;
    $.each(options, function (index, label){
      $(".rt-option").append("<li>"+label+"</li>");
      $(".rt-rank").append("<li>"+r+"</li>");
    });
  });

  if (list["completed_voting_count"] > 1) {
    $(".indiv-results-display").html("");
    var individual_rankings = list["individual_rankings"];
    console.log(individual_rankings);
    console.log(Object.keys(list["individual_rankings"]).length);
    $.each(individual_rankings, function (userName, rankings) {
      var newTable = $("#original-table").clone().addClass("indiv");
      console.log(userName);
      newTable.appendTo(".indiv-results-display");
      newTable.find(".rank-table-title").html("");
      newTable.find(".rt-option").html("");
      newTable.find(".rt-rank").html("");
      newTable.find(".rank-table-title").html(userName);
      $.each(rankings, function (rank, options) {
        var ri = rank;
        $.each(options, function (index, labeli) {
          console.log(ri);
          console.log(labeli);
          newTable.find(".rt-option").append("<li>"+labeli+"</li>");
          newTable.find(".rt-rank").append("<li>"+ri+"</li>");
        });
      });
    });
  }
  $(document.getElementById("resultsdiv")).show();
};
