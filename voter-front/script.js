//what to do with data once it's returned
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
//html function to test button
function buttontesting() {
      var button = document.getElementById("buttontest").value
      console.log("button pressed");
      console.log("Button value: " + button);
      button = "new value"; //variable/reference changes; but actual button value does not
      document.getElementById("buttontest").value = "new value"; // change actual button value
      console.log(button);
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
//voterListFromUser sent to server. Proceed to send to server function to find out what happens next.
  console.log("after send to server")
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
    alert("Data: " + data + "\nStatus: " + status);
    console.log(data);
    document.getElementById('FaceOffSection').style.display = "block";
    var faceOffs = data["face_offs"];
    faceOffGo(faceOffs);
    //call function on data to commence next step
  }, 'json');

};


function faceOffGo(faceOffs) {
  console.log(faceOffs);//prints array of faceofs
  if(faceOffs != undefined) {
     let face1 = faceOffs[0][0]["label"];
     var face1Button = document.getElementById('face1');
     face1Button.value = face1;
     let face2 = faceOffs[0][1]["label"];
     var face2Button = document.getElementById('face2');
     face2Button.value = face2;
     
     face1Button.addEventListener("click", function () { 
       setWinner(face1,face2,faceOffs)
       face1Button.removeEventListener("click");
     });
     face2Button.addEventListener("click", function () { 
       setWinner(face2,face1,faceOffs); 
       face2Button.removeEventListener("click") 
     });
  }    //end if statement
  else {
       console.log("out of faceoffs");
  }
      
};  // end faceOffGo function



function setWinner(face1, face2, face_array) {
  let winner = face1;
  let loser = face2;
  console.log("winner: " + face1);
  console.log("loser: " + face2);
  secondSendToServer(winner, loser);
  removeFaceOff(face_array);
  console.log("new array: " + face_array);
  faceOffGo(face_array);
};

function removeFaceOff(face_array) {
  array.shift();
  return array;
}

function secondSendToServer(winner, loser) {
  const url = "https://agile-ridge-67293.herokuapp.com/lists.json";
  const payload = {
    face_off : {
      winner_id : winner,
      loser_id : loser
    }
  }
  $.post(url, payload, function(data,status) {
    alert("Data: " + data + "\nStatus: " + status);
    console.log(data + " back from server");
  }, 'json');
}


  //post to server list with winner and loser
