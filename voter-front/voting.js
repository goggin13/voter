
var list_id = getListId();

function setUpLinkSharer (id) {
  var windowlink = window.location.href;
  $(".sharableLink").val(windowlink);
  $(".linkButton").click(function(){
    var copyText = document.getElementById(id);
    copyText.select();
    document.execCommand("copy");
    $(".copyLink").val("Copied!");
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
    console.log(data);
    var faceOffs = data["face_offs"];
    var listName = data["name"];
    $("#enterNameInstructions").append(" "+listName+"!");
    $("#faceOffTitle").append(listName);
    $("#listNameRanking").append(" "+listName+"!");
    if(faceOffs.length == 0) {
      listRankings(data);
      $(document.getElementById("nameSection")).hide();
      $(document.getElementById("resultsdiv")).show();
      $(document.getElementById("resultsrank")).show();

    }
    else {
      $("#listOptionsGo").click(function(){
        if($('#userName').val() == ''){
          alert('You must enter a name');
        }
        else {
          const userName = document.getElementById("userName").value;
          setUserName(userName, function () {
            $(document.getElementById("nameSection")).hide();
            $(document.getElementById("FaceOffSection")).fadeIn();
            faceOffGo(faceOffs);
          });
        };
      });
    };
  }, 'json');
});


function faceOffGo(faceOffs) {
  if(faceOffs.length == 0) {
    $(document.getElementById('headertext2')).fadeOut();
    $(document.getElementById("FaceOffSection")).fadeOut();
    $(document.getElementById("resultsdiv")).show();
  } else {
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
    });
    $(face2Button).off();
    $(face2Button).on("click", function listen2() {
      setWinner(face2id,face1id,faceOffs);
     });
  }    //end else statement
};  // end faceOffGo function



function setWinner(face1id, face2id, face_array) {
  sendWinnersToServer(face1id, face2id);
  removeFaceOff(face_array);
  faceOffGo(face_array);
};

function removeFaceOff(face_array) {
  face_array.shift();
}

function sendWinnersToServer(winner, loser) {
  const faceoffurl = "face_offs.json";
  const payload = {
    face_off : {
      winner_id : winner,
      loser_id : loser
    },
  }
  $post(faceoffurl, payload, function(data,status) {
    getList(list_id, function(data2,status) {
      listRankings(data2);
    });
  }, 'json');

}


function listRankings(list) {
  var rankings = list["rankings"];
  setUpLinkSharer("sharableLink2");
  if (Object.keys(rankings).length > 0) {
    displayResults(list);
    pollForListUpdates(list, function(updated_list) {
      $("#headertext1").fadeOut(300).html("Results Updated").fadeIn(300).fadeOut(200).fadeIn(200);
      displayResults(updated_list);
    });
  };
}

function displayResults(list) {
  console.log("displayResults");
  var rankings = list["rankings"];
  var qty_of_winners = Object.keys(rankings["1"]).length;
  displayNarrative($("#narrative"), list);
  $("#voterQty").html("Number of voters: " + list["completed_voting_count"]);
  if (qty_of_winners > 1) {
    $("#result").html("There was a " + qty_of_winners + "-way tie!");
  }
  else {
   var first_choice = rankings["1"][0]["label"];
   $("#result").html(first_choice);
  }

  $("#resultsrank").html("")
  $("#listresults").html("")
  $.each(rankings, function (rank,options){
    var r = rank;
    $.each(options, function (index, option){
      var label = option["label"];
      $("#listresults").append("<li>"+label+"</li>");
      $("#resultsrank").append("<li>"+r+"</li>");
    });
  });
};

