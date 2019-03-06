# Git Cheat Sheet
## pushing your changes
1. `git add -Av`
2. `git commit -m "<trello> - I made a thing better"`
3. `git push`

## pulling other changes
1. `git pull`

# Todo

1. Create HTML Form
    a. Need input for name of form
    b. Need input of options
    c. Need Go button
    
    
2. Using javascript
    a. User should be able to add or remove options as needed

3. Using javascript to send "Go" POST (an http method) request to endpoint
  https://agile-ridge-67293.herokuapp.com/lists
    The body of the request will look like the json below:
		"JSON" = Javascript option notation (kinda like a csv file, both are data formats; that's what the api uses/reads/writes 			back to you. This is the language the front end talks to the backend with.
    
      describe "POST /lists" do
    it "creates a list with options" do
      post lists_path(:format => :json), :params => {
        :list => {
          :name => "my list",
          :options => [
            {:label => "option 1"},
            {:label => "option 2"},
          ]
        }
      }

3.5. Work on CSS and design of interface.
     a. Find the div classes from demo/examples and copy those. Copy the css listed for each element with inspect.
     b. Color scheme?
     c. Name of app?

4. Display a link to send to people which will lead to the start voting page.??
5. On the same page, display a start voting button.

6. Create page for input name of voter
	(using JSON to assign user name to userid)

7. Create voting/face off page (one combination per swipe)

8. Create results page with:
	Winner is ____
	Display each voter name and ranked list
	
	
	


The jQuery syntax is tailor-made for selecting HTML elements and performing some action on the element(s).

Basic syntax is: $(selector).action()

A $ sign to define/access jQuery
A (selector) to "query (or find)" HTML elements
A jQuery action() to be performed on the element(s)
Examples:

$(this).hide() - hides the current element.

$("p").hide() - hides all <p> elements.

$(".test").hide() - hides all elements with class="test".

$("#test").hide() - hides the element with id="test".

AJAX:
$.post(URL,data,callback);

