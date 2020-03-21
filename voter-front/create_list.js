$(document).ready(function(){
  $("#proceedToName").click(function(){
    $(document.getElementById("proceedToName")).hide();
    $(document.getElementById("loading_gif")).show();

    name = document.getElementById("form-title").value
    options = getOptions();

    if (options.length < 2 || name.length < 1) {
      alert("You must have a name for your list and at least two options");
      $(document.getElementById("proceedToName")).show();
      $(document.getElementById("loading_gif")).hide();
    } else {
      sendListToServer(name, options);
    }
  });// exit on click function

  $("#add-option").click(addOption);
  $(".remove-option").click(removeOption);
});//exit on click function

function getOptions() {
  return $(".option-input").map(function (i,o) {
    return {label: $(o).val()};
  }).filter(function (i, option) {
    return option.label.length > 0;
  }).toArray();
};

function addOption() {
  $newOption = $("#option2").parent().clone();
  $newOption.removeAttr("id");
  $newOption.children("input").val("");
  $newOption.insertBefore($(this).parent());
  $newOption.children(".remove-option").click(removeOption);
  $newOption.children(".remove-option").show();
  $newOption.show();
}

function removeOption() {
  $(this).parent(".form-row").fadeOut();
}

function sendListToServer (name, options) {
  const url = "lists.json";
  const payload = {
    list : {
      name : name,
      options : options
    }
  }
  $post(url, payload, function(data,status) {
    //alert("Data: " + data + "\nStatus: " + status);
    window.location.href='voting.html?list_id=' + data["id"];
  }, 'json');

};

