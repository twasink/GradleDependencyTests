Before do |scenario|
  clean_repository()
  start_scenario(scenario.title)
end


Given /^"([^"]*)" "([^"]*)" exists$/ do | project, version|
  create_project(project: project, version: version)
end


Given /^"([^"]*)" "([^"]*)" depends on "([^"]*)" "([^"]*)"$/ do | project, version, dependency, dependency_version |
  create_project(project: project, version: version).add_dependency(project: dependency, version: dependency_version)
end

Then /^the build for "([^"]*)" "([^"]*)" will include "([^"]*)" "([^"]*)"$/ do | project, version, dependency, dependency_version |
  build_all_projects_except(project: project)

  dependencies_for(project: project, version: version).should include([project: dependency, version: dependency_version])
end
