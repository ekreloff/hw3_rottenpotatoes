# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    if Movie.where(["title = ?", movie[:title]]).length == 0
      Movie.create!(movie)
    end
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  regexp = /#{e1}.*#{e2}/m #  /m means match across newlines
  page.body.should =~ regexp
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

  action_str = (uncheck == "un")? "uncheck" : "check"

  rating_list.gsub(/\s+/,"").split(',').each do |rating|
    step_str = %Q{When I #{action_str} "ratings_#{rating}"}
    steps step_str
  end
end

Then /I should( not)? see movies having ratings: (.*)/ do | have, rating_list|
  where_str =  "rating IN (?)"
  rating_values = rating_list.gsub(/\s+/,"").split(',')
  movie_list = Movie.where([where_str, rating_values])

  movie_list.each do |m|
    step_str = %Q{Then I should#{have} see "#{m.title}"}
    steps step_str
  end
end

