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
var dataVariable;
function sendToServer () {
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
    dataVariable = data; 
    getFaceOffs(dataVariable);
    //call function on data to commence next step
  }, 'json');

};
 
$(document).ready(function(){  
  $("#listOptionsGo").click(function(){ //upon submitting form:
    voterListFromUser.name = document.getElementById("titleOfForm").value
    var optionsArray = [];
    optionsArray.push(document.getElementById("option1").value);
    optionsArray.push(document.getElementById("option2").value);
    optionsArray.push(document.getElementById("option3").value);
    optionsArray.push(document.getElementById("option4").value);
    optionsArray.push(document.getElementById("option5").value);
    optionsArray.push(document.getElementById("option6").value);
    optionsArray = optionsArray.filter(Boolean);//making sure it's truthy
    optionsArray.forEach(function(option) {
      if(option != undefined) {
        voterListFromUser.addOptions(option);
      };  
    });
    sendToServer(voterListFromUser);
//voterListFromUser sent to server. See that function to find out what happens next.
  console.log("after send to server")
  });// exit on click function
});//exit on click function
    
function getFaceOffs(dataVariable) {
  var faceOffs = dataVariable["face_offs"];
  console.log(faceOffs.length);//prints array of faceofs
  //loop through face_offs, print each one.
  for (let i = 0; i < faceOffs.length; i ++) {
    console.log("Faceoff!");

    console.log(faceOffs[i][0]);
    console.log(faceOffs[i][1]);
  }
  }; 


//debug(voterListFromUser.titleOfList);
//voterListFromUser.addOptions(document.getElementById("option1").value; //document.getElementById("options").value
//voterListFromUser.addOptions(document.getElementById("option2").value;
//debug(voterListFromUser.listOptions);
//debug(JSON.stringify(voterListFromUser))

//console.log(JSON.stringify(voterListFromUser));

