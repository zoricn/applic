##Navigating

You can use the visit method to navigate to other pages:

visit('/projects')
visit(post_comments_path(post))
expect(current_path).to eq(post_comments_path(post))

##Clicking links and buttons

click_link('id-of-link')
click_link('Link Text')
click_button('Save')
click_on('Link Text') # clicks on either links or buttons
click_on('Button Value')

##Interacting with forms

fill_in('First Name', :with => 'John')
fill_in('Password', :with => 'Seekrit')
fill_in('Description', :with => 'Really Long Text...')
choose('A Radio Button')
check('A Checkbox')
uncheck('A Checkbox')
attach_file('Image', '/path/to/image.jpg')
select('Option', :from => 'Select Box')

within("li#employee") do
  fill_in 'Name', :with => 'Jimmy'
end

## Finding

find_field('First Name').value
find_link('Hello').visible?
find_button('Send').click

find(:xpath, "//table/tr").click
find("#overlay").find("h1").click
all('a').each { |a| a[:href] }
Note: find will wait for an element to appear on the page, as explained in the Ajax section. If the element does not appear it will raise an error.

These elements all have all the Capybara DSL methods available, so you can restrict them to specific parts of the page:

find('#navigation').click_link('Home')
expect(find('#navigation')).to have_button('Sign out')

##Debugging

save_and_open_page

You can also retrieve the current state of the DOM as a string using page.html.

print page.html
This is mostly useful for debugging. You should avoid testing against the contents of page.html and use the more expressive finder methods instead.

Finally, in drivers that support it, you can save a screenshot:

page.save_screenshot('screenshot.png')

Or have it save and automatically open:

save_and_open_screenshot