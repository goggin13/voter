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
			
4. Display a link to send to people which will lead to the start voting page.
5. On the same page, display a start voting button.

6. Create page for input name of voter
	(using JSON to assign user name to userid)

7. Create voting/face off page (one combination per swipe)

8. Create results page with:
	Winner is ____
	Display each voter name and ranked list
    
