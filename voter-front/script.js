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


  });// exit on click function
});//exit on click function



//debug(voterListFromUser.titleOfList);
//voterListFromUser.addOptions(document.getElementById("option1").value; //document.getElementById("options").value
//voterListFromUser.addOptions(document.getElementById("option2").value;
//debug(voterListFromUser.listOptions);
//debug(JSON.stringify(voterListFromUser))

//console.log(JSON.stringify(voterListFromUser));
