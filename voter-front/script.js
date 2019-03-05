var list_id;
const voterListFromUser = {
  name : "",
  options : [], 

  addOptions(optionx) {
    newOpt = {
      label : optionx
    }
    console.log(optionx)
    console.log(this)
    this.options.push(newOpt);
  }
};

$(document).ready(function(){  
  $("#listOptionsGo").click(function(){ //upon submitting form:
    voterListFromUser.name = document.getElementById("titleOfForm").value
    var optionsArray = [];
    optionsArray.push(document.getElementById("option1").value);
    optionsArray.push(document.getElementById("option2").value);
    optionsArray.push(document.getElementById("option3").value);
   // optionsArray.push(document.getElementById("option4").value);
    //optionsArray.push(document.getElementById("option5").value);
    //optionsArray.push(document.getElementById("option6").value);
    optionsArray = optionsArray.filter(Boolean);//making sure it's truthy
    optionsArray.forEach(function(option) {
      if(option != undefined) {
        voterListFromUser.addOptions(option);
      };  
    });
    firstSendToServer(voterListFromUser);
  });// exit on click function
});//exit on click function
 

function firstSendToServer () {
  const url = "https://agile-ridge-67293.herokuapp.com/lists.json";
  const payload = {
    list : {
      name : voterListFromUser.name,
      options : voterListFromUser.options
    }
  }
  $.post(url, payload, function(data,status) {
    //alert("Data: " + data + "\nStatus: " + status);
    console.log(data);
    $(document.getElementById('formdiv')).fadeOut();
    $(document.getElementById('FaceOffSection')).fadeIn("slow");
    var faceOffs = data["face_offs"];
    console.log(faceOffs);
    faceOffGo(faceOffs);
    list_id = data["id"];
  }, 'json');

};


function faceOffGo(faceOffs) {
  if(faceOffs.length == 0) {
  console.log("out of faceoffs");
  $(document.getElementById('headertext2')).fadeOut();
  $(document.getElementById("FaceOffSection")).fadeOut();
  $(document.getElementById("resultsdiv")).fadeIn("slow"); 

  }
  else {
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
  secondSendToServer(face1id, face2id);
  removeFaceOff(face_array);
  faceOffGo(face_array);
};

function removeFaceOff(face_array) {
  face_array.shift();
}

function secondSendToServer(winner, loser) {
  const faceoffurl = "https://agile-ridge-67293.herokuapp.com/face_offs.json";
  const payload = {
    face_off : {
      winner_id : winner,
      loser_id : loser
    },
    session_id : 7
  }
  var listurl = "https://agile-ridge-67293.herokuapp.com/lists/"+list_id+".json?session_id=7";
  $.post(faceoffurl, payload, function(data,status) {
    //console.log(data);
    $.get(listurl, function(data2,status) {
      console.log(data2);
      listRankings(data2);
    })
  }, 'json');

}


function listRankings(data2) {
  var rankings = data2["rankings"];
  var r = 1;
  if (Object.keys(rankings).length > 0) {
    var qty_of_winners = Object.keys(rankings["1"]).length;
    if (qty_of_winners > 1) {
      $("#result").html("There was a " + qty_of_winners + "-way tie!");
      
      $.each(rankings["1"], function (k,v) {
        var tied_label = v["label"];
        console.log(Object.keys(rankings));
        $("#listresults").append("<li>"+tied_label+"</li>");
        $("#resultsrank").append("<li>"+Object.keys(rankings)+"</li>");
      });
    }
    
    else {
     var first_choice = rankings["1"][0]["label"];
     $("#result").html(first_choice);
     $.each(rankings, function (k,v) {
       var label = v[0]["label"];
       console.log(label);
       console.log(k + v); 
     	$("#listresults").append("<li>"+label+"</li>");
     	$("#resultsrank").append("<li>"+k+"</li>");
     	r += 1;
     });
    }
  }
};
    
  //$(document.getElementById("listresults")).append("<li>Testing</li>"); 




