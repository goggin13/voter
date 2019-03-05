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
  $("#proceedToName").click(function(){ 
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
    sendListToServer(voterListFromUser);
  });// exit on click function
});//exit on click function
 

function sendListToServer () {
  const url = "https://agile-ridge-67293.herokuapp.com/lists.json";
  const payload = {
    list : {
      name : voterListFromUser.name,
      options : voterListFromUser.options
    }
  }
  $post(url, payload, function(data,status) {
    //alert("Data: " + data + "\nStatus: " + status);
    console.log(data);
    list_id = data["id"];
     window.location.href='voting.html?list_id='+list_id;
  }, 'json');

};

