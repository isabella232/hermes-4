# A tutorial
json.type         'tutorial'
json.selector     tutorial.selector
json.id           tutorial.id
json.title        tutorial.title
json.welcome      tutorial.welcome_message || ''
json.progress_bar tutorial.progress_bar
json.overlay      tutorial.overlay
json.site_ref     tutorial.site.hostname
json.path         tutorial.path
json.path_re      tutorial.path_re
# with its own tips
json.tips(tutorial.tips.sort_by_row_order) do |tip|
  json.partial! 'tip', :tip => tip
end
